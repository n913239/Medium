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
.cat { font-weight: 600; color: #555; }
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

# 中文：14 個 Skill 總覽
generate "table-skills" '<table>
<tr><th>類別</th><th>Skill</th><th>做什麼</th></tr>
<tr><td class="cat">規劃</td><td><code>brainstorming</code></td><td>用蘇格拉底式提問逼出真正的需求</td></tr>
<tr><td class="cat">規劃</td><td><code>writing-plans</code></td><td>把工作拆成 2–5 分鐘的小任務</td></tr>
<tr><td class="cat">規劃</td><td><code>executing-plans</code></td><td>照計畫逐項執行</td></tr>
<tr><td class="cat">實作</td><td><code>test-driven-development</code></td><td>強制 RED-GREEN-REFACTOR</td></tr>
<tr><td class="cat">實作</td><td><code>subagent-driven-development</code></td><td>每個任務派新的 subagent + 審查關卡</td></tr>
<tr><td class="cat">實作</td><td><code>dispatching-parallel-agents</code></td><td>平行派工</td></tr>
<tr><td class="cat">除錯</td><td><code>systematic-debugging</code></td><td>根因分析，不靠猜</td></tr>
<tr><td class="cat">審查</td><td><code>requesting-code-review</code></td><td>提交前先自我審查</td></tr>
<tr><td class="cat">審查</td><td><code>receiving-code-review</code></td><td>處理審查意見</td></tr>
<tr><td class="cat">審查</td><td><code>verification-before-completion</code></td><td>宣告完成前先驗證</td></tr>
<tr><td class="cat">版控</td><td><code>using-git-worktrees</code></td><td>隔離的平行工作區</td></tr>
<tr><td class="cat">版控</td><td><code>finishing-a-development-branch</code></td><td>收尾、合併、開 PR</td></tr>
<tr><td class="cat">Meta</td><td><code>writing-skills</code></td><td>教你寫新的 Skill</td></tr>
<tr><td class="cat">Meta</td><td><code>using-superpowers</code></td><td>框架的自我引導入口</td></tr>
</table>' 760

# 英文：14 個 Skill 總覽
generate "table-skills-en" '<table>
<tr><th>Category</th><th>Skill</th><th>What It Does</th></tr>
<tr><td class="cat">Planning</td><td><code>brainstorming</code></td><td>Socratic questioning to extract the real requirement</td></tr>
<tr><td class="cat">Planning</td><td><code>writing-plans</code></td><td>Break work into 2–5 minute tasks</td></tr>
<tr><td class="cat">Planning</td><td><code>executing-plans</code></td><td>Execute the plan item by item</td></tr>
<tr><td class="cat">Build</td><td><code>test-driven-development</code></td><td>Enforce RED-GREEN-REFACTOR</td></tr>
<tr><td class="cat">Build</td><td><code>subagent-driven-development</code></td><td>Fresh subagent per task + review gates</td></tr>
<tr><td class="cat">Build</td><td><code>dispatching-parallel-agents</code></td><td>Parallel task dispatch</td></tr>
<tr><td class="cat">Debug</td><td><code>systematic-debugging</code></td><td>Root-cause analysis, no guessing</td></tr>
<tr><td class="cat">Review</td><td><code>requesting-code-review</code></td><td>Self-review before submitting</td></tr>
<tr><td class="cat">Review</td><td><code>receiving-code-review</code></td><td>Handle review feedback</td></tr>
<tr><td class="cat">Review</td><td><code>verification-before-completion</code></td><td>Verify before declaring done</td></tr>
<tr><td class="cat">Version control</td><td><code>using-git-worktrees</code></td><td>Isolated parallel workspaces</td></tr>
<tr><td class="cat">Version control</td><td><code>finishing-a-development-branch</code></td><td>Wrap up, merge, open PR</td></tr>
<tr><td class="cat">Meta</td><td><code>writing-skills</code></td><td>Teaches you to write new Skills</td></tr>
<tr><td class="cat">Meta</td><td><code>using-superpowers</code></td><td>The framework&apos;s self-bootstrapping entry point</td></tr>
</table>' 820

# 中文：Plan Mode / OpenSpec / Superpowers
generate "table-brainstorm-planmode" '<table>
<tr><th></th><th>Plan Mode</th><th>OpenSpec</th><th>Superpowers</th></tr>
<tr><td class="cat">釐清什麼</td><td>怎麼做</td><td>要做什麼（你寫規格）</td><td>要做什麼（AI 問出來）</td></tr>
<tr><td class="cat">資訊流向</td><td>Claude 讀 codebase → 交計畫</td><td>你把需求寫成規格</td><td>Claude 一次一題問你</td></tr>
<tr><td class="cat">產物</td><td>對話裡的計畫，用完即棄</td><td>持久的 spec 檔</td><td>持久的 spec + plan 檔</td></tr>
<tr><td class="cat">保證層級</td><td>機制層：寫入工具被禁</td><td>工具／流程約束</td><td>prompt 層：skill 裡的紀律</td></tr>
</table>' 1000

# 英文：Plan Mode / OpenSpec / Superpowers
generate "table-brainstorm-planmode-en" '<table>
<tr><th></th><th>Plan Mode</th><th>OpenSpec</th><th>Superpowers</th></tr>
<tr><td class="cat">Clarifies</td><td>How to build</td><td>What to build (you write the spec)</td><td>What to build (AI asks it out)</td></tr>
<tr><td class="cat">Information flow</td><td>Claude reads codebase → plan</td><td>You write the requirement into a spec</td><td>Claude asks one question at a time</td></tr>
<tr><td class="cat">Artifact</td><td>A plan in the chat, gone after use</td><td>A durable spec file</td><td>Durable spec + plan files</td></tr>
<tr><td class="cat">Guarantee</td><td>Mechanism: write tools disabled</td><td>Tool / process constraint</td><td>Prompt: discipline in the skill</td></tr>
</table>' 1120

echo ""
echo "裁切邊框..."
for name in table-skills table-skills-en table-brainstorm-planmode table-brainstorm-planmode-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
