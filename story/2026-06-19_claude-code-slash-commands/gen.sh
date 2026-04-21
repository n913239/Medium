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

# 中文：功能總覽
generate "table-commands-agents" '<table>
<tr><th>功能</th><th>用途</th><th>放在哪裡</th></tr>
<tr><td>Slash Commands</td><td>把常用 prompt 存起來</td><td><code>.claude/commands/</code></td></tr>
<tr><td>Custom Agents</td><td>定義有角色和工具的代理人</td><td><code>.claude/agents/</code></td></tr>
<tr><td>allowedTools</td><td>設定不需確認的工具</td><td>CLAUDE.md frontmatter</td></tr>
<tr><td>對話授權</td><td>這次對話的臨時授權</td><td>對話開頭</td></tr>
</table>'

# 英文：功能總覽
generate "table-commands-agents-en" '<table>
<tr><th>Feature</th><th>Purpose</th><th>Location</th></tr>
<tr><td>Slash Commands</td><td>Save common prompts as commands</td><td><code>.claude/commands/</code></td></tr>
<tr><td>Custom Agents</td><td>Define role-based agents with tools</td><td><code>.claude/agents/</code></td></tr>
<tr><td>allowedTools</td><td>Set tools that don&apos;t require confirmation</td><td>CLAUDE.md frontmatter</td></tr>
<tr><td>Conversation auth</td><td>Temporary permission for one session</td><td>Start of conversation</td></tr>
</table>'

# 裁切灰色邊框
echo ""
echo "裁切邊框..."
for name in table-commands-agents table-commands-agents-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "全部完成！"
