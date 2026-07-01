# Claude Code 工作流設定指南（可重用）

> 這是〈從 Demo 到 Production — 我用 Claude Code 產出一個功能的一天〉的附錄。
> 文章講「為什麼、怎麼串」；這份文件是「照著做」——把整套設定複製進任何 iOS 專案就能用。
>
> 已在 WAS 專案（CocoaPods，scheme `WAS`，測試 target `WASTests`，共用模組 `WALibrary`）實測，hook 攔截行為驗證通過。

---

## 檔案總覽

全部放在 **git repo 根目錄**（Claude Code 以 repo 根為 project root）：

| 檔案 | 用途 | 對應文章環節 |
|---|---|---|
| `.claude/settings.json` | 權限 + 掛載 hook | 權限設定 |
| `.claude/agents/test-writer.md` | 先寫測試的 agent | 10:00 實作 |
| `.claude/agents/code-reviewer.md` | 唯讀審查 agent | 14:00 審查 |
| `.claude/commands/precommit.md` | `/precommit` 提交前檢查 | 16:30 把關 |
| `.claude/commands/pr-description.md` | `/pr-description` 生 PR 描述 | 17:00 收尾 |
| `scripts/precommit-guard.sh` | commit 前自動掃 staged diff 的 hook | 16:30 把關 |

---

## 1. `.claude/settings.json`

權限與 hook 的核心。`allow` 放行不需確認的工具，`ask` 強制 `git commit`/`push` 每次都要人確認。hook 的 `matcher` 是**工具名稱** `Bash`（不是指令內容——那是 `permissions` 的語法），實際判斷交給腳本。

```json
{
  "permissions": {
    "allow": [
      "Bash(xcodebuild:*)",
      "Bash(xcrun simctl:*)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(git status:*)",
      "Read",
      "Edit",
      "Glob",
      "Grep"
    ],
    "ask": [
      "Bash(git commit:*)",
      "Bash(git push:*)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR/scripts/precommit-guard.sh\""
          }
        ]
      }
    ]
  }
}
```

> ⚠️ 常見錯誤：把 hook 的 `matcher` 寫成 `"Bash(git commit*)"`。hook 的 matcher 只比對工具名稱，指令層級的過濾要在腳本裡做（見下方 `precommit-guard.sh` 讀 stdin 的部分）。

---

## 2. `.claude/agents/test-writer.md`

```markdown
---
name: test-writer
description: 根據需求或計畫，為 WAS 專案撰寫 XCTest 測試，遵循 WASTests 既有慣例。先寫失敗的測試，再讓實作通過。
tools: Read, Glob, Grep, Edit, Bash
---

你是 WAS 這個 iOS 專案的測試工程師。你的職責是「先寫測試」——在實作之前，把需求翻譯成會失敗的測試，讓實作有明確的目標。

## 專案背景

- App target：`WAS`（CocoaPods，`WAS.xcworkspace`，scheme `WAS`）
- 測試 target：`WASTests`
- 共用模組：`WALibrary`（SwiftPM）
- 架構：Coordinator + ViewController，網路層走 Alamofire，本地儲存用 RealmSwift

## 測試慣例（務必遵守，跟現有檔案一致）

1. 檔頭：`import XCTest` + `@testable import WAS`（需要時 `import WALibrary`）
2. 類別：`class XxxTests: XCTestCase`，被測物件一律命名 `var sut: Xxx!`
3. 生命週期用 `setUpWithError()` / `tearDownWithError()`，在 tearDown 把 `sut` 和相依物件設回 `nil`
4. 測試方法命名：`test_情境_預期結果`
   - 例：`test_startWithNotLogin_pushesViewController`、`test_indexCell_rendersWithTitleAndSubtitle`
5. 三段式結構（Arrange → Act → Assert），段落之間空一行
6. **network 一律 mock，絕不打真 API**。沿用 `WASTests/TestDouble/` 下既有的 Mock；需要新 Mock 時放進 `TestDouble/` 並比照命名 `XxxMock.swift`
7. UI 呈現類的測試，優先沿用 `XCTestCase+Snapshot.swift` 的 snapshot 機制

## 工作流程

1. 讀過相關的既有測試（先 `Glob WASTests/**/*Tests.swift` 挑範本）與被測程式碼
2. 依需求列出要覆蓋的情境（正常 + 邊界 + 錯誤路徑）
3. 先寫「會失敗」的測試
4. 執行 `xcodebuild -workspace WAS/WAS.xcworkspace -scheme WAS -destination 'platform=iOS Simulator,name=iPhone 16' test` 確認 RED
5. 回報：新增哪些測試、覆蓋什麼、目前紅燈狀態

## 不要做的事

- 不要為了讓測試通過而修改被測程式碼的邏輯
- 不要寫「一定會過」的空測試充數
- 不要引入新的測試框架或第三方套件
```

