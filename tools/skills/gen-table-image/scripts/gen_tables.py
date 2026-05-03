#!/usr/bin/env python3
"""從 Markdown 文章的 HTML comment 提取表格，轉為 PNG 圖片。"""
import re
import sys
import subprocess
import tempfile
from pathlib import Path

STYLE = """<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8">
<style>
html, body { margin: 0; padding: 0; background: #f5f5f5; }
.wrap { display: inline-block; padding: 20px; }
table { border-collapse: collapse; font-size: 15px; line-height: 1.6; background: #fff; }
th { background: #333; color: #fff; font-weight: 600; text-align: left; padding: 12px 20px; }
td { padding: 12px 20px; border-bottom: 1px solid #e0e0e0; color: #333; }
tr:last-child td { border-bottom: none; }
code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 13px; font-family: "SF Mono", Menlo, monospace; }
.c { text-align: center; }
</style></head><body>
<div class="wrap">"""

STYLE_END = """</div></body></html>"""


def parse_align(sep_row):
    """解析分隔行的對齊方式"""
    aligns = []
    for cell in sep_row.strip().strip('|').split('|'):
        cell = cell.strip()
        if cell.startswith(':') and cell.endswith(':'):
            aligns.append('c')
        elif cell.endswith(':'):
            aligns.append('r')
        else:
            aligns.append('l')
    return aligns


def cell_to_html(text):
    """轉換儲存格內容"""
    text = text.strip()
    # `code` → <code>
    text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
    # **bold** → <b>
    text = re.sub(r'\*\*([^*]+)\*\*', r'<b>\1</b>', text)
    # HTML entities
    text = text.replace('<', '&lt;').replace('>', '&gt;')
    # But restore <code>, <b>, </code>, </b>
    text = text.replace('&lt;code&gt;', '<code>').replace('&lt;/code&gt;', '</code>')
    text = text.replace('&lt;b&gt;', '<b>').replace('&lt;/b&gt;', '</b>')
    return text


def md_table_to_html(md_text):
    """Markdown 表格 → HTML table"""
    lines = [l.strip() for l in md_text.strip().split('\n') if l.strip()]
    if len(lines) < 2:
        return None

    # Find header and separator
    header_line = lines[0]
    sep_line = lines[1]

    # Check if it's actually a table
    if '|' not in header_line or not re.match(r'^[\s|:\-]+$', sep_line):
        return None

    aligns = parse_align(sep_line)
    headers = [c.strip() for c in header_line.strip().strip('|').split('|')]
    data_lines = lines[2:]

    html = '<table>\n<tr>'
    for i, h in enumerate(headers):
        align_class = f' class="c"' if i < len(aligns) and aligns[i] == 'c' else ''
        html += f'<th{align_class}>{cell_to_html(h)}</th>'
    html += '</tr>\n'

    for line in data_lines:
        cells = [c.strip() for c in line.strip().strip('|').split('|')]
        html += '<tr>'
        for i, c in enumerate(cells):
            align_class = f' class="c"' if i < len(aligns) and aligns[i] == 'c' else ''
            html += f'<td{align_class}>{cell_to_html(c)}</td>'
        html += '</tr>\n'

    html += '</table>'
    return html


def extract_tables(md_content):
    """從 Markdown 中提取 ![table-name](table-name.png) + <!-- table --> 配對"""
    # Pattern: ![name](name.png) followed by <!-- ... -->
    pattern = r'!\[(table[^\]]*)\]\([^\)]+\.png\)\s*\n<!--\s*\n(.*?)\n-->'
    matches = re.findall(pattern, md_content, re.DOTALL)

    tables = []
    for name, comment_content in matches:
        # Skip if comment contains "Gemini prompt"
        if 'Gemini prompt' in comment_content or 'gemini prompt' in comment_content.lower():
            continue
        # Check if comment contains a markdown table
        if '|' in comment_content and '---' in comment_content:
            tables.append((name, comment_content.strip()))

    return tables


def generate_png(name, html_table, output_dir):
    """用 playwright 截圖產生 PNG"""
    full_html = STYLE + html_table + STYLE_END

    with tempfile.NamedTemporaryFile(mode='w', suffix='.html', delete=False, dir=output_dir) as f:
        f.write(full_html)
        tmp_path = f.name

    output_path = output_dir / f"{name}.png"

    try:
        subprocess.run(
            ['npx', 'playwright', 'screenshot',
             '--viewport-size', '900,100',
             '--full-page',
             f'file://{tmp_path}',
             str(output_path)],
            capture_output=True, text=True, timeout=30
        )
    finally:
        Path(tmp_path).unlink(missing_ok=True)

    return output_path.exists()


def main():
    if len(sys.argv) < 2:
        print("用法：python3 gen_tables.py <md-file> [table-name]")
        sys.exit(1)

    md_file = Path(sys.argv[1]).resolve()
    filter_name = sys.argv[2] if len(sys.argv) > 2 else None

    if not md_file.exists():
        print(f"❌ 檔案不存在：{md_file}")
        sys.exit(1)

    output_dir = md_file.parent
    md_content = md_file.read_text(encoding='utf-8')

    tables = extract_tables(md_content)

    if filter_name:
        tables = [(n, t) for n, t in tables if n == filter_name]

    if not tables:
        print("❌ 找不到符合的表格")
        sys.exit(1)

    print("📊 表格圖片產生報告\n")

    success = 0
    for name, md_table in tables:
        html = md_table_to_html(md_table)
        if html is None:
            print(f"⚠️  {name} — 無法解析為表格")
            continue

        row_count = md_table.count('\n') - 1  # subtract header separator
        if generate_png(name, html, output_dir):
            print(f"✅ {name}.png（{row_count} 列）")
            success += 1
        else:
            print(f"❌ {name}.png — 截圖失敗")

    print(f"\n總計：{success} 張圖片已產生")
    print(f"輸出目錄：{output_dir}/")


if __name__ == '__main__':
    main()
