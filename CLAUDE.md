# CLAUDE.md — Medium 文章 repo

這個 repo 用來寫 Medium 技術文章,主力是 **Claude Code 中／英雙語系列**(每週一篇的節奏)。以下是寫作慣例、工具鏈與發布流程。

## 回應與工作慣例

- **用繁體中文回應**(user 偏好)。
- **一次 commit 只放一篇文章**;commit message 照系列格式(見既有 git log)。
- **commit message 不要加 `Co-Authored-By`(或任何 AI 署名 / 產生工具的 trailer)**——保持乾淨的系列格式。
- 工作檔／草稿可以先不進 git,等文章完成再由 user 自己 commit。

## 文章結構與慣例

- **位置**:`story/YYYY-MM-DD_<slug>/`,發布日當資料夾名前綴。系列文 slug 用 `claude-code-<topic>`。
- **雙語**:`index.md`(繁體中文)+ `index-en.md`(英文),兩版結構一一對應。
- **首行 Tags**:`<!-- Tags: A, B, C, D, E -->`(Medium 上限 5 個)。
- **封面與插圖**:引用 `![](cover.png)` 等,並在緊接的 `<!-- -->` 註解裡放 **Gemini 生圖 prompt**。畫風統一:吉卜力柔和粉彩(mint／peach／lavender)、白底、16:9。
- **表格以 PNG 呈現**(Medium 不吃 markdown 表格):
  ```
  ![table-xxx](table-xxx.png)
  <!--
  | 欄A | 欄B |
  |---|---|
  | 值 | 值 |
  -->
  ```
  markdown 表格原始碼放在圖片後的 HTML comment 裡,再產生風格一致的 PNG(見下方工具)。中英各一張(`table-xxx.png` / `table-xxx-en.png`)。
- **文章結構**:前言 → Part/時間段 → 總結 → 參考資料。
- **站內連結**用實際發布後的 Medium 文章網址(不要只連個人頁);連結文字要與目的地文章標題一致。
- **技術正確性**:涉及 Claude Code 的設定(hooks matcher、permissions、Shift+Tab 等)要與實際可運作版本一致——過去修過這類技術錯誤(見 git log `修正文章技術錯誤`)。

## 工具鏈(`tools/`)

- **`md-to-medium.html`** — 「Markdown to Medium Converter」。貼文時用它把 `index.md` 轉成 Medium 友善格式再貼上。
- **`skills/gen-table-image`** — 從 .md 裡「圖片引用 + 緊接 HTML comment 表格」的配對,產生與文章風格一致的 PNG。每篇資料夾裡的 `gen.sh` 就是同一套邏輯的在地版(playwright screenshot + ImageMagick trim)。
  - 表格圖風格:深色標題列(`#333`)+ 白底 + 淡灰分隔線;`code` 用等寬字。
- **`skills/convert-docx`** — Markdown → Word(.docx),自動修表格框線與欄寬。
- **`skills/clean-legacy`** + **`skills/clean-check`** — 清掉被註解掉的遺留碼／壓縮空行,並驗證 git diff 只動到註解。(偏程式碼清理,非寫作用。)

> 註:`tools/skills/` 是這些 skill 的備份存放處。`gen-table-image` 目前未列在啟用的 skill 清單中,所以實務上用各篇的 `gen.sh` 產表格圖;其餘(convert-docx、clean-*)為可直接呼叫的 skill。

## 發布流程

1. 在 `story/YYYY-MM-DD_<slug>/` 寫 `index.md` + `index-en.md`。
2. 依 HTML comment 裡的 Gemini prompt 生封面／插圖;跑 `gen.sh` 產表格 PNG(中英)。
3. 貼文前檢查:圖片檔齊全、code fence 平衡、外部連結有效、站內連結用實際網址。
4. 用 `tools/md-to-medium.html` 轉換後貼到 Medium(貼完掃一眼 code block／JSON 有沒有跑掉)。
5. 完成後一篇一個 commit。

## 記錄分工(哪些記在哪)

- **CLAUDE.md(這裡)**:穩定的 repo 慣例、工具鏈、發布流程 —— 版控、每次 session 自動載入。
- **演進中的專案狀態與個人偏好**:放在本機的自動記憶,**不寫進此 repo**(此 repo 為公開,避免外洩私有專案或個人資訊)。
