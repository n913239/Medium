#!/bin/bash
# 2026-09-10:playwright 1.63 起本機沒有 headless shell,一律用 --channel=chrome
# 走系統 Chrome。⚠️ 它的算繪與舊版 headless shell 不同,重產的 PNG 不會與
# 已發布的位元組相同(檔案會小約 10%),已發布的文章沒事別重跑。
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
th { background: #333; color: #fff; font-weight: 600; text-align: left; padding: 12px 18px; }
td { padding: 12px 18px; border-bottom: 1px solid #e0e0e0; color: #333; vertical-align: top; }
tr:last-child td { border-bottom: none; }
code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 13px; font-family: "SF Mono", Menlo, monospace; }
th code { background: rgba(255,255,255,0.20); color: #fff; }
strong { color: #1a1a1a; }
.d { color: #c0392b; font-weight: 600; }
.p { color: #27ae60; font-weight: 600; }
.d strong, .p strong { color: inherit; }
.note { color: #777; font-size: 13px; }
.hl td { background: #fff8e1; }
.num { text-align: right; font-variant-numeric: tabular-nums; white-space: nowrap; }
.bar { display: inline-block; height: 13px; background: #c0392b; border-radius: 2px; vertical-align: middle; }
.bar.lo { background: #e8a33d; }
.bar.ok { background: #27ae60; }
</style></head><body>
<div class="wrap">${body_html}</div>
</body></html>
ENDHTML
  npx playwright screenshot --channel=chrome --viewport-size "${vw},100" --full-page \
    "file://${DIR}/_${name}.html" "${DIR}/${name}.png" 2>&1 | grep -i "error\|Executable doesn" && echo "⚠️  ${name} 產圖可能失敗"
  rm -f "${DIR}/_${name}.html"
  [ -f "${DIR}/${name}.png" ] && echo "✅ ${name}.png" || echo "❌ ${name}.png 沒產出"
}

trim() {
  local file="${DIR}/${1}.png"
  command -v magick >/dev/null 2>&1 || return 0
  [ -f "$file" ] || return 0
  magick "$file" -fuzz 3% -trim +repage -bordercolor '#f5f5f5' -border 12 "$file"
}

# ---------- 1. 四種擴充方式對照 ----------
generate "table-compare" '<table>
<tr><th style="min-width:150px"></th><th>mod</th><th>settings hook</th><th>skill</th><th>MCP server</th></tr>
<tr><td><strong>是什麼</strong></td><td>外掛裡的函式,跑在 Claude Code 自己的 process</td><td>settings.json 設定的指令 / HTTP / prompt</td><td><code>SKILL.md</code> 指示</td><td>外部 process 提供工具</td></tr>
<tr><td><strong>能改什麼</strong></td><td>tool call、prompt、turn、<strong>介面畫什麼</strong></td><td>放不放行、改參數與結果</td><td>Claude 知道什麼</td><td>Claude 有哪些工具</td></tr>
<tr class="hl"><td><strong>能畫介面嗎</strong></td><td class="p">能</td><td class="d">不能</td><td class="d">不能</td><td class="d">不能</td></tr>
<tr class="hl"><td><strong>要花 token 嗎</strong></td><td class="p">不用</td><td class="p">不用</td><td class="d">要</td><td class="d">要</td></tr>
<tr><td><strong>寫什麼</strong></td><td>JavaScript / TypeScript</td><td>腳本 + settings 條目</td><td>Markdown</td><td>任何語言</td></tr>
</table>' 1040
generate "table-compare-en" '<table>
<tr><th style="min-width:150px"></th><th>Mod</th><th>Settings hook</th><th>Skill</th><th>MCP server</th></tr>
<tr><td><strong>What it is</strong></td><td>Functions in a plugin, running in Claude Code&rsquo;s own process</td><td>A command / HTTP call / prompt configured in settings.json</td><td>A <code>SKILL.md</code> of instructions</td><td>An external process offering tools</td></tr>
<tr><td><strong>What it can change</strong></td><td>Tool calls, prompts, turns, <strong>what the interface draws</strong></td><td>Whether a call proceeds, its arguments and result</td><td>What Claude knows</td><td>Which tools Claude has</td></tr>
<tr class="hl"><td><strong>Can it draw</strong></td><td class="p">Yes</td><td class="d">No</td><td class="d">No</td><td class="d">No</td></tr>
<tr class="hl"><td><strong>Does it cost tokens</strong></td><td class="p">No</td><td class="p">No</td><td class="d">Yes</td><td class="d">Yes</td></tr>
<tr><td><strong>What you write</strong></td><td>JavaScript / TypeScript</td><td>A script plus a settings entry</td><td>Markdown</td><td>Any language</td></tr>
</table>' 1120

# ---------- 2. 哪裡跑得動 ----------
generate "table-where" '<table>
<tr><th>你在哪裡用 Claude Code</th><th>hook 跑嗎</th><th>畫得出來嗎</th></tr>
<tr><td>終端機 <code>claude</code>(含編輯器內建終端機)</td><td class="p">是</td><td class="p">是</td></tr>
<tr><td>桌面版 App 的 Code 分頁</td><td class="p">是</td><td class="p">是 <span class="note">(少數終端機限定元素除外)</span></td></tr>
<tr><td>桌面版的 WSL session</td><td class="d">否</td><td class="d">否</td></tr>
<tr class="hl"><td>VS Code 擴充套件的對話面板</td><td class="p">是</td><td class="d">否</td></tr>
<tr><td><code>claude -p</code> 與 Agent SDK</td><td class="p">是</td><td class="d">否</td></tr>
<tr><td>雲端 session</td><td class="note">看外掛有沒有跟進雲端</td><td class="d">否</td></tr>
</table>' 720
generate "table-where-en" '<table>
<tr><th>Where you run Claude Code</th><th>Hooks run</th><th>What it draws appears</th></tr>
<tr><td><code>claude</code> in a terminal (including an editor&rsquo;s integrated terminal)</td><td class="p">Yes</td><td class="p">Yes</td></tr>
<tr><td>The Code tab of the Desktop app</td><td class="p">Yes</td><td class="p">Yes <span class="note">(except terminal-only elements)</span></td></tr>
<tr><td>A WSL session in the Desktop app</td><td class="d">No</td><td class="d">No</td></tr>
<tr class="hl"><td>The VS Code extension&rsquo;s chat panel</td><td class="p">Yes</td><td class="d">No</td></tr>
<tr><td><code>claude -p</code> and the Agent SDK</td><td class="p">Yes</td><td class="d">No</td></tr>
<tr><td>A cloud session</td><td class="note">If the plugin reaches the cloud session</td><td class="d">No</td></tr>
</table>' 820

for t in table-compare table-compare-en table-where table-where-en; do trim "$t"; done

# ---------- 3. 一個 mod vs 兩個 mod ----------
generate "table-split" '<table>
<tr><th style="min-width:220px"></th><th>一個 mod</th><th>兩個 mod</th></tr>
<tr class="hl"><td><strong>常駐的那支能開 process 嗎</strong></td><td class="d"><strong>能</strong></td><td class="p"><strong>不能</strong></td></tr>
<tr><td>drift 怎麼觸發</td><td><code>/check drift</code> 參數</td><td><code>/check-drift</code> 獨立指令</td></tr>
<tr><td>沒裝 LM Studio 的人</td><td>裝到一個帶著死功能的 mod</td><td>不裝那支就好</td></tr>
<tr><td>給別人用</td><td>綁死中英雙語流程</td><td><code>medium-band</code> 可單獨給</td></tr>
<tr><td>markdown 解析碼</td><td>一份</td><td>兩份,各約 40 行</td></tr>
<tr><td><code>validate</code> 看起來</td><td>一張混在一起的能力清單</td><td>兩張,各自對應各自的風險</td></tr>
</table>' 800
generate "table-split-en" '<table>
<tr><th style="min-width:280px"></th><th>One mod</th><th>Two mods</th></tr>
<tr class="hl"><td><strong>Can the always-on one start processes</strong></td><td class="d"><strong>Yes</strong></td><td class="p"><strong>No</strong></td></tr>
<tr><td>How drift is triggered</td><td><code>/check drift</code> argument</td><td><code>/check-drift</code>, its own command</td></tr>
<tr><td>Someone without LM Studio</td><td>Installs a mod with a dead feature</td><td>Simply does not install that one</td></tr>
<tr><td>Giving it to someone else</td><td>Tied to a bilingual workflow</td><td><code>medium-band</code> stands alone</td></tr>
<tr><td>Markdown parsing code</td><td>One copy</td><td>Two copies, about 40 lines each</td></tr>
<tr><td>What <code>validate</code> shows</td><td>One capability list, mixed together</td><td>Two, each matching its own risk</td></tr>
</table>' 900

for t in table-split table-split-en; do trim "$t"; done

# ---------- 4. mods 還能做什麼 ----------
generate "table-uses" '<table>
<tr><th>應用</th><th>靠哪個事件</th><th>驗證程度</th></tr>
<tr class="hl"><td>常駐狀態列(檢查清單、CI 狀態、待辦)</td><td><code>ui.render{AbovePrompt}</code></td><td class="p">本文實作</td></tr>
<tr class="hl"><td>自訂指令直接跑函式,不經模型</td><td><code>command.register</code> + <code>command.run</code></td><td class="p">本文實作</td></tr>
<tr class="hl"><td>寫檔守門員,擋含敏感字的 Edit/Write</td><td><code>tool.call{Write/Edit}</code> → <code>{ deny }</code></td><td class="p">本文實作</td></tr>
<tr class="hl"><td>把慢工具塞進 hook(地端模型、外部 CLI)</td><td><code>$.process.run</code></td><td class="p">本文實作</td></tr>
<tr><td>危險指令攔截 + 影響範圍預覽,附確認按鈕</td><td><code>tool.call{Bash}</code> + <code>Pane</code></td><td>官方 <code>blast-radius</code>(528 行)</td></tr>
<tr><td>context 用量儀表板</td><td><code>turn.complete</code> + <code>$.session.usage</code></td><td>官方 <code>token-weather</code>(122 行)</td></tr>
<tr><td>重播上一輪的檔案修改</td><td><code>command.run</code> + <code>$.fs</code> + <code>Pane</code></td><td>官方 <code>replay-theater</code>(249 行)</td></tr>
<tr><td>接管內建指令(<code>/diff</code> 本身就是 mod)</td><td><code>command.run</code></td><td>內建 <code>cc-plugin-diff</code></td></tr>
<tr><td>側邊 agent 盯著你,發現漏掉的事就貼便條</td><td><code>agent.spawn</code> + <code>AbovePrompt</code></td><td>內建 <code>you-should-know</code></td></tr>
</table>' 1000
generate "table-uses-en" '<table>
<tr><th>Use</th><th>Which event</th><th>How far I verified it</th></tr>
<tr class="hl"><td>A standing status line (checklists, CI state, todos)</td><td><code>ui.render{AbovePrompt}</code></td><td class="p">Built here</td></tr>
<tr class="hl"><td>A command that runs your function, no model turn</td><td><code>command.register</code> + <code>command.run</code></td><td class="p">Built here</td></tr>
<tr class="hl"><td>A write guard blocking Edit/Write with sensitive strings</td><td><code>tool.call{Write/Edit}</code> → <code>{ deny }</code></td><td class="p">Built here</td></tr>
<tr class="hl"><td>Putting a slow tool inside a hook (local model, CLI)</td><td><code>$.process.run</code></td><td class="p">Built here</td></tr>
<tr><td>Holding a risky shell command, previewing its blast radius</td><td><code>tool.call{Bash}</code> + <code>Pane</code></td><td>Official <code>blast-radius</code> (528 lines)</td></tr>
<tr><td>A context usage dashboard</td><td><code>turn.complete</code> + <code>$.session.usage</code></td><td>Official <code>token-weather</code> (122)</td></tr>
<tr><td>Replaying the file edits from the last turn</td><td><code>command.run</code> + <code>$.fs</code> + <code>Pane</code></td><td>Official <code>replay-theater</code> (249)</td></tr>
<tr><td>Taking over a built-in command (<code>/diff</code> is a mod)</td><td><code>command.run</code></td><td>Built-in <code>cc-plugin-diff</code></td></tr>
<tr><td>A side agent watching for what you might miss</td><td><code>agent.spawn</code> + <code>AbovePrompt</code></td><td>Built-in <code>you-should-know</code></td></tr>
</table>' 1120

for t in table-uses table-uses-en; do trim "$t"; done
