#!/bin/bash
cd "$(dirname "$0")"
DIR="$(pwd)"
FAILED=0

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
.note { color: #777; font-size: 13px; }
</style></head><body>
<div class="wrap">${body_html}</div>
<script>
  const w = document.querySelector('.wrap');
  document.title = w.offsetWidth + 'x' + w.offsetHeight;
</script>
</body></html>
ENDHTML
  # 舊檔存在時 [ -f ] 永遠為真 —— 產圖全失敗也會印 ✅。改比對 mtime。
  local before=0
  [ -f "${DIR}/${name}.png" ] && before=$(stat -f %m "${DIR}/${name}.png")
  npx playwright screenshot --viewport-size "${vw},100" --full-page \
    "file://${DIR}/_${name}.html" "${DIR}/${name}.png" 2>&1 | grep -i "error\|Executable doesn" && echo "⚠️  ${name} 產圖可能失敗"
  rm -f "${DIR}/_${name}.html"
  local after=0
  [ -f "${DIR}/${name}.png" ] && after=$(stat -f %m "${DIR}/${name}.png")
  if [ "$after" -gt "$before" ]; then
    echo "✅ ${name}.png"
  else
    echo "❌ ${name}.png 沒有被重新產出（舊檔還在，不要當成成功）"
    FAILED=1
  fi
}

trim() {
  local file="${DIR}/${1}.png"
  command -v magick >/dev/null 2>&1 || return 0
  [ -f "$file" ] || return 0
  magick "$file" -fuzz 3% -trim +repage -bordercolor '#f5f5f5' -border 12 "$file"
}

# ---------- 1. 三份 CLAUDE.md 對照 ----------
generate "table-count" '<table>
<tr><th>檔案</th><th>行數</th><th>定位</th></tr>
<tr><td>我的全域 <code>~/.claude/CLAUDE.md</code></td><td class="p"><strong>7</strong></td><td>只放跨專案的鐵則,其餘丟給 skill</td></tr>
<tr><td>Apple <code>containerization/CLAUDE.md</code></td><td><strong>91</strong></td><td>大型 Swift 專案,整份都是地雷區</td></tr>
<tr><td>我這個寫作 repo 的 <code>CLAUDE.md</code></td><td><strong>104</strong></td><td>個人寫作慣例,被真實錯誤逼出來的</td></tr>
</table>' 720

generate "table-count-en" '<table>
<tr><th>File</th><th>Lines</th><th>What it is for</th></tr>
<tr><td>My global <code>~/.claude/CLAUDE.md</code></td><td class="p"><strong>7</strong></td><td>Cross-project hard rules only; the rest lives in skills</td></tr>
<tr><td>Apple <code>containerization/CLAUDE.md</code></td><td><strong>91</strong></td><td>Large Swift project; the whole file is a minefield map</td></tr>
<tr><td>My writing repo <code>CLAUDE.md</code></td><td><strong>104</strong></td><td>Writing conventions, beaten out of me by real mistakes</td></tr>
</table>' 840

# ---------- 2. Apple 的規則 vs 不寫會怎麼錯 ----------
generate "table-rules" '<table>
<tr><th>Apple 寫的規則</th><th>不寫的話,AI 會怎麼做錯</th></tr>
<tr><td>用 <code>make</code> 建置,不要直接 <code>swift build</code></td><td>直接跑 <code>swift build</code>,卡在編不動的 guest 套件</td></tr>
<tr><td><code>WARNINGS_AS_ERRORS=true</code> 是預設,<strong>別隨手關掉</strong></td><td>遇到 warning 擋路,順手關掉 flag——CI 才炸</td></tr>
<tr><td><code>.pb.swift</code> / <code>.grpc.swift</code> <strong>是產生的,不要手改</strong></td><td>直接改生成檔,下次 <code>make protos</code> 全被蓋掉</td></tr>
<tr><td>每個 Swift 檔都要 license header</td><td>新檔案漏掉,pre-commit hook 擋下來才發現</td></tr>
<tr><td><code>NeverForceUnwrap</code> / <code>NeverUseForceTry</code> 全開</td><td>寫出 <code>!</code> 和 <code>try!</code>,lint 全紅</td></tr>
<tr><td>加程式碼放<strong>最小適用的模組</strong></td><td>圖方便全塞進頂層 <code>Containerization</code>,破壞分層</td></tr>
<tr><td>Squash-and-merge:PR 標題會變成 commit message</td><td>PR 標題隨手寫「fix」,污染 commit 歷史</td></tr>
<tr><td>Apple silicon + macOS 26 + Xcode 26,舊版不支援</td><td>在不支援的機器上除錯半天</td></tr>
</table>' 900

