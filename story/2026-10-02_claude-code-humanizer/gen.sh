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


# ---------- 1. 5 句空的比喻 ----------
generate "table-empty" '<table>
<tr><th>#</th><th>英文版的句子</th><th>中文原稿</th><th>從哪來</th></tr>
<tr><td>1</td><td><em>this is a different species from what most people write</em></td><td>它跟大家寫的完全是兩種東西</td><td class="d" style="white-space:nowrap">翻譯時加的</td></tr>
<tr><td>2</td><td><em>the faster that scaffolding rots</em></td><td>腐爛得愈快</td><td style="white-space:nowrap">原稿就有</td></tr>
<tr><td>3</td><td><em>the delete test is really sorting your rules for you</em></td><td>刪除法其實是在替你分類</td><td style="white-space:nowrap">原稿就有</td></tr>
<tr><td>4</td><td><em>slow feedback is exactly what turns around and bites me</em></td><td>回饋慢這一點,下一段就會反過來咬到我自己</td><td style="white-space:nowrap">原稿就有</td></tr>
<tr><td>5</td><td><em>nothing on earth stops me</em></td><td>沒有任何工具會擋你</td><td class="d" style="white-space:nowrap">翻譯時加的</td></tr>
</table>' 900
generate "table-empty-en" '<table>
<tr><th>#</th><th>English sentence</th><th>Chinese original, translated literally</th><th>Where it came from</th></tr>
<tr><td>1</td><td><em>this is a different species from what most people write</em></td><td>it is a completely different thing from what people usually write</td><td class="d">Added in translation</td></tr>
<tr><td>2</td><td><em>the faster that scaffolding rots</em></td><td>rots faster</td><td>Already in the Chinese</td></tr>
<tr><td>3</td><td><em>the delete test is really sorting your rules for you</em></td><td>the delete test is actually sorting them for you</td><td>Already in the Chinese</td></tr>
<tr><td>4</td><td><em>slow feedback is exactly what turns around and bites me</em></td><td>slow feedback will turn around and bite me in the next section</td><td>Already in the Chinese</td></tr>
<tr><td>5</td><td><em>nothing on earth stops me</em></td><td>no tool will stop you</td><td class="d">Added in translation</td></tr>
</table>' 980

# ---------- 2. humanizer 抓到什麼 ----------
generate "table-patterns" '<table>
<tr><th>模式</th><th class="num">次數</th><th>抓的是什麼</th></tr>
<tr class="hl"><td>#15 粗體過多</td><td class="num"><strong>48</strong></td><td>整句或一段裡太多粗體</td></tr>
<tr class="hl"><td>#14 破折號</td><td class="num"><strong>34</strong></td><td>用破折號帶轉折或補充</td></tr>
<tr><td>#9 不是 X 而是 Y</td><td class="num">6</td><td>對仗式的否定句</td></tr>
<tr><td>#32 套語式格言</td><td class="num">4</td><td>把普通主張包成金句</td></tr>
<tr><td>#28 預告下一個重點</td><td class="num">4</td><td>「接下來很有意思:」這類過場</td></tr>
<tr><td>#31 戲劇性短句</td><td class="num">3</td><td>「Zero. Not one.」這類斷句</td></tr>
<tr><td>其他</td><td class="num">2</td><td>標題大小寫、AI 常用詞各 1</td></tr>
<tr><td><strong>合計</strong></td><td class="num"><strong>101</strong></td><td class="note">專門抓比喻的模式:0 條</td></tr>
</table>' 560
generate "table-patterns-en" '<table>
<tr><th>Pattern</th><th class="num">Count</th><th>What it flags</th></tr>
<tr class="hl"><td>#15 Too much bold</td><td class="num"><strong>48</strong></td><td>Whole sentences in bold, or too many bold spans in one paragraph</td></tr>
<tr class="hl"><td>#14 Em dashes</td><td class="num"><strong>34</strong></td><td>Dashes used for asides and turns</td></tr>
<tr><td>#9 Not X but Y</td><td class="num">6</td><td>Contrast built on a negation</td></tr>
<tr><td>#32 Formulaic sayings</td><td class="num">4</td><td>An ordinary claim packaged as a maxim</td></tr>
<tr><td>#28 Announcing the next point</td><td class="num">4</td><td>Transitions like "Then it gets interesting:"</td></tr>
<tr><td>#31 Dramatic fragments</td><td class="num">3</td><td>Lines like "Zero. Not one."</td></tr>
<tr><td>Other</td><td class="num">2</td><td>One title-case heading, one stock AI word</td></tr>
<tr><td><strong>Total</strong></td><td class="num"><strong>101</strong></td><td class="note">Patterns dedicated to metaphors: 0</td></tr>
</table>' 780

# ---------- 3. 0828 vs 0925 ----------
generate "table-compare" '<table>
<tr><th></th><th class="num">0828 英文版(翻譯)</th><th class="num">0925 英文版(直接寫)</th></tr>
<tr><td>字數</td><td class="num">2,679</td><td class="num">1,528</td></tr>
<tr class="hl"><td>humanizer 找到</td><td class="num d">101</td><td class="num p">4</td></tr>
<tr class="hl"><td>空的比喻</td><td class="num d">5</td><td class="num p">0</td></tr>
<tr><td>用了破折號的行,每千字</td><td class="num">12.7</td><td class="num">0.7</td></tr>
<tr><td>粗體片段,每千字</td><td class="num">25.0</td><td class="num">12.4</td></tr>
</table>' 520
generate "table-compare-en" '<table>
<tr><th style="min-width:300px"></th><th class="num">Aug 28 English (translated)</th><th class="num">Sep 25 English (written directly)</th></tr>
<tr><td>Words</td><td class="num">2,679</td><td class="num">1,528</td></tr>
<tr class="hl"><td>Humanizer findings</td><td class="num d">101</td><td class="num p">4</td></tr>
<tr class="hl"><td>Empty metaphors</td><td class="num d">5</td><td class="num p">0</td></tr>
<tr><td>Lines with em dashes, per 1,000 words</td><td class="num">12.7</td><td class="num">0.7</td></tr>
<tr><td>Bold spans, per 1,000 words</td><td class="num">25.0</td><td class="num">12.4</td></tr>
</table>' 860
