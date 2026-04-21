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

# 中文：直接執行 vs 先規劃再執行
generate "table-plan-mode" '<table>
<tr><th></th><th>直接執行</th><th>先規劃再執行</th></tr>
<tr><td>簡單任務</td><td>快</td><td>多餘</td></tr>
<tr><td>中等任務</td><td>可能要 undo 重來</td><td>少走彎路</td></tr>
<tr><td>複雜任務</td><td>容易走錯方向</td><td>差距很大</td></tr>
</table>'

# 英文：直接執行 vs 先規劃再執行
generate "table-plan-mode-en" '<table>
<tr><th></th><th>Execute Directly</th><th>Plan First, Then Execute</th></tr>
<tr><td>Simple task</td><td>Fast</td><td>Unnecessary overhead</td></tr>
<tr><td>Medium task</td><td>May need to undo and redo</td><td>Fewer wrong turns</td></tr>
<tr><td>Complex task</td><td>Easy to go off course</td><td>Significant difference in outcome</td></tr>
</table>'

# 中文：什麼時候值得這樣做
generate "table-when-to-use" '<table>
<tr><th>任務規模</th><th>建議</th></tr>
<tr><td>改一個 function、加一個 UI 元件</td><td>直接執行，不需要 Plan Mode</td></tr>
<tr><td>跨多個檔案的改動</td><td>Plan Mode 先確認範圍</td></tr>
<tr><td>牽涉到架構或資料流</td><td>完整規劃 + 驗證迴圈</td></tr>
<tr><td>有風險的改動（migration、auth、API）</td><td>必須規劃，驗證要跑完整測試</td></tr>
</table>'

# 英文：什麼時候值得這樣做
generate "table-when-to-use-en" '<table>
<tr><th>Task Scale</th><th>Recommendation</th></tr>
<tr><td>One function, one UI component</td><td>Execute directly, Plan Mode not needed</td></tr>
<tr><td>Changes spanning multiple files</td><td>Use Plan Mode to confirm scope</td></tr>
<tr><td>Architecture or data flow changes</td><td>Full planning + verification loop</td></tr>
<tr><td>High-risk changes (migrations, auth, APIs)</td><td>Always plan; run complete test suite</td></tr>
</table>'

# 中文：Plan Mode vs OpenSpec 路徑比較
generate "table-path-comparison" '<table>
<tr><th></th><th>Plan Mode 路徑</th><th>OpenSpec 路徑</th></tr>
<tr><td>適合情境</td><td>規格清楚，需要想清楚實作步驟</td><td>規格模糊、邊界複雜、跨多個系統</td></tr>
<tr><td>驗證方式</td><td>Claude 自己跑 build／test 迴圈</td><td><code>/opsx:verify</code> 對照 spec 確認實作完整性</td></tr>
</table>'

# 英文：Plan Mode vs OpenSpec 路徑比較
generate "table-path-comparison-en" '<table>
<tr><th></th><th>Plan Mode Path</th><th>OpenSpec Path</th></tr>
<tr><td>Best for</td><td>Spec is clear; need to think through implementation</td><td>Spec is fuzzy, boundaries complex, multiple systems</td></tr>
<tr><td>Verification</td><td>Claude runs build/test loop autonomously</td><td><code>/opsx:verify</code> checks implementation against spec</td></tr>
</table>'

# 裁切灰色邊框
echo ""
echo "裁切邊框..."
for name in table-plan-mode table-plan-mode-en table-when-to-use table-when-to-use-en table-path-comparison table-path-comparison-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
