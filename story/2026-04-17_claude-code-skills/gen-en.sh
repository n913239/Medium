#!/bin/bash
cd "$(dirname "$0")"
DIR="$(pwd)"

generate() {
  local name="$1"
  local table_html="$2"
  local vw="${3:-900}"
  cat > "${DIR}/_${name}.html" << ENDHTML
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
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

generate "table-comparison-en" '<table>
<tr><th></th><th>CLAUDE.md</th><th>Skills</th></tr>
<tr><td><b>Purpose</b></td><td>Project conventions, loaded on every startup</td><td>Specific workflows, loaded on demand</td></tr>
<tr><td><b>Trigger</b></td><td>Always active</td><td><code>/skill-name</code> manual call, or Claude auto-decides</td></tr>
<tr><td><b>Best for</b></td><td>Coding style, architecture docs, restrictions</td><td>Deploy flows, code cleanup, file conversion</td></tr>
<tr><td><b>Location</b></td><td>Project root</td><td><code>.claude/skills/</code> directory</td></tr>
</table>'

generate "table-scope-en" '<table>
<tr><th>Level</th><th>Path</th><th>Scope</th></tr>
<tr><td>Personal</td><td><code>~/.claude/skills/&lt;skill-name&gt;/SKILL.md</code></td><td>All your projects</td></tr>
<tr><td>Project</td><td><code>.claude/skills/&lt;skill-name&gt;/SKILL.md</code></td><td>This project only</td></tr>
<tr><td>Enterprise</td><td>Managed settings</td><td>All users in your org</td></tr>
</table>'

generate "table-bundled-en" '<table>
<tr><th>Skill</th><th>Purpose</th></tr>
<tr><td><code>/batch &lt;instruction&gt;</code></td><td>Large-scale parallel changes — decomposes work, spawns one agent per unit in a git worktree, each opens a PR</td></tr>
<tr><td><code>/claude-api</code></td><td>Loads Claude API reference; auto-triggers when writing Anthropic SDK code</td></tr>
<tr><td><code>/debug [description]</code></td><td>Enables debug logging and analyzes the current session</td></tr>
<tr><td><code>/loop [interval] &lt;prompt&gt;</code></td><td>Runs a prompt on a recurring interval — great for monitoring deploys or polling PRs</td></tr>
<tr><td><code>/simplify [focus]</code></td><td>Spawns three parallel review agents to check recent changes for reuse, quality, and efficiency issues</td></tr>
</table>' 1200

generate "table-docx-compare-en" '<table>
<tr><th>Item</th><th class="c">/convert-docx</th><th class="c">Official docx skill (pandoc)</th></tr>
<tr><td>Table borders</td><td class="c">✅ Complete</td><td class="c">❌ No borders</td></tr>
<tr><td>Column width</td><td class="c">✅ Auto-fit</td><td class="c">❌ Fixed width</td></tr>
<tr><td>Image embedding</td><td class="c">✅ Normal</td><td class="c">✅ Normal</td></tr>
<tr><td>Steps required</td><td class="c">1 step</td><td class="c">1 step (but needs manual border fix)</td></tr>
</table>'

generate "table-frontmatter-en" '<table>
<tr><th>Field</th><th>Description</th><th>Default</th></tr>
<tr><td><code>name</code></td><td>Skill name — what you type after <code>/</code></td><td>Directory name</td></tr>
<tr><td><code>description</code></td><td>Describes purpose; Claude uses this to decide whether to auto-load</td><td>None</td></tr>
<tr><td><code>argument-hint</code></td><td>Hint shown during autocomplete</td><td>None</td></tr>
<tr><td><code>disable-model-invocation</code></td><td>Set <code>true</code> to allow manual invocation only; Claude won'"'"'t auto-trigger</td><td><code>false</code></td></tr>
<tr><td><code>user-invocable</code></td><td>Set <code>false</code> to hide from <code>/</code> menu; only Claude can invoke</td><td><code>true</code></td></tr>
<tr><td><code>allowed-tools</code></td><td>Restrict which tools the Skill can use</td><td>All</td></tr>
<tr><td><code>model</code></td><td>Specify model to use (e.g., Haiku) to save tokens</td><td>Inherits session</td></tr>
<tr><td><code>effort</code></td><td>Reasoning effort: <code>low</code>, <code>medium</code>, <code>high</code>, <code>max</code></td><td>Inherits session</td></tr>
<tr><td><code>context</code></td><td>Set <code>fork</code> to run in an isolated subagent</td><td>None</td></tr>
</table>'

generate "table-invocation-en" '<table>
<tr><th>Setting</th><th class="c">You can invoke</th><th class="c">Claude auto-invokes</th><th>Best for</th></tr>
<tr><td>Default (nothing set)</td><td class="c">Yes</td><td class="c">Yes</td><td>General-purpose Skills</td></tr>
<tr><td><code>disable-model-invocation: true</code></td><td class="c">Yes</td><td class="c">No</td><td>Deploy, notifications, or any side-effect operations</td></tr>
<tr><td><code>user-invocable: false</code></td><td class="c">No</td><td class="c">Yes</td><td>Background knowledge, e.g., legacy system architecture</td></tr>
</table>' 1200

echo ""
echo "All done!"
