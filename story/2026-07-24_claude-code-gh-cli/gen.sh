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
th { background: #333; color: #fff; font-weight: 600; text-align: left; padding: 12px 20px; }
td { padding: 12px 20px; border-bottom: 1px solid #e0e0e0; color: #333; }
tr:last-child td { border-bottom: none; }
code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 13px; font-family: "SF Mono", Menlo, monospace; }
.ok { color: #1a7f37; font-weight: 600; white-space: nowrap; }
.man { color: #9a6700; font-weight: 600; white-space: nowrap; }
.stop { color: #cf222e; font-weight: 600; white-space: nowrap; }
</style></head><body>
<div class="wrap">${body_html}</div>
<script>
  const w = document.querySelector('.wrap');
  document.title = w.offsetWidth + 'x' + w.offsetHeight;
</script>
</body></html>
ENDHTML
  npx playwright screenshot --channel=chrome --viewport-size "${vw},100" --full-page \
    "file://${DIR}/_${name}.html" "${DIR}/${name}.png" 2>/dev/null
  rm -f "${DIR}/_${name}.html"
  echo "✅ ${name}.png"
}

trim() {
  local name="$1"
  local file="${DIR}/${name}.png"
  magick "$file" -fuzz 3% -trim +repage -bordercolor '#f5f5f5' -border 12 "$file"
}

# 終端風格樣式(gh-run 圖共用)
TERM_STYLE='<style>
.term{background:#fff;border:1px solid #e0e0e0;border-radius:8px;overflow:hidden;font-family:"SF Mono",Menlo,monospace;font-size:14px;line-height:1.7}
.bar{background:#f0f0f0;color:#57606a;padding:8px 16px;border-bottom:1px solid #e0e0e0;font-size:13px}
.tbody{padding:14px 16px;color:#333;white-space:pre}
.p{color:#8250df;font-weight:600}
.g{color:#1a7f37;font-weight:600}
.d{color:#8a8a8a}
</style>'

# 中文:gh run 監控終端
generate "gh-run" "${TERM_STYLE}"'<div class="term">
<div class="bar">Terminal — 用 gh 盯 CI,全程不開瀏覽器</div>
<div class="tbody"><span class="p">$ gh run list -L 1</span>
completed  <span class="g">success</span>  Add CI + hook tests  CI  main  push  28765628543  <span class="g">8s</span>

<span class="p">$ gh run view 28765628543</span>
<span class="g">✓</span> main CI · 28765628543
JOBS
<span class="g">✓</span> test in 5s

<span class="d"># 讀到 success 就回報「綠了」,紅了才進下一步讀 log</span></div>
</div>' 760

# 英文:gh run 監控終端
generate "gh-run-en" "${TERM_STYLE}"'<div class="term">
<div class="bar">Terminal — watching CI with gh, no browser involved</div>
<div class="tbody"><span class="p">$ gh run list -L 1</span>
completed  <span class="g">success</span>  Add CI + hook tests  CI  main  push  28765628543  <span class="g">8s</span>

<span class="p">$ gh run view 28765628543</span>
<span class="g">✓</span> main CI · 28765628543
JOBS
<span class="g">✓</span> test in 5s

<span class="d"># read success -> report green; only go read the log when it is red</span></div>
</div>' 780

# 中文:放手 vs 按停 對照表
generate "table-handoff" '<table>
<tr><th>gh 操作</th><th>性質</th><th>交給誰</th></tr>
<tr><td><code>gh run list</code> / <code>run view</code> / <code>run watch</code></td><td>唯讀:看 CI 狀態與 log</td><td class="ok">✓ 放手給 Claude</td></tr>
<tr><td><code>gh pr view</code> / <code>pr diff</code></td><td>唯讀:看 PR 內容</td><td class="ok">✓ 放手給 Claude</td></tr>
<tr><td><code>gh pr create</code></td><td>產出,可改可關</td><td class="man">⚠ 產完給你過目</td></tr>
<tr><td><code>gh pr merge</code> / <code>repo delete</code> / <code>push --force</code></td><td>動遠端、不可逆</td><td class="stop">✋ 留給人按停</td></tr>
</table>' 780

# 英文:放手 vs 按停 對照表
generate "table-handoff-en" '<table>
<tr><th>gh operation</th><th>Nature</th><th>Who does it</th></tr>
<tr><td><code>gh run list</code> / <code>run view</code> / <code>run watch</code></td><td>Read-only: CI status &amp; logs</td><td class="ok">✓ Hand off to Claude</td></tr>
<tr><td><code>gh pr view</code> / <code>pr diff</code></td><td>Read-only: PR contents</td><td class="ok">✓ Hand off to Claude</td></tr>
<tr><td><code>gh pr create</code></td><td>Produces, editable/closable</td><td class="man">⚠ Generate, you review</td></tr>
<tr><td><code>gh pr merge</code> / <code>repo delete</code> / <code>push --force</code></td><td>Touches remote, irreversible</td><td class="stop">✋ Keep for a human</td></tr>
</table>' 820

echo ""
echo "裁切邊框..."
for name in gh-run gh-run-en table-handoff table-handoff-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "完成！"
