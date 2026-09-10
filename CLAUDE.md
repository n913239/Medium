# CLAUDE.md — Medium 文章 repo

這個 repo 用來寫 Medium 技術文章,主力是 **Claude Code 中／英雙語系列**(每週一篇的節奏)。以下是寫作慣例、工具鏈與發布流程。

## 回應與工作慣例

- **用繁體中文回應**(user 偏好)。
- **作者身分一律是 `n913239 <n913239@gmail.com>`**(git commit 作者、Medium 帳號皆同;Medium 個人頁 `https://medium.com/@n913239`)。目前吃全域 git 設定,值已正確,commit 時不必另外指定;若哪天發現 commit 作者跑掉,用這組值修正。
- **一次 commit 只放一篇文章**;commit message 照系列格式(見既有 git log)。
- **commit message 不要加 `Co-Authored-By`(或任何 AI 署名 / 產生工具的 trailer)**——保持乾淨的系列格式。
- 工作檔／草稿可以先不進 git,等文章完成再由 user 自己 commit。

## 路徑慣例

- **測試／參考用的外部專案一律放 `../Github/`**(本 repo 的姊妹目錄,**不在版控內**)。要 clone 別人的 repo 來跑 graphify、寫文章實測、或單純研讀原始碼,都放這裡,不要 clone 進 `Medium/` 以免污染文章 repo。
  - 已在裡面的:`containerization/`(apple/containerization,2026-07-27 clone,HEAD `74ace148`)。
  - 寫文章引用時記得記下 **commit SHA**,讀者才能重現同樣結果。
- **鐵人賽工作區在 `../ithome-2026/`**(private repo,與本 repo 平行,2026-09-09 從原本的 `iThome/` 搬出)。30 篇草稿、體例規範、建置排程、團隊規劃、實測腳本與圖片都在那裡。
  - 🔒 **永遠不要改成 public** —— history 裡有未發表的 30 篇草稿,以及隊友本名(89 處,散在 6 份規劃文件)。GitHub 一按 public,整段 history 跟著公開,不可逆。
  - 本 repo `.gitignore` 的 `iThome/` 那行**留著**,防止哪天又在 `Medium/` 底下長出一個。
  - 實作專案 `event-signup` 是**另一個 public repo**(讀者要能 clone),不放進 `ithome-2026`。
- **題目備存放 `backlog/`**:研究過但還沒排程的題目,一個題目一個 `.md`,格式見 `backlog/README.md`(是什麼／為什麼值得寫／可寫角度／風險／建議排程 + **查證當下日期與數據**)。決定要寫時再搬進 `story/YYYY-MM-DD_<slug>/`。

## 文章結構與慣例

- **位置**:`story/YYYY-MM-DD_<slug>/`,發布日當資料夾名前綴。系列文 slug 用 `claude-code-<topic>`。
- **雙語**:`index.md`(繁體中文)+ `index-en.md`(英文),兩版結構一一對應。
- **首行 Tags**:`<!-- Tags: A, B, C, D, E -->`(Medium 上限 5 個)。
- **封面與插圖**:引用 `![](cover.png)` 等,並在緊接的 `<!-- -->` 註解裡放 **Gemini 生圖 prompt**。畫風統一:吉卜力柔和粉彩(mint／peach／lavender)、白底、16:9。
- **每張圖前面都要有「插入圖片」提示行**(貼到 Medium 時提醒自己該放哪張圖,貼完再刪):
  ```
  *(在這裡插入封面圖:cover.png)*      ← 封面
  ![](cover.png)

  *(在這裡插入圖片:table-xxx.png)*     ← 其餘所有圖(插圖、表格圖)
  ![table-xxx](table-xxx.png)
  ```
  英文版用 `*(Insert cover image here: cover.png)*` / `*(Insert image here: table-xxx-en.png)*`,且檔名要指向英文版的圖。**中英兩版、每一張圖都要有,別漏。**
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
- **結尾段落標題固定**:收束段中文用 `## 總結`、英文用 `## Summary`;參考資料段中文用 `## 參考資料`、英文用 `## References`。(過去英文曾漂移成 Conclusion / Wrapping Up / Closing、中文冒出「結語」,現已統一。)
- **站內連結**用實際發布後的 Medium 文章網址(不要只連個人頁);連結文字要與目的地文章標題一致。
  - 網址格式:`https://medium.com/@n913239/<slug>-<12碼hex>`。slug 規則:小寫、空格與標點(含 `—`、`「」`)轉單一連字號、中文逐字 percent-encode。**Medium 靠結尾 hex ID 解析**,所以只要 ID 對就一定導得到——user 給 ID 即可組出網址。
  - **只在「首次提及」與參考資料段加連結**;行文中反覆出現的「上一篇…」不必每句都連,重複連很吵。
- **標點**:中文版用**半形**逗號、括號、冒號(`,` `(` `)` `:`),不用全形(`，（）：`)。系列近期已統一。
- **技術正確性**:涉及 Claude Code 的設定(hooks matcher、permissions、Shift+Tab 等)要與實際可運作版本一致——過去修過這類技術錯誤(見 git log `修正文章技術錯誤`)。

## 去識別化(寫到真實專案時必做)

文章常拿 user 的**商業 iOS 專案**當案例,此 repo 公開,所以:

