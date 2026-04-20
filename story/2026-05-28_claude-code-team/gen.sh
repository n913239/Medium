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

# 中文：導入階段
generate "table-rollout-phases" '<table>
<tr><th>階段</th><th>做什麼</th><th>目標</th></tr>
<tr><td>試用期（1–2 週）</td><td>1–2 人先跑，記錄有效和無效的用法</td><td>找出適合這個專案的使用模式</td></tr>
<tr><td>共識期（1–2 週）</td><td>把有效的用法寫進 CLAUDE.md，開會對齊</td><td>建立團隊共同的基準</td></tr>
<tr><td>全員期（持續）</td><td>全團隊使用，每兩週回顧 CLAUDE.md</td><td>維持一致性，持續改善</td></tr>
</table>'

# 英文：導入階段
generate "table-rollout-phases-en" '<table>
<tr><th>Phase</th><th>What to Do</th><th>Goal</th></tr>
<tr><td>Trial (1–2 weeks)</td><td>1–2 people try it, document what works and what doesn&apos;t</td><td>Find usage patterns that fit this project</td></tr>
<tr><td>Alignment (1–2 weeks)</td><td>Write what works into CLAUDE.md, hold a team sync</td><td>Build a shared team baseline</td></tr>
<tr><td>Full rollout (ongoing)</td><td>Everyone uses it, review CLAUDE.md every two weeks</td><td>Maintain consistency, keep improving</td></tr>
</table>'

# 裁切灰色邊框
echo ""
echo "裁切邊框..."
for name in table-rollout-phases table-rollout-phases-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
