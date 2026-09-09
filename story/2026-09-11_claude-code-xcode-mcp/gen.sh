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


# ---------- 1. 三種環境 ----------
generate "table-env" '<table>
<tr><th></th><th>Xcode 26.3</th><th>Xcode 26.6</th><th>Xcode 27 GUI</th><th>Xcode 27 headless</th></tr>
<tr><td>建置版本</td><td><code>17C529</code>(正式版)</td><td><code>17F113</code>(正式版)</td><td><code>27A5237l</code>(<strong>beta 5</strong>)</td><td><code>27A5237l</code>(<strong>beta 5</strong>)</td></tr>
<tr><td>server 版本</td><td><code>v24582</code></td><td><code>v24952</code></td><td><code>v25280.8</code></td><td><code>v25280.8</code></td></tr>
<tr class="hl"><td><strong>工具數</strong></td><td><strong>20</strong></td><td><strong>21</strong></td><td><strong>53</strong></td><td><strong>53</strong>(換掉 4 支)</td></tr>
<tr><td>MCP 協定</td><td><code>2025-06-18</code></td><td><code>2025-06-18</code></td><td><code>2025-06-18</code></td><td><code>2025-06-18</code></td></tr>
<tr><td>需要開著 Xcode</td><td class="d">要</td><td class="d">要</td><td class="d">要</td><td class="p"><strong>不用</strong></td></tr>
<tr><td>連接方式</td><td><code>xcrun mcpbridge</code></td><td><code>xcrun mcpbridge</code></td><td><code>xcrun mcpbridge</code></td><td><code>xcrun mcp-server</code> + bridge</td></tr>
</table>' 980

generate "table-env-en" '<table>
<tr><th></th><th>Xcode 26.3</th><th>Xcode 26.6</th><th>Xcode 27 GUI</th><th>Xcode 27 headless</th></tr>
<tr><td>build</td><td><code>17C529</code> (release)</td><td><code>17F113</code> (release)</td><td><code>27A5237l</code> (<strong>beta 5</strong>)</td><td><code>27A5237l</code> (<strong>beta 5</strong>)</td></tr>
<tr><td>server version</td><td><code>v24582</code></td><td><code>v24952</code></td><td><code>v25280.8</code></td><td><code>v25280.8</code></td></tr>
<tr class="hl"><td><strong>tool count</strong></td><td><strong>20</strong></td><td><strong>21</strong></td><td><strong>53</strong></td><td><strong>53</strong> (4 swapped)</td></tr>
<tr><td>MCP protocol</td><td><code>2025-06-18</code></td><td><code>2025-06-18</code></td><td><code>2025-06-18</code></td><td><code>2025-06-18</code></td></tr>
<tr><td>Xcode must be open</td><td class="d">yes</td><td class="d">yes</td><td class="d">yes</td><td class="p"><strong>no</strong></td></tr>
<tr><td>how you connect</td><td><code>xcrun mcpbridge</code></td><td><code>xcrun mcpbridge</code></td><td><code>xcrun mcpbridge</code></td><td><code>xcrun mcp-server</code> + bridge</td></tr>
</table>' 1060

# ---------- 2. CPU 取樣 ----------
generate "table-cpu" '<table>
<tr><th>時間區間</th><th>情境</th><th>編譯器行程數</th></tr>
<tr class="hl"><td>建置失敗那 16 秒</td><td><code>RunSomeTests</code> 宣稱 3 passed</td><td class="d"><strong>全程 0</strong></td></tr>
<tr><td>正常跑測試時</td><td><code>RunSomeTests</code> 花 12.4s</td><td class="p"><span class="bar ok" style="width:26px"></span> 12</td></tr>
<tr><td>冷啟建置時</td><td><code>BuildProject</code> 花 26.5s</td><td class="p"><span class="bar ok" style="width:60px"></span> 峰值 28</td></tr>
</table>' 820

generate "table-cpu-en" '<table>
<tr><th>Window</th><th>Situation</th><th>Compiler processes</th></tr>
<tr class="hl"><td>The 16s around the failed build</td><td><code>RunSomeTests</code> claimed 3 passed</td><td class="d"><strong>0 the entire time</strong></td></tr>
<tr><td>A genuine test run</td><td><code>RunSomeTests</code> took 12.4s</td><td class="p"><span class="bar ok" style="width:26px"></span> 12</td></tr>
<tr><td>A cold build</td><td><code>BuildProject</code> took 26.5s</td><td class="p"><span class="bar ok" style="width:60px"></span> peak 28</td></tr>
</table>' 900

