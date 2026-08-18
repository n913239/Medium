#!/usr/bin/env python3
"""medium-check — 把這個 repo 的發布前檢查清單做成 MCP server。

規格來源:CLAUDE.md「發布流程」第 3 條。
執行:uv run --with mcp python server.py
"""

from __future__ import annotations

import re
import unicodedata
from dataclasses import dataclass, asdict
from pathlib import Path

# SDK 2.0 起 FastMCP 改名為 MCPServer(網路上多數教學還停在 fastmcp)
from mcp.server.mcpserver import MCPServer

REPO = Path(__file__).resolve().parents[3]
STORY = REPO / "story"

# 去識別化樣式放在本機檔案,不進版控 —— 檢查洩漏的工具本身不能洩漏。
# 格式:一行一個 regex,`#` 開頭為註解。範例見 deident-patterns.example.txt
DEIDENT_FILE = Path(__file__).with_name("deident-patterns.txt")

mcp = MCPServer(
    "medium-check",
    instructions="這個 repo 的發布前檢查清單。貼文到 Medium 之前用 check_article 跑一遍。",
    version="0.1.0",
)


@dataclass
class Check:
    name: str
    ok: bool
    detail: str

    @property
    def as_dict(self) -> dict:
        return asdict(self)


# ---------- markdown 解析 ----------

def strip_fences(lines: list[str]) -> list[tuple[int, str]]:
    """回傳 (行號, 內容),已剔除 fenced code block 內的行。

    標題計數一定要走這裡:文章正文會示範 `## 專案簡介` 這種 markdown,
    naive grep '^## ' 會把 code block 裡的假標題算進去(這個坑真的踩過)。
    """
    out, in_fence = [], False
    for i, line in enumerate(lines, 1):
        if line.startswith("```"):
            in_fence = not in_fence
            continue
        if not in_fence:
            out.append((i, line))
    return out


def count_fences(lines: list[str]) -> int:
    return sum(1 for line in lines if line.startswith("```"))


def headings(lines: list[str], level: int) -> list[str]:
    prefix = "#" * level + " "
    return [t for _, t in strip_fences(lines) if t.startswith(prefix)]


IMAGE_RE = re.compile(r"^!\[[^\]]*\]\(([^)]+)\)")
MARKER_RE = re.compile(r"^\*\((在這裡插入|Insert)")
PLACEHOLDER_RE = re.compile(r"TODO|待補|\(Medium 網址\)|TBD")
# 全形標點:中文版一律用半形逗號括號冒號(CLAUDE.md 慣例)
FULLWIDTH_RE = re.compile(r"[，（）：；！？]")


INLINE_CODE_RE = re.compile(r"`[^`]*`")


def prose_only(lines: list[str], drop_inline_code: bool = False) -> list[tuple[int, str]]:
    """只留散文:剔除 fenced code,可選擇連行內 code span 一起剔除。

    為什麼需要:講 hook 擋 `TODO` 的文章,內文本來就會出現 TODO,
    那是被討論的對象,不是殘留的佔位符。第一版沒排除,誤判了 2 篇。
    """
    out = []
    for i, text in strip_fences(lines):
        out.append((i, INLINE_CODE_RE.sub("", text) if drop_inline_code else text))
    return out


def images(lines: list[str]) -> list[str]:
    return [m.group(1) for line in lines if (m := IMAGE_RE.match(line))]


def markers(lines: list[str]) -> int:
    return sum(1 for line in lines if MARKER_RE.match(line))


def load_deident_patterns() -> list[str]:
    if not DEIDENT_FILE.exists():
        return []
    pats = []
    for raw in DEIDENT_FILE.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if line and not line.startswith("#"):
            pats.append(line)
    return pats


# ---------- 個別檢查 ----------

def check_tags(lines: list[str], lang: str) -> Check:
    first = lines[0] if lines else ""
    m = re.match(r"<!--\s*Tags:\s*(.+?)\s*-->", first)
    if not m:
        return Check(f"tags[{lang}]", False, "第一行不是 <!-- Tags: ... --> 註解")
    tags = [t.strip() for t in m.group(1).split(",") if t.strip()]
    ok = len(tags) <= 5
    return Check(f"tags[{lang}]", ok, f"{len(tags)} 個(Medium 上限 5):{', '.join(tags)}")


def check_fences(lines: list[str], lang: str) -> Check:
    n = count_fences(lines)
    return Check(f"fences[{lang}]", n % 2 == 0, f"{n} 個 ``` {'(偶數)' if n % 2 == 0 else '(奇數,未閉合)'}")


def check_images(path: Path, lines: list[str], lang: str) -> list[Check]:
    imgs = images(lines)
    n_mark = markers(lines)
    out = [
        Check(
            f"image-markers[{lang}]",
            len(imgs) == n_mark,
            f"圖片 {len(imgs)} 張 vs 提示行 {n_mark} 行",
        )
    ]

    missing = [p for p in imgs if not (path.parent / p).exists()]
    out.append(
        Check(
            f"image-files[{lang}]",
            not missing,
            "全部存在" if not missing else f"缺少:{', '.join(missing)}",
        )
    )

    if lang == "en":
        # 只在「磁碟上真的有 -en 版本、英文版卻沒用」時才算錯。
        # 無文字的截圖(UI 畫面、流程圖)本來就中英共用,不該逼它做兩份 ——
        # 第一版寫成「一律要 -en」,把 8 篇的共用截圖全誤判成問題。
        wrong = []
        for p in imgs:
            if "-en." in p:
                continue
            stem, _, ext = p.rpartition(".")
            if stem and (path.parent / f"{stem}-en.{ext}").exists():
                wrong.append(p)
        out.append(
            Check(
                "image-en-variant[en]",
                not wrong,
                "無漏用的 -en 版本" if not wrong else f"有 -en 版卻沒用:{', '.join(wrong)}",
            )
        )
    return out


