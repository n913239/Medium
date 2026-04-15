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

generate "table-skill-vs-agent-en" '<table>
<tr><th>Dimension</th><th>Skill</th><th>Agent</th></tr>
<tr><td><b>Trigger</b></td><td>User types <code>/xxx</code></td><td>Auto-invoked by Skill or Claude</td></tr>
<tr><td><b>Interactivity</b></td><td>High (back-and-forth)</td><td>Low (runs independently, reports back)</td></tr>
<tr><td><b>Context</b></td><td>Shared with main conversation</td><td>Isolated context window</td></tr>
<tr><td><b>Tool restriction</b></td><td>All tools by default</td><td>Configurable via <code>tools</code> field</td></tr>
<tr><td><b>Best for</b></td><td>Flows requiring user input</td><td>Heavy analysis, fully isolated tasks</td></tr>
</table>' 1000

generate "table-agent-frontmatter-en" '<table>
<tr><th>Field</th><th>Description</th><th>Example</th></tr>
<tr><td><code>description</code></td><td>How Claude decides when to auto-invoke — describe the use case</td><td><code>iOS code reviewer for git diff</code></td></tr>
<tr><td><code>tools</code></td><td>Restrict which tools the Agent can use; inherits defaults if omitted</td><td><code>["Read", "Bash", "Grep", "Glob"]</code></td></tr>
<tr><td><code>model</code></td><td>Specify model to use; pick the right one for the task</td><td><code>haiku</code> / <code>sonnet</code> / <code>opus</code></td></tr>
</table>' 1100

generate "table-ios-agents-en" '<table>
<tr><th>Agent</th><th>Purpose</th><th>Invoked by</th><th>Scope</th></tr>
<tr><td><code>ios-reviewer</code></td><td>Lightweight code review</td><td><code>/ios-commit</code></td><td>Diff only</td></tr>
<tr><td><code>ios-deep-reviewer</code></td><td>Deep review + architecture analysis + score</td><td><code>/ios-deep-review</code></td><td>Diff + full files</td></tr>
<tr><td><code>ios-pr-writer</code></td><td>Generate structured PR description</td><td><code>/ios-pr</code></td><td>git log + diff</td></tr>
<tr><td><code>ios-json-to-model</code></td><td>JSON → Swift Codable struct</td><td><code>/ios-json-to-model</code></td><td>User-provided JSON</td></tr>
<tr><td><code>ios-test-stub-generator</code></td><td>Unit test scaffolding (Swift Testing / XCTest)</td><td><code>/ios-test-stub</code></td><td>Specified Swift file</td></tr>
</table>' 1200

generate "table-tools-guide-en" '<table>
<tr><th>Task type</th><th>Recommended tools</th><th>Notes</th></tr>
<tr><td>Read-only analysis (code review, log analysis)</td><td><code>Read</code>, <code>Bash</code>, <code>Grep</code>, <code>Glob</code></td><td>Can only read — no file modifications</td></tr>
<tr><td>Content conversion (JSON → Swift Model)</td><td><code>Read</code>, <code>Write</code></td><td>Read input data, write output file</td></tr>
<tr><td>Code modification (auto-fix, refactoring)</td><td><code>Read</code>, <code>Edit</code>, <code>Bash</code></td><td>Read then directly modify existing files</td></tr>
</table>' 1100

echo ""
echo "All done!"
