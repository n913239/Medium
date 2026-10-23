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
  # (2026-10-23 在 side-channel 那篇發現,先前整批圖右側都留著一塊空白)。
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

# ---------- 1. 用框架 vs 手刻 ----------
generate "table-framework" '<table>
<tr><th></th><th>用框架</th><th>手刻</th></tr>
<tr><td><strong>速度</strong></td><td class="p">十幾行接起來就能跑</td><td>195 行,每步自己寫</td></tr>
<tr class="hl"><td><strong>換零件、進階功能</strong></td><td class="p">換模型改一行;重新排序、混合搜尋有現成元件,但要自己接</td><td class="d">要自己做</td></tr>
<tr><td><strong>看得懂內部</strong></td><td class="d">零件裡做什麼不一定知道</td><td class="p">每一步看得見</td></tr>
<tr class="hl"><td><strong>版本變動</strong></td><td class="d">改版頻繁,舊教學常跑不動</td><td class="p">只依賴 sqlite-vec 和 MCP SDK</td></tr>
</table>' 900
generate "table-framework-en" '<table>
<tr><th></th><th>With a framework</th><th>Hand-rolled</th></tr>
<tr><td><strong>Time to first run</strong></td><td class="p">A dozen lines of glue</td><td>195 lines, every step written out</td></tr>
<tr class="hl"><td><strong>Swapping parts, extras</strong></td><td class="p">One line to swap a model; reranking and hybrid search need wiring</td><td class="d">Build it yourself</td></tr>
<tr><td><strong>Seeing the internals</strong></td><td class="d">What a component does is not always visible</td><td class="p">Every step is visible</td></tr>
<tr class="hl"><td><strong>Version churn</strong></td><td class="d">Frequent releases; old tutorials stop working</td><td class="p">Only sqlite-vec and the MCP SDK</td></tr>
</table>' 980

for t in table-framework table-framework-en; do trim "$t"; done

# ---------- 2. 一篇筆記變 30 張卡 ----------
generate "table-chunk" '<table>
<tr><th>id</th><th>字數</th><th>開頭</th><th>怎麼來的</th></tr>
<tr><td class="num">3744</td><td class="num">800</td><td><code>## 定義 &gt; Gerard Meszaros 提出…</code></td><td>「定義」的前 800 字</td></tr>
<tr class="hl"><td class="num">3745</td><td class="num">484</td><td><code>反,本庫不採用。** Hudson…</code></td><td class="d">「定義」剩下的,<strong>從句子中間開始</strong></td></tr>
<tr><td class="num">3746</td><td class="num">800</td><td><code>## 我的實踐 **AppTests/…</code></td><td>「我的實踐」前 800 字</td></tr>
<tr><td class="num">3747</td><td class="num">800</td><td><code>**(不開 simulator 跑 XCUITest):</code></td><td>接著切</td></tr>
<tr class="hl"><td class="num">3748</td><td class="num">102</td><td><code> + override)為主——對應…</code></td><td class="d">「我的實踐」切剩的<strong>尾巴</strong></td></tr>
</table>' 1020
generate "table-chunk-en" '<table>
<tr><th>id</th><th>Chars</th><th>Starts with</th><th>Where it came from</th></tr>
<tr><td class="num">3744</td><td class="num">800</td><td><code>## Definition &gt; Gerard Meszaros…</code></td><td>First 800 chars of &ldquo;Definition&rdquo;</td></tr>
<tr class="hl"><td class="num">3745</td><td class="num">484</td><td><code>…the opposite, not used here.** Hudson…</code></td><td class="d">The rest of it, <strong>starting mid-sentence</strong></td></tr>
<tr><td class="num">3746</td><td class="num">800</td><td><code>## My practice **AppTests/…</code></td><td>First 800 chars of &ldquo;My practice&rdquo;</td></tr>
<tr><td class="num">3747</td><td class="num">800</td><td><code>**(XCUITest without a simulator):</code></td><td>Next cut</td></tr>
<tr class="hl"><td class="num">3748</td><td class="num">102</td><td><code> + override) mostly &mdash; matching…</code></td><td class="d">The leftover <strong>tail</strong></td></tr>
</table>' 1120

for t in table-chunk table-chunk-en; do trim "$t"; done

