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

# 中文:God Nodes 邊數 vs 行數
generate "table-godnodes" '<table>
<tr><th>節點</th><th>邊數</th><th>實際行數</th></tr>
<tr><td><code>RecordDetailViewController</code></td><td>99</td><td>1722</td></tr>
<tr><td><code>RequestCreateViewController</code></td><td>92</td><td>1349</td></tr>
<tr><td><code>AssetManagementViewController</code></td><td>60</td><td>1040</td></tr>
<tr><td><code>RecordReviewViewController</code></td><td>48</td><td>776</td></tr>
<tr><td><code>RequestListViewController</code></td><td>46</td><td>829</td></tr>
<tr><td><code>LoginViewController</code></td><td>39</td><td>591</td></tr>
</table>' 545

# 英文:God Nodes 邊數 vs 行數
generate "table-godnodes-en" '<table>
<tr><th>Node</th><th>Edges</th><th style="white-space:nowrap">Actual lines</th></tr>
<tr><td><code>RecordDetailViewController</code></td><td>99</td><td>1722</td></tr>
<tr><td><code>RequestCreateViewController</code></td><td>92</td><td>1349</td></tr>
<tr><td><code>AssetManagementViewController</code></td><td>60</td><td>1040</td></tr>
<tr><td><code>RecordReviewViewController</code></td><td>48</td><td>776</td></tr>
<tr><td><code>RequestListViewController</code></td><td>46</td><td>829</td></tr>
<tr><td><code>LoginViewController</code></td><td>39</td><td>591</td></tr>
</table>' 545

# 中文:什麼時候值得用
generate "table-when" '<table>
<tr><th>情境</th><th>建議</th></tr>
<tr><td>幾十個檔的小專案</td><td>✗ 不用,Claude 直接讀就好</td></tr>
<tr><td>接手一個陌生的大 codebase</td><td>✓ 值得,先看群集分群比一個一個翻快</td></tr>
<tr><td>重構前想知道「動這裡會扯到哪」</td><td>✓ 值得,這正是圖的強項</td></tr>
<tr><td>想量化技術債、說服別人</td><td>✓ 值得,一張圖比一段抱怨有力</td></tr>
<tr><td>要精確答案(哪一行、什麼型別)</td><td>✗ 別靠它,回去讀 code</td></tr>
</table>' 700

# 英文:什麼時候值得用
generate "table-when-en" '<table>
<tr><th>Situation</th><th>Verdict</th></tr>
<tr><td>Small project, a few dozen files</td><td>✗ Skip it — let Claude just read the code</td></tr>
<tr><td>Inheriting an unfamiliar large codebase</td><td>✓ Worth it — community clusters beat file-by-file</td></tr>
<tr><td>Pre-refactor "what breaks if I touch this"</td><td>✓ Worth it — the graph&#39;s home turf</td></tr>
<tr><td>Quantifying tech debt to convince someone</td><td>✓ Worth it — a picture outargues a complaint</td></tr>
<tr><td>Needing exact answers (which line, which type)</td><td>✗ Don&#39;t — go read the code</td></tr>
</table>' 780

echo ""
echo "裁切邊框..."
for name in table-godnodes table-godnodes-en table-when table-when-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "完成！"
