#!/usr/bin/env python3
"""Markdown → 單一自帶圖片的 HTML。

把一份 index.md（或任意 .md）轉成一個 self-contained 的 .html：
- 所有本地圖片以 base64 內嵌，成品是單一檔案，不需附帶圖片
- 依這個 repo 的寫作慣例，自動略過：
    * 首行 <!-- Tags: ... --> 與所有 HTML 註解（表格原始碼 / Gemini prompt）
    * 作者註記 *(在這裡插入圖片：xxx.png)* 這類 placeholder 行
- 外部 http(s) 圖片保留原網址，不下載

用法：
    python3 md_to_single_html.py <path/to/index.md> [output.html]

不給 output 時，輸出到 md 同目錄的同名 .html。
"""
import re, os, base64, html, mimetypes, sys


def data_uri(path, base):
    full = path if os.path.isabs(path) else os.path.join(base, path)
    mime = mimetypes.guess_type(full)[0] or "image/png"
    with open(full, "rb") as f:
        b64 = base64.b64encode(f.read()).decode()
    return f"data:{mime};base64,{b64}"


def inline(text):
    text = html.escape(text)
    text = re.sub(r'`([^`]+)`', lambda m: '<code>%s</code>' % m.group(1), text)
    text = re.sub(r'\[([^\]]+)\]\(([^)]+)\)',
                  lambda m: '<a href="%s">%s</a>' % (m.group(2), m.group(1)), text)
    text = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', text)
    text = re.sub(r'\*([^*]+)\*', r'<em>\1</em>', text)
    return text


def convert(src, out=None):
    base = os.path.dirname(os.path.abspath(src))
    if out is None:
        out = os.path.splitext(src)[0] + ".html"

    with open(src, encoding="utf-8") as f:
        lines = f.read().split("\n")

    body = []
    list_stack = []
    i, n = 0, len(lines)

    def close_list():
        while list_stack:
            body.append("</ul>")
            list_stack.pop()

    while i < n:
        line = lines[i]

        # HTML 註解（單行或多行）→ 丟棄
        if line.lstrip().startswith("<!--"):
            if "-->" in line:
                i += 1
                continue
            i += 1
            while i < n and "-->" not in lines[i]:
                i += 1
            i += 1
            continue

        # 作者 placeholder 註記 *(在這裡插入…)* → 丟棄
        if re.match(r'^\*\(.*\)\*\s*$', line.strip()):
            i += 1
            continue

        # code fence
        if line.startswith("```"):
            i += 1
            buf = []
            while i < n and not lines[i].startswith("```"):
                buf.append(lines[i])
                i += 1
            i += 1
            close_list()
            body.append('<pre><code>%s</code></pre>' % html.escape("\n".join(buf)))
            continue

        stripped = line.strip()

        if stripped == "":
            close_list()
            i += 1
            continue

        if stripped == "---":
            close_list()
            body.append("<hr>")
            i += 1
            continue

        # 圖片
        m = re.match(r'^!\[([^\]]*)\]\(([^)]+)\)\s*$', stripped)
        if m:
            close_list()
            alt, srcref = html.escape(m.group(1)), m.group(2)
            if not srcref.startswith("http"):
                srcref = data_uri(srcref, base)
            body.append('<p><img src="%s" alt="%s"></p>' % (srcref, alt))
            i += 1
            continue

        # 標題
        m = re.match(r'^(#{1,6})\s+(.*)$', stripped)
        if m:
            close_list()
            lv = len(m.group(1))
            body.append("<h%d>%s</h%d>" % (lv, inline(m.group(2)), lv))
            i += 1
            continue

        # blockquote（連續 > 行合併）
        if stripped.startswith(">"):
            close_list()
            buf = []
            while i < n and lines[i].strip().startswith(">"):
                buf.append(re.sub(r'^\s*>\s?', '', lines[i]))
                i += 1
            body.append("<blockquote>%s</blockquote>" % inline(" ".join(buf)))
            continue

        # 清單（支援一層縮排巢狀）
        m = re.match(r'^(\s*)[-*]\s+(.*)$', line)
        if m:
            depth = 1 if len(m.group(1)) >= 2 else 0
            while len(list_stack) > depth + 1:
                body.append("</ul>")
                list_stack.pop()
            while len(list_stack) < depth + 1:
                body.append("<ul>")
                list_stack.append(True)
            body.append("<li>%s</li>" % inline(m.group(2)))
            i += 1
            continue

        # 段落
        close_list()
        body.append("<p>%s</p>" % inline(stripped))
        i += 1

    close_list()
    body = "\n".join(body)

    tm = re.search(r'<h1>(.*?)</h1>', body)
    title = re.sub('<[^>]+>', '', tm.group(1)) if tm else os.path.basename(src)

    doc = TEMPLATE % (html.escape(title), body)
    with open(out, "w", encoding="utf-8") as f:
        f.write(doc)
    return out


TEMPLATE = """<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>%s</title>
<style>
  :root { color-scheme: light dark; }
  body {
    max-width: 720px; margin: 0 auto; padding: 2.5rem 1.2rem 5rem;
    font-family: -apple-system, "PingFang TC", "Noto Sans TC", "Helvetica Neue", sans-serif;
    line-height: 1.8; color: #242424; background: #fff;
    font-size: 18px; -webkit-font-smoothing: antialiased;
  }
  h1 { font-size: 2rem; line-height: 1.3; margin: 1.8rem 0 1rem; font-weight: 700; }
  h2 { font-size: 1.45rem; margin: 2.4rem 0 .9rem; font-weight: 700; }
  h3 { font-size: 1.2rem; margin: 2rem 0 .8rem; font-weight: 700; }
  p { margin: 1.1rem 0; }
  a { color: #1a73e8; text-decoration: none; }
  a:hover { text-decoration: underline; }
  img { max-width: 100%%; height: auto; border-radius: 8px; display: block; margin: 1.4rem auto; }
  hr { border: none; border-top: 1px solid #e5e5e5; margin: 2.4rem 0; }
  blockquote {
    margin: 1.4rem 0; padding: .4rem 0 .4rem 1.2rem;
    border-left: 3px solid #b0b0b0; color: #555; font-style: italic;
  }
  code {
    font-family: "SF Mono", Menlo, Consolas, monospace;
    background: rgba(135,131,120,.15); border-radius: 4px;
    padding: .12em .4em; font-size: .88em;
  }
  pre {
    background: #f6f8fa; border: 1px solid #e5e5e5; border-radius: 8px;
    padding: 1rem 1.2rem; overflow-x: auto; margin: 1.4rem 0;
  }
  pre code { background: none; padding: 0; font-size: .85em; line-height: 1.6; }
  ul { margin: 1.1rem 0; padding-left: 1.4rem; }
  li { margin: .4rem 0; }
  @media (prefers-color-scheme: dark) {
    body { color: #e6e6e6; background: #1a1a1a; }
    h1,h2,h3 { color: #f5f5f5; }
    a { color: #6ab0ff; }
    hr { border-top-color: #333; }
    blockquote { color: #aaa; border-left-color: #555; }
    pre { background: #222; border-color: #333; }
  }
</style>
</head>
<body>
%s
</body>
</html>
"""


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python3 md_to_single_html.py <path/to/index.md> [output.html]", file=sys.stderr)
        sys.exit(1)
    src = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else None
    if not os.path.isfile(src):
        print("找不到檔案: %s" % src, file=sys.stderr)
        sys.exit(1)
    result = convert(src, out)
    size_mb = round(os.path.getsize(result) / 1024 / 1024, 2)
    print("輸出: %s (%s MB)" % (result, size_mb))
