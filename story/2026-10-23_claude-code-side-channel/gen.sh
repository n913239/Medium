#!/bin/bash
# 2026-09-10:playwright 1.63 起本機沒有 headless shell,一律用 --channel=chrome
# 走系統 Chrome。⚠️ 它的算繪與舊版 headless shell 不同,重產的 PNG 不會與
# 已發布的位元組相同(檔案會小約 10%),已發布的文章沒事別重跑。
cd "$(dirname "$0")"
DIR="$(pwd)"

generate() {
  local name="$1"
  local body_html="$2"
  # 第 3 個參數(舊版的 viewport 寬度)已不使用:viewport 固定 400,
  # 靠 table 的 width:max-content 把 document 橫向撐開,--full-page 就會
  # 截到表格的真實寬度。這台機器沒裝 ImageMagick,下面的 trim 會靜默跳過
  # (2026-10-23 才發現,先前整批圖右側都留著一塊空白)。
  local _unused_vw="${3:-720}"
  cat > "${DIR}/_${name}.html" << ENDHTML
<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8">
<style>
html, body { margin: 0; padding: 0; background: #f5f5f5; }
.wrap { display: inline-block; padding: 20px; }
table { border-collapse: collapse; font-size: 15px; line-height: 1.6; background: #fff; width: max-content; }
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
  npx playwright screenshot --channel=chrome --viewport-size "400,100" --full-page \
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

# ---------- 1. 一個請求的解剖 ----------
generate "table-anatomy" '<table>
<tr><th>請求的哪一塊</th><th>內容</th><th>大小</th><th>cache_control</th></tr>
<tr><td rowspan="3"><strong>system</strong><br><span class="note">3 個 block</span></td><td>第 1 塊</td><td class="num">74 字元</td><td class="note">—</td></tr>
<tr><td>第 2 塊</td><td class="num">62 字元</td><td class="p">ephemeral 1h</td></tr>
<tr class="hl"><td>第 3 塊 <span class="note">(Anthropic 的 system 守則)</span></td><td class="num"><strong>27,565 字元</strong></td><td class="p">ephemeral 1h</td></tr>
<tr><td><strong>tools</strong></td><td>28 個工具定義 <span class="note">(全是內建)</span></td><td class="num"><strong>95,662 bytes</strong></td><td class="note">自己沒有<br><span class="note">(被 system 的標記蓋住)</span></td></tr>
<tr><td rowspan="8"><strong>messages</strong><br><span class="note">只有 1 則 user,<br>切成 8 個 block</span></td><td>[0] 執行環境</td><td class="num">712</td><td class="note">—</td></tr>
<tr><td>[1] 模型資訊</td><td class="num">176</td><td class="note">—</td></tr>
<tr><td>[2] 可用的 agent 類型</td><td class="num">1,880</td><td class="note">—</td></tr>
<tr><td>[3] 可用的 skill 清單</td><td class="num">7,964</td><td class="note">—</td></tr>
<tr><td>[4] <strong>CLAUDE.md 與使用者指令</strong></td><td class="num">1,497</td><td class="note">—</td></tr>
<tr><td>[5] 回答時的注意事項</td><td class="num">559</td><td class="note">—</td></tr>
<tr><td>[6] 今天日期</td><td class="num">65</td><td class="note">—</td></tr>
<tr class="hl"><td>[7] <strong>我真正打的字</strong></td><td class="num"><strong>29</strong></td><td class="p"><strong>ephemeral 1h</strong></td></tr>
<tr><td colspan="2"><strong>整個請求</strong></td><td class="num"><strong>138,765 bytes</strong></td><td class="note"></td></tr>
</table>' 980
generate "table-anatomy-en" '<table>
<tr><th>Part of the request</th><th>What it holds</th><th>Size</th><th>cache_control</th></tr>
<tr><td rowspan="3"><strong>system</strong><br><span class="note">3 blocks</span></td><td>Block 1</td><td class="num">74 chars</td><td class="note">&mdash;</td></tr>
<tr><td>Block 2</td><td class="num">62 chars</td><td class="p">ephemeral 1h</td></tr>
<tr class="hl"><td>Block 3 <span class="note">(Anthropic&rsquo;s system prompt)</span></td><td class="num"><strong>27,565 chars</strong></td><td class="p">ephemeral 1h</td></tr>
<tr><td><strong>tools</strong></td><td>28 tool definitions <span class="note">(all built-in)</span></td><td class="num"><strong>95,662 bytes</strong></td><td class="note">none of its own<br><span class="note">(covered by the system marker)</span></td></tr>
<tr><td rowspan="8"><strong>messages</strong><br><span class="note">one user message,<br>split into 8 blocks</span></td><td>[0] Environment</td><td class="num">712</td><td class="note">&mdash;</td></tr>
<tr><td>[1] Model information</td><td class="num">176</td><td class="note">&mdash;</td></tr>
<tr><td>[2] Available agent types</td><td class="num">1,880</td><td class="note">&mdash;</td></tr>
<tr><td>[3] Available skills</td><td class="num">7,964</td><td class="note">&mdash;</td></tr>
<tr><td>[4] <strong>CLAUDE.md and user instructions</strong></td><td class="num">1,497</td><td class="note">&mdash;</td></tr>
<tr><td>[5] Notes on answering</td><td class="num">559</td><td class="note">&mdash;</td></tr>
<tr><td>[6] Today&rsquo;s date</td><td class="num">65</td><td class="note">&mdash;</td></tr>
<tr class="hl"><td>[7] <strong>What I actually typed</strong></td><td class="num"><strong>29</strong></td><td class="p"><strong>ephemeral 1h</strong></td></tr>
<tr><td colspan="2"><strong>The whole request</strong></td><td class="num"><strong>138,765 bytes</strong></td><td class="note"></td></tr>
</table>' 1060

for t in table-anatomy table-anatomy-en; do trim "$t"; done

# ---------- 2. 標記字串什麼時候進請求 ----------
generate "table-markers" '<table>
<tr><th>標記字串放在哪</th><th>什麼時候出現在請求裡</th></tr>
<tr class="hl"><td>CLAUDE.md 的 <strong>block-level 註解</strong><br><span class="note">&lt;!-- … --&gt; 自成一段</span></td><td class="d">從來沒有</td></tr>
<tr><td>CLAUDE.md 的<strong>正文</strong></td><td class="p">第一輪就在<span class="note">(對照組)</span></td></tr>
<tr class="hl"><td>CLAUDE.md <strong>code fence 裡的註解</strong></td><td class="p"><strong>第一輪就在</strong><br><span class="note">文件寫明的例外</span></td></tr>
<tr class="hl"><td><code>.claude/rules/</code> 的<br><code>paths: ["**/*.ts"]</code></td><td>讀 <code>.ts</code> 之後<strong class="p">才出現</strong><br><span class="note">src/app.ts、docs/helper.ts</span><br>讀 <code>.md</code> <span class="d">不會</span><br><span class="note">docs/readme.md、src/notes.md</span><br><span class="note">→ 看副檔名不看目錄</span></td></tr>
<tr class="hl"><td><code>notes/CLAUDE.md</code><br><span class="note">沒有 frontmatter</span></td><td><code>cat notes/deep.md</code> 之後才出現<br><span class="note">bash 的 cat 也算 read</span></td></tr>
</table>' 900
generate "table-markers-en" '<table>
<tr><th>Where the marker string lives</th><th>When it shows up in the request</th></tr>
<tr class="hl"><td>A <strong>block-level comment</strong> in CLAUDE.md<br><span class="note">&lt;!-- … --&gt; on its own</span></td><td class="d">Never</td></tr>
<tr><td><strong>Prose</strong> in CLAUDE.md</td><td class="p">From the first request<span class="note">(control)</span></td></tr>
<tr class="hl"><td>A comment <strong>inside a code fence</strong> in CLAUDE.md</td><td class="p"><strong>From the first request</strong><br><span class="note">the documented exception</span></td></tr>
<tr class="hl"><td><code>.claude/rules/</code> with<br><code>paths: ["**/*.ts"]</code></td><td><strong class="p">Only after</strong> a <code>.ts</code> read<br><span class="note">src/app.ts, docs/helper.ts</span><br><span class="d">Not</span> after a <code>.md</code> read<br><span class="note">docs/readme.md, src/notes.md</span><br><span class="note">&rarr; extension, not directory</span></td></tr>
<tr class="hl"><td><code>notes/CLAUDE.md</code><br><span class="note">no frontmatter</span></td><td>Only after <code>cat notes/deep.md</code><br><span class="note">bash cat counts as a read</span></td></tr>
</table>' 980

for t in table-markers table-markers-en; do trim "$t"; done

# ---------- 3. cache 邊界會滑動 ----------
generate "table-cache" '<table>
<tr><th>block</th><th>第 1 輪</th><th>第 2 輪</th></tr>
<tr><td>system 第 2、3 塊</td><td class="p">1h</td><td class="p">1h</td></tr>
<tr class="hl"><td>user 的最後一塊(我打的字)</td><td class="p"><strong>1h</strong></td><td class="d"><strong>沒有了</strong></td></tr>
<tr class="hl"><td>assistant 的 <code>tool_use</code></td><td class="note">(還不存在)</td><td class="p"><strong>1h</strong></td></tr>
<tr class="hl"><td>user 的 <code>tool_result</code></td><td class="note">(還不存在)</td><td class="p"><strong>1h</strong></td></tr>
<tr><td colspan="1"><strong>標記總數</strong></td><td class="num">3 個</td><td class="num"><strong>4 個</strong> <span class="note">(上限)</span></td></tr>
<tr><td colspan="1"><strong>請求大小</strong></td><td class="num">138,765 bytes</td><td class="num">140,065 bytes <span class="note">(+1,300)</span></td></tr>
</table>' 820
generate "table-cache-en" '<table>
<tr><th>Block</th><th>Request 1</th><th>Request 2</th></tr>
<tr><td>system blocks 2 and 3</td><td class="p">1h</td><td class="p">1h</td></tr>
<tr class="hl"><td>Last user block (what I typed)</td><td class="p"><strong>1h</strong></td><td class="d"><strong>gone</strong></td></tr>
<tr class="hl"><td>The assistant&rsquo;s <code>tool_use</code></td><td class="note">(does not exist yet)</td><td class="p"><strong>1h</strong></td></tr>
<tr class="hl"><td>The <code>tool_result</code></td><td class="note">(does not exist yet)</td><td class="p"><strong>1h</strong></td></tr>
<tr><td colspan="1"><strong>Markers in total</strong></td><td class="num">3</td><td class="num"><strong>4</strong> <span class="note">(the limit)</span></td></tr>
<tr><td colspan="1"><strong>Request size</strong></td><td class="num">138,765 bytes</td><td class="num">140,065 bytes <span class="note">(+1,300)</span></td></tr>
</table>' 900

for t in table-cache table-cache-en; do trim "$t"; done
