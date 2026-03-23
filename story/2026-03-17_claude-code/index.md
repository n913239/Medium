# 工程師的 AI 加速器 — Claude Code 實戰應用分享

> 用了之後回不去的開發體驗

---

## 前言

身為一名開發者，每天都在跟程式碼打交道，Debug、寫功能、Review PR、寫文件... 這些事情佔了工作中大部分的時間。

前陣子開始用 Claude Code 之後，發現它跟一般的 AI 聊天工具不太一樣。它是跑在 terminal 裡面的，可以直接讀你的 codebase、跑指令、改檔案，等於是真的在你的專案裡面工作，不是在那邊隔空抓藥。

用了一段時間之後，整理了幾個我覺得最實用的場景，跟大家分享一下。

---

## 查業務邏輯與 Debug

接手不熟悉的模組，大概是工程師最常遇到的事了。不知道從哪裡開始看、不確定改下去會影響到哪裡，相信大家都有經驗。

用 Claude Code 的話，直接用白話跟它說就好：

```
「幫我找到使用者登入的驗證邏輯在哪裡」
「這個 API 從 controller 到 service 到 repository 的流程是什麼？」
「如果我改了 UserService.updateProfile()，哪些地方會受影響？」
```

它會去掃你的 codebase，幫你定位到對應的檔案跟函式，還可以追呼叫鏈，整個流程幫你理出來。

Debug 也是類似的用法，直接把 error log 貼給它，它會分析根本原因，列出幾個可能的排查方向，還會按可能性排序。

這邊有個小撇步：**不要只丟 error message，最好讓它也讀到相關的原始碼**，分析會準確很多。

---

## 需求開發 — 這個我覺得最重要

大家應該都有經驗，需求描述很模糊，結果做出來的東西跟 PM 想的不一樣，來回修改很浪費時間。

Claude Code 可以根據你給的 Spec 直接產出程式碼，而且會遵循你專案既有的 coding style。

**但是，關鍵來了：Spec 越完整，產出品質越高。**

這真的是最重要的一點。你給它越詳細的規格，它產出的東西就越接近你要的。Spec 應該包含：

- 輸入 / 輸出格式
- 邊界條件與錯誤處理
- 商業邏輯規則

不要只跟它說「幫我做一個上傳功能」，而是要說清楚：

```
「需求：使用者可以上傳大頭照，格式限 jpg/png，大小限 5MB，
 要有壓縮處理，存到 S3，更新 user profile」
```

規格越詳細越好，這樣產出的程式碼才會包含主要邏輯、錯誤處理，甚至測試都幫你寫好。

---

## CLAUDE.md — 讓 AI 記住你的專案規範

這個功能我覺得很實用。CLAUDE.md 是放在專案根目錄的設定檔，Claude Code 每次啟動都會讀取，等於是幫它設定「專案規則」。

可以放什麼進去：

- 專案架構說明（哪個資料夾放什麼）
- Coding style 規範（命名慣例、縮排）
- 常用指令（怎麼跑測試、怎麼 build）
- 禁止事項（不要用某個 library、不要改某個檔案）
- commit message 格式、branch 命名規則

簡單範例：

```markdown
# CLAUDE.md

## 專案結構
- src/controllers/ — API 入口
- src/services/ — 商業邏輯
- src/repositories/ — 資料存取

## 規範
- 使用 TypeScript strict mode
- API response 統一用 ResponseWrapper
- 不要使用 any 型別

## 常用指令
- 跑測試：npm run test
- 本地啟動：npm run dev
```

團隊共用同一份 CLAUDE.md 的話，每個人用 Claude Code 產出的東西就會比較一致，這個蠻重要的。

---

## Code Review 與 Git 操作

PR 太大的時候，Review 很耗時，容易漏看一些潛在問題。

直接跟 Claude Code 說「幫我 review 目前的 git diff」，它會分析改動，檢查邏輯正確性、效能問題、安全風險、邊界條件處理等等。如果 PR 比較大，建議分模組 review，效果更好。

Git 操作也很方便，像是：

```
「幫我 commit 目前的改動」
「幫我建立 PR，目標 branch 是 develop」
```

它會分析 staged changes 自動產出有意義的 commit message，PR description 也會包含改動摘要。以前最懶得寫的 commit message 跟 PR 描述，現在都不用自己煩了。

---

## 架構規劃 — Plan Mode 先想再做

架構調整影響範圍大，不敢輕易動手，應該很多人都有這個困擾。

Claude Code 有一個 **Plan Mode**，切換方式是 `Shift + Tab`，它會先幫你分析、規劃，你確認方案之後才開始動手。

流程大概是：

1. 分析現有程式碼
2. 提出規劃方案，列出具體步驟
3. 你確認方案後，才開始實作
4. 逐步執行，每步都可以 review

適合的場景包括：模組拆分、導入 Design Pattern、API 版本升級、DB schema 調整。這些大型改動，一定要先用 Plan Mode 看看方案再動手，可以省下很多白做工的時間。

---

## 寫文件 — 工程師的救星

工程師最不愛做的事之一大概就是寫文件了吧（不知道大家有沒有同感 XD）。

Claude Code 可以幫你快速產出結構化的 Markdown 文件，而且還可以轉成 Word 或 PowerPoint。

工作流程：

1. 先請 Claude Code 產出 `.md` 檔
2. Review 內容，調整到滿意
3. 再請它轉成 `.docx` 或 `.pptx`

其實這次公司分享用的簡報，就是用 Claude Code 產出的。先產出 Markdown 內容，review 之後再轉成 pptx，算是一個蠻順的流程。

---

## 實用技巧速查

最後整理一些常用的操作，給大家參考：

- `claude` — 啟動 Claude Code
- `/compact` — 壓縮對話，釋放 context window
- `/clear` — 清除對話，重新開始
- `Shift + Tab` — 切換 Plan Mode / Act Mode
- `Esc` — 中斷目前操作
- `claude -p "指令"` — headless 模式，適合腳本整合

還有幾個提高效率的習慣：

- **先給 context 再問問題** — 告訴它你在做什麼、改了什麼
- **用具體的 prompt** — 「修好這個 bug」不如「UserService 第 42 行的 NPE 怎麼修」
- **善用 Plan Mode** — 不確定怎麼做的時候，先讓它規劃
- **分段處理大任務** — 一次做太多容易出錯，拆成小步驟
- **定期 /compact** — 對話太長會影響品質，適時壓縮

---

## 總結

用了一段時間後，整理出五個關鍵心法：

- **輸入品質決定輸出品質** — Spec 越完整、問題越具體，結果越好
- **先規劃再動手** — 大型任務用 Plan Mode，避免白做工
- **善用 CLAUDE.md** — 定義專案規範，確保產出一致性
- **迭代修正** — 第一次不完美很正常，逐步調整
- **人還是要 Review** — AI 是加速引擎，人還是要掌握方向盤

一句話總結的話：**Claude Code 就是一個 AI-Powered Development Accelerator。**

它不會取代工程師，但它可以讓你把時間花在更有價值的事情上。

感謝讀者們的閱讀，如果有任何問題或是使用心得，歡迎留言一起討論。
