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


# ---------- 1. 歷屆規模 ----------
generate "table-history" '<table>
<tr><th>屆</th><th>年</th><th class="num">參賽</th><th class="num">完賽</th><th>備註</th></tr>
<tr><td>1</td><td>2008</td><td class="num">—</td><td class="num">—</td><td class="note">第一屆,11 月公布得獎名單</td></tr>
<tr class="hl"><td>8</td><td>2016/12–2017/01</td><td class="num">252</td><td class="num">—</td><td><strong>我第一次參加</strong></td></tr>
<tr><td>9</td><td>2017/12–2018/01</td><td class="num">359</td><td class="num">143</td><td></td></tr>
<tr><td>10</td><td>2018</td><td class="num">523</td><td class="num">264</td><td></td></tr>
<tr class="hl"><td>11</td><td>2019/09</td><td class="num">812</td><td class="num">381</td><td><strong>我第二次參加</strong></td></tr>
<tr><td>12</td><td>2020/09</td><td class="num">926</td><td class="num">529</td><td></td></tr>
<tr><td>13</td><td>2021</td><td class="num">1,087</td><td class="num">572</td><td></td></tr>
<tr><td>14</td><td>2022</td><td class="num">993</td><td class="num">—</td><td class="note">19,489 篇文章</td></tr>
<tr><td>15</td><td>2023</td><td class="num">1,123</td><td class="num">—</td><td class="note">23,018 篇文章</td></tr>
<tr><td>16</td><td>2024</td><td class="num">1,064</td><td class="num">—</td><td class="note">22,213 篇文章</td></tr>
<tr><td>17</td><td>2025</td><td class="num">902</td><td class="num">528</td><td class="note">19,790 篇文章</td></tr>
<tr class="hl"><td>18</td><td>2026</td><td class="num">929</td><td class="num">進行中</td><td><strong>我第三次參加</strong><br><span class="note">截至 9/24 已 12,489 篇</span></td></tr>
</table>' 608
trim "table-history"

generate "table-history-en" '<table>
<tr><th>#</th><th>Year</th><th class="num">Entered</th><th class="num">Finished</th><th>Notes</th></tr>
<tr><td>1</td><td>2008</td><td class="num">—</td><td class="num">—</td><td class="note">First contest; winners announced in November</td></tr>
<tr class="hl"><td>8</td><td>Dec 2016 – Jan 2017</td><td class="num">252</td><td class="num">—</td><td><strong>My first entry</strong></td></tr>
<tr><td>9</td><td>Dec 2017 – Jan 2018</td><td class="num">359</td><td class="num">143</td><td></td></tr>
<tr><td>10</td><td>2018</td><td class="num">523</td><td class="num">264</td><td></td></tr>
<tr class="hl"><td>11</td><td>Sep 2019</td><td class="num">812</td><td class="num">381</td><td><strong>My second entry</strong></td></tr>
<tr><td>12</td><td>Sep 2020</td><td class="num">926</td><td class="num">529</td><td></td></tr>
<tr><td>13</td><td>2021</td><td class="num">1,087</td><td class="num">572</td><td></td></tr>
<tr><td>14</td><td>2022</td><td class="num">993</td><td class="num">—</td><td class="note">19,489 articles</td></tr>
<tr><td>15</td><td>2023</td><td class="num">1,123</td><td class="num">—</td><td class="note">23,018 articles</td></tr>
<tr><td>16</td><td>2024</td><td class="num">1,064</td><td class="num">—</td><td class="note">22,213 articles</td></tr>
<tr><td>17</td><td>2025</td><td class="num">902</td><td class="num">528</td><td class="note">19,790 articles</td></tr>
<tr class="hl"><td>18</td><td>2026</td><td class="num">929</td><td class="num">In progress</td><td><strong>My third entry</strong><br><span class="note">12,489 articles as of Sep 24</span></td></tr>
</table>' 818
trim "table-history-en"

# ---------- 2. 三屆對照 ----------
generate "table-three" '<table>
<tr><th>屆</th><th>系列</th><th>組別</th><th class="num">篇數</th><th class="num">總瀏覽</th></tr>
<tr><td>2017</td><td>雲端服務新手村</td><td>Cloud</td><td class="num">31</td><td class="num">220,981</td></tr>
<tr><td>2019</td><td>iOS App 實作開發新手村</td><td>Software Development</td><td class="num">30</td><td class="num">65,681</td></tr>
<tr class="hl"><td>2026</td><td><strong>盡信 Claude,不如無 Code</strong></td><td>Claude AI</td><td class="num">進行中</td><td class="num">937<br><span class="note">前 10 天</span></td></tr>
</table>' 710
trim "table-three"

generate "table-three-en" '<table>
<tr><th>Year</th><th>Series</th><th>Group</th><th class="num">Articles</th><th class="num">Total views</th></tr>
<tr><td>2017</td><td>Cloud Services for Beginners</td><td>Cloud</td><td class="num">31</td><td class="num">220,981</td></tr>
<tr><td>2019</td><td>iOS App Development for Beginners</td><td>Software Development</td><td class="num">30</td><td class="num">65,681</td></tr>
<tr class="hl"><td>2026</td><td><strong>盡信 Claude,不如無 Code</strong></td><td>Claude AI</td><td class="num">In progress</td><td class="num">937<br><span class="note">first 10 days</span></td></tr>
</table>' 845
trim "table-three-en"