---

## 3. `.claude/agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: 以嚴格的資深 iOS 工程師視角審查 WAS 專案的改動，只讀不寫。重點抓記憶體、執行緒、Realm、Coordinator 生命週期與慣例一致性。
tools: Read, Glob, Grep, Bash
---

你是 WAS 專案的資深 iOS code reviewer。你**只讀不寫**——你的產出是一份分級的問題清單，不是修改後的程式碼。

## 審查範圍

預設審查目前的改動：先跑 `git diff` 或 `git diff --cached`，需要時再讀完整檔案理解上下文。

## 重點檢查項目（依這個順序）

1. **記憶體 / retain cycle**
   - closure（completion handler、Alamofire callback、Coordinator 的 finishDelegate）捕獲 `self` 有沒有 `[weak self]`
   - Coordinator 的 `childCoordinators` 有沒有在子流程結束時被正確移除
   - delegate 屬性該不該是 `weak`
2. **執行緒**
   - UI 更新是否都在 main thread（網路 callback 回來後直接改 UI 是常見錯誤）
   - RealmSwift：Realm instance/Object 不可跨執行緒傳遞；write 是否包在 `try realm.write { }`
3. **業務邏輯判斷**（linter 抓不到、最有價值）
   - 錯誤處理是否合理（例如不可重試的操作卻沿用了通用 retry）
   - 邊界條件、nil 處理、狀態轉換有沒有漏
4. **安全**
   - 有沒有 hardcode 的 token / api key / 密碼 / 測試帳號
   - 敏感資料有沒有印到 log
5. **慣例一致性**
   - 命名、檔案位置、分層有沒有跟專案既有風格一致
   - 有沒有留下 `print(`、`// TODO`、被註解掉的舊 code

## 輸出格式

依嚴重度分級，每項給「檔案:行號 + 問題 + 建議修法」：

- 🔴 **Critical**（會 crash、記憶體洩漏、資料錯誤、安全）— 必須修才能合併
- 🟡 **Warning**（潛在風險、慣例不一致）— 建議修
- 🔵 **Nit**（風格、可讀性）— 可選

若沒有 Critical，明確說「沒有阻擋性問題」。找不到問題就說乾淨，不要湊數。
```

---

## 4. `.claude/commands/precommit.md`

```markdown
在提交前，幫我對目前 staged 的改動做一次完整檢查。

步驟：
1. 執行 `git diff --cached` 取得 staged 的改動
2. 逐項確認：
   - 有沒有遺留的 debug 用 `print(` / `debugPrint(` / `NSLog(`？
   - 有沒有 hardcode 的 API key、token、密碼、測試帳號？
   - 有沒有被註解掉的舊 code 或 `// TODO` / `// FIXME` 忘了處理？
   - closure 捕獲 self 有沒有漏 `[weak self]`（retain cycle）？
   - 新增的邏輯有沒有對應的 WASTests 測試覆蓋主要路徑與錯誤路徑？
3. 列出需要修正的項目（附 檔案:行號）；如果都沒問題，回覆「可以 commit」。

只做檢查與回報，不要直接修改或執行 commit。
```

---

## 5. `.claude/commands/pr-description.md`

```markdown
根據目前 branch 相對於主線的 commits，產生一份 PR 描述。

步驟：
1. 找出主線（依序嘗試 `main`、`master`、`develop`，用第一個存在的）
2. 執行 `git log <主線>..HEAD --oneline` 取得本 branch 的 commits
3. 需要時用 `git diff <主線>...HEAD --stat` 了解改動範圍
4. 依下列模板輸出（繁體中文）：

## 動機 / 背景
（這個 PR 想解決什麼問題或需求）

## 改了什麼
- （條列主要改動，依模組或功能分組）

## 怎麼測
- （reviewer 可以怎麼驗證：跑哪些測試、手動測哪些流程）

## 備註
（相依、風險、後續待辦；沒有就寫「無」）

