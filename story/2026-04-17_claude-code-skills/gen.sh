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

generate "table-comparison" '<table>
<tr><th></th><th>CLAUDE.md</th><th>Skills</th></tr>
<tr><td><b>用途</b></td><td>專案規範，每次啟動自動載入</td><td>特定工作流程，需要時才載入</td></tr>
<tr><td><b>觸發方式</b></td><td>永遠生效</td><td><code>/skill-name</code> 手動呼叫，或 Claude 自動判斷</td></tr>
<tr><td><b>適合放什麼</b></td><td>coding style、架構說明、禁止事項</td><td>部署流程、程式碼清理、檔案轉換</td></tr>
<tr><td><b>放置位置</b></td><td>專案根目錄</td><td><code>.claude/skills/</code> 資料夾</td></tr>
</table>'

generate "table-scope" '<table>
<tr><th>層級</th><th>路徑</th><th>作用範圍</th></tr>
<tr><td>個人</td><td><code>~/.claude/skills/&lt;skill-name&gt;/SKILL.md</code></td><td>你所有的專案</td></tr>
<tr><td>專案</td><td><code>.claude/skills/&lt;skill-name&gt;/SKILL.md</code></td><td>只有這個專案</td></tr>
<tr><td>企業</td><td>managed settings 設定</td><td>組織內所有人</td></tr>
</table>'

generate "table-bundled" '<table>
<tr><th>Skill</th><th>用途</th></tr>
<tr><td><code>/batch &lt;instruction&gt;</code></td><td>大規模平行修改 — 自動拆解任務，每個子任務開獨立 agent 執行，完成後各自開 PR</td></tr>
<tr><td><code>/claude-api</code></td><td>載入 Claude API 參考文件，寫 Anthropic SDK 程式碼時自動觸發</td></tr>
<tr><td><code>/debug [description]</code></td><td>開啟 debug log 並分析當前 session 的問題</td></tr>
<tr><td><code>/loop [interval] &lt;prompt&gt;</code></td><td>定時重複執行指令，適合監控部署狀態或輪詢 PR</td></tr>
<tr><td><code>/simplify [focus]</code></td><td>平行啟動三個 review agent 檢查修改的檔案，找出可重用、品質、效能問題並修正</td></tr>
</table>'

generate "table-docx-compare" '<table>
<tr><th>項目</th><th class="c">/convert-docx</th><th class="c">官方 docx skill (pandoc)</th></tr>
<tr><td>表格框線</td><td class="c">✅ 完整</td><td class="c">❌ 無框線</td></tr>
<tr><td>欄寬</td><td class="c">✅ 自動分配</td><td class="c">❌ 固定寬度</td></tr>
<tr><td>圖片嵌入</td><td class="c">✅ 正常</td><td class="c">✅ 正常</td></tr>
<tr><td>操作步驟</td><td class="c">1 步完成</td><td class="c">1 步（但需手動修框線）</td></tr>
</table>'

generate "table-frontmatter" '<table>
<tr><th>欄位</th><th>說明</th><th>預設</th></tr>
<tr><td><code>name</code></td><td>Skill 名稱，就是 <code>/</code> 後面打的那個</td><td>資料夾名稱</td></tr>
<tr><td><code>description</code></td><td>描述用途，Claude 會用這個判斷是否自動載入</td><td>無</td></tr>
<tr><td><code>argument-hint</code></td><td>自動完成時顯示的參數提示</td><td>無</td></tr>
<tr><td><code>disable-model-invocation</code></td><td>設 <code>true</code> 只能手動呼叫，Claude 不會自動觸發</td><td><code>false</code></td></tr>
<tr><td><code>user-invocable</code></td><td>設 <code>false</code> 只有 Claude 能用，不出現在 <code>/</code> 選單</td><td><code>true</code></td></tr>
<tr><td><code>allowed-tools</code></td><td>限制 Skill 可以用的工具</td><td>全部</td></tr>
<tr><td><code>context</code></td><td>設 <code>fork</code> 可以在獨立的子 agent 中執行</td><td>無</td></tr>
</table>'

generate "table-invocation" '<table>
<tr><th>設定</th><th class="c">你能呼叫</th><th class="c">Claude 自動用</th><th>適合場景</th></tr>
<tr><td>預設（都不設）</td><td class="c">可以</td><td class="c">可以</td><td>通用型 Skill</td></tr>
<tr><td><code>disable-model-invocation: true</code></td><td class="c">可以</td><td class="c">不行</td><td>deploy、發通知等有副作用的操作</td></tr>
<tr><td><code>user-invocable: false</code></td><td class="c">不行</td><td class="c">可以</td><td>背景知識，如舊系統架構說明</td></tr>
</table>'

# cleanup
rm -f "${DIR}/gen-tables.html" "${DIR}/gen-tables.js" "${DIR}/gen-all-tables.sh" "${DIR}/test.png" "${DIR}/_test.html" "${DIR}/_test_out.png"

echo ""
echo "全部完成！"
