#!/bin/bash
cd "$(dirname "$0")"
DIR="$(pwd)"

generate() {
  local name="$1"
  local table_html="$2"
  local vw="${3:-900}"
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
.c { text-align: center; }
</style></head><body>
<div class="wrap">${table_html}</div>
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

# 中文：一天總覽
generate "table-one-day" '<table>
<tr><th>時間</th><th>環節</th><th>用了什麼</th><th>解決什麼</th></tr>
<tr><td>09:00</td><td>對齊</td><td>Plan Mode</td><td>動手前先讀懂四年的架構</td></tr>
<tr><td>10:00</td><td>實作</td><td>test-writer agent + 權限設定</td><td>測試與實作分腦袋</td></tr>
<tr><td>14:00</td><td>審查</td><td>code-reviewer agent（唯讀）</td><td>沒有同事，就造一個</td></tr>
<tr><td>16:30</td><td>把關</td><td><code>/precommit</code> + PreToolUse hook</td><td>接住所有人都忘記的事</td></tr>
<tr><td>17:00</td><td>收尾</td><td><code>/pr-description</code></td><td>重複勞動變成 30 秒</td></tr>
</table>' 1000

# 英文：一天總覽
generate "table-one-day-en" '<table>
<tr><th>Time</th><th>Phase</th><th>Tools</th><th>Problem Solved</th></tr>
<tr><td>09:00</td><td>Alignment</td><td>Plan Mode</td><td>Read four years of architecture before coding</td></tr>
<tr><td>10:00</td><td>Build</td><td>test-writer agent + permissions</td><td>Tests and implementation from separate brains</td></tr>
<tr><td>14:00</td><td>Review</td><td>code-reviewer agent (read-only)</td><td>No colleague? Build one</td></tr>
<tr><td>16:30</td><td>Guard</td><td><code>/precommit</code> + PreToolUse hook</td><td>Catch what everyone forgot</td></tr>
<tr><td>17:00</td><td>Wrap-up</td><td><code>/pr-description</code></td><td>Repetitive labor becomes 30 seconds</td></tr>
</table>' 1100

# 裁切灰色邊框
echo ""
echo "裁切邊框..."
for name in table-one-day table-one-day-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
