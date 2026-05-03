---
name: clean-legacy
description: 清理遺留碼 - 刪除被註解掉的程式碼（非一般註解）並壓縮多餘空行。Use when user wants to clean up commented-out legacy code or reduce excessive blank lines.
argument-hint: [file-path or directory]
user-invocable: true
---

# 清理遺留碼

當用戶要求清理程式碼時，執行以下兩項任務：

## 1. 刪除被註解掉的程式碼（保留一般註解）

**判斷標準** - 符合以下特徵的是「被註解掉的程式碼」，應刪除：

### Swift/Objective-C 模式（正則）
```regex
^\s*//\s*(let|var|func|class|struct|enum|protocol|extension|import|@|if|else|for|while|switch|guard|return|try|await|self\.|super\.|case|break|continue|throw|catch|do\s*\{|private|public|internal|fileprivate|open|static|lazy|override|mutating|async|weak|unowned)\b.*$
```

```regex
# 只有「不含中文」且「含程式符號」的註解才刪除
# 含中文的註解即使有 (){}[];= 也保留（除非被夾在註解程式碼中間）
^\s*//\s*(?!.*[\u4e00-\u9fff]).*[\(\)\{\}\[\];=].*$
```

**中文註解保護：**
- `// 呼叫 doSomething() 方法` → ✅ 保留（含中文）
- `// doSomething()` → 刪除（純程式碼）
- `// 設定 value = 10` → ✅ 保留（含中文）
- `// value = 10` → 刪除（純程式碼）

### 多行註解中的程式碼
```regex
/\*[\s\S]*?(let|var|func|class|return|if|for)[\s\S]*?\*/
```

**保留的一般註解特徵：**
- `// MARK:`, `// TODO:`, `// FIXME:`, `// NOTE:`
- 說明性文字（中英文句子）
- 文件註解 `///` 或 `/** */`
- **檔案標頭註解**（檔案開頭的版權/作者資訊區塊）

**檔案標頭註解保護：**

檔案最開頭連續的註解區塊視為「檔案標頭」，必須完整保留。判斷方式：
1. 從檔案第 1 行開始
2. 連續的 `//` 註解行（包含空的 `//`）都屬於標頭
3. 遇到第一個非註解行（空行或程式碼）時，標頭區塊結束

```swift
// 這些都是標頭，全部保留：
//
//  MyClass.swift
//  ProjectName
//
//  Created by Author on 2024/1/1.
//  Copyright © 2024 Company. All rights reserved.
//
                          ← 第一個空行，標頭結束
import Foundation         ← 程式碼開始
```

即使標頭中含有看起來像程式碼的內容（如 `//  MyClass.swift`），也不刪除。

**例外：夾在註解程式碼區塊中的說明註解**

如果一個說明性註解的「上一行」和「下一行」都是被註解掉的程式碼，則該說明註解也應刪除（包含中文註解）。

原因：該註解是在解釋被註解掉的程式碼，刪除程式碼後它會變成孤立且無意義的註解。

```swift
// 刪除前：
//        actionTitle = action.actionTitle       ← 註解程式碼
//        // add new event                       ← 說明註解，但夾在中間 → 刪除
//        // 設定新的事件                          ← 中文說明，但夾在中間 → 一樣刪除
//        confirmBtn.removeTarget(...)           ← 註解程式碼

// 刪除後：（整個區塊都移除）
```

## 2. MARK 註解緊貼程式碼

移除 `// MARK:` 註解與下一行程式碼之間的空行（包含只有空白字元的行）。

**正則：**
```regex
查找: (// MARK:.*)\n([ \t]*\n)+
替換: $1\n
```

說明：
- `[ \t]*\n` 匹配空行或只含空白字元的行
- `([ \t]*\n)+` 匹配一行或多行這樣的空行
- 替換為 `$1\n` 讓 MARK 直接接下一行程式碼

## 3. 壓縮多餘空行

**正則：** 將連續 2 行以上的空行壓縮為 1 行
```regex
查找: \n{3,}
替換: \n\n
```

## 執行流程

### 單一檔案模式
當 `$ARGUMENTS` 是單一檔案時：
1. 讀取指定檔案
2. **識別檔案標頭區塊**（從第 1 行開始的連續註解），標記為保護區域
3. 識別並標記要刪除的註解程式碼行（跳過標頭區塊）
4. 執行刪除
4. 移除 MARK 註解後的空行（緊貼程式碼）
5. 壓縮多餘空行
6. 顯示變更摘要（刪除了幾行註解程式碼、壓縮了幾處空行）
7. 使用 Edit 工具套用變更

### 目錄/多檔案模式（並行處理）
當 `$ARGUMENTS` 是目錄或包含多個子目錄時，**必須使用並行 Sonnet agents** 加速處理：

1. 掃描目錄，列出所有子目錄
2. **使用 Task tool 並行啟動多個 Sonnet agents**，每個處理一個子目錄：
   ```
   Task tool 參數：
   - subagent_type: "general-purpose"
   - model: "sonnet"  ← 使用較低成本的模型
   - prompt: 包含完整清理規則 + 目標目錄路徑
   ```
3. 等待所有 agents 完成
4. 彙整結果報告

**重要**：
- 每個 Task 呼叫處理一個子目錄
- 在單一訊息中發送多個 Task 呼叫以實現真正的並行
- Sonnet 模型足以處理此類模式匹配任務，且成本較低

### 範例：並行處理多個目錄
```
用戶輸入: /clean-legacy Sources/

執行方式:
1. 掃描 Sources/ 發現子目錄: Models/, Views/, Controllers/
2. 同時啟動 3 個 Sonnet agents:
   - Agent 1: 處理 Sources/Models/
   - Agent 2: 處理 Sources/Views/
   - Agent 3: 處理 Sources/Controllers/
3. 彙整報告
```

## 範例

**刪除前：**
```swift
//
//  MyClass.swift
//  MyProject
//
//  Created by Author on 2024/1/1.
//  Copyright © 2024 Company. All rights reserved.
//

import Foundation

class MyClass {
    // 這是說明註解，保留

    // MARK: - Lifecycle

    func doSomething() {
        // let oldValue = 123
        // // 設定初始值              ← 夾在註解程式碼中的說明，一起刪除
        // if condition {
        //     print("test")
        // }
        let newValue = 456



        print(newValue)
    }
}
```

**刪除後：**
```swift
//
//  MyClass.swift
//  MyProject
//
//  Created by Author on 2024/1/1.
//  Copyright © 2024 Company. All rights reserved.
//

import Foundation

class MyClass {
    // 這是說明註解，保留

    // MARK: - Lifecycle
    func doSomething() {
        let newValue = 456

        print(newValue)
    }
}
```