# ---------- 3. 三種讓 AI 查筆記的方式 ----------
generate "table-access" '<table>
<tr><th></th><th>① 自己 Grep／讀檔</th><th>② Bash 跑 <code>query.py -r</code></th><th>③ MCP <code>vault_search</code></th></tr>
<tr><td><strong>怎麼找</strong></td><td>關鍵字比對</td><td class="p">語意</td><td class="p">語意</td></tr>
<tr class="hl"><td><strong>它怎麼知道能用</strong></td><td>本來就會</td><td>CLAUDE.md 要寫一句</td><td class="p"><strong>工具說明一直在眼前</strong></td></tr>
<tr><td><strong>回傳格式</strong></td><td>檔案原文</td><td class="d">一段文字,要自己讀懂</td><td class="p">四個欄位:來源、路徑、距離、原文</td></tr>
<tr class="hl"><td><strong>權限</strong></td><td>讀檔權限</td><td class="d">每個 Bash 指令可能都要核准</td><td class="p">核准一次</td></tr>
<tr><td><strong>跨程式重用</strong></td><td class="d">不行,各自實作</td><td>可以,但要自己呼叫 CLI、解析輸出</td><td class="p">可以,拿到的是結構化欄位</td></tr>
<tr class="hl"><td><strong>設定成本</strong></td><td class="p">零</td><td class="p">低</td><td class="d">較高:寫 server、註冊、核准</td></tr>
</table>' 1180
generate "table-access-en" '<table>
<tr><th></th><th>① Grep / read files</th><th>② Bash, <code>query.py -r</code></th><th>③ MCP <code>vault_search</code></th></tr>
<tr><td><strong>How it finds things</strong></td><td>Keyword match</td><td class="p">Semantic</td><td class="p">Semantic</td></tr>
<tr class="hl"><td><strong>How it knows this exists</strong></td><td>Built in</td><td>A line in CLAUDE.md</td><td class="p"><strong>Tool description always in view</strong></td></tr>
<tr><td><strong>What comes back</strong></td><td>Raw file text</td><td class="d">A blob of text to parse yourself</td><td class="p">Four fields: source, path, distance, text</td></tr>
<tr class="hl"><td><strong>Permissions</strong></td><td>File read</td><td class="d">Possibly one approval per command</td><td class="p">Approve once</td></tr>
<tr><td><strong>Reuse from another program</strong></td><td class="d">No, each rolls its own</td><td>Yes, but you call the CLI and parse its output</td><td class="p">Yes, and you get structured fields</td></tr>
<tr class="hl"><td><strong>Setup cost</strong></td><td class="p">Zero</td><td class="p">Low</td><td class="d">Higher: write, register, approve</td></tr>
</table>' 1240

for t in table-access table-access-en; do trim "$t"; done

# ---------- 4. 地端模型的 14 次 bash ----------
generate "table-pi" '<table>
<tr><th>第幾次</th><th>它做了什麼</th></tr>
<tr class="hl"><td class="num"><strong>1</strong></td><td class="p"><code>uv run query.py -r "Coordinator 導航"</code> <span class="note">—— 我教它的那條,一次就查對</span></td></tr>
<tr><td class="num">2–5</td><td><code>cat</code> 一個不存在的檔、<code>find</code>、<code>ls</code>,到處翻</td></tr>
<tr><td class="num">6</td><td><code>cat query.py</code> <span class="note">—— 讀我的原始碼</span></td></tr>
<tr><td class="num">7–8</td><td>試著 <code>from query import retrieve</code> 直接呼叫函式</td></tr>
<tr><td class="num">9–11</td><td><code>cat ingest.py</code>、<code>cat common.py</code></td></tr>
<tr class="hl"><td class="num">12–14</td><td class="d">直接 <code>sqlite3 vault-bge-m3.db "SELECT source, text FROM chunks WHERE …"</code> 撈資料庫</td></tr>
</table>' 1000
generate "table-pi-en" '<table>
<tr><th>Call</th><th>What it did</th></tr>
<tr class="hl"><td class="num"><strong>1</strong></td><td class="p"><code>uv run query.py -r "Coordinator navigation"</code> <span class="note">&mdash; the one command I gave it; hit on the first try</span></td></tr>
<tr><td class="num">2&ndash;5</td><td><code>cat</code> a file that does not exist, <code>find</code>, <code>ls</code> &mdash; rummaging around</td></tr>
<tr><td class="num">6</td><td><code>cat query.py</code> <span class="note">&mdash; reading my source</span></td></tr>
<tr><td class="num">7&ndash;8</td><td>Tried <code>from query import retrieve</code> to call the function directly</td></tr>
<tr><td class="num">9&ndash;11</td><td><code>cat ingest.py</code>, <code>cat common.py</code></td></tr>
<tr class="hl"><td class="num">12&ndash;14</td><td class="d">Went straight to <code>sqlite3 vault-bge-m3.db "SELECT source, text FROM chunks WHERE …"</code></td></tr>
</table>' 1120