def check_closing(lines: list[str], lang: str) -> Check:
    h2 = headings(lines, 2)
    want = ["總結", "參考資料"] if lang == "zh" else ["Summary", "References"]
    tail = [h.removeprefix("## ").strip() for h in h2[-2:]]
    ok = tail == want
    return Check(f"closing[{lang}]", ok, f"結尾兩節為 {tail},應為 {want}")


def check_placeholders(lines: list[str], lang: str) -> Check:
    hits = [f"L{i}" for i, t in prose_only(lines, drop_inline_code=True) if PLACEHOLDER_RE.search(t)]
    return Check(
        f"placeholders[{lang}]",
        not hits,
        "無殘留" if not hits else f"{len(hits)} 處:{', '.join(hits[:8])}",
    )


def check_fullwidth(lines: list[str]) -> Check:
    hits = []
    for i, t in prose_only(lines):
        for m in FULLWIDTH_RE.finditer(t):
            hits.append(f"L{i}:{m.group()}")
    return Check(
        "fullwidth[zh]",
        not hits,
        "無全形標點" if not hits else f"{len(hits)} 處:{', '.join(hits[:8])}",
    )


def check_deident(text: str, lang: str, pats: list[str]) -> Check:
    if not pats:
        return Check(
            f"deident[{lang}]",
            True,
            f"跳過:{DEIDENT_FILE.name} 不存在(複製 .example 並填入樣式後才會檢查)",
        )
    hits = [p for p in pats if re.search(p, text, re.IGNORECASE)]
    return Check(
        f"deident[{lang}]",
        not hits,
        f"{len(pats)} 條樣式,0 命中" if not hits else f"命中 {len(hits)} 條:{', '.join(hits)}",
    )


def check_parity(zh: list[str], en: list[str]) -> list[Check]:
    out = []
    for level in (2, 3):
        a, b = len(headings(zh, level)), len(headings(en, level))
        out.append(Check(f"parity-h{level}", a == b, f"中 {a} / 英 {b}"))
    a, b = len(images(zh)), len(images(en))
    out.append(Check("parity-images", a == b, f"中 {a} / 英 {b}"))
    return out


# ---------- MCP tools ----------

@mcp.tool()
def list_articles() -> list[dict]:
    """列出 story/ 底下所有文章資料夾,以及各自有沒有中英文檔。

    回傳每篇的 slug、是否有 index.md / index-en.md、圖檔數量。
    """
    out = []
    for d in sorted(STORY.iterdir()):
        if not d.is_dir():
            continue
        zh, en = d / "index.md", d / "index-en.md"
        if not zh.exists() and not en.exists():
            continue
        out.append(
            {
                "slug": d.name,
                "zh": zh.exists(),
                "en": en.exists(),
                "images": len(list(d.glob("*.png"))) + len(list(d.glob("*.jpg"))),
            }
        )
    return out


@mcp.tool()
def check_article(article: str) -> dict:
    """對一篇文章跑完整的發布前檢查清單(CLAUDE.md 發布流程第 3 條)。

    Args:
        article: 文章資料夾名稱(例如 2026-09-04_claude-code-mcp-server),
                 或 story/ 底下的相對路徑。

    Returns:
        passed: 是否全數通過
        failed: 未通過的檢查數
        checks: 每一項的 name / ok / detail
    """
    d = STORY / article
    if not d.is_dir():
        return {"error": f"找不到文章資料夾:{d}"}

    zh_path, en_path = d / "index.md", d / "index-en.md"
    if not zh_path.exists() or not en_path.exists():
        return {"error": f"缺少 index.md 或 index-en.md(zh={zh_path.exists()}, en={en_path.exists()})"}

    zh_text = zh_path.read_text(encoding="utf-8")
    en_text = en_path.read_text(encoding="utf-8")
    zh, en = zh_text.split("\n"), en_text.split("\n")
    pats = load_deident_patterns()

    checks: list[Check] = []

    # 表格 PNG 是讀者唯一看得到的東西,漏改等於沒去識別化(CLAUDE.md 記著這次翻車)。
    # PNG 內的文字掃不了,但它的來源 gen.sh 掃得到 —— 掃來源等於掃圖。
    gen = d / "gen.sh"
    if gen.exists():
        checks.append(check_deident(gen.read_text(encoding="utf-8"), "gen.sh", pats))

    for lines, path, lang, text in ((zh, zh_path, "zh", zh_text), (en, en_path, "en", en_text)):
        checks.append(check_tags(lines, lang))
        checks.append(check_fences(lines, lang))
        checks.extend(check_images(path, lines, lang))
        checks.append(check_closing(lines, lang))
        checks.append(check_placeholders(lines, lang))
        checks.append(check_deident(text, lang, pats))
    checks.append(check_fullwidth(zh))
    checks.extend(check_parity(zh, en))

    failed = [c for c in checks if not c.ok]
    return {
        "article": article,
        "passed": not failed,
        "failed": len(failed),
        "checks": [c.as_dict for c in checks],
    }


if __name__ == "__main__":
    mcp.run()
