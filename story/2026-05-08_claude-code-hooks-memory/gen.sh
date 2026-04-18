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

generate "table-hooks-events" '<table>
<tr><th>事件</th><th>觸發時機</th><th>常見用途</th></tr>
<tr><td><code>PreToolUse</code></td><td>Claude 執行工具<b>之前</b></td><td>安全檢查、阻擋危險指令</td></tr>
<tr><td><code>PostToolUse</code></td><td>Claude 執行工具<b>之後</b></td><td>自動格式化、跑測試、記錄 log</td></tr>
<tr><td><code>Stop</code></td><td>Claude <b>完成回應</b>時</td><td>發桌面通知、記錄對話摘要</td></tr>
<tr><td><code>Notification</code></td><td>Claude Code <b>發出系統通知</b>時</td><td>轉發到 Slack、Telegram、Line</td></tr>
</table>'

generate "table-hooks-config" '<table>
<tr><th>欄位</th><th>說明</th><th>範例</th></tr>
<tr><td><code>matcher</code></td><td>攔截哪個工具，用 <code>|</code> 分隔多個；不填則攔截全部</td><td><code>"Edit|Write"</code></td></tr>
<tr><td><code>type</code></td><td>目前只有 <code>"command"</code></td><td><code>"command"</code></td></tr>
<tr><td><code>command</code></td><td>要執行的 shell 指令</td><td><code>"swiftlint lint ..."</code></td></tr>
</table>'

generate "table-memory-types" '<table>
<tr><th>類型</th><th>儲存什麼</th><th>範例</th></tr>
<tr><td><code>user</code></td><td>你的角色、技能、偏好</td><td>「iOS 老手，第一次碰 React」</td></tr>
<tr><td><code>feedback</code></td><td>Claude 應該怎麼做事的指導</td><td>「commit message 不加 Co-Authored-By」</td></tr>
<tr><td><code>project</code></td><td>進行中的工作、決策、截止日期</td><td>「5/15 前要完成登入功能」</td></tr>
<tr><td><code>reference</code></td><td>外部資源的位置</td><td>「bug 追蹤在 Linear 的 INGEST 專案」</td></tr>
</table>'

generate "table-agent-memory-scopes" '<table>
<tr><th>Scope</th><th>儲存位置</th><th>適合場景</th></tr>
<tr><td><code>user</code></td><td><code>~/.claude/agent-memory/&lt;agent-name&gt;/</code></td><td>跨所有專案都適用的知識</td></tr>
<tr><td><code>project</code></td><td><code>.claude/agent-memory/&lt;agent-name&gt;/</code></td><td>專案專屬，可 commit 進 repo 讓團隊共用</td></tr>
<tr><td><code>local</code></td><td><code>.claude/agent-memory-local/&lt;agent-name&gt;/</code></td><td>專案專屬，但不 commit（個人用）</td></tr>
</table>'

generate "table-vs-claudemd" '<table>
<tr><th></th><th>CLAUDE.md</th><th>Memory</th></tr>
<tr><td><b>性質</b></td><td>靜態規範，你主動寫入</td><td>動態記憶，對話中自動累積</td></tr>
<tr><td><b>內容</b></td><td>架構、命名、禁止事項</td><td>個人偏好、進行中的工作、過去的決策</td></tr>
<tr><td><b>更新方式</b></td><td>你手動編輯</td><td>Claude 自動寫入，你也可以要求</td></tr>
<tr><td><b>適合</b></td><td>整個團隊共用的規範</td><td>個人偏好和跨對話的脈絡</td></tr>
<tr><td><b>Commit 進 repo</b></td><td>通常 commit</td><td>不 commit，個人專屬</td></tr>
</table>'

generate "table-hooks-events-en" '<table>
<tr><th>Event</th><th>When It Fires</th><th>Common Uses</th></tr>
<tr><td><code>PreToolUse</code></td><td><b>Before</b> Claude runs a tool</td><td>Safety checks, blocking dangerous commands</td></tr>
<tr><td><code>PostToolUse</code></td><td><b>After</b> Claude runs a tool</td><td>Auto-format, run tests, log activity</td></tr>
<tr><td><code>Stop</code></td><td>When Claude <b>finishes a response</b></td><td>Desktop notifications, log session summaries</td></tr>
<tr><td><code>Notification</code></td><td>When Claude Code <b>sends a system notification</b></td><td>Forward to Slack, Telegram, Line</td></tr>
</table>'

generate "table-hooks-config-en" '<table>
<tr><th>Field</th><th>Description</th><th>Example</th></tr>
<tr><td><code>matcher</code></td><td>Which tool to intercept; use <code>|</code> to separate multiple; omit to intercept all</td><td><code>"Edit|Write"</code></td></tr>
<tr><td><code>type</code></td><td>Currently only <code>"command"</code></td><td><code>"command"</code></td></tr>
<tr><td><code>command</code></td><td>The shell command to execute</td><td><code>"swiftlint lint ..."</code></td></tr>
</table>'

generate "table-memory-types-en" '<table>
<tr><th>Type</th><th>Stores</th><th>Example</th></tr>
<tr><td><code>user</code></td><td>Your role, skills, preferences</td><td>"10 years of Swift, first time touching React"</td></tr>
<tr><td><code>feedback</code></td><td>Guidance on how Claude should behave</td><td>"Don&apos;t add Co-Authored-By to commit messages"</td></tr>
<tr><td><code>project</code></td><td>Ongoing work, decisions, deadlines</td><td>"Merge freeze until 5/8, no non-critical PRs"</td></tr>
<tr><td><code>reference</code></td><td>Locations of external resources</td><td>"Bugs tracked in Linear project INGEST"</td></tr>
</table>'

generate "table-agent-memory-scopes-en" '<table>
<tr><th>Scope</th><th>Storage Location</th><th>Best For</th></tr>
<tr><td><code>user</code></td><td><code>~/.claude/agent-memory/&lt;agent-name&gt;/</code></td><td>Knowledge applicable across all projects</td></tr>
<tr><td><code>project</code></td><td><code>.claude/agent-memory/&lt;agent-name&gt;/</code></td><td>Project-specific; committable for team sharing</td></tr>
<tr><td><code>local</code></td><td><code>.claude/agent-memory-local/&lt;agent-name&gt;/</code></td><td>Project-specific, not committed (personal only)</td></tr>
</table>'

generate "table-vs-claudemd-en" '<table>
<tr><th></th><th>CLAUDE.md</th><th>Memory</th></tr>
<tr><td><b>Nature</b></td><td>Static rules you write manually</td><td>Dynamic memory that accumulates through conversation</td></tr>
<tr><td><b>Content</b></td><td>Architecture, naming, prohibitions</td><td>Your preferences, ongoing work, past decisions</td></tr>
<tr><td><b>Updates</b></td><td>You edit manually</td><td>Claude writes automatically; you can also request</td></tr>
<tr><td><b>Best for</b></td><td>Team-wide conventions</td><td>Personal preferences and cross-session context</td></tr>
<tr><td><b>Commit to repo</b></td><td>Usually yes</td><td>No — personal only</td></tr>
</table>'

echo ""
echo "全部完成！"