for t in table-pi table-pi-en; do trim "$t"; done

# ---------- 5. 同一個地端模型:bash vs MCP ----------
generate "table-local" '<table>
<tr><th></th><th>Pi + bash 跑 <code>query.py</code></th><th>LM Studio + MCP</th></tr>
<tr class="hl"><td><strong>工具呼叫次數</strong></td><td class="d"><strong>14 次</strong></td><td class="p"><strong>1 次</strong></td></tr>
<tr><td><strong>token</strong></td><td class="num d">19,145 <span class="note">(任務累計)</span></td><td class="num p">2,492 <span class="note">(對話 context)</span></td></tr>
<tr class="hl"><td><strong>它拿到什麼</strong></td><td class="d">終端機印出的一段文字</td><td class="p"><code>source</code>／<code>path</code>／<code>distance</code>／<code>text</code> 四個欄位</td></tr>
<tr><td><strong>查詢字串</strong></td><td>自己縮成「Coordinator 導航」</td><td>原樣用我的問句</td></tr>
<tr class="hl"><td><strong>有沒有去翻我的實作</strong></td><td class="d">有:原始碼、import、SQL</td><td class="p">沒有</td></tr>
</table>' 1060
generate "table-local-en" '<table>
<tr><th></th><th>Pi + bash running <code>query.py</code></th><th>LM Studio + MCP</th></tr>
<tr class="hl"><td><strong>Tool calls</strong></td><td class="d"><strong>14</strong></td><td class="p"><strong>1</strong></td></tr>
<tr><td><strong>Tokens</strong></td><td class="num d">19,145 <span class="note">(task total)</span></td><td class="num p">2,492 <span class="note">(conversation context)</span></td></tr>
<tr class="hl"><td><strong>What it received</strong></td><td class="d">A blob printed to a terminal</td><td class="p">Four fields: <code>source</code> / <code>path</code> / <code>distance</code> / <code>text</code></td></tr>
<tr><td><strong>Query string</strong></td><td>Shortened to &ldquo;Coordinator navigation&rdquo; on its own</td><td>My question, verbatim</td></tr>
<tr class="hl"><td><strong>Went digging in my code</strong></td><td class="d">Yes: source, imports, SQL</td><td class="p">No</td></tr>
</table>' 1160

for t in table-local table-local-en; do trim "$t"; done

