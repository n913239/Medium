#!/usr/bin/env python3
"""medium-check — 把這個 repo 的發布前檢查清單做成 MCP server。

規格來源:CLAUDE.md「發布流程」第 3 條。
執行:uv run --with mcp==2.2.0 python server.py(版本與 .mcp.json 一致)
"""

from __future__ import annotations

import datetime
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
    # warn=True:只提醒、不算進 failed —— 留給要人工判斷的項目
    warn: bool = False

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
    # 封面不必有「插入圖片」提示行(2026-10-23 改:封面的 Gemini prompt 註解移到 H1 上方,
    # 提示行一併拿掉)。舊文章封面還留著提示行,所以兩種寫法都要算對 —— 只比非封面的。
    n_cover_img = sum(1 for p_ in imgs if p_.lower().startswith("cover."))
    n_cover_mark = sum(1 for line in lines if MARKER_RE.match(line) and "cover." in line.lower())
    body_img, body_mark = len(imgs) - n_cover_img, n_mark - n_cover_mark
    out = [
        Check(
            f"image-markers[{lang}]",
            body_img == body_mark,
            f"內文圖 {body_img} 張 vs 提示行 {body_mark} 行"
            + (f";封面圖 {n_cover_img} 張、提示行 {n_cover_mark} 行(封面提示行可有可無)" if n_cover_img else ""),
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


def check_rules(lines: list[str], lang: str) -> Check:
    """每個 H2 前面一條 `---`:系列從 0317 起的排版慣例。

    只檢查「每個 H2 前面有沒有」,不檢查總數相等 ——
    有 9 篇舊文在別處也用了水平線(12 條 vs 11 個 H2),那不是錯。
    一定要走 strip_fences:正文會示範水平線,也會有 `--- stdout ---` 這種分隔。
    """
    body = [t.strip() for _, t in strip_fences(lines)]
    missing = []
    for i, text in enumerate(body):
        if not text.startswith("## "):
            continue
        # 往回跳過空行,看前一個非空行是不是 ---
        j = i - 1
        while j >= 0 and body[j] == "":
            j -= 1
        if j < 0 or body[j] != "---":
            missing.append(text.removeprefix("## ").strip())
    return Check(
        f"rules[{lang}]",
        not missing,
        "每個 H2 前都有 ---" if not missing
        else f"{len(missing)} 個 H2 前面少了 ---:{', '.join(missing[:4])}",
    )


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


COMMENT_RE = re.compile(r"<!--.*?-->", re.S)
# 不算「散文」的行首:清單、標題、表格、圖片、提示行、水平線、註解殘行
BLOCK_RE = re.compile(r"\s*([-*+|#!]|\d+\.\s|\*\(|<!--|-->)")


def body_lines(text: str) -> list[tuple[int, str]]:
    """剔除 HTML 註解與 fenced code,保留原始行號。

    註解裡放的是表格原始碼與 Gemini prompt,本來就是多行,不能算進正文。
    """
    blanked = COMMENT_RE.sub(lambda m: "\n" * m.group().count("\n"), text)
    return strip_fences(blanked.split("\n"))


def check_linebreaks(text: str, lang: str) -> Check:
    """段落中間的換行:md-to-medium 會把它轉成 <br>,線上一句話斷成好幾行。

    0828 起的慣例是一段一行;1005、1016 是拆行寫的,發文後才發現(1016 線上 77 個 <br>)。
    想斷開好讀的地方應該空一行另起段落。只提醒不擋:偶爾是刻意的,由人判斷。
    """
    body = body_lines(text)
    hits = []
    for (i, a), (j, b) in zip(body, body[1:]):
        # 只有 `>` 的行是引言內的段落分隔,等同空行
        if j != i + 1 or a.strip() in ("", ">") or b.strip() in ("", ">"):
            continue
        quote = a.lstrip().startswith(">") and b.lstrip().startswith(">")
        item_cont = re.match(r"\s*[-*+]\s", a) and re.match(r"\s{2,}\S", b) and not re.match(r"\s*[-*+]\s", b)
        prose = not BLOCK_RE.match(a) and not a.lstrip().startswith(">") \
            and not BLOCK_RE.match(b) and not b.lstrip().startswith(">")
        if quote or item_cont or prose:
            hits.append(f"L{i}")
    return Check(
        f"linebreaks[{lang}]",
        not hits,
        "無段落內換行" if not hits else f"{len(hits)} 處(刻意的請改空一行):{', '.join(hits[:8])}",
        warn=True,
    )


def check_bold(text: str, lang: str) -> Check:
    """`**` 旁邊是標點又緊貼文字時,CommonMark 不認它是粗體的開頭/結尾,線上直接顯示 `**`。

    1016 合併換行後踩到:`…Makefile。**而 A 組` 原本 `**` 後面是換行所以沒事,
    合併後變成「標點 + ** + 文字」,5 段粗體全失效。修法是把標點移到 `**` 外面。
    """
    def punct(ch: str) -> bool:
        # CommonMark 的「標點」含 Unicode P 與 S 類(反引號、$、+ 都算)
        return unicodedata.category(ch)[0] in "PS"

    hits = []
    for i, line in body_lines(text):
        # code span 換成 `c`:保留反引號(它本身算標點),內容不參與判斷
        parts = INLINE_CODE_RE.sub("`c`", line).split("**")
        if len(parts) < 3:
            continue
        for k in range(1, len(parts) - 1, 2):
            inner, before, after = parts[k], parts[k - 1], parts[k + 1]
            if not inner:
                continue
            bad_close = punct(inner[-1]) and after and not after[0].isspace() and not punct(after[0])
            bad_open = punct(inner[0]) and before and not before[-1].isspace() and not punct(before[-1])
            if bad_close or bad_open:
                hits.append(f"L{i}")
                break
    return Check(
        f"bold[{lang}]",
        not hits,
        "粗體標記都會生效" if not hits else f"{len(hits)} 行的 ** 會失效(把標點移到 ** 外面):{', '.join(hits[:8])}",
    )


def sentences(text: str, lang: str) -> list[str]:
    """把正文切成句子。標題、表格、清單、圖片、引言、程式碼一律不算。

    量的是「讀者讀到的散文」,所以結構性的行要先拿掉 —— 表格裡的欄位、
    清單的條目都不是句子,混進來會把句長分布算壞。
    """
    out = []
    for _, line in body_lines(text):
        s = line.strip()
        if not s or BLOCK_RE.match(line) or s.startswith(">"):
            continue
        s = INLINE_CODE_RE.sub("c", s)
        s = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", s)   # 連結只留文字
        s = s.replace("**", "").replace("*", "")
        parts = re.split(r"(?<=[。!?:])\s*", s) if lang == "zh" else re.split(r"(?<=[.!?])\s+", s)
        out += [p.strip() for p in parts if len(p.strip()) > 2]
    return out


def rhythm_stats(text: str, lang: str) -> dict | None:
    """一篇文章的句長分布。句數太少就不算(短文的分布沒有意義)。"""
    sents = sentences(text, lang)
    if len(sents) < 20:
        return None
    L = [len(s) if lang == "zh" else len(s.split()) for s in sents]
    n = len(L)
    mean = sum(L) / n
    sd = (sum((x - mean) ** 2 for x in L) / n) ** 0.5
    near = 5 if lang == "zh" else 3
    runs = sum(1 for i in range(n - 2) if max(L[i:i + 3]) - min(L[i:i + 3]) <= near)
    return {
        "n": n, "mean": mean, "sd": sd,
        "runs100": runs / n * 100,
        "long": sum(1 for x in L if x >= (60 if lang == "zh" else 41)) / n * 100,
    }


def series_baseline(lang: str, exclude: Path) -> list[dict]:
    """系列已發布文章的句長分布,當作這個 venue 的基準。

    為什麼不用外部數字:sepia 的人類基準來自台灣新聞長文語料(每句中位數 59 字),
    技術部落格本來就寫得短 —— 拿新聞的數字當及格線,全系列 11 篇會一起亮紅燈
    (2026-10-23 試過)。sepia 自己的 "Read the venue first" 講的就是這件事:
    場域的既有稿件定義目標,不是規則書。外部數字只放在 detail 裡當參考。
    """
    today = datetime.date.today().isoformat()
    out = []
    for d in sorted(STORY.iterdir()):
        if not d.is_dir() or d.resolve() == exclude.resolve():
            continue
        # 資料夾前綴是發布日;還沒發的不列入基準
        if not re.match(r"\d{4}-\d{2}-\d{2}_", d.name) or d.name[:10] > today:
            continue
        f = d / ("index.md" if lang == "zh" else "index-en.md")
        if not f.exists():
            continue
        if st := rhythm_stats(f.read_text(encoding="utf-8"), lang):
            out.append(st)
    return out


def _median(xs: list[float]) -> float:
    xs = sorted(xs)
    n = len(xs)
    return xs[n // 2] if n % 2 else (xs[n // 2 - 1] + xs[n // 2]) / 2


def check_rhythm(text: str, lang: str, article_dir: Path) -> Check:
    """句長分布 —— 跟系列自己的既往文章比。只提醒,不擋發文。

    標的是「這篇跟你平常寫的不一樣」,不是「這篇不像人寫的」:
    句長離散度掉下來、或連續等長句變多,是文章讀起來單調的徵兆。
    detail 裡一併列出 sepia(Nanako0129/sepia v0.12.4)的語料數字當參考,
    那是台灣新聞長文與 2026 年三個模型的 register 級分布,**不是及格線**。
    """
    cur = rhythm_stats(text, lang)
    if cur is None:
        return Check(f"rhythm[{lang}]", True, "句數太少,不計", warn=True)

    unit = "字" if lang == "zh" else "詞"
    ref = ("人類新聞 59/34、2026 三模型 34-48/15-19" if lang == "zh"
           else "41+ 詞人類 12.0%、2023 base 5.5%")
    stat = (f"{cur['n']} 句,平均 {cur['mean']:.0f}{unit} SD {cur['sd']:.0f},"
            f"{'60+' if lang == 'zh' else '41+'}{unit} {cur['long']:.0f}%,"
            f"近等長 {cur['runs100']:.0f}/百句")

    base = series_baseline(lang, article_dir)
    if len(base) < 5:
        return Check(f"rhythm[{lang}]", True, f"{stat}(系列樣本 {len(base)} 篇,不足以比較;參考:{ref})", warn=True)

    m_sd = _median([b["sd"] for b in base])
    m_runs = _median([b["runs100"] for b in base])
    notes = []
    # 0.75 / 1.5 倍是看 2026-09 起 8 篇的實際散布定的,抓的是明顯的離群篇
    if cur["sd"] < m_sd * 0.75:
        notes.append(f"句長 SD {cur['sd']:.0f} 低於系列中位數 {m_sd:.0f} 的四分之三,長短句拉開一點")
    if cur["runs100"] > max(m_runs * 1.5, m_runs + 3):
        notes.append(f"近等長句 {cur['runs100']:.0f}/百句,系列中位數 {m_runs:.0f}")
    if lang == "en":
        because = len(re.findall(r"\bbecause\b", text, re.I))
        stat += f",because {because}"
        if because <= 1:
            notes.append(f"because 只用 {because} 次(sepia §4:模型用量是人類的 20%,列為該補回來的連接詞)")

    return Check(
        f"rhythm[{lang}]",
        not notes,
        f"{stat}(系列 {len(base)} 篇:SD 中位數 {m_sd:.0f}、近等長 {m_runs:.0f}/百句;參考:{ref})"
        + ("" if not notes else " ⚠ " + ";".join(notes)),
        warn=True,
    )


def check_deident(text: str, lang: str, pats: list[str]) -> Check:
    if not pats:
        return Check(
            f"deident[{lang}]",
            True,
            f"跳過:{DEIDENT_FILE.name} 不存在(複製 .example 並填入樣式後才會檢查)",
        )
    # 樣式含大寫字母 → 區分大小寫(否則全大寫的專案代號會命中同拼法的英文單字、/Users/ 會命中網址裡的 /users/);
    # 全小寫的樣式才不分大小寫,讓 acme 也抓得到 ACME。
    hits = [p for p in pats
            if re.search(p, text, 0 if re.search(r"[A-Z]", p) else re.IGNORECASE)]
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
    d = (STORY / article).resolve()
    # article 來自呼叫端,擋掉 ../ 跳出 story/ 的路徑
    if not d.is_relative_to(STORY.resolve()) or not d.is_dir():
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
        checks.append(check_rules(lines, lang))
        checks.append(check_placeholders(lines, lang))
        checks.append(check_deident(text, lang, pats))
        checks.append(check_bold(text, lang))
        checks.append(check_linebreaks(text, lang))
        checks.append(check_rhythm(text, lang, d))
    checks.append(check_fullwidth(zh))
    checks.extend(check_parity(zh, en))

    failed = [c for c in checks if not c.ok and not c.warn]
    warnings = [c for c in checks if not c.ok and c.warn]
    return {
        "article": article,
        "passed": not failed,
        "failed": len(failed),
        "warnings": len(warnings),
        "checks": [c.as_dict for c in checks],
    }


if __name__ == "__main__":
    mcp.run()
