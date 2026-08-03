#!/bin/bash
cd "$(dirname "$0")"
DIR="$(pwd)"

generate() {
  local name="$1"
  local body_html="$2"
  local vw="${3:-720}"
  cat > "${DIR}/_${name}.html" << ENDHTML
<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8">
<style>
html, body { margin: 0; padding: 0; background: #f5f5f5; }
.wrap { display: inline-block; padding: 20px; }
table { border-collapse: collapse; font-size: 15px; line-height: 1.6; background: #fff; }
th { background: #333; color: #fff; font-weight: 600; text-align: left; padding: 12px 20px; }
td { padding: 12px 20px; border-bottom: 1px solid #e0e0e0; color: #333; }
tr:last-child td { border-bottom: none; }
code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 13px; font-family: "SF Mono", Menlo, monospace; }
strong { color: #1a1a1a; }
</style></head><body>
<div class="wrap">${body_html}</div>
<script>
  const w = document.querySelector('.wrap');
  document.title = w.offsetWidth + 'x' + w.offsetHeight;
</script>
</body></html>
ENDHTML
  npx playwright screenshot --viewport-size "${vw},100" --full-page \
    "file://${DIR}/_${name}.html" "${DIR}/${name}.png" 2>/dev/null
  rm -f "${DIR}/_${name}.html"
  echo "✅ ${name}.png"
}

trim() {
  local name="$1"
  local file="${DIR}/${name}.png"
  magick "$file" -fuzz 3% -trim +repage -bordercolor '#f5f5f5' -border 12 "$file"
}

# 中文:一份 md,三種產出
generate "table-formats" '<table>
<tr><th>產出格式</th><th>給誰 / 什麼場合</th><th>怎麼生</th></tr>
<tr><td><strong>Word 講義</strong></td><td>學員印出來跟著操作</td><td><code>pandoc</code>（convert-docx skill）</td></tr>
<tr><td><strong>PPTX 簡報</strong></td><td>講師上課投影</td><td><code>python-pptx</code></td></tr>
<tr><td><strong>HTML 網頁 / 簡報</strong></td><td>線上自學,一個連結看全部</td><td>請 Claude Code 直接生</td></tr>
</table>' 680

# 英文:一份 md,三種產出
generate "table-formats-en" '<table>
<tr><th>Output format</th><th>For whom / what setting</th><th>How it is made</th></tr>
<tr><td><strong>Word handout</strong></td><td>Students print it and follow along</td><td><code>pandoc</code> (convert-docx skill)</td></tr>
<tr><td><strong>PPTX deck</strong></td><td>Instructor projects in class</td><td><code>python-pptx</code></td></tr>
<tr><td><strong>HTML page / deck</strong></td><td>Online self-study, one link for all</td><td>Claude Code writes it directly</td></tr>
</table>' 760

echo ""
echo "裁切邊框..."
for name in table-formats table-formats-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "完成！"
