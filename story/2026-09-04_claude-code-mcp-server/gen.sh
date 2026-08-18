#!/bin/bash
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
  npx playwright screenshot --viewport-size "${vw},100" --full-page \
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

# ---------- 1. 三層架構 ----------
generate "table-layer" '<table>
<tr><th>層</th><th>機制</th><th>什麼時候生效</th><th>適合放什麼</th></tr>
<tr><td><strong>脈絡</strong></td><td><code>CLAUDE.md</code></td><td>每次 session 自動載入</td><td>「不知道就會做錯」的專案事實</td></tr>
<tr class="hl"><td><strong>能力</strong></td><td><strong>MCP server / skill</strong></td><td><strong>Claude 判斷需要時主動呼叫</strong></td><td><strong>要算、要查、要跑的事</strong></td></tr>
<tr><td>強制</td><td>hook / CI</td><td>固定生命週期事件,不管 AI 怎麼想</td><td>一定要擋的紅線</td></tr>
</table>' 900

generate "table-layer-en" '<table>
<tr><th>Layer</th><th>Mechanism</th><th>When it fires</th><th>What belongs there</th></tr>
<tr><td><strong>Context</strong></td><td><code>CLAUDE.md</code></td><td>Loaded at the start of every session</td><td>Project facts you&rsquo;d get wrong without knowing</td></tr>
<tr class="hl"><td><strong>Capability</strong></td><td><strong>MCP server / skill</strong></td><td><strong>Called when Claude decides it&rsquo;s needed</strong></td><td><strong>Things to compute, look up, or run</strong></td></tr>
<tr><td>Enforcement</td><td>hook / CI</td><td>Fixed lifecycle events, regardless of the model</td><td>Hard lines that must be blocked</td></tr>
</table>' 1060

# ---------- 2. SDK 2.0 改名對照 ----------
generate "table-sdk" '<table>
<tr><th>舊教材寫的</th><th>SDK 2.0 實際上</th></tr>
<tr><td class="d"><code>from mcp.server.fastmcp import FastMCP</code></td><td class="p"><code>from mcp.server.mcpserver import MCPServer</code></td></tr>
<tr><td class="d"><code>FastMCP("name")</code></td><td class="p"><code>MCPServer("name", instructions=..., version=...)</code></td></tr>
<tr><td class="d"><code>init.serverInfo</code></td><td class="p"><code>init.server_info</code></td></tr>
<tr><td class="d"><code>tool.inputSchema</code></td><td class="p"><code>tool.input_schema</code></td></tr>
</table>' 880

generate "table-sdk-en" '<table>
<tr><th>What the old tutorials say</th><th>What SDK 2.0 actually wants</th></tr>
<tr><td class="d"><code>from mcp.server.fastmcp import FastMCP</code></td><td class="p"><code>from mcp.server.mcpserver import MCPServer</code></td></tr>
<tr><td class="d"><code>FastMCP("name")</code></td><td class="p"><code>MCPServer("name", instructions=..., version=...)</code></td></tr>
<tr><td class="d"><code>init.serverInfo</code></td><td class="p"><code>init.server_info</code></td></tr>
<tr><td class="d"><code>tool.inputSchema</code></td><td class="p"><code>tool.input_schema</code></td></tr>
</table>' 900

# ---------- 3. 手動整理的三種漏法 ----------
generate "table-miss" '<table>
<tr><th>文章</th><th>當時做了什麼</th><th>今天仍不合格</th><th>漏法</th></tr>
<tr><td>0504</td><td><code>結語</code> → <code>總結</code> <span class="p">✅</span></td><td>參考資料段還叫「知識來源 / Sources」</td><td>修好了搜到的,漏了它的兄弟節</td></tr>
<tr><td>0701</td><td><code>Conclusion:</code> → <code>Summary:</code> <span class="p">✅</span></td><td>副標還掛著:<code>Summary: Better Models Won&rsquo;t Save You…</code></td><td>換掉關鍵字,沒滿足規則</td></tr>
<tr class="hl"><td>0707</td><td class="d"><strong>完全沒動到</strong></td><td>結尾是「Part 6:我的誠實評價」,<strong>根本沒有總結段</strong></td><td><strong>搜不到一個不存在的東西</strong></td></tr>
</table>' 1040