只產生描述文字，不要真的開 PR 或 push。
```

---

## 6. `scripts/precommit-guard.sh`

hook 腳本。掛在 `Bash` 工具上，每個 Bash 指令前觸發，自己判斷是不是 `git commit`；是的話才掃 staged diff，發現問題以 **exit code 2** 擋下並把原因回饋給 Claude。

```bash
#!/bin/bash
#
# precommit-guard.sh — Claude Code PreToolUse hook
#
# 當 Claude 準備執行 `git commit` 時，掃描 staged 的改動，
# 若發現殘留的 debug 輸出、被註解掉的 TODO、或疑似 hardcode 的密鑰，
# 就以 exit code 2 擋下 commit。其他 Bash 指令一律放行（exit 0）。

set -euo pipefail

# 1) 讀取 hook 的 stdin（JSON），取出這次要執行的指令
payload="$(cat)"
command="$(printf '%s' "$payload" | jq -r '.tool_input.command // ""')"

# 2) 只攔 git commit，其餘放行
case "$command" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

# 3) 取得 staged 的「新增行」（只看 + 開頭、排除 diff 標頭的 +++）
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 1
added="$(git diff --cached --unified=0 -- '*.swift' \
  | grep -E '^\+' | grep -vE '^\+\+\+' || true)"

[ -z "$added" ] && exit 0

problems=""
flag() { problems="${problems}  - $1\n"; }

# 4) 各項檢查（針對新增行）
echo "$added" | grep -qE '\b(print|debugPrint|NSLog)\s*\(' \
  && flag "殘留 debug 輸出（print / debugPrint / NSLog）"

echo "$added" | grep -qE '//\s*(TODO|FIXME)' \
  && flag "未處理的 TODO / FIXME 註解"

echo "$added" | grep -qiE '(api[_-]?key|token|password|passwd|secret)\s*[:=]\s*"[^"]+"' \
  && flag "疑似 hardcode 的密鑰 / 密碼"
echo "$added" | grep -qE '"[A-Za-z0-9+/]{32,}={0,2}"' \
  && flag "疑似 hardcode 的長字串密鑰（32 字元以上）"

# 5) 有問題就擋下
if [ -n "$problems" ]; then
  {
    echo "🛑 precommit-guard 攔截了這次 commit，staged 改動裡有問題："
    printf "%b" "$problems"
    echo "請先處理上述項目，或確認無誤後再提交。"
  } >&2
  exit 2
fi

exit 0
```

需求：系統要有 `jq`（macOS 內建 `/usr/bin/jq`）。

---

## 安裝步驟

```bash
# 1. 把 .claude/ 和 scripts/ 複製進你的 repo 根目錄
# 2. 讓 hook 可執行
chmod +x scripts/precommit-guard.sh
# 3. 重開一個 Claude Code session，讓 settings.json 生效
```

## 驗證 hook 是否運作

```bash
export CLAUDE_PROJECT_DIR="$(git rev-parse --show-toplevel)"

# 造一個含殘留 print 的暫存檔並 stage
printf 'func f() {\n    print("debug")\n}\n' > _t.swift && git add _t.swift

# 模擬 hook 收到 git commit
echo '{"tool_input":{"command":"git commit -m x"}}' | ./scripts/precommit-guard.sh
echo "exit code = $?"   # 預期 2（被擋下）

# 清理
git reset -q _t.swift && rm -f _t.swift
```

---

## 套用到不同專案要改什麼

| 位置 | WAS 專案的值 | 換專案時改成 |
|---|---|---|
| test-writer 的建置指令 | `xcodebuild -workspace WAS/WAS.xcworkspace -scheme WAS ...` | 你的 workspace / scheme |
| test-writer 的測試慣例 | `test_情境_預期`、`sut`、`TestDouble/` | 你專案的命名與 mock 慣例 |
| settings.json 的 `allow` | `Bash(xcodebuild:*)` | 純 SwiftPM 專案可換成 `Bash(swift build:*)` / `Bash(swift test:*)` |
| code-reviewer 的檢查項 | Realm、Coordinator、Alamofire | 你專案實際用的框架與架構 |
| precommit-guard 的掃描副檔名 | `'*.swift'` | 其他語言改對應副檔名 |

hook 腳本本身是語言無關的（純 grep staged diff），大多可直接沿用；agent 內容則建議依專案的框架與慣例微調。
