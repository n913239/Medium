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

generate "table-skill-vs-agent" '<table>
<tr><th>面向</th><th>Skill</th><th>Agent</th></tr>
<tr><td><b>觸發方式</b></td><td>使用者輸入 <code>/xxx</code></td><td>由 Skill 或 Claude 自動呼叫</td></tr>
<tr><td><b>互動性</b></td><td>高（可來回對話）</td><td>低（獨立執行後回報）</td></tr>
<tr><td><b>Context</b></td><td>共用主對話 context</td><td>獨立 context window</td></tr>
<tr><td><b>工具限制</b></td><td>預設全部工具</td><td>可用 <code>tools</code> 欄位限制</td></tr>
<tr><td><b>適合場景</b></td><td>需要使用者輸入的流程</td><td>大量分析、可完全隔離的任務</td></tr>
</table>'

generate "table-agent-frontmatter" '<table>
<tr><th>欄位</th><th>說明</th><th>範例</th></tr>
<tr><td><code>description</code></td><td>Claude 判斷何時自動呼叫的依據，要寫使用情境</td><td><code>iOS code reviewer for git diff</code></td></tr>
<tr><td><code>tools</code></td><td>限制 Agent 可以用的工具，不填則繼承預設</td><td><code>["Read", "Bash", "Grep", "Glob"]</code></td></tr>
<tr><td><code>model</code></td><td>指定使用的模型，可針對任務選最適合的</td><td><code>haiku</code> / <code>sonnet</code> / <code>opus</code></td></tr>
</table>' 1000

generate "table-ios-agents" '<table>
<tr><th>Agent</th><th>用途</th><th>呼叫來源</th><th>分析範圍</th></tr>
<tr><td><code>ios-reviewer</code></td><td>輕量 code review</td><td><code>/ios-commit</code></td><td>只看 diff</td></tr>
<tr><td><code>ios-deep-reviewer</code></td><td>深度 review + 架構分析 + 評分</td><td><code>/ios-deep-review</code></td><td>diff + 完整檔案</td></tr>
<tr><td><code>ios-pr-writer</code></td><td>產生結構化 PR 說明</td><td><code>/ios-pr</code></td><td>git log + diff</td></tr>
<tr><td><code>ios-json-to-model</code></td><td>JSON → Swift Codable struct</td><td><code>/ios-json-to-model</code></td><td>使用者輸入的 JSON</td></tr>
<tr><td><code>ios-test-stub-generator</code></td><td>單元測試骨架（Swift Testing / XCTest）</td><td><code>/ios-test-stub</code></td><td>指定的 Swift 檔案</td></tr>
</table>' 1100

generate "table-tools-guide" '<table>
<tr><th>任務類型</th><th>建議 tools</th><th>說明</th></tr>
<tr><td>唯讀分析（code review、log 分析）</td><td><code>Read</code>, <code>Bash</code>, <code>Grep</code>, <code>Glob</code></td><td>只能讀取，無法修改任何檔案</td></tr>
<tr><td>內容轉換（JSON → Swift Model）</td><td><code>Read</code>, <code>Write</code></td><td>讀入原始資料，寫出新檔案</td></tr>
<tr><td>程式碼修改（自動修正、重構）</td><td><code>Read</code>, <code>Edit</code>, <code>Bash</code></td><td>讀取後直接修改既有檔案</td></tr>
</table>' 1000

echo ""
echo "全部完成！"
