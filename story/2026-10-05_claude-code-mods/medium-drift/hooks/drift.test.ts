import { expect, test } from 'claude-code/testing'

import { sections } from './register'

const doc = [
  '# 標題',
  '前言一句',
  '',
  '## 第一節',
  '內容 A',
  '```ts',
  'const code = 1   // 這行不該進 body',
  '```',
  '還有內容 B',
  '',
  '## 參考資料',
  '- [連結](https://example.com)',
].join('\n').split('\n')

test('切出 H2 區塊,code block 不進 body', async () => {
  const got = sections(doc)

  expect(got.length).toBe(1)
  expect(got[0].title).toBe('第一節')
  expect(got[0].body).toContain('內容 A')
  expect(got[0].body).toContain('還有內容 B')
  expect(got[0].body).not.toContain('const code')
})

test('參考資料整節跳過:連結本來就中英各指各的', async () => {
  expect(sections(doc).map(s => s.title)).not.toContain('參考資料')
  expect(sections(['## References', 'a'].join('\n').split('\n')).length).toBe(0)
})

test('H2 之前的前言不算任何一節', async () => {
  expect(sections(doc)[0].body).not.toContain('前言一句')
})
