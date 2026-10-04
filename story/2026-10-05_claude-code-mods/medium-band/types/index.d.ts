export type CheckRow = {
  name: string
  ok: boolean
  detail: string
}

export type Report = {
  /** 文章資料夾名(story/ 底下) */
  slug: string
  rows: CheckRow[]
  /** 失敗項數,band 靠它決定顏色 */
  failed: number
}

declare module 'claude-code' {
  interface PluginState {
    'medium-band': { report: Report | null }
  }
}
