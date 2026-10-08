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
# ---------- 1. 五題與落點 ----------
generate "table-design" '<table>
<tr><th>題</th><th>問什麼</th><th>答案在 CLAUDE.md 哪一段</th></tr>
<tr class="hl"><td><strong>Q1</strong></td><td>host 與 guest 怎麼通訊?預設 port?契約在哪個檔?</td><td><strong>Architecture</strong> <span class="note">(L33&ndash;40)</span></td></tr>
<tr><td><strong>Q2</strong></td><td>加一個 <code>cctl</code> 子命令要改哪些檔?</td><td class="d"><strong>完全沒寫</strong> <span class="note">(對照)</span></td></tr>
<tr class="hl"><td><strong>Q3</strong></td><td>幾個 VMM 後端?怎麼切換?</td><td><strong>Architecture</strong> <span class="note">(L42&ndash;49)</span></td></tr>
<tr><td><strong>Q4</strong></td><td>為什麼不用 <code>swift build</code> 建?guest 那半怎麼編?</td><td class="d">Build 段 <span class="note">(L5&ndash;27,對照)</span></td></tr>
<tr class="hl"><td><strong>Q5</strong></td><td>「讀 ext4」的功能放哪個 module?能 import <code>Containerization</code> 嗎?</td><td><strong>Architecture</strong> <span class="note">(L58&ndash;70)</span></td></tr>
</table>' 940
generate "table-design-en" '<table>
<tr><th>Q</th><th>The question</th><th>Where the answer lives in CLAUDE.md</th></tr>
<tr class="hl"><td><strong>Q1</strong></td><td>How do host and guest communicate? Default port? Where is the contract?</td><td><strong>Architecture</strong> <span class="note">(L33&ndash;40)</span></td></tr>
<tr><td><strong>Q2</strong></td><td>To add a <code>cctl</code> subcommand, which files change?</td><td class="d"><strong>Not written at all</strong> <span class="note">(control)</span></td></tr>
<tr class="hl"><td><strong>Q3</strong></td><td>How many VMM backends? How are they selected?</td><td><strong>Architecture</strong> <span class="note">(L42&ndash;49)</span></td></tr>
<tr><td><strong>Q4</strong></td><td>Why not build with <code>swift build</code>? How is the guest half compiled?</td><td class="d">Build section <span class="note">(L5&ndash;27, control)</span></td></tr>
<tr class="hl"><td><strong>Q5</strong></td><td>Where does an ext4 reader go? May it import <code>Containerization</code>?</td><td><strong>Architecture</strong> <span class="note">(L58&ndash;70)</span></td></tr>
</table>' 1020

for t in table-design table-design-en; do trim "$t"; done

