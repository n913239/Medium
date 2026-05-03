---
name: convert-docx
description: 將 Markdown 轉為 Word (.docx)，自動修正表格框線與欄寬。支援指定檔案路徑或自動偵測當前目錄的 .md 檔案。
argument-hint: <md-file-path>
user-invocable: true
---

# Markdown 轉 Word（含表格框線修正）

## 執行步驟（照做）

收到 `$ARGUMENTS` 後，依序執行以下步驟：

### Step 1: 確認輸入檔

```bash
# $ARGUMENTS 為 md 檔案路徑（可為相對路徑或絕對路徑）
# 若為相對路徑，以當前工作目錄為基準
ls -la "$ARGUMENTS"
```

若檔案不存在，提示使用者並停止。

### Step 2: 決定輸出路徑

- 輸出放在 md 檔案同目錄下的 `word/` 子資料夾
- 檔名同 md，副檔名改 `.docx`
- 例：`SASD_參8_ControlM.md` → `word/SASD_參8_ControlM.docx`

```bash
# 建立 word/ 子資料夾（如不存在）
mkdir -p "$(dirname "$ARGUMENTS")/word"
```

### Step 3: pandoc 轉換

```bash
cd "$(dirname "$ARGUMENTS")"
pandoc "$(basename "$ARGUMENTS")" -o "word/$(basename "${ARGUMENTS%.md}.docx")" \
  --from markdown --to docx --resource-path=.
```

### Step 4: 修正表格框線

用 `~/.claude/skills/convert-docx/fix_tables.py` 修正表格框線與欄寬：

```bash
python3 ~/.claude/skills/convert-docx/fix_tables.py "word/$(basename "${ARGUMENTS%.md}.docx")"
```

### Step 5: 回報結果

```bash
ls -lh "word/$(basename "${ARGUMENTS%.md}.docx")"
```

輸出格式：
```
轉換完成
輸出：word/SASD_參8_ControlM.docx（XXkB）
表格修正：N 張表格已修正框線
```

---

## 前置條件

- `pandoc` 已安裝
- Python 套件 `python-docx` 已安裝（`pip3 install python-docx`）

## fix_tables.py

位於 `~/.claude/skills/convert-docx/fix_tables.py`，功能：
- 為所有表格加上黑色單線框線（top/bottom/left/right/insideH/insideV）
- 表格寬度設為 100%（pct 5000）、autofit
- 儲存格寬度設為 auto
- 儲存格加上獨立框線（確保合併儲存格也有框）
