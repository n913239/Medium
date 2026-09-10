# md-single-html — 使用教學

把一篇 `.md`（例如文章的 `index.md`）轉成**一個單一的 `.html` 檔**：
文章裡引用的所有本地圖片都會被 base64 內嵌進去，成品**不需附帶任何圖片檔**，
直接雙擊用瀏覽器開、或整個檔案傳給朋友都行。

> 為什麼要這個：Medium 草稿是 `index.md` + 一堆 `.png`。要給非工程師的朋友預覽時，
> 傳一包資料夾很麻煩，這個工具把它壓成「一個檔」。

---

## 前置條件

- 只需要 **Python 3**（macOS 內建即可，本工具純標準庫，**不用 `pip install` 任何東西**）。
- 圖片檔要跟 `.md` 在**同一個資料夾**（本 repo 的文章都是這樣擺）。

---

## 三種用法（擇一）

### 1. 直接跑腳本（最單純）

在文章資料夾裡：

```bash
python3 ~/.claude/skills/md-single-html/md_to_single_html.py index.md
```

腳本已設為可執行，也可以省略 `python3`：

```bash
~/.claude/skills/md-single-html/md_to_single_html.py index.md
```

想指定輸出檔名／路徑，加第二個參數：

```bash
python3 ~/.claude/skills/md-single-html/md_to_single_html.py index.md ~/Desktop/給朋友看.html
```

### 2. 當 Claude Code skill 呼叫

在對話裡輸入：

```
/md-single-html index.md
```

省略參數會自動抓當前目錄的 `index.md`：

```
/md-single-html
```

### 3. 用 Claude 白話請它做

「幫我把這篇 index.md 轉成單一 HTML」——Claude 會走這個 skill。

---

## 輸出

- 預設輸出到 **`.md` 同目錄的同名 `.html`**（`index.md` → `index.html`）。
- 終端會印出路徑與大小，例如：
  ```
  輸出: index.html (12.19 MB)
  ```
- 檔案偏大是正常的：封面等大圖 base64 內嵌後會膨脹約 1.33 倍。
  8 MB 的封面就佔掉大半——**這是「單檔自帶圖片」的必然代價**，不是壞掉。

---

## 它會自動略過的東西（本 repo 慣例）

轉換時這些不會出現在成品裡：

| 原文 | 處理 |
|---|---|
| 首行 `<!-- Tags: A, B, C -->` | 略過 |
| 圖片後 HTML 註解裡的表格 markdown 原始碼 | 略過（表格本身是 PNG，會正常內嵌） |
| `<!-- Gemini prompt: … -->` 生圖提示 | 略過 |
| `*(在這裡插入圖片：xxx.png)*` 作者備註行 | 略過 |
| 外部 `http(s)` 圖片 | **保留原網址**，不下載內嵌 |

---

## 支援的 Markdown 語法

標題、段落、`**粗體**`、`*斜體*`、`` `行內碼` ``、`[連結](url)`、
```` ``` ```` code fence、`>` 引言、`-`/`*` 清單（含一層縮排巢狀）、`---` 分隔線、圖片。

> 這是為本系列文章量身寫的**輕量轉換器**，不是通用 Markdown 引擎。
> 表格請沿用 repo 慣例用 PNG 呈現（見 `gen.sh` / `gen-table-image`），別直接寫 markdown 表格。

---

## 產出長相

仿 Medium 閱讀版型：720px 置中、粉彩中性色、圖片圓角、手機 RWD、支援深色模式
（跟隨系統 `prefers-color-scheme`）。所有 CSS 都 inline 在 `<head>`，成品零外部相依。

---

## 檔案位置

| 路徑 | 說明 |
|---|---|
| `~/.claude/skills/md-single-html/` | 啟用位置，`/md-single-html` 從這裡跑 |
| `tools/skills/md-single-html/` | repo 內備份（跟 `convert-docx` 同模式） |
| [Gist `7ae7d88c`](https://gist.github.com/n913239/7ae7d88cfbc51d5540201891bb1ff6f4) | 對外公開的那份，鐵人賽 Day 5 的 `curl` 指向它 |

改動腳本時**三個地方都要更新**（`~/.claude/skills/…` 是實際執行的那份，
Gist 用 `gh gist edit 7ae7d88cfbc51d5540201891bb1ff6f4 -f md_to_single_html.py` 推上去）。

> ⚠️ 三份來源會漂移，而漂移的時候不會有任何東西提醒你 ——
> 這正是 Day 5 那篇在講的事。改完記得三邊 `diff` 一次。