generate "table-miss-en" '<table>
<tr><th>Piece</th><th>What the cleanup did</th><th>Still wrong today</th><th>Failure mode</th></tr>
<tr><td>0504</td><td><code>結語</code> → <code>總結</code> <span class="p">✅</span></td><td>References section still named &ldquo;知識來源 / Sources&rdquo;</td><td>Fixed what it searched for, missed the sibling</td></tr>
<tr><td>0701</td><td><code>Conclusion:</code> → <code>Summary:</code> <span class="p">✅</span></td><td>Subtitle still attached: <code>Summary: Better Models Won&rsquo;t Save You…</code></td><td>Swapped the keyword, didn&rsquo;t satisfy the rule</td></tr>
<tr class="hl"><td>0707</td><td class="d"><strong>never touched</strong></td><td>Ends on &ldquo;Part 6: My Honest Assessment&rdquo; — <strong>no Summary at all</strong></td><td><strong>You can&rsquo;t grep for something that isn&rsquo;t there</strong></td></tr>
</table>' 1180

# ---------- 4. 全形標點曲線 ----------
bar() { echo "<span class=\"bar${2:+ $2}\" style=\"width:${1}px\"></span>"; }

CURVE_ZH='<table>
<tr><th>文章</th><th>全形標點數</th><th></th></tr>
<tr><td>0508</td><td class="num">188</td><td>'"$(bar 188)"'</td></tr>
<tr><td>0515</td><td class="num">123</td><td>'"$(bar 123)"'</td></tr>
<tr><td>0605</td><td class="num">66</td><td>'"$(bar 66)"'</td></tr>
<tr><td>0701</td><td class="num">128</td><td>'"$(bar 128)"'</td></tr>
<tr><td>0707</td><td class="num"><strong>212</strong></td><td>'"$(bar 212)"'</td></tr>
<tr class="hl"><td><strong>0717</strong></td><td class="num"><strong>12</strong></td><td>'"$(bar 12 lo)"' <span class="note">← 慣例在這裡落地</span></td></tr>
<tr><td>0724</td><td class="num">3</td><td>'"$(bar 3 lo)"'</td></tr>
<tr><td>0731 / 0807</td><td class="num">5 / 5</td><td>'"$(bar 5 lo)"'</td></tr>
<tr><td>0814 / 0821 / 0828</td><td class="num p"><strong>0 / 0 / 0</strong></td><td><span class="note">(無)</span></td></tr>
</table>'
generate "table-curve" "$CURVE_ZH" 720

CURVE_EN='<table>
<tr><th>Piece</th><th>Full-width punctuation</th><th></th></tr>
<tr><td>0508</td><td class="num">188</td><td>'"$(bar 188)"'</td></tr>
<tr><td>0515</td><td class="num">123</td><td>'"$(bar 123)"'</td></tr>
<tr><td>0605</td><td class="num">66</td><td>'"$(bar 66)"'</td></tr>
<tr><td>0701</td><td class="num">128</td><td>'"$(bar 128)"'</td></tr>
<tr><td>0707</td><td class="num"><strong>212</strong></td><td>'"$(bar 212)"'</td></tr>
<tr class="hl"><td><strong>0717</strong></td><td class="num"><strong>12</strong></td><td>'"$(bar 12 lo)"' <span class="note">← the rule lands here</span></td></tr>
<tr><td>0724</td><td class="num">3</td><td>'"$(bar 3 lo)"'</td></tr>
<tr><td>0731 / 0807</td><td class="num">5 / 5</td><td>'"$(bar 5 lo)"'</td></tr>
<tr><td>0814 / 0821 / 0828</td><td class="num p"><strong>0 / 0 / 0</strong></td><td><span class="note">(none)</span></td></tr>
</table>'
generate "table-curve-en" "$CURVE_EN" 800

echo ""
echo "裁切邊框..."
for name in table-layer table-layer-en table-sdk table-sdk-en table-miss table-miss-en table-curve table-curve-en; do
  trim "$name"
done

echo ""
echo "完成！"