generate "table-rules-en" '<table>
<tr><th>What Apple wrote</th><th>How the AI gets it wrong otherwise</th></tr>
<tr><td>Build via <code>make</code>, not <code>swift build</code></td><td>Runs <code>swift build</code> and stalls on the guest package</td></tr>
<tr><td><code>WARNINGS_AS_ERRORS=true</code> is the default — <strong>do not disable it casually</strong></td><td>Hits a blocking warning, helpfully turns the flag off, CI explodes later</td></tr>
<tr><td><code>.pb.swift</code> / <code>.grpc.swift</code> <strong>are generated — never hand-edit</strong></td><td>Edits the generated file; the next <code>make protos</code> wipes it</td></tr>
<tr><td>License headers required on every Swift file</td><td>New file ships without one, caught by the pre-commit hook</td></tr>
<tr><td><code>NeverForceUnwrap</code> / <code>NeverUseForceTry</code> are on</td><td>Writes <code>!</code> and <code>try!</code>, lint goes red</td></tr>
<tr><td>Add code to the <strong>smallest applicable module</strong></td><td>Dumps everything into top-level <code>Containerization</code>, breaking the layering</td></tr>
<tr><td>Squash-and-merge: the PR title becomes the commit message</td><td>Titles the PR &ldquo;fix&rdquo;, polluting the commit history</td></tr>
<tr><td>Apple silicon + macOS 26 + Xcode 26; older releases unsupported</td><td>Debugs for hours on a machine that was never going to work</td></tr>
</table>' 1040

# ---------- 3. 我的規則 vs 哪次翻車 ----------
generate "table-fail" '<table>
<tr><th>新增的規則</th><th>因為哪次翻車</th></tr>
<tr><td>中文版一律用<strong>半形</strong>標點</td><td>中文版混進全形逗號括號,前後篇不一致</td></tr>
<tr><td>每張圖前面都要有「插入圖片」提示行</td><td>整篇寫完才發現一行都沒加</td></tr>
<tr><td>收尾標題固定用「總結」/「參考資料」</td><td>英文版漂移成 Conclusion / Wrapping Up / Closing,中文冒出「結語」</td></tr>
<tr><td>去識別化整整一節</td><td>漏掉一個真實類別名,<strong>而且表格 PNG 裡也有</strong></td></tr>
<tr><td>code snippet 裡的變數名也要換</td><td>變數名洩漏了產業別,比類別名更難察覺</td></tr>
<tr><td>改完 <code>gen.sh</code> 一定要重新產圖</td><td>原始碼改了、PNG 沒重產,等於沒改</td></tr>
<tr><td>「community」中文用「群集」不用「社群」</td><td>讀者反映看不懂,以為在講社交網站</td></tr>
<tr><td>站內連結的 slug 與 hex ID 規則</td><td>不知道怎麼從標題組出網址,只好連到個人頁</td></tr>
<tr><td>外部專案一律 clone 到姊妹目錄</td><td>差點把整個測試 repo clone 進文章 repo</td></tr>
</table>' 880

generate "table-fail-en" '<table>
<tr><th>Rule that got added</th><th>The crash that caused it</th></tr>
<tr><td>Chinese text uses <strong>half-width</strong> punctuation</td><td>Full-width commas and brackets crept in, inconsistent across pieces</td></tr>
<tr><td>Every image needs an &ldquo;insert image here&rdquo; marker line</td><td>Finished a whole piece without a single one</td></tr>
<tr><td>Closing headings fixed to Summary / References</td><td>English drifted to Conclusion / Wrapping Up / Closing</td></tr>
<tr><td>A whole de-identification section</td><td>Missed one real class name — <strong>and it was inside a table PNG too</strong></td></tr>
<tr><td>Rename variables inside code snippets as well</td><td>A variable name leaked the industry; far harder to spot than a class name</td></tr>
<tr><td>Regenerate the images after editing <code>gen.sh</code></td><td>Edited the source, never re-rendered the PNG — so nothing actually changed</td></tr>
<tr><td>Use the right word for graph &ldquo;community&rdquo; in Chinese</td><td>A reader said the obvious translation reads as &ldquo;social network&rdquo;</td></tr>
<tr><td>The slug and hex-ID rule for in-series links</td><td>Could not build a URL from a title, so I linked the profile page instead</td></tr>
<tr><td>Clone external projects into a sibling directory</td><td>Nearly cloned an entire test repo into the writing repo</td></tr>
</table>' 1000

echo ""
echo "裁切邊框..."
for name in table-count table-count-en table-rules table-rules-en table-fail table-fail-en; do
  trim "$name"
done

echo ""
echo "完成！"

if [ "$FAILED" -ne 0 ]; then
  echo "⚠️  有圖沒產出來 —— 舊檔還在，不要以為改好了。"
  exit 1
fi
