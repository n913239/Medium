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
td { padding: 12px 18px; border-bottom: 1px solid #e0e0e0; color: #333; }
tr:last-child td { border-bottom: none; }
code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 13px; font-family: "SF Mono", Menlo, monospace; }
th code { background: rgba(255,255,255,0.20); color: #fff; }
strong { color: #1a1a1a; }
.d { color: #c0392b; font-weight: 600; }
.p { color: #27ae60; font-weight: 600; }
.note { color: #777; font-size: 13px; }
</style></head><body>
<div class="wrap">${body_html}</div>
<script>
  const w = document.querySelector('.wrap');
  document.title = w.offsetWidth + 'x' + w.offsetHeight;
</script>
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

# ---------- 1. method 邊佔比:高連接度 ≠ god node ----------
generate "table-method" '<table>
<tr><th>節點</th><th>專案</th><th>總邊</th><th>其中 <code>method</code></th><th>佔比</th></tr>
<tr><td><code>RecordDetailViewController</code></td><td>那個 iOS 專案</td><td>120</td><td>92</td><td class="d">76.7%</td></tr>
<tr><td><code>LinuxContainer</code></td><td>containerization</td><td>158</td><td>26</td><td class="p">16.5%</td></tr>
<tr><td><code>IntegrationSuite</code> <span class="note">(測試 suite)</span></td><td>containerization</td><td>119</td><td>114</td><td>95.8%</td></tr>
<tr><td><code>Initd</code> <span class="note">(gRPC 服務端)</span></td><td>containerization</td><td>42</td><td>39</td><td>92.9%</td></tr>
<tr><td><code>Vminitd</code> <span class="note">(gRPC client 包裝)</span></td><td>containerization</td><td>43</td><td>32</td><td>74.4%</td></tr>
</table>' 800

generate "table-method-en" '<table>
<tr><th>Node</th><th>Project</th><th style="white-space:nowrap">Total edges</th><th>of which <code>method</code></th><th>Share</th></tr>
<tr><td><code>RecordDetailViewController</code></td><td>that iOS project</td><td>120</td><td>92</td><td class="d">76.7%</td></tr>
<tr><td><code>LinuxContainer</code></td><td>containerization</td><td>158</td><td>26</td><td class="p">16.5%</td></tr>
<tr><td><code>IntegrationSuite</code> <span class="note">(test suite)</span></td><td>containerization</td><td>119</td><td>114</td><td>95.8%</td></tr>
<tr><td><code>Initd</code> <span class="note">(gRPC server)</span></td><td>containerization</td><td>42</td><td>39</td><td>92.9%</td></tr>
<tr><td><code>Vminitd</code> <span class="note">(gRPC client wrapper)</span></td><td>containerization</td><td>43</td><td>32</td><td>74.4%</td></tr>
</table>' 860

# ---------- 2. 一個 target 被拆成幾個群集 ----------
generate "table-split" '<table>
<tr><th>target</th><th>節點數</th><th>被拆成幾個群集</th><th>最大群集佔比</th></tr>
<tr><td><code>Containerization</code></td><td>1303</td><td class="d"><strong>101</strong></td><td>6.6%</td></tr>
<tr><td><code>ContainerizationOCI</code></td><td>396</td><td>41</td><td>12.4%</td></tr>
<tr><td><code>ContainerizationOS</code></td><td>365</td><td>38</td><td>12.9%</td></tr>
<tr><td><code>VminitdCore</code></td><td>332</td><td>32</td><td>13.3%</td></tr>
<tr><td><code>ContainerizationEXT4</code></td><td>236</td><td>20</td><td>12.7%</td></tr>
</table>' 660

generate "table-split-en" '<table>
<tr><th>Target</th><th>Nodes</th><th style="white-space:nowrap">Split across N communities</th><th style="white-space:nowrap">Largest community</th></tr>
<tr><td><code>Containerization</code></td><td>1303</td><td class="d"><strong>101</strong></td><td>6.6%</td></tr>
<tr><td><code>ContainerizationOCI</code></td><td>396</td><td>41</td><td>12.4%</td></tr>
<tr><td><code>ContainerizationOS</code></td><td>365</td><td>38</td><td>12.9%</td></tr>
<tr><td><code>VminitdCore</code></td><td>332</td><td>32</td><td>13.3%</td></tr>
<tr><td><code>ContainerizationEXT4</code></td><td>236</td><td>20</td><td>12.7%</td></tr>
</table>' 780

# ---------- 3. 四個指令實測 ----------
generate "table-cmd" '<table>
<tr><th>指令</th><th>實測結果</th><th>判定</th></tr>
<tr><td><code>god-nodes</code></td><td>結構總覽準確,但排名混入框架型別</td><td>有用(要自己濾)</td></tr>
<tr><td><code>explain &lt;節點&gt;</code></td><td>鄰居清單命中真實 API 面</td><td class="p"><strong>最有用</strong></td></tr>
<tr><td><code>path A B</code></td><td>繞道 <code>Logging</code>,語意上是廢話</td><td class="d">不可靠</td></tr>
<tr><td><code>query "自然語言問題"</code></td><td>起點斷詞失準,答案完全跑題</td><td class="d"><strong>最弱</strong></td></tr>
<tr><td>自訂查詢(限定邊種類)</td><td>兩跳命中真實呼叫點</td><td>有效,但要自己寫</td></tr>
</table>' 780

generate "table-cmd-en" '<table>
<tr><th>Command</th><th>What actually happened</th><th>Verdict</th></tr>
<tr><td><code>god-nodes</code></td><td>Accurate overview, framework types pollute the ranking</td><td style="white-space:nowrap">Useful (filter it yourself)</td></tr>
<tr><td><code>explain &lt;node&gt;</code></td><td>Neighbor list hit the real API surface</td><td class="p"><strong>Most useful</strong></td></tr>
<tr><td><code>path A B</code></td><td>Detoured through <code>Logging</code> &mdash; semantic noise</td><td class="d">Unreliable</td></tr>
<tr><td><code>query "natural language"</code></td><td>Start-node matching misfired; answer off-topic</td><td class="d"><strong>Weakest</strong></td></tr>
<tr><td style="white-space:nowrap">Custom query (edge types constrained)</td><td>Two hops onto the real call site</td><td style="white-space:nowrap">Works, but you write it</td></tr>
</table>' 1040

echo ""
echo "裁切邊框..."
for name in table-method table-method-en table-split table-split-en table-cmd table-cmd-en; do
  trim "$name"
done

echo ""
echo "完成！"
