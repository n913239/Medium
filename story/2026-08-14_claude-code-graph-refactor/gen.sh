#!/bin/bash
cd "$(dirname "$0")"
DIR="$(pwd)"

generate() {
  local name="$1"
  local body_html="$2"
  local vw="${3:-640}"
  cat > "${DIR}/_${name}.html" << ENDHTML
<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8">
<style>
html, body { margin: 0; padding: 0; background: #f5f5f5; }
.wrap { display: inline-block; padding: 20px; }
table { border-collapse: collapse; font-size: 15px; line-height: 1.6; background: #fff; }
th { background: #333; color: #fff; font-weight: 600; text-align: left; padding: 12px 18px; }
td { padding: 12px 18px; border-bottom: 1px solid #e0e0e0; color: #333; }
tr:last-child td { border-bottom: none; }
code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 13px; font-family: "SF Mono", Menlo, monospace; }
strong { color: #1a1a1a; }
.d { color: #c0392b; font-weight: 600; }
.p { color: #27ae60; font-weight: 600; }
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

# 中文:重構前後對照
generate "table-diff" '<table>
<tr><th>指標</th><th>重構前</th><th>重構後</th><th>變化</th></tr>
<tr><td><code>RecordDetailViewController</code> 邊數</td><td>120</td><td>119</td><td class="d">−1</td></tr>
<tr><td>全圖節點數</td><td>2012</td><td>2025</td><td class="p">+13</td></tr>
<tr><td>全圖群集數</td><td>120</td><td>107</td><td>−13</td></tr>
<tr><td><code>getQuantityErrorMessage</code> 節點</td><td>有</td><td>無</td><td>移除</td></tr>
<tr><td><code>RecordValidator</code> 節點</td><td>無</td><td>有(自成群集)</td><td class="p">新增</td></tr>
</table>' 640

# 英文:重構前後對照
generate "table-diff-en" '<table>
<tr><th>Metric</th><th>Before</th><th>After</th><th>&Delta;</th></tr>
<tr><td><code>RecordDetailViewController</code> edges</td><td>120</td><td>119</td><td class="d">−1</td></tr>
<tr><td>Total nodes</td><td>2012</td><td>2025</td><td class="p">+13</td></tr>
<tr><td>Total communities</td><td>120</td><td>107</td><td>−13</td></tr>
<tr><td><code>getQuantityErrorMessage</code> node</td><td>present</td><td>gone</td><td>removed</td></tr>
<tr><td><code>RecordValidator</code> node</td><td>absent</td><td>present (own&nbsp;community)</td><td class="p">added</td></tr>
</table>' 740

echo ""
echo "完成！(magick 未裝則略過裁邊;viewport 寬度已調)"