# ---------- 2. 結果 ----------
generate "table-result" '<table>
<tr><th>題</th><th>落點</th><th>A 完整 91 行</th><th>B 砍掉 Arch</th><th>C 無 CLAUDE.md</th></tr>
<tr><td>Q1 通訊機制</td><td><strong>Architecture</strong></td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td><code>[2, 2, 5]</code> → 3.0</td><td><code>[3, 5, 5]</code> → 4.3</td></tr>
<tr><td>Q2 新增子命令</td><td class="note">對照(未寫)</td><td><code>[2, 2, 2]</code> → 2.0</td><td><code>[2, 4, 4]</code> → 3.3</td><td><code>[4, 3, 3]</code> → 3.3</td></tr>
<tr><td>Q3 VMM 後端</td><td><strong>Architecture</strong></td><td><code>[0, 4, 1]</code> → 1.7</td><td class="d"><code>[9, 10, 7]</code> → <strong>8.7</strong></td><td><code>[4, 5, 5]</code> → 4.7</td></tr>
<tr><td>Q4 為何不用 swift build</td><td class="note">對照(Build 段)</td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td><code>[4, 3, 2]</code> → 3.0</td></tr>
<tr><td>Q5 module 邊界</td><td><strong>Architecture</strong></td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td><code>[4, 1, 3]</code> → 2.7</td><td><code>[5, 5, 2]</code> → 4.0</td></tr>
<tr class="hl"><td colspan="2"><strong>Architecture 三題合計</strong></td><td class="p"><strong>1.7 次／輪</strong></td><td class="d"><strong>14.3 次／輪</strong></td><td><strong>13.0 次／輪</strong></td></tr>
<tr class="hl"><td colspan="2">對照兩題合計</td><td>2.0 次／輪</td><td>3.3 次／輪</td><td>6.3 次／輪</td></tr>
</table>' 1100
generate "table-result-en" '<table>
<tr><th>Q</th><th>Where</th><th>A full 91 lines</th><th>B Arch removed</th><th>C no CLAUDE.md</th></tr>
<tr><td>Q1 Communication</td><td><strong>Architecture</strong></td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td><code>[2, 2, 5]</code> → 3.0</td><td><code>[3, 5, 5]</code> → 4.3</td></tr>
<tr><td>Q2 New subcommand</td><td class="note">Control (not written)</td><td><code>[2, 2, 2]</code> → 2.0</td><td><code>[2, 4, 4]</code> → 3.3</td><td><code>[4, 3, 3]</code> → 3.3</td></tr>
<tr><td>Q3 VMM backends</td><td><strong>Architecture</strong></td><td><code>[0, 4, 1]</code> → 1.7</td><td class="d"><code>[9, 10, 7]</code> → <strong>8.7</strong></td><td><code>[4, 5, 5]</code> → 4.7</td></tr>
<tr><td>Q4 Why not swift build</td><td class="note">Control (Build section)</td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td><code>[4, 3, 2]</code> → 3.0</td></tr>
<tr><td>Q5 Module boundary</td><td><strong>Architecture</strong></td><td class="p"><code>[0, 0, 0]</code> → <strong>0.0</strong></td><td><code>[4, 1, 3]</code> → 2.7</td><td><code>[5, 5, 2]</code> → 4.0</td></tr>
<tr class="hl"><td colspan="2"><strong>Architecture questions, total</strong></td><td class="p"><strong>1.7 per run</strong></td><td class="d"><strong>14.3 per run</strong></td><td><strong>13.0 per run</strong></td></tr>
<tr class="hl"><td colspan="2">Control questions, total</td><td>2.0 per run</td><td>3.3 per run</td><td>6.3 per run</td></tr>
</table>' 1180

for t in table-result table-result-en; do trim "$t"; done

# ---------- 3. 種下假事實 ----------
generate "table-stale" '<table>
<tr><th>種下的假事實</th><th>這個事實在文件裡的狀況</th><th>結果(3 次)</th></tr>
<tr class="hl"><td>vsock port <code>1024</code> → <strong><code>1025</code></strong></td><td><strong>孤立</strong> —— 全份 CLAUDE.md 只出現這一次</td><td class="d"><strong>照抄 1025</strong><br><span class="note">三次皆然,tool call 0 次</span></td></tr>
<tr><td>proto 路徑 → <code>Sandbox/ContextService.proto</code> <span class="note">(不存在)</span></td><td>L24 的 <code>make protos</code> 說明仍指著舊路徑</td><td class="lo" style="color:#e8a33d;font-weight:600">注意到矛盾,但沒查證<br><span class="note">三次皆然,tool call 0 次</span></td></tr>
<tr><td>ext4 的 module → <code>ContainerizationIO</code></td><td>害清單裡出現<strong>兩個</strong> <code>ContainerizationIO</code> 條目</td><td class="p">真的去查了<br><span class="note">三次皆然,tool call 1–2 次</span></td></tr>
</table>' 1180
generate "table-stale-en" '<table>
<tr><th>The false fact I planted</th><th>How that fact sits in the document</th><th>Result (3 runs)</th></tr>
<tr class="hl"><td>vsock port <code>1024</code> → <strong><code>1025</code></strong></td><td><strong>Isolated</strong> &mdash; stated once in the whole file</td><td class="d"><strong>Repeated 1025</strong><br><span class="note">all three runs, 0 tool calls</span></td></tr>
<tr><td>proto path → <code>Sandbox/ContextService.proto</code> <span class="note">(does not exist)</span></td><td>The <code>make protos</code> note on L24 still points at the old path</td><td class="lo" style="color:#e8a33d;font-weight:600">Noticed the contradiction, never verified<br><span class="note">all three runs, 0 tool calls</span></td></tr>
<tr><td>ext4 module → <code>ContainerizationIO</code></td><td>Left <strong>two</strong> <code>ContainerizationIO</code> entries in the list</td><td class="p">Actually went and checked<br><span class="note">all three runs, 1&ndash;2 tool calls</span></td></tr>
</table>' 1260

for t in table-stale table-stale-en; do trim "$t"; done

