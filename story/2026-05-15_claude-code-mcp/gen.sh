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

# 中文表格
generate "table-mcp-capabilities" '<table>
<tr><th>類型</th><th>說明</th><th>範例</th></tr>
<tr><td><code>Tools</code></td><td>Claude 可呼叫的函式，會真的執行某個動作</td><td>查詢 DB、搜尋 issues、送出 PR</td></tr>
<tr><td><code>Resources</code></td><td>Claude 可讀取的資料，類似唯讀的 context</td><td>讀取設計規格、取得 schema</td></tr>
<tr><td><code>Prompts</code></td><td>預先定義好的 prompt 範本</td><td>「幫我 review 這個 PR」模板</td></tr>
</table>'

generate "table-mcp-transport" '<table>
<tr><th>Transport</th><th>啟動方式</th><th>適合場景</th></tr>
<tr><td><code>stdio</code></td><td><code>command</code> + <code>args</code>，Claude 直接啟動子程序</td><td>本地工具、npm/pip 套件</td></tr>
<tr><td><code>SSE (http)</code></td><td>連到已在跑的 HTTP server</td><td>遠端服務、需要常駐的 server</td></tr>
</table>'

# 英文表格
generate "table-mcp-capabilities-en" '<table>
<tr><th>Type</th><th>Description</th><th>Examples</th></tr>
<tr><td><code>Tools</code></td><td>Functions Claude can call that actually execute an action</td><td>Query DB, search issues, submit PR</td></tr>
<tr><td><code>Resources</code></td><td>Data Claude can read, like read-only context</td><td>Read design specs, get schema</td></tr>
<tr><td><code>Prompts</code></td><td>Predefined prompt templates</td><td>"Help me review this PR" template</td></tr>
</table>'

generate "table-mcp-transport-en" '<table>
<tr><th>Transport</th><th>How It Starts</th><th>Best For</th></tr>
<tr><td><code>stdio</code></td><td><code>command</code> + <code>args</code>; Claude spawns the subprocess</td><td>Local tools, npm/pip packages</td></tr>
<tr><td><code>SSE (http)</code></td><td>Connects to an already-running HTTP server</td><td>Remote services, persistent servers</td></tr>
</table>'

# 裁切灰色邊框
echo ""
echo "裁切邊框..."
for name in table-mcp-capabilities table-mcp-transport table-mcp-capabilities-en table-mcp-transport-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
