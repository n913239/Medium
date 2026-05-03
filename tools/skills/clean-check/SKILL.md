---
name: clean-check
description: 驗證 clean-legacy 執行結果 - 確認 git diff 只有刪除註解和空白行，沒有改到實際程式碼。Use after clean-legacy to verify changes are safe.
argument-hint: [file-path (optional)]
user-invocable: true
---

# 驗證清理結果

在執行 `clean-legacy` 後使用，檢查 git diff 確認：
- 只有刪除（沒有新增程式碼）
- 刪除的都是註解或空白行
- 沒有誤刪實際程式碼

## 執行流程

1. 執行 `git diff` 取得變更（若有指定檔案 `$ARGUMENTS` 則只檢查該檔案）
2. 解析 diff 輸出，找出所有被刪除的行（以 `-` 開頭，但非 `---`）
3. 對每個刪除行進行分類判斷
4. 輸出檢查報告

## 判斷規則

### 安全的刪除（✅）

```regex
# 空行或只有空白
^-\s*$

# 單行註解
^-\s*//.*$

# 多行註解
^-\s*/\*.*$
^-\s*\*.*$
^-\s*\*/.*$
```

### 可疑的刪除（⚠️ 需人工確認）

不符合上述安全規則的任何刪除行，可能是：
- 實際程式碼被誤刪
- 有意義的程式邏輯

## 輸出格式

### 全部安全時：
```
✅ 檢查通過

📊 變更統計：
  - 刪除註解：23 行
  - 刪除空白：15 行
  - 總計：38 行安全刪除

結論：所有刪除都是註解或空白，沒有影響程式碼功能。
```

### 有可疑刪除時：
```
⚠️ 發現可疑刪除，請人工確認

📊 變更統計：
  - 刪除註解：20 行 ✅
  - 刪除空白：10 行 ✅
  - 可疑刪除：3 行 ⚠️

⚠️ 可疑刪除詳情：
  檔案：MyClass.swift
    Line 45: `let value = 123`
    Line 78: `if condition {`

  檔案：Helper.swift
    Line 12: `return result`

請確認這些行是否應該被刪除。
```

### 有新增程式碼時：
```
❌ 檢查失敗：發現新增的程式碼

本工具只驗證「純刪除」的變更。
如果你有手動修改程式碼，請自行 review。

新增的行數：5 行
```

## 範例指令

```bash
# 檢查所有變更
/clean-check

# 只檢查特定檔案
/clean-check Sources/MyClass.swift
```