# ---------- 4. 四個組別 ----------
generate "table-arms" '<table>
<tr><th>組</th><th>那份 CLAUDE.md</th><th>行數</th><th>這一組要回答什麼</th></tr>
<tr><td><strong>A</strong></td><td>原樣,一個字沒動</td><td class="num">91</td><td>基準</td></tr>
<tr class="hl"><td><strong>B</strong></td><td>砍掉 Architecture 段 <span class="note">(L29&ndash;79)</span></td><td class="num">40</td><td><strong>那 51 行值多少</strong></td></tr>
<tr><td><strong>C</strong></td><td>整份刪掉</td><td class="num">0</td><td>完全靠原始碼要花多少</td></tr>
<tr class="hl"><td><strong>D</strong></td><td>原樣,但在 Architecture 段裡<strong>種三個假事實</strong></td><td class="num">91</td><td><strong>文件過期它會發現嗎</strong></td></tr>
</table>' 860
generate "table-arms-en" '<table>
<tr><th>Arm</th><th>Its CLAUDE.md</th><th>Lines</th><th>What this arm answers</th></tr>
<tr><td><strong>A</strong></td><td>Untouched</td><td class="num">91</td><td>Baseline</td></tr>
<tr class="hl"><td><strong>B</strong></td><td>Architecture section removed <span class="note">(L29&ndash;79)</span></td><td class="num">40</td><td><strong>What those 51 lines are worth</strong></td></tr>
<tr><td><strong>C</strong></td><td>Deleted entirely</td><td class="num">0</td><td>The cost of reading source alone</td></tr>
<tr class="hl"><td><strong>D</strong></td><td>Untouched, but with <strong>three false facts planted</strong> in the Architecture section</td><td class="num">91</td><td><strong>Does it notice a stale document</strong></td></tr>
</table>' 980

for t in table-arms table-arms-en; do trim "$t"; done

# ---------- 5. 成本與 token ----------
generate "table-cost" '<table>
<tr><th>每輪平均</th><th>A 完整 91 行</th><th>B 砍掉 Arch</th><th>C 無 CLAUDE.md</th></tr>
<tr class="hl"><td><strong>Architecture 三題 成本</strong></td><td class="p"><strong>$0.1153</strong></td><td class="d">$0.2107 <span class="note">(1.83×)</span></td><td class="d">$0.2334 <span class="note">(2.02×)</span></td></tr>
<tr><td>　計費 input tokens</td><td class="num">118,362</td><td class="num">273,941</td><td class="num">324,693</td></tr>
<tr><td>　output tokens</td><td class="num">2,819</td><td class="num">5,267</td><td class="num">5,317</td></tr>
<tr class="hl"><td><strong>對照兩題 成本</strong></td><td>$0.0925</td><td class="p"><strong>$0.0870</strong> <span class="note">(0.94×,便宜 6%)</span></td><td class="d">$0.1536 <span class="note">(1.66×)</span></td></tr>
<tr><td><strong>五題合計 成本</strong></td><td class="p">$0.2078</td><td>$0.2977</td><td class="d">$0.3869</td></tr>
</table>' 1120
generate "table-cost-en" '<table>
<tr><th>Per run, averaged</th><th>A full 91 lines</th><th>B Arch removed</th><th>C no CLAUDE.md</th></tr>
<tr class="hl"><td><strong>Architecture questions, cost</strong></td><td class="p"><strong>$0.1153</strong></td><td class="d">$0.2107 <span class="note">(1.83&times;)</span></td><td class="d">$0.2334 <span class="note">(2.02&times;)</span></td></tr>
<tr><td>　Billed input tokens</td><td class="num">118,362</td><td class="num">273,941</td><td class="num">324,693</td></tr>
<tr><td>　Output tokens</td><td class="num">2,819</td><td class="num">5,267</td><td class="num">5,317</td></tr>
<tr class="hl"><td><strong>Control questions, cost</strong></td><td>$0.0925</td><td class="p"><strong>$0.0870</strong> <span class="note">(0.94&times;, 6% cheaper)</span></td><td class="d">$0.1536 <span class="note">(1.66&times;)</span></td></tr>
<tr><td><strong>All five questions, cost</strong></td><td class="p">$0.2078</td><td>$0.2977</td><td class="d">$0.3869</td></tr>
</table>' 1240

for t in table-cost table-cost-en; do trim "$t"; done