- **業務相關的類別名一律換成 stand-in**,且**跨篇要一致**(讀者要認得出是同一個東西)。已用過的對照:god node = `RecordDetailViewController`、其餘 `RequestCreateViewController` / `AssetManagementViewController` / `RecordReviewViewController` / `RequestListViewController`;抽出的 validator = `RecordValidator`。
- **通用框架/骨架名保持原樣**:`NSObject`、`BaseViewController`、`AppCoordinator`、`LoginViewController`、UIKit delegate 等。
- **連 code snippet 裡的變數/元件名也要換**(容易漏!):例如 `fooButton`/`barQty` 這種會透露產業(醫療/用藥)的,要改成 `optionButton`/`itemQty`。
- **數字(行數、邊數、節點數)保留真實值**——那是度量,不具識別性,也是文章可信度來源。
- **圖片同樣要處理**:截圖裁掉會顯示真實名稱的面板;表格 PNG 記得**改完 `gen.sh` 要重新產圖**(PNG 是讀者唯一看得到的,漏改就等於沒去識別化)。
- 文章裡放一段**去識別化聲明**(參考 0807 的寫法:哪些換了、哪些沒換、數字是真的)。

## 術語

- 知識圖的 **community** 中文用「**群集**」,不要用「社群」(會被讀成社交社群)。搭配「分群演算法」一起用。
  - 例外:真的在講社交媒體時(如「像社群網站上同學自成一團」)才用「社群」。

## 工具鏈(`tools/`)

- **`md-to-medium.html`** — 「Markdown to Medium Converter」。貼文時用它把 `index.md` 轉成 Medium 友善格式再貼上。
- **`skills/gen-table-image`** — 從 .md 裡「圖片引用 + 緊接 HTML comment 表格」的配對,產生與文章風格一致的 PNG。每篇資料夾裡的 `gen.sh` 就是同一套邏輯的在地版(playwright screenshot + ImageMagick trim)。
  - 表格圖風格:深色標題列(`#333`)+ 白底 + 淡灰分隔線;`code` 用等寬字。
- **`skills/convert-docx`** — Markdown → Word(.docx),自動修表格框線與欄寬。
- **`skills/md-single-html`** — 把 `index.md` 轉成**單一自帶圖片的 HTML**(圖片 base64 內嵌),方便傳給別人看。純標準庫、無第三方相依;沿用本 repo 慣例自動略過 Tags／表格原始碼／Gemini prompt 等 HTML 註解與 `*(在這裡插入圖片…)*` placeholder。可 `/md-single-html` 呼叫,或直接 `python3 ~/.claude/skills/md-single-html/md_to_single_html.py index.md`。使用教學見該資料夾的 `README.md`。
  **對外公開版在 [Gist `7ae7d88c`](https://gist.github.com/n913239/7ae7d88cfbc51d5540201891bb1ff6f4)**(鐵人賽 Day 5 的 `curl` 指向它)—— 這支腳本共三份(`~/.claude/skills/`、本 repo、Gist),**改動要三邊同步**,漂移了不會有東西提醒你。
- **`skills/clean-legacy`** + **`skills/clean-check`** — 清掉被註解掉的遺留碼／壓縮空行,並驗證 git diff 只動到註解。(偏程式碼清理,非寫作用。)

> 註:`tools/skills/` 是這些 skill 的備份存放處。`gen-table-image` 目前未列在啟用的 skill 清單中,所以實務上用各篇的 `gen.sh` 產表格圖;其餘(convert-docx、clean-*)為可直接呼叫的 skill。

## 發布流程

1. 在 `story/YYYY-MM-DD_<slug>/` 寫 `index.md` + `index-en.md`。
2. 依 HTML comment 裡的 Gemini prompt 生封面／插圖;跑 `gen.sh` 產表格 PNG(中英)。
3. **貼文前檢查(逐項跑過)**:
   - 圖檔齊全:每個 `![](x.png)` 引用的檔案都存在;英文版指向 `-en` 版本的圖
   - **圖片數 == 「插入圖片」提示行數**(中英各自檢查)
   - code fence 平衡(偶數)、H2 章節數**中英相同**、Tags ≤ 5
   - 收尾標題正確(總結/參考資料、Summary/References)
   - 殘留 `TODO`／`待補`／`(Medium 網址)` 佔位符 = 0
   - 去識別化:真實類名、業務用語、真實路徑、公司名皆為 0(**含表格 PNG 內的文字**)
   - 站內連結用實際網址且中英各自指向對應語言版;外部連結有效
   - 中文版無全形標點
4. 用 `tools/md-to-medium.html` 轉換後貼到 Medium(貼完掃一眼 code block／JSON 有沒有跑掉;**刪掉 `*(在這裡插入圖片…)*` 提示行**)。
   - **按下發布前先設好 custom URL**:三點選單 → More settings → Advanced settings → 勾 Custom,英文版填英文 slug。
     **發布後就永遠改不了了**(改標題也不會更新 slug),唯一的補救是刪掉重貼,而那會換掉 hex ID——所有既有連結與統計一起消失。
   - **貼完立刻點進去確認語言版本正確**(掃一眼標題與第一段);中英兩篇分開貼,最容易貼錯的就是這一步。
   - 文章若曾刪掉重發,**hex ID 會變**,記得回頭更新所有引用它的文章。
5. 完成後**一篇一個 commit**(見上方 commit 慣例:無 AI 署名 trailer)。
6. **發文工作檔不進 git**:重構草稿、`OUTLINE.md`、`QA.md` 等寫作過程產物在完成後刪掉或留在 repo 外——尤其含真實類名的草稿(有隱私風險)。

## 記錄分工(哪些記在哪)

- **CLAUDE.md(這裡)**:穩定的 repo 慣例、工具鏈、發布流程 —— 版控、每次 session 自動載入。
- **演進中的專案狀態與個人偏好**:放在本機的自動記憶,**不寫進此 repo**(此 repo 為公開,避免外洩私有專案或個人資訊)。
