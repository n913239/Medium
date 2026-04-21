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

# 中文：適合/不適合平行的任務
generate "table-parallel-tasks" '<table>
<tr><th>適合平行</th><th>不適合平行</th></tr>
<tr><td>功能開發 + 補測試</td><td>同一個模組的兩個改動</td></tr>
<tr><td>修 bug + 重構</td><td>有共同依賴的改動（API 合約、資料庫 schema）</td></tr>
<tr><td>新功能 + 文件更新</td><td>需要前一個任務完成才能開始</td></tr>
<tr><td>不同模組的獨立任務</td><td>任何會產生 merge conflict 的組合</td></tr>
</table>'

# 英文：適合/不適合平行的任務
generate "table-parallel-tasks-en" '<table>
<tr><th>Good for Parallel</th><th>Not Good for Parallel</th></tr>
<tr><td>Feature dev + writing tests</td><td>Two changes to the same module</td></tr>
<tr><td>Bug fix + refactoring</td><td>Changes with shared dependencies (API contracts, DB schema)</td></tr>
<tr><td>New feature + documentation</td><td>When Task B requires Task A to finish first</td></tr>
<tr><td>Independent tasks in different modules</td><td>Any combination likely to cause merge conflicts</td></tr>
</table>'

# 裁切灰色邊框
echo ""
echo "裁切邊框..."
for name in table-parallel-tasks table-parallel-tasks-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
