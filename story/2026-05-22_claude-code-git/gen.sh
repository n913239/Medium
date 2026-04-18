#!/bin/bash
cd "$(dirname "$0")"
DIR="$(pwd)"

generate() {
  local name="$1"
  local table_html="$2"
  local vw="${3:-900}"
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
.c { text-align: center; }
</style></head><body>
<div class="wrap">${table_html}</div>
<script>
  const w = document.querySelector('.wrap');
  document.title = w.offsetWidth + 'x' + w.offsetHeight;
</script>
</body></html>
ENDHTML
  npx playwright screenshot --viewport-size "${vw},100" --full-page \
    "file://${DIR}/_${name}.html" "${DIR}/${name}.png" 2>/dev/null
  rm -f "${DIR}/_${name}.html"
  echo "✅ ${name}.png"
}

trim() {
  local name="$1"
  local file="${DIR}/${name}.png"
  magick "$file" -fuzz 3% -trim +repage -bordercolor '#f5f5f5' -border 12 "$file"
}

# 中文表格
generate "table-git-workflow" '<table>
<tr><th>步驟</th><th>以前怎麼做</th><th>有 Claude Code 之後</th></tr>
<tr><td>開新功能</td><td>自己想 branch 名稱</td><td>告訴 Claude 要做什麼，它建 branch</td></tr>
<tr><td>改程式碼</td><td>自己寫</td><td>Claude 幫你寫或一起寫</td></tr>
<tr><td>確認改動</td><td>自己看 diff</td><td>叫 Claude review diff，找潛在問題</td></tr>
<tr><td>Commit</td><td>自己想 message</td><td>Claude 分析 diff 寫 message</td></tr>
<tr><td>開 PR</td><td>自己寫 description</td><td>Claude 根據 commits 寫 PR description</td></tr>
<tr><td>Merge conflict</td><td>自己手動解</td><td>讓 Claude 理解兩邊意圖再解</td></tr>
</table>'

# 英文表格
generate "table-git-workflow-en" '<table>
<tr><th>Step</th><th>Before</th><th>With Claude Code</th></tr>
<tr><td>Start a feature</td><td>Think of a branch name yourself</td><td>Tell Claude what you&apos;re building; it creates the branch</td></tr>
<tr><td>Write code</td><td>Write it yourself</td><td>Claude writes it or pairs with you</td></tr>
<tr><td>Review changes</td><td>Read the diff yourself</td><td>Ask Claude to review the diff and find issues</td></tr>
<tr><td>Commit</td><td>Write the message yourself</td><td>Claude analyzes the diff and writes the message</td></tr>
<tr><td>Open PR</td><td>Write the description yourself</td><td>Claude writes the PR description from your commits</td></tr>
<tr><td>Merge conflict</td><td>Resolve manually</td><td>Claude understands both sides&apos; intent before resolving</td></tr>
</table>'

# 裁切灰色邊框
echo ""
echo "裁切邊框..."
for name in table-git-workflow table-git-workflow-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
