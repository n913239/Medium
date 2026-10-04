import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { CheckRow, Report } from '../types'

const report = atom({ plugin: 'medium-band', key: 'report' } as const, null)

/* ---------- markdown 解析 ----------
   每個拿到 $ 的 helper 都必須宣告在檔案最上層:引擎靠靜態分析列出
   「這個 mod 會呼叫什麼」,closure 它追不動,validate 會直接拒收。 */

const IMAGE_RE = /^!\[[^\]]*\]\(([^)]+)\)/
const MARKER_RE = /^\*\((在這裡插入|Insert)/
const PLACEHOLDER_RE = /TODO|待補|\(Medium 網址\)|TBD/
const FULLWIDTH_RE = /[，（）：；！？]/g
const INLINE_CODE_RE = /`[^`]*`/g

/** 剔除 fenced code block 內的行。
    標題計數一定要走這裡:正文會示範 `## 專案簡介`,naive 比對會把假標題算進去。 */
function outsideFences(lines: string[]): Array<[number, string]> {
  const out: Array<[number, string]> = []
  let inFence = false
  lines.forEach((line, i) => {
    if (line.startsWith('```')) {
      inFence = !inFence
      return
    }
    if (!inFence) out.push([i + 1, line])
  })
  return out
}

function countFences(lines: string[]): number {
  return lines.filter(l => l.startsWith('```')).length
}

function headings(lines: string[], level: number): string[] {
  const prefix = `${'#'.repeat(level)} `
  return outsideFences(lines)
    .map(([, t]) => t)
    .filter(t => t.startsWith(prefix))
}

function images(lines: string[]): string[] {
  return lines.flatMap(l => {
    const m = IMAGE_RE.exec(l)
    return m === null ? [] : [m[1]]
  })
}

function markers(lines: string[]): number {
  return lines.filter(l => MARKER_RE.test(l)).length
}

/* ---------- 個別檢查 ---------- */

function checkTags(lines: string[], lang: string): CheckRow {
  const m = /<!--\s*Tags:\s*(.+?)\s*-->/.exec(lines[0] ?? '')
  if (m === null) {
    return { name: `tags[${lang}]`, ok: false, detail: '第一行不是 <!-- Tags: ... -->' }
  }
  const tags = m[1].split(',').map(t => t.trim()).filter(t => t.length > 0)
  return { name: `tags[${lang}]`, ok: tags.length <= 5, detail: `${tags.length} 個(上限 5)` }
}

function checkFences(lines: string[], lang: string): CheckRow {
  const n = countFences(lines)
  return { name: `fences[${lang}]`, ok: n % 2 === 0, detail: `${n} 個 ${n % 2 === 0 ? '(偶數)' : '(奇數,未閉合)'}` }
}

function checkMarkers(lines: string[], lang: string): CheckRow {
  const a = images(lines).length
  const b = markers(lines)
  return { name: `image-markers[${lang}]`, ok: a === b, detail: `圖 ${a} 張 vs 提示行 ${b} 行` }
}

/** 每個 H2 前面一條 `---`:系列從 0317 起的排版慣例。

    只檢查「每個 H2 前面有沒有」,不檢查總數相等 ——
    有 9 篇舊文在別處也用了水平線(12 條 vs 11 個 H2),那不是錯。
    一定要走 outsideFences:正文會示範水平線,也會有 `--- stdout ---` 這種分隔。 */
