import { expect, test } from 'claude-code/testing'

const DIR = '/repo/story/2026-10-05_demo'
const ZH = `${DIR}/index.md`
const EN = `${DIR}/index-en.md`

const zhGood = [
  '<!-- Tags: A, B -->',
  '# 標題',
  '*(在這裡插入封面圖:cover.png)*',
  '![](cover.png)',
  '---',
  '## 一節',
  '---',
  '## 總結',
  '---',
  '## 參考資料',
].join('\n')

const enGood = [
  '<!-- Tags: A, B -->',
  '# Title',
  '*(Insert cover image here: cover.png)*',
  '![](cover.png)',
  '---',
  '## One',
  '---',
  '## Summary',
  '---',
  '## References',
].join('\n')

/** 把檔案系統接起來,攔 state.set 取出 mod 算完的那份報告 */
async function reportAfterWrite(
  $: Parameters<Parameters<typeof test>[1]>[0],
  on: Parameters<Parameters<typeof test>[1]>[1],
  files: Record<string, string>,
) {
  let captured: any = null
  let version = 0

  on('session.cwd', () => ({ value: DIR }))
  on('fs.read', (_$, e) => {
    const text = files[String((e as { path?: unknown }).path ?? '')]
    return text === undefined ? { deny: 'ENOENT' } : { value: text }
  })
  on('state.set', (_$, e) => {
    captured = (e as { value?: unknown }).value
    version += 1
    return { value: { version } }
  })
  on('tool.call', () => ({ result: 'written' }))

  await $.tool.call({ tool: 'Write', file_path: ZH, content: 'x' })
  return captured
}

test('中英齊全且合規時,全部通過', async ($, on) => {
  const got = await reportAfterWrite($, on, { [ZH]: zhGood, [EN]: enGood })

  expect(got?.slug).toBe('2026-10-05_demo')
  expect(got?.failed).toBe(0)
})

test('英文版缺一個 H2,parity 會抓到', async ($, on) => {
  const enShort = enGood.replace('## One\n', '')
  const got = await reportAfterWrite($, on, { [ZH]: zhGood, [EN]: enShort })

  const parity = got?.rows.find(r => r.name === 'parity-h2')
  expect(parity?.ok).toBe(false)
  expect(parity?.detail).toBe('中 3 / 英 2')
})

test('圖片數和提示行數對不上會抓到', async ($, on) => {
  const zhBad = zhGood.replace('*(在這裡插入封面圖:cover.png)*\n', '')
  const got = await reportAfterWrite($, on, { [ZH]: zhBad, [EN]: enGood })

  const row = got?.rows.find(r => r.name === 'image-markers[zh]')
  expect(row?.ok).toBe(false)
  expect(row?.detail).toContain('圖 1 張 vs 提示行 0 行')
})

test('全形標點會抓到,但 code block 裡的不算', async ($, on) => {
  const zhFull = zhGood.replace(
    '## 一節',
    '## 一節\n\n這行有全形\uFF0C括號\uFF08像這樣\uFF09\n\n```\n程式碼裡的\uFF0C不算\n```',
  )
  const got = await reportAfterWrite($, on, { [ZH]: zhFull, [EN]: enGood })

  const row = got?.rows.find(r => r.name === 'fullwidth[zh]')
  expect(row?.ok).toBe(false)
  expect(row?.detail).toContain('1 行')
})

test('收尾標題錯了會抓到', async ($, on) => {
  const zhWrong = zhGood.replace('## 總結', '## 結語')
  const got = await reportAfterWrite($, on, { [ZH]: zhWrong, [EN]: enGood })

  expect(got?.rows.find(r => r.name === 'closing[zh]')?.ok).toBe(false)
})

test('還沒有英文版時明講,不是靜靜跳過', async ($, on) => {
  const got = await reportAfterWrite($, on, { [ZH]: zhGood })

  expect(got?.rows.find(r => r.name === 'index-en.md')?.ok).toBe(false)
})

// 註:session.start 是引擎事件,測試套件沒有辦法主動發它
// ($.classic.* 只發舊式 settings hook 事件),所以「存進 state 的是 Report
// 不是 Promise」這條只能在實機驗。render 端的 Array.isArray 守衛就是為此而加。

test('少一條 --- 會抓到', async ($, on) => {
  const zhMissing = zhGood.replace('---\n## 總結', '## 總結')
  const got = await reportAfterWrite($, on, { [ZH]: zhMissing, [EN]: enGood })

  const row = got?.rows.find((r: any) => r.name === 'rules[zh]')
  expect(row?.ok).toBe(false)
  expect(row?.detail).toContain('總結')
})

test('code block 裡的 --- 不算,文章正文示範水平線不會誤判', async ($, on) => {
  const zhFake = zhGood.replace('## 一節', '## 一節\n\n```\n--- stdout ---\n---\n```')
  const got = await reportAfterWrite($, on, { [ZH]: zhFake, [EN]: enGood })

  expect(got?.rows.find((r: any) => r.name === 'rules[zh]')?.ok).toBe(true)
})

test('別處多用水平線不算錯,只要每個 H2 前面都有', async ($, on) => {
  const zhExtra = zhGood.replace('## 一節', '## 一節\n\n中間一段\n\n---\n\n再一段')
  const got = await reportAfterWrite($, on, { [ZH]: zhExtra, [EN]: enGood })

  expect(got?.rows.find((r: any) => r.name === 'rules[zh]')?.ok).toBe(true)
})
