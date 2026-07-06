#!/bin/bash
cd "$(dirname "$0")"
DIR="$(pwd)"

generate() {
  local name="$1"
  local table_html="$2"
  local vw="${3:-720}"
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
.ok { color: #1a7f37; font-weight: 600; white-space: nowrap; }
.man { color: #9a6700; font-weight: 600; white-space: nowrap; }
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

# 中文：CI 三關全過
generate "ci-summary" '<table>
<tr><th>CI 檢查（每次 push / PR）</th><th>結果</th></tr>
<tr><td><code>settings.json</code> 合法性（jq）</td><td class="ok">✓ 通過</td></tr>
<tr><td><code>shellcheck</code> 靜態檢查</td><td class="ok">✓ 通過</td></tr>
<tr><td><code>precommit-guard</code> 行為測試</td><td class="ok">✓ 6 / 6 通過</td></tr>
</table>'

# 英文：CI 三關全過
generate "ci-summary-en" '<table>
<tr><th>CI check (every push / PR)</th><th>Result</th></tr>
<tr><td><code>settings.json</code> valid JSON (jq)</td><td class="ok">✓ pass</td></tr>
<tr><td><code>shellcheck</code> static analysis</td><td class="ok">✓ pass</td></tr>
<tr><td><code>precommit-guard</code> behavior tests</td><td class="ok">✓ 6 / 6 pass</td></tr>
</table>'

# 中文:可測 vs 不可測 對照表
generate "table-testable" '<table>
<tr><th>工作流元件</th><th>本質</th><th>怎麼守</th></tr>
<tr><td><code>precommit-guard.sh</code></td><td>純 shell、決定性</td><td class="ok">✓ CI 行為測試</td></tr>
<tr><td><code>settings.json</code></td><td>靜態設定</td><td class="ok">✓ CI（jq 驗）</td></tr>
<tr><td><code>test-writer</code> / <code>code-reviewer</code></td><td>要 LLM 判斷</td><td class="man">人工測</td></tr>
<tr><td><code>/precommit</code>、<code>/pr-description</code></td><td>要 LLM 判斷</td><td class="man">人工測</td></tr>
</table>' 640

# 英文:可測 vs 不可測 對照表
generate "table-testable-en" '<table>
<tr><th>Workflow component</th><th>Nature</th><th>How it is guarded</th></tr>
<tr><td><code>precommit-guard.sh</code></td><td>Pure shell, deterministic</td><td class="ok">✓ CI behavior tests</td></tr>
<tr><td><code>settings.json</code></td><td>Static config</td><td class="ok">✓ CI (jq)</td></tr>
<tr><td><code>test-writer</code> / <code>code-reviewer</code></td><td>Needs LLM judgment</td><td class="man">Manual</td></tr>
<tr><td><code>/precommit</code>, <code>/pr-description</code></td><td>Needs LLM judgment</td><td class="man">Manual</td></tr>
</table>' 780

# 終端風格樣式(regression 紅燈圖共用)
TERM_STYLE='<style>
.term{background:#fff;border:1px solid #e0e0e0;border-radius:8px;overflow:hidden;margin:0 0 16px;font-family:"SF Mono",Menlo,monospace;font-size:14px;line-height:1.7}
.term:last-child{margin-bottom:0}
.bar{background:#f0f0f0;color:#57606a;padding:8px 16px;border-bottom:1px solid #e0e0e0;font-size:13px}
.tbody{padding:12px 16px;color:#333;white-space:pre}
.g{color:#1a7f37}
.r{color:#cf222e;font-weight:600}
.cap{font-weight:600}
</style>'

# 中文:regression 紅燈(改壞前 vs 改壞後)
generate "ci-regression" "${TERM_STYLE}"'<div class="term">
<div class="bar">$ bash tests/test-precommit-guard.sh   # 改壞前</div>
<div class="tbody">precommit-guard 測試:
<span class="g">  ✓ 有 print 的 commit 應被擋 (exit 2)</span>
<span class="g">  ✓ 有 hardcode token 的 commit 應被擋 (exit 2)</span>
<span class="g">  ✓ 有 TODO 的 commit 應被擋 (exit 2)</span>
<span class="g">  ✓ 乾淨的 commit 應放行 (exit 0)</span>
<span class="g">  ✓ 沒有 staged 檔的 commit 應放行 (exit 0)</span>
<span class="g">  ✓ 非 commit 指令一律放行 (exit 0)</span>

<span class="g cap">通過 6,失敗 0  →  CI 綠燈</span></div>
</div>
<div class="term">
<div class="bar">$ bash tests/test-precommit-guard.sh   # 手滑把 exit 2 改成 exit 0 之後</div>
<div class="tbody">precommit-guard 測試:
<span class="r">  ✗ 有 print 的 commit 應被擋 — 預期 exit 2,實際 0</span>
<span class="r">  ✗ 有 hardcode token 的 commit 應被擋 — 預期 exit 2,實際 0</span>
<span class="r">  ✗ 有 TODO 的 commit 應被擋 — 預期 exit 2,實際 0</span>
<span class="g">  ✓ 乾淨的 commit 應放行 (exit 0)</span>
<span class="g">  ✓ 沒有 staged 檔的 commit 應放行 (exit 0)</span>
<span class="g">  ✓ 非 commit 指令一律放行 (exit 0)</span>

<span class="r cap">通過 3,失敗 3  →  CI 變紅</span></div>
</div>' 860

# 英文:regression 紅燈(改壞前 vs 改壞後)
generate "ci-regression-en" "${TERM_STYLE}"'<div class="term">
<div class="bar">$ bash tests/test-precommit-guard.sh   # before</div>
<div class="tbody">precommit-guard tests:
<span class="g">  ✓ commit with print should be blocked (exit 2)</span>
<span class="g">  ✓ commit with hardcoded token should be blocked (exit 2)</span>
<span class="g">  ✓ commit with TODO should be blocked (exit 2)</span>
<span class="g">  ✓ clean commit should pass (exit 0)</span>
<span class="g">  ✓ no staged file should pass (exit 0)</span>
<span class="g">  ✓ non-commit command should pass (exit 0)</span>

<span class="g cap">6 passed, 0 failed  →  CI green</span></div>
</div>
<div class="term">
<div class="bar">$ bash tests/test-precommit-guard.sh   # after fat-fingering exit 2 into exit 0</div>
<div class="tbody">precommit-guard tests:
<span class="r">  ✗ commit with print should be blocked — expected exit 2, got 0</span>
<span class="r">  ✗ commit with hardcoded token should be blocked — expected exit 2, got 0</span>
<span class="r">  ✗ commit with TODO should be blocked — expected exit 2, got 0</span>
<span class="g">  ✓ clean commit should pass (exit 0)</span>
<span class="g">  ✓ no staged file should pass (exit 0)</span>
<span class="g">  ✓ non-commit command should pass (exit 0)</span>

<span class="r cap">3 passed, 3 failed  →  CI red</span></div>
</div>' 900

echo ""
echo "裁切邊框..."
for name in ci-summary ci-summary-en table-testable table-testable-en ci-regression ci-regression-en; do
  trim "$name"
  echo "✂️  ${name}.png"
done

echo ""
echo "完成！"
