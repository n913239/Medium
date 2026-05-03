---
name: gen-table-image
description: 從 Markdown 文章中的 HTML comment 提取表格，轉為 PNG 圖片。用於 Medium 文章中以圖片呈現表格。
argument-hint: <md-file-path> [table-name]
disable-model-invocation: true
user-invocable: true
---

# Markdown 表格轉 PNG 圖片

從指定的 .md 檔案中，自動找出所有以圖片方式引用的表格（`![table-xxx](table-xxx.png)` + HTML comment 中的 Markdown 表格），轉為與文章風格一致的 PNG 圖片。

## 前置條件

- `npx playwright` 可用（不需要額外安裝 npm 套件，用 npx 即可）
- Chromium 已透過 playwright 安裝

## 解析規則

掃描 .md 檔案，找出符合以下模式的區塊：

```
![some-table-name](some-table-name.png)
<!--
| 欄位A | 欄位B |
|---|---|
| 值1 | 值2 |
-->
```

每組配對代表一張要產生的表格圖片：
- 圖片檔名從 `![](xxx.png)` 取得
- 表格內容從緊接在後的 `<!-- ... -->` HTML comment 中取得
- comment 中如果包含非表格的文字（如 `Gemini prompt:`）則跳過該區塊

## 參數

- `$ARGUMENTS[0]`（必要）：.md 檔案路徑
- `$ARGUMENTS[1]`（可選）：只產生指定名稱的表格（例如 `table-comparison`），省略則產生全部

## HTML 表格樣式

使用以下固定樣式，確保每次產出的圖片風格一致：

```html
<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8">
<style>
html, body { margin: 0; padding: 0; background: #f5f5f5; }
.wrap { display: inline-block; padding: 20px; }
table { border-collapse: collapse; font-size: 15px; line-height: 1.6; background: #fff; }
th { background: #333; color: #fff; font-weight: 600; text-align: left; padding: 12px 20px; }
td { padding: 12px 20px; border-bottom: 1px solid #e0e0e0; color: #333; }
tr:last-child td { border-bottom: none; }
code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 13px; font-family: "SF Mono", Menlo, monospace; }
.c { text-align: center; }
</style></head><body>
<div class="wrap">TABLE_HTML</div>
</body></html>
```

## Markdown → HTML 轉換規則

將 Markdown 表格轉為 HTML 時：
1. 第一行（header row）→ `<tr><th>...</th></tr>`
2. 第二行（分隔線 `|---|---|`）→ 跳過，但解析對齊方式（`:---:` = 置中，加 `class="c"`）
3. 其餘行 → `<tr><td>...</td></tr>`
4. 儲存格內的 `` `code` `` → `<code>code</code>`
5. 儲存格內的 `**bold**` → `<b>bold</b>`
6. 保留 emoji 符號（✅ ❌ 等）

## 執行流程

1. 讀取指定的 .md 檔案
2. 用正則解析出所有 `![table-name](table-name.png)` + `<!-- markdown table -->` 配對
3. 如果有指定 `$ARGUMENTS[1]`，只處理符合名稱的表格
4. 對每張表格：
   a. 將 Markdown 表格轉為 HTML
   b. 套用固定樣式產生完整 HTML 檔案
   c. 寫入暫存 HTML 檔
   d. 用 `npx playwright screenshot --viewport-size 900,100 --full-page` 截圖
   e. 存為 PNG 到 .md 檔案的同目錄
   f. 刪除暫存 HTML
5. 輸出報告

## 輸出格式

```
📊 表格圖片產生報告

✅ table-comparison.png（4 列）
✅ table-scope.png（3 列）
✅ table-bundled.png（5 列）

總計：3 張圖片已產生
輸出目錄：/path/to/article/
```

## 範例

```bash
# 產生文章中所有表格圖片
/gen-table-image story/2026-04-12_claude-code-skills/index.md

# 只重新產生某一張
/gen-table-image story/2026-04-12_claude-code-skills/index.md table-comparison
```