# ---------- 6. 30 張卡的長條圖(來自 chunks-eli5 的 ⑤,改成靜態版) ----------
# 資料 = Test Doubles.md 切出來的 30 張卡:[字數, 所屬大段, 是否從句子中間開始]
# 互動版在 docs/2026-10-30-chunks/,這裡只產文章用的靜態 PNG。
shelf() {
  local name="$1" lang="$2"
  local L_TITLE L_SUB L_H1 L_H2 L_H3 L_H4 L_LEG L_S1 L_S2 L_S3 L_S4 L_S5 L_S6 L_NOTE
  if [ "$lang" = "en" ]; then
    L_SUB='All 30 chunks from Test Doubles.md, left to right in original order'
    L_H1='1 bar = 1 chunk<br>taller = more characters, max 800'
    L_H2='Flat top<br>starts at a heading'
    L_H3='Torn top<br>starts mid-sentence<br>(cut at 800)'
    L_H4='Very short<br>leftover fragment'
    L_LEG='Colour = which part of the file it came from:'
    L_S1=Definition; L_S2='My practice'; L_S3='Outside views'; L_S4='Tensions'; L_S5=Examples; L_S6=Sources
    L_NOTE='The first three green bars are <b>tall, tall, short</b> (800, 800, 102). &ldquo;My practice&rdquo; was cut twice; the 102-character tail is what was left. The last two have torn tops because each picks up mid-sentence from the one before.'
  else
    L_SUB='Test Doubles.md 切出來的 30 張卡,由左到右照原檔順序排'
    L_H1='一根 = 一張卡<br>越高字越多,最高 800'
    L_H2='平頂<br>從標題開始'
    L_H3='鋸齒頂<br>從句子中間開始<br>(800 字剪的)'
    L_H4='特別矮<br>切剩的碎片'
    L_LEG='顏色 = 來自原檔哪一大段:'
    L_S1=定義; L_S2=我的實踐; L_S3=外部觀點; L_S4=張力與缺口; L_S5=例子; L_S6=來源
    L_NOTE='看綠色開頭三根:<b>高、高、矮</b>(800、800、102 字)。「我的實踐」太長,被剪了兩刀,剩 102 字的尾巴;後兩根是鋸齒頂,因為都從上一張的中間接下去。'
  fi

  cat > "${DIR}/_${name}.html" << ENDHTML
<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8">
<style>
html,body{margin:0;padding:0;background:#f5f5f5}
.wrap{display:inline-block;padding:24px 28px;background:#fff;width:max-content}
body{font-family:-apple-system,"PingFang TC","Noto Sans TC",sans-serif;color:#1d2a44;line-height:1.5}
.sub{font-size:16px;color:#6b7385;margin:0 0 18px}
.guide{display:flex;gap:10px;margin:0 0 16px}
.g{display:flex;align-items:flex-end;gap:8px;background:#f2f4f8;border-radius:10px;padding:10px 12px}
.g p{margin:0;font-size:13px;color:#6b7385}
.g b{color:#1d2a44}
.bar{display:block;width:16px;border-radius:3px 3px 1px 1px;background:#4fa77a}
.torn{clip-path:polygon(0 6px,20% 0,40% 6px,60% 0,80% 6px,100% 0,100% 100%,0 100%)}
.shelf{display:flex;align-items:flex-end;gap:6px;border-bottom:3px solid #d9dce3;padding:0 2px 0}
.shelf .bar{width:24px}
.legend{display:flex;flex-wrap:wrap;gap:6px 16px;margin:12px 0 0;font-size:14px;color:#6b7385;align-items:center}
.legend span{display:inline-flex;align-items:center;gap:6px}
.dot{width:13px;height:13px;border-radius:3px;display:inline-block}
.def{background:#5b7fd6}.mine{background:#4fa77a}.ext{background:#8a63d2}
.ten{background:#e08a3c}.ex{background:#d9534f}.src{background:#6b7385}
.note{margin:16px 0 0;font-size:14px;color:#1d2a44;background:#fff8e1;border-radius:10px;padding:12px 14px;max-width:820px}
</style></head><body><div class="wrap">
<p class="sub">${L_SUB}</p>
<div class="guide">
  <div class="g"><span class="bar mine" style="height:56px"></span><p>${L_H1}</p></div>
  <div class="g"><span class="bar mine" style="height:56px"></span><p>${L_H2}</p></div>
  <div class="g"><span class="bar mine torn" style="height:56px"></span><p>${L_H3}</p></div>
  <div class="g"><span class="bar mine" style="height:11px"></span><p>${L_H4}</p></div>
</div>
<div class="shelf" id="shelf"></div>
<div class="legend"><span>${L_LEG}</span>
  <span><i class="dot def"></i>${L_S1}</span><span><i class="dot mine"></i>${L_S2}</span>
  <span><i class="dot ext"></i>${L_S3}</span><span><i class="dot ten"></i>${L_S4}</span>
  <span><i class="dot ex"></i>${L_S5}</span><span><i class="dot src"></i>${L_S6}</span>
</div>
<p class="note">${L_NOTE}</p>
</div>
<script>
const cards=[[800,"def",0],[484,"def",1],[800,"mine",0],[800,"mine",1],[102,"mine",1],[800,"mine",0],[748,"mine",1],[800,"mine",0],[63,"mine",1],[800,"ext",0],[728,"ext",1],[800,"ext",0],[777,"ext",1],[179,"ext",0],[323,"ext",0],[800,"ext",0],[800,"ext",1],[209,"ext",1],[429,"ext",0],[506,"ten",0],[692,"ten",0],[342,"ten",0],[391,"ten",0],[150,"ten",0],[158,"ten",0],[800,"ex",0],[656,"ex",1],[508,"ex",0],[200,"src",0],[731,"src",0]];
const sh=document.getElementById("shelf");
cards.forEach(([len,sec,torn])=>{
  const b=document.createElement("span");
  b.className="bar "+sec+(torn?" torn":"");
  b.style.height=Math.max(10,Math.round(len/800*150))+"px";
  sh.appendChild(b);
});
</script></body></html>
ENDHTML
  npx playwright screenshot --channel=chrome --viewport-size "400,100" --full-page \
    "file://${DIR}/_${name}.html" "${DIR}/${name}.png" 2>&1 | grep -i "error\|Executable doesn" && echo "⚠️  ${name} 產圖可能失敗"
  rm -f "${DIR}/_${name}.html"
  [ -f "${DIR}/${name}.png" ] && echo "✅ ${name}.png" || echo "❌ ${name}.png 沒產出"
}

shelf "chunk-shelf" zh
shelf "chunk-shelf-en" en
