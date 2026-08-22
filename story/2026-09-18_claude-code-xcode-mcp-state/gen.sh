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


# ---------- 1. 架構對照 ----------
generate "table-arch" '<table>
<tr><th></th><th>前兩篇自製的 server</th><th>Xcode 的 MCP</th></tr>
<tr><td>形態</td><td>獨立行程</td><td>接到 GUI 的橋</td></tr>
<tr class="hl"><td><strong>狀態</strong></td><td class="p">無狀態,一開一關就是一次</td><td class="d"><strong>有狀態,狀態在 IDE 裡</strong></td></tr>
<tr><td>定址單位</td><td>檔案路徑</td><td><strong>視窗的分頁(<code>tabIdentifier</code>)</strong></td></tr>
<tr><td>沒開 IDE</td><td class="p">照跑</td><td class="d"><strong>fatal error</strong></td></tr>
<tr><td>進得了 CI 嗎</td><td class="p">可以</td><td><strong>整個 26 線都不行,27 才可以</strong></td></tr>
</table>' 900

generate "table-arch-en" '<table>
<tr><th></th><th>The server I built two articles back</th><th>Xcode&rsquo;s MCP</th></tr>
<tr><td>Shape</td><td>standalone process</td><td>a bridge onto a GUI</td></tr>
<tr class="hl"><td><strong>State</strong></td><td class="p">stateless, one run per process</td><td class="d"><strong>stateful, state lives in the IDE</strong></td></tr>
<tr><td>Addressing unit</td><td>file paths</td><td><strong>a window tab (<code>tabIdentifier</code>)</strong></td></tr>
<tr><td>With the IDE closed</td><td class="p">runs fine</td><td class="d"><strong>fatal error</strong></td></tr>
<tr><td>Can it reach CI</td><td class="p">yes</td><td><strong>no across the whole 26 line; yes on 27</strong></td></tr>
</table>' 1000

# ---------- 2. 參數名 ----------
generate "table-param" '<table>
<tr><th>模式</th><th>要的參數</th><th>送另一個會怎樣</th></tr>
<tr><td>26.3 / 26.6(都只有 GUI)</td><td><code>tabIdentifier</code></td><td class="note">&mdash;</td></tr>
<tr><td>27 <strong>GUI</strong></td><td><code>tabIdentifier</code></td><td class="d">送 <code>workspaceIdentifier</code> 被拒</td></tr>
<tr class="hl"><td>27 <strong>headless</strong></td><td><strong><code>workspaceIdentifier</code></strong></td><td class="d">送 <code>tabIdentifier</code> 被拒</td></tr>
</table>' 860

generate "table-param-en" '<table>
<tr><th>Mode</th><th>Parameter it wants</th><th>If you send the other one</th></tr>
<tr><td>26.3 / 26.6 (both GUI-only)</td><td><code>tabIdentifier</code></td><td class="note">&mdash;</td></tr>
<tr><td>27 <strong>GUI</strong></td><td><code>tabIdentifier</code></td><td class="d"><code>workspaceIdentifier</code> is rejected</td></tr>
<tr class="hl"><td>27 <strong>headless</strong></td><td><strong><code>workspaceIdentifier</code></strong></td><td class="d"><code>tabIdentifier</code> is rejected</td></tr>
</table>' 960

# ---------- 3. schema 四處不符(表列可救回的三處)----------
generate "table-schema" '<table>
<tr><th>schema 怎麼說</th><th>實際</th></tr>
<tr><td><code>workspaceIdentifier</code> 收「identifier <strong>或其絕對路徑</strong>」</td><td class="d">送絕對路徑 &rarr; <code>Unknown workspace identifier</code></td></tr>
<tr><td><code>"required": []</code>(非必填)</td><td class="d">省略不送 &rarr; <code>workspaceIdentifier is required for this action</code></td></tr>
<tr><td>只公告 <code>workspaceIdentifier</code></td><td class="d">GUI 模式實際要 <code>tabIdentifier</code></td></tr>
</table>' 920

generate "table-schema-en" '<table>
<tr><th>What the schema says</th><th>What actually happens</th></tr>
<tr><td><code>workspaceIdentifier</code> accepts an identifier <strong>or its absolute path</strong></td><td class="d">absolute path &rarr; <code>Unknown workspace identifier</code></td></tr>
<tr><td><code>"required": []</code> (optional)</td><td class="d">omit it &rarr; <code>workspaceIdentifier is required for this action</code></td></tr>
<tr><td>advertises only <code>workspaceIdentifier</code></td><td class="d">GUI mode actually wants <code>tabIdentifier</code></td></tr>
</table>' 1000