function checkRules(lines: string[], lang: string): CheckRow {
  const body = outsideFences(lines).map(([, t]) => t.trim())
  const missing: string[] = []

  body.forEach((text, i) => {
    if (!text.startsWith('## ')) return
    let j = i - 1
    while (j >= 0 && body[j] === '') j -= 1
    if (j < 0 || body[j] !== '---') missing.push(text.replace(/^##\s+/, ''))
  })

  return {
    name: `rules[${lang}]`,
    ok: missing.length === 0,
    detail: missing.length === 0
      ? '每個 H2 前都有 ---'
      : `${missing.length} 個 H2 前面少了 ---:${missing.slice(0, 3).join(', ')}`,
  }
}

function checkClosing(lines: string[], lang: string): CheckRow {
  const want = lang === 'zh' ? ['總結', '參考資料'] : ['Summary', 'References']
  const tail = headings(lines, 2).slice(-2).map(h => h.replace(/^##\s+/, '').trim())
  const ok = tail.length === 2 && tail[0] === want[0] && tail[1] === want[1]
  return { name: `closing[${lang}]`, ok, detail: `結尾兩節 ${JSON.stringify(tail)},應為 ${JSON.stringify(want)}` }
}

/** 散文才算:講「hook 擋 TODO」的文章,內文本來就會出現 TODO,那是被討論的對象 */
function checkPlaceholders(lines: string[], lang: string): CheckRow {
  const hits = outsideFences(lines)
    .filter(([, t]) => PLACEHOLDER_RE.test(t.replace(INLINE_CODE_RE, '')))
    .map(([i]) => `L${i}`)
  return {
    name: `placeholders[${lang}]`,
    ok: hits.length === 0,
    detail: hits.length === 0 ? '無殘留' : `${hits.length} 處:${hits.slice(0, 6).join(', ')}`,
  }
}

function checkFullwidth(lines: string[]): CheckRow {
  const hits = outsideFences(lines).flatMap(([i, t]) => {
    const found = t.match(FULLWIDTH_RE)
    return found === null ? [] : [`L${i}`]
  })
  return {
    name: 'fullwidth[zh]',
    ok: hits.length === 0,
    detail: hits.length === 0 ? '無全形標點' : `${hits.length} 行:${hits.slice(0, 6).join(', ')}`,
  }
}

function checkParity(zh: string[], en: string[]): CheckRow[] {
  const rows: CheckRow[] = []
  for (const level of [2, 3]) {
    const a = headings(zh, level).length
    const b = headings(en, level).length
    rows.push({ name: `parity-h${level}`, ok: a === b, detail: `中 ${a} / 英 ${b}` })
  }
  const a = images(zh).length
  const b = images(en).length
  rows.push({ name: 'parity-images', ok: a === b, detail: `中 ${a} / 英 ${b}` })
  return rows
}

/* ---------- 跑一輪 ---------- */

/** 目前在編哪一篇:cwd 在 story/ 底下就用它,否則用最新的那個資料夾 */
async function currentArticle($: EngineInterface): Promise<string | null> {
  const cwd = await $.session.cwd()
  const m = /\/story\/([^/]+)/.exec(cwd)
  if (m !== null) return m[1]

  const root = /^(.*?)\/story(\/|$)/.exec(cwd)?.[1] ?? cwd
  try {
    const entries = await $.fs.list(`${root}/story`)
    const dirs = entries.filter(e => /^\d{4}-\d{2}-\d{2}_/.test(e.name)).map(e => e.name).sort()
    return dirs.at(-1) ?? null
  } catch {
    return null
  }
}

async function storyRoot($: EngineInterface, slug: string): Promise<string> {
  const cwd = await $.session.cwd()
  const root = /^(.*?)\/story(\/|$)/.exec(cwd)?.[1] ?? cwd
  return `${root}/story/${slug}`
}

async function readLines($: EngineInterface, path: string): Promise<string[] | null> {
  try {
    return (await $.fs.read(path)).split('\n')
  } catch {
    return null
  }
}

async function runChecks($: EngineInterface): Promise<Report | null> {
  const slug = await currentArticle($)
  if (slug === null) return null

  const dir = await storyRoot($, slug)
  const zh = await readLines($, `${dir}/index.md`)
  const en = await readLines($, `${dir}/index-en.md`)
  if (zh === null) return null

  const rows: CheckRow[] = [
    checkTags(zh, 'zh'),
    checkFences(zh, 'zh'),
    checkMarkers(zh, 'zh'),
    checkClosing(zh, 'zh'),
    checkRules(zh, 'zh'),
    checkPlaceholders(zh, 'zh'),
    checkFullwidth(zh),
  ]

  if (en === null) {
    rows.push({ name: 'index-en.md', ok: false, detail: '還沒有英文版' })
  } else {
    rows.push(
      checkTags(en, 'en'),
      checkFences(en, 'en'),
      checkMarkers(en, 'en'),
      checkClosing(en, 'en'),
      checkRules(en, 'en'),
      checkPlaceholders(en, 'en'),
      ...checkParity(zh, en),
    )
  }

  return { slug, rows, failed: rows.filter(r => !r.ok).length }
}

/* ---------- 地端模型:中英語意漂移 ---------- */

/* ---------- hooks ---------- */

export const register: Register = (on) => {

  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'check',
      description: '跑這個 repo 的發文前檢查(加 drift 比對中英語意)',
    })
    // 先 await 算完再寫。把 async 函式直接交給 update 會把 Promise 存進
    // $.state,下一次 render 讀到的就不是 Report —— 第一版就是這樣炸的。
    const made = await runChecks($)
    if (made !== null) await update($, report, () => made)

    return next(e)
  })

  /* 指令直接跑這個函式:沒有模型回合,不花 token,Claude 在忙也能按 */
  on('command.run', { command: 'check' }, async ($, e) => {
    const made = await runChecks($)
    if (made === null) {
      return { text: 'medium-band:找不到 story/ 底下的文章。' }
    }
    await update($, report, () => made)

    const lines = made.rows.map(r => `${r.ok ? '✓' : '✗'} ${r.name.padEnd(22)} ${r.detail}`)
    const head = `${made.slug} — ${made.rows.length} 項,${made.failed} 項未過`

    // 認不得的參數要講出來。打成 /check deift 卻靜靜當作沒給參數,
    // 使用者會以為跑過了 —— 跟無聲跳過是同一種錯。
    const args = String(e.args ?? '').trim().split(/\s+/).filter(a => a.length > 0)
    if (args.length > 0) {
      lines.push('', `不認得的參數:${args.join(', ')}(語意比對請用 /check-drift)`)
    }

    return { text: [head, '', ...lines].join('\n') }
  })

  /* 寫完文章就重算,band 跟著變 */
  on('tool.call', async ($, e, next) => {
    const ran = await next(e)
    const path = String((e as { file_path?: unknown }).file_path ?? '')
    if (/\/story\/[^/]+\/index(-en)?\.md$/.test(path)) {
      const made = await runChecks($)
      if (made !== null) await update($, report, () => made)
    }
    return ran
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const made = await read($, report)
    if (made === null || !Array.isArray(made.rows)) return next(e)

    const { Box, Text } = $.ui.resolve(e)
    const good = made.failed === 0

    return (
      <Box>
        <Text dimColor>{made.slug} </Text>
        <Text color={good ? 'green' : 'yellow'}>
          {good ? `✓ ${made.rows.length} 項全過` : `✗ ${made.failed} 項未過`}
        </Text>
        <Text dimColor>
          {good ? '' : ` — ${made.rows.filter(r => !r.ok).map(r => r.name).slice(0, 3).join(', ')}`}
        </Text>
      </Box>
    )
  })
}
