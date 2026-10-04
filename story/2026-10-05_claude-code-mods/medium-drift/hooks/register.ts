import type { EngineInterface, Register } from 'claude-code'

/* 這支 mod 刻意只掛一個 command.run:它握有 $.process.run,
   所以它不該常駐、不該掛在 tool.call 上。常駐的檢查在 medium-band,
   那支沒有開 process 的能力。拆開的理由就是這個。 */

const DRIFT_ASK = [
  '下面是同一篇技術文章「同一個章節」的中文版正文與英文版正文。',
  '判斷兩邊是不是在講同一件事:論點、數字、結論要一致。',
  '用字、例子的先後、修辭差異不算漂移;數字對不上、少掉一個論點、結論相反才算。',
  '只回一行:一致回 OK;不一致回 DRIFT: <差在哪>',
].join('\n')

/** 參考資料的連結本來就中英各指各的,比對它只會製造雜訊 */
const SKIP_SECTIONS = new Set(['參考資料', 'References'])

let model = ''

/* 下面這幾個解析函式和 medium-band 重複。
   它們是純函式、不碰 $,而 dependencies 機制是用來共用「$ 上的能力」的,
   不是共用幾十行字串處理。兩份各自維護,比為了 DRY 把兩支綁在一起好。 */

export function outsideFences(lines: string[]): string[] {
  const out: string[] = []
  let inFence = false
  for (const line of lines) {
    if (line.startsWith('```')) {
      inFence = !inFence
      continue
    }
    if (!inFence) out.push(line)
  }
  return out
}

export function sections(lines: string[]): Array<{ title: string; body: string }> {
  const out: Array<{ title: string; body: string }> = []
  let cur: { title: string; body: string } | null = null

  for (const text of outsideFences(lines)) {
    if (text.startsWith('## ')) {
      if (cur !== null) out.push(cur)
      cur = { title: text.replace(/^##\s+/, '').trim(), body: '' }
    } else if (cur !== null && text.trim().length > 0) {
      cur.body += `${text.trim()}\n`
    }
  }
  if (cur !== null) out.push(cur)

  return out.filter(one => !SKIP_SECTIONS.has(one.title))
}

async function readLines($: EngineInterface, path: string): Promise<string[] | null> {
  try {
    return (await $.fs.read(path)).split('\n')
  } catch {
    return null
  }
}

async function articleDir($: EngineInterface): Promise<string | null> {
  const cwd = await $.session.cwd()
  const m = /^(.*\/story\/[^/]+)/.exec(cwd)
  return m === null ? null : m[1]
}

async function compare(
  $: EngineInterface,
  zh: string[],
  en: string[],
): Promise<string[]> {
  const a = sections(zh)
  const b = sections(en)

  if (a.length !== b.length) {
    return [`節數對不上:中 ${a.length} / 英 ${b.length}。先把骨架對齊再比內容。`]
  }

  const argv = model === '' ? ['lm', '-f', DRIFT_ASK] : ['lm', '-m', model, '-f', DRIFT_ASK]
  const out: string[] = []

  for (let i = 0; i < a.length; i += 1) {
    const body = [
      '中文:',
      a[i].body.slice(0, 2500),
      '',
      '英文:',
      b[i].body.slice(0, 2500),
    ].join('\n')

    const ran = await $.process.run(argv, { stdin: body, timeoutMs: 180000 })
    out.push(
      `${a[i].title}:${ran.exitCode === 0 ? ran.stdout.trim().replace(/\s+/g, ' ') : '地端模型沒回應'}`,
    )
  }

  return out
}

export const register: Register = (on, options) => {
  model = String(options.model ?? '')

  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'check-drift',
      description: '地端模型逐節比對中英兩版(慢,一到三分鐘)',
    })
    return next(e)
  })

  on('command.run', { command: 'check-drift' }, async $ => {
    const dir = await articleDir($)
    if (dir === null) {
      return { text: 'medium-drift:請在 story/<文章> 底下跑。' }
    }

    const zh = await readLines($, `${dir}/index.md`)
    const en = await readLines($, `${dir}/index-en.md`)
    if (zh === null || en === null) {
      return { text: `medium-drift:跳過,${zh === null ? '找不到 index.md' : '還沒有英文版'}。` }
    }

    const rows = await compare($, zh, en)
    return { text: ['地端逐節語意比對:', ...rows.map(r => `  ${r}`)].join('\n') }
  })
}