# ---------- 3. 三種失敗形態 ----------
generate "table-shape" '<table>
<tr><th>情境</th><th>工具回傳</th><th>如實嗎</th></tr>
<tr><td><strong>26.3</strong>,選了實機、簽章失敗</td><td><code>failed:0, notRun:3</code><br><code>state:"No result"</code></td><td>如實,但容易誤讀</td></tr>
<tr><td><strong>26.3</strong>,建置失敗、<strong>這輪還沒跑過測試</strong></td><td><code>passed:0, failed:0, notRun:189</code></td><td>如實,但容易誤讀</td></tr>
<tr class="hl"><td><strong>26.3</strong>,建置失敗、<strong>這輪跑過測試</strong></td><td class="d"><strong><code>passed:163, failed:0</code></strong></td><td class="d"><strong>錯誤</strong></td></tr>
<tr><td><strong>26.6 / 27</strong>,建置失敗(GUI 與 headless 皆同)</td><td><code>{"type":"error","data":"Build action failed."}</code></td><td class="p"><strong>正確</strong></td></tr>
<tr><td><strong>27 headless</strong>,destination 選錯、app 崩潰</td><td><code>passed:0, failed:0, notRun:189</code></td><td class="d">技術上為真,實質誤導</td></tr>
</table>' 1020

generate "table-shape-en" '<table>
<tr><th>Situation</th><th>What the tool returns</th><th>Faithful?</th></tr>
<tr><td><strong>26.3</strong>, device destination, signing fails</td><td><code>failed:0, notRun:3</code><br><code>state:"No result"</code></td><td>faithful, easy to misread</td></tr>
<tr><td><strong>26.3</strong>, build fails, <strong>no test run yet this session</strong></td><td><code>passed:0, failed:0, notRun:189</code></td><td>faithful, easy to misread</td></tr>
<tr class="hl"><td><strong>26.3</strong>, build fails, <strong>a test ran earlier</strong></td><td class="d"><strong><code>passed:163, failed:0</code></strong></td><td class="d"><strong>wrong</strong></td></tr>
<tr><td><strong>26.6 / 27</strong>, build fails (GUI and headless alike)</td><td><code>{"type":"error","data":"Build action failed."}</code></td><td class="p"><strong>correct</strong></td></tr>
<tr><td><strong>27 headless</strong>, wrong destination, app crashes</td><td><code>passed:0, failed:0, notRun:189</code></td><td class="d">technically true, materially misleading</td></tr>
</table>' 1120

# ---------- 4. 音效十二格 ----------
generate "table-sound" '<table>
<tr><th>環境</th><th>正常跑</th><th>建置失敗</th><th>測試沒跑過</th></tr>
<tr><td><strong>26.3 GUI</strong></td><td class="p">成功音 / <code>163 passed</code>(20.1s)</td><td class="d"><strong>無聲</strong> / <strong><code>163 passed</code>(1.2s,假的)</strong></td><td class="p">失敗音 / <code>failed:1</code>(改壞斷言)</td></tr>
<tr><td><strong>26.6 GUI</strong></td><td class="p">成功音 / <code>163 passed</code>(8.3s)</td><td>無聲 / <code>Build action failed</code></td><td class="p">失敗音 / <code>failed:1</code>(改壞斷言)</td></tr>
<tr><td><strong>27 GUI</strong></td><td class="p">成功音 / <code>163 passed</code></td><td>無聲 / <code>Build action failed</code></td><td class="p">失敗音 / <code>failed:1</code>(改壞斷言)</td></tr>
<tr class="hl"><td><strong>27 headless</strong></td><td class="p"><strong>成功音</strong>(Xcode 根本沒開)</td><td>無聲 / <code>Build action failed</code></td><td class="d"><strong>失敗音</strong> / <strong><code>failed:0</code></strong>(app 崩潰)</td></tr>
</table>' 1080

generate "table-sound-en" '<table>
<tr><th>Environment</th><th>Normal run</th><th>Build fails</th><th>Tests do not run clean</th></tr>
<tr><td><strong>26.3 GUI</strong></td><td class="p">success sound / <code>163 passed</code> (20.1s)</td><td class="d"><strong>silence</strong> / <strong><code>163 passed</code> (1.2s, fake)</strong></td><td class="p">failure sound / <code>failed:1</code> (broken assert)</td></tr>
<tr><td><strong>26.6 GUI</strong></td><td class="p">success sound / <code>163 passed</code> (8.3s)</td><td>silence / <code>Build action failed</code></td><td class="p">failure sound / <code>failed:1</code> (broken assert)</td></tr>
<tr><td><strong>27 GUI</strong></td><td class="p">success sound / <code>163 passed</code></td><td>silence / <code>Build action failed</code></td><td class="p">failure sound / <code>failed:1</code> (broken assert)</td></tr>
<tr class="hl"><td><strong>27 headless</strong></td><td class="p"><strong>success sound</strong> (Xcode not even open)</td><td>silence / <code>Build action failed</code></td><td class="d"><strong>failure sound</strong> / <strong><code>failed:0</code></strong> (app crash)</td></tr>
</table>' 1180

for n in table-env table-env-en table-cpu table-cpu-en table-shape table-shape-en table-sound table-sound-en; do trim "$n"; done
echo "完成"