# ---------- 4. 授權模型 ----------
generate "table-auth" '<table>
<tr><th></th><th>Xcode 26.3</th><th>Xcode 26.6</th><th>Xcode 27</th></tr>
<tr><td>認什麼</td><td>執行檔路徑 <strong>+ PID</strong></td><td>執行檔路徑 <strong>+ PID</strong><br>(另外顯示簽章)</td><td>只認執行檔路徑</td></tr>
<tr class="hl"><td><strong>一次授權管多久</strong></td><td class="d"><strong>一個 process</strong></td><td class="d"><strong>一個 process</strong></td><td class="p"><strong>24 小時</strong></td></tr>
<tr><td>每跑一次腳本</td><td class="d"><strong>要重按一次</strong></td><td class="d"><strong>要重按一次</strong></td><td class="p">不必</td></tr>
<tr><td>能不能預先授權</td><td class="d">不行</td><td class="d">不行</td><td class="p"><code>mcp-server approve</code> / <code>allow-folder</code>(需 sudo)</td></tr>
<tr><td>進得了 CI 嗎</td><td class="d"><strong>不行,有個等人按的對話框</strong></td><td class="d"><strong>不行,同一個對話框</strong></td><td class="p"><strong>可以</strong></td></tr>
</table>' 1180

generate "table-auth-en" '<table>
<tr><th></th><th>Xcode 26.3</th><th>Xcode 26.6</th><th>Xcode 27</th></tr>
<tr><td>What it keys on</td><td>executable path <strong>+ PID</strong></td><td>executable path <strong>+ PID</strong><br>(signature shown)</td><td>executable path only</td></tr>
<tr class="hl"><td><strong>How long one grant lasts</strong></td><td class="d"><strong>one process</strong></td><td class="d"><strong>one process</strong></td><td class="p"><strong>24 hours</strong></td></tr>
<tr><td>Every script run</td><td class="d"><strong>another click</strong></td><td class="d"><strong>another click</strong></td><td class="p">no click</td></tr>
<tr><td>Pre-authorization possible</td><td class="d">no</td><td class="d">no</td><td class="p"><code>mcp-server approve</code> / <code>allow-folder</code> (sudo)</td></tr>
<tr><td>Can it reach CI</td><td class="d"><strong>no &mdash; a dialog waits for a human</strong></td><td class="d"><strong>no &mdash; the same dialog</strong></td><td class="p"><strong>yes</strong></td></tr>
</table>' 1280

# ---------- 5. 部署目標 ----------
generate "table-deploy" '<table>
<tr><th></th><th>Xcode 26.3</th><th>Xcode 26.6</th><th>Xcode 27</th></tr>
<tr><td>iOS SDK</td><td><code>26.2</code></td><td><code>26.5</code></td><td><code>27.0</code></td></tr>
<tr><td>部署目標下限</td><td>12.0</td><td><strong>12.0</strong></td><td><strong>15.0</strong></td></tr>
<tr class="hl"><td>專案裡 9.0 / 10.0 / 11.0 的設定</td><td class="p"><strong>warning</strong></td><td class="p"><strong>warning</strong></td><td class="d"><strong>error</strong></td></tr>
<tr><td>同一個專案</td><td class="p">建置成功</td><td class="p">建置成功</td><td class="d"><strong>建置失敗</strong></td></tr>
</table>' 1080

generate "table-deploy-en" '<table>
<tr><th></th><th>Xcode 26.3</th><th>Xcode 26.6</th><th>Xcode 27</th></tr>
<tr><td>iOS SDK</td><td><code>26.2</code></td><td><code>26.5</code></td><td><code>27.0</code></td></tr>
<tr><td>Minimum deployment target</td><td>12.0</td><td><strong>12.0</strong></td><td><strong>15.0</strong></td></tr>
<tr class="hl"><td>Settings at 9.0 / 10.0 / 11.0</td><td class="p"><strong>warning</strong></td><td class="p"><strong>warning</strong></td><td class="d"><strong>error</strong></td></tr>
<tr><td>The same project</td><td class="p">builds</td><td class="p">builds</td><td class="d"><strong>fails</strong></td></tr>
</table>' 1180

for n in table-arch table-arch-en table-param table-param-en table-schema table-schema-en table-auth table-auth-en table-deploy table-deploy-en; do trim "$n"; done
echo "完成"
