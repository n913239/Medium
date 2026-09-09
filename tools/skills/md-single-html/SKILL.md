---
name: md-single-html
description: 將 Markdown 文章轉為單一自帶圖片的 HTML 檔（圖片 base64 內嵌），方便傳給別人看。支援指定 md 路徑或自動偵測當前目錄的 index.md。
argument-hint: <md-file-path>
user-invocable: true
---

# Markdown 轉單一 HTML（圖片內嵌）

把一份 `.md` 轉成一個 **self-contained** 的 `.html`：所有本地圖片以 base64 內嵌，
成品是**單一檔案**，不需附帶任何圖片檔，直接傳給別人或用瀏覽器開即可。

## 執行步驟（照做）

### Step 1: 確認輸入檔

```bash
# $ARGUMENTS 為 md 檔路徑；若省略，預設當前目錄的 index.md
MD="${ARGUMENTS:-index.md}"
ls -la "$MD"
```

若檔案不存在，提示使用者並停止。

### Step 2: 轉換

```bash
python3 ~/.claude/skills/md-single-html/md_to_single_html.py "$MD"
```

- 輸出到 md 同目錄的**同名 `.html`**（例：`index.md` → `index.html`）。
- 要指定輸出路徑：`python3 …/md_to_single_html.py "$MD" /path/to/out.html`

### Step 3: 回報結果

腳本會印出輸出路徑與檔案大小，例如：

```
輸出: /path/to/index.html (12.19 MB)
```

一併提醒使用者：封面等大圖會讓檔案偏大（base64 內嵌），屬正常。

---

## 直接當 shell 指令用（不透過 skill 也行）

腳本本身可獨立執行，不依賴任何第三方套件（純標準庫）：

```bash
python3 ~/.claude/skills/md-single-html/md_to_single_html.py index.md
# 或（已設為可執行）
~/.claude/skills/md-single-html/md_to_single_html.py index.md
```

## 這個 repo 專屬的處理

依本 repo 的寫作慣例，轉換時會自動略過：

- 首行 `<!-- Tags: ... -->` 與**所有 HTML 註解**（表格原始碼、Gemini 生圖 prompt 都在註解裡）
- 作者 placeholder 註記 `*(在這裡插入圖片：xxx.png)*` 這類行

表格是以 PNG 圖片呈現的（`![table-xxx](table-xxx.png)`），所以會被正常內嵌；
藏在圖片後 HTML 註解裡的 markdown 表格原始碼則被略過，兩者不衝突。

外部 `http(s)` 圖片會保留原網址、不下載內嵌。

## 支援的 Markdown 語法

標題、段落、`**粗體**`、`*斜體*`、`` `行內碼` ``、`[連結](url)`、
` ``` ` code fence、`>` 引言、`-`/`*` 清單（含一層縮排巢狀）、`---` 分隔線、圖片。
（針對本系列文章夠用；非通用 Markdown 引擎。）

## 產出樣式

仿 Medium 閱讀版型：720px 置中、粉彩中性色、支援深色模式（`prefers-color-scheme`）、
手機 RWD、圖片圓角。樣式全部 inline 在 `<head>`，成品零外部相依。
