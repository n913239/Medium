<!-- Tags: Claude Code, CI, GitHub Actions, Developer Tools, Testing -->

*(在這裡插入封面圖：cover.png)*
![](cover.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration. A chibi engineer character watches a small robot (representing the workflow tooling) being checked by a friendly inspector robot holding a green checkmark clipboard. A conveyor belt with small "test" gears runs beneath them. Soft pastel colors (mint, peach, lavender), white background, clean and simple. 16:9 ratio.
-->

# 幫「工作流」本身寫測試 — 用 CI 守住你的 Claude Code 設定

> 你為 Claude Code 搭了 hook、agents、commands。但這些設定本身會不會壞?誰來守?

---

## 前言

上一篇〈從 Demo 到 Production〉裡,我把一整天用來產出功能的那套設定——先規劃的 Plan Mode、先寫測試的 `test-writer`、唯讀審查的 `code-reviewer`、`/precommit` 把關、外加一個 commit 前自動掃 staged diff 的 pre-commit hook——抽成一個可重用的種子庫,讓「先規劃、先測試、先審查、先把關」變成新專案的預設結構。

抽出來的那一刻,我卻冒出一個不太舒服的念頭:**這個 hook 是一段 shell script,它自己也是程式碼——程式碼就會壞。**

改一行 grep、動一個 exit code、`settings.json` 手滑多一個逗號,這整套「守門」的機制就可能默默失效,而你渾然不覺,照樣每天叫它幫你把關。我平常會叫 `test-writer` 在動 App 的程式碼之前先寫測試;這一篇,我把同一套紀律轉過來對準**工具自己**——先幫 hook 寫測試、再掛上 CI,讓「守門員」本身也一直被守著。

---

## Part 1:為什麼「工作流」也需要被測

設定檔給人的錯覺是「寫一次就永遠對」。但只要它是程式碼,就會 regression,而且是那種**不會報錯、只會靜默失效**的 regression:

- **exit code 手滑**:hook 靠 `exit 2` 擋下 commit、`exit 0` 放行。哪天把攔截區塊的 `exit 2` 改成 `exit 0`,它就從「擋下」變成「放行」——功能還在、指令還跑、什麼錯都不報,只是再也擋不住任何東西。
- **`settings.json` 多一個逗號**:JSON 少一個引號、多一個尾逗號,整個設定檔解析失敗,hook **完全不會被掛上**。不是「掛上但沒作用」,是根本沒載入,而你以為它一直在。
- **grep pattern 打錯**:少一個跳脫、多一個空白,某一類該擋的東西(比方 `NSLog`)就悄悄漏過去。
- **matcher 寫錯**:把 PreToolUse 的 `matcher` 寫成 `"Bash(git commit*)"`——它其實只比對**工具名稱**(`Bash`),指令層級的判斷要在腳本裡做;寫成前者,hook 要嘛不觸發、要嘛觸發時機全錯。

這些都不是假想。我把第一個場景實際做給你看:在種子庫裡,把 `precommit-guard.sh` 攔截區塊那行 `exit 2` 改成 `exit 0`,其他一個字都不動,然後跑一次 hook 的測試——

*(在這裡插入圖片：ci-regression.png)*
![ci-regression](ci-regression.png)
<!-- 由 gen.sh 產生:左=改壞前 6/6 綠燈,右=exit 2 改成 exit 0 後,三個「該擋」的 case 變紅 -->

左邊是改壞前:6 個行為測試全過,CI 綠燈。右邊是把 `exit 2` 改成 `exit 0` 之後:三個「該擋」的 case 立刻紅了——因為它們預期 hook 回傳 `exit 2`,實際卻拿到 `0`。測試回傳非 0,CI 直接變紅。

這就是重點:**那行手滑如果沒有測試,你永遠不會發現**。App 照 commit、hook 照跑、綠色小勾照亮,只是它其實什麼都沒擋。有了這組測試,那行改動連 push 都 push 不過去。

---

## Part 2:幫 hook 寫行為測試

hook 有個很順手的性質:它是「讀 stdin 的 JSON → 掃 staged diff → 用 exit code 表態」的純函式,不需要真的跑一次 `git commit`,也不需要 Claude 在場。所以測試可以非常直接——**在一個暫存 git repo 裡 stage 一個檔、餵它一段模擬的 hook JSON、驗它吐出來的 exit code**。

`tests/test-precommit-guard.sh` 的核心就是這個 `run_case`:

```bash
# run_case <名稱> <預期exit> <staged內容> <指令JSON>
run_case() {
  local name="$1" expected="$2" content="$3" json="$4"
  local tmp code
  tmp="$(mktemp -d)"
  git -C "$tmp" init -q
  git -C "$tmp" config user.email t@example.com
  git -C "$tmp" config user.name test
  if [ -n "$content" ]; then
    printf '%s\n' "$content" > "$tmp/file.swift"
    git -C "$tmp" add file.swift
  fi
  CLAUDE_PROJECT_DIR="$tmp" bash -c 'echo "$1" | "$2"' _ "$json" "$GUARD" >/dev/null 2>&1
  code=$?
  rm -rf "$tmp"
  [ "$code" -eq "$expected" ] && echo "  ✓ $name (exit $code)" \
    || echo "  ✗ $name — 預期 exit $expected,實際 $code"
}
```

有了它,六個情境就是六行宣告——把「這個輸入應該得到這個 exit code」寫成一句話:

```bash
COMMIT='{"tool_input":{"command":"git commit -m x"}}'
NONCOMMIT='{"tool_input":{"command":"ls -la"}}'

run_case "有 print 的 commit 應被擋"          2 'func f() { print("x") }'                                 "$COMMIT"
run_case "有 hardcode token 的 commit 應被擋" 2 'let apiKey = "sk_live_0123456789abcdef0123456789abcdef"' "$COMMIT"
run_case "有 TODO 的 commit 應被擋"           2 '// TODO: remove'                                          "$COMMIT"
run_case "乾淨的 commit 應放行"               0 'func g() { let x = 1; _ = x }'                            "$COMMIT"
run_case "沒有 staged 檔的 commit 應放行"     0 ''                                                        "$COMMIT"
run_case "非 commit 指令一律放行"             0 'func f() { print("x") }'                                 "$NONCOMMIT"
```

三個「該擋」、三個「該放行」——涵蓋了 hook 的兩種責任:**抓到髒東西要擋(exit 2)、不該管的一律別擋(exit 0)**。最後那個 case 特別重要:同樣一段有 `print` 的髒 code,只要指令不是 `git commit`(這裡是 `ls -la`),就必須放行——不然 hook 會攔下每一個 Bash 指令,Claude 什麼都做不了。

一個小地方藏著功力:測試 harness 開頭用的是 `set -uo pipefail`,而**不是** `set -euo pipefail`。少了 `-e`,是為了讓某個 case 失敗時不要立刻中斷整輪——我要看到「6 個裡面掛了哪幾個」,而不是撞到第一個紅燈就停。反過來,hook 本體用的是完整的 `set -euo pipefail`,因為它一旦出錯就該乾脆地失敗。

跑起來全過長這樣:

*(在這裡插入圖片：ci-summary.png)*
![ci-summary](ci-summary.png)
<!--
| CI 檢查（每次 push / PR） | 結果 |
|---|---|
| `settings.json` 合法性（jq） | ✓ 通過 |
| `shellcheck` 靜態檢查 | ✓ 通過 |
| `precommit-guard` 行為測試 | ✓ 6 / 6 通過 |
-->

---

## Part 3:用 GitHub Actions 自動守住

本機能跑測試很好,但「記得跑」這件事本身就不可靠。真正的守法是讓它在每次 push / PR 自動跑。`.github/workflows/ci.yml` 全部只有這樣:

```yaml
name: CI

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate settings.json is valid JSON
        run: jq empty .claude/settings.json

      - name: ShellCheck
        run: shellcheck scripts/precommit-guard.sh tests/test-precommit-guard.sh

      - name: Run precommit-guard tests
        run: bash tests/test-precommit-guard.sh
```

三關,對應 Part 1 講的三種壞法:

1. **`jq empty` 驗 `settings.json`**——直接守住「多一個逗號就整個沒載入」那條。設定檔只要不是合法 JSON,這一關就紅,根本輪不到 hook 靜默失效。
2. **`shellcheck` 靜態檢查**——抓 shell 的老問題。最典型的是沒加引號的變數:`$added` 遇到含空白或 `*` 的內容會被 word-split 或展開成檔名,行為就跑掉;shellcheck 會直接點你哪一行該補引號。這種錯在本機常常「剛好沒踩到」,上了別人的機器才爆。
3. **`bash tests/test-precommit-guard.sh`**——就是 Part 2 那六個行為測試,每次 push 重跑一遍。

值得一提的是這裡用 **Ubuntu runner、完全不碰 Xcode**。因為我們守的是「工具本身」,不是 iOS App——它跟沉重的 App build 是解耦的,所以能在最便宜、最快的環境跑。

---

## Part 4:CI 綠燈長這樣

講了半天,不如看真的。這不是示意圖,是這個種子庫真的在 GitHub Actions 上跑出來的:

*(在這裡插入圖片：ci-proof.png)*
![ci-proof](ci-proof.png)
<!-- GitHub Actions 實際綠燈截圖 -->

注意右下角那個數字:**9 秒**。三關全過、一次 push 九秒收工。

對照一下:真 iOS App 的 CI 要 macOS runner、要 Xcode、要開模擬器,一輪動輒好幾分鐘,免費額度還特別燒。而這套守工具的 CI 之所以能「9 秒、Ubuntu、公開 repo 免費」,正是因為它守的東西夠純——純 shell、純 JSON,沒有一行需要編譯。**守工具的成本,本來就該遠低於守產品。** 便宜到這種程度,你就沒有藉口不掛。

---

## Part 5:手動測試 vs 自動測試

那是不是所有東西都塞進 CI 就好?不是。這套種子庫裡有六個元件,它們天生分成兩類——這條界線,才是這篇最想講的:

*(在這裡插入圖片：table-testable.png)*
![table-testable](table-testable.png)
<!--
| 工作流元件 | 本質 | 怎麼守 |
|---|---|---|
| `precommit-guard.sh` | 純 shell、決定性 | ✓ CI 行為測試 |
| `settings.json` | 靜態設定 | ✓ CI（jq 驗） |
| `test-writer` / `code-reviewer` | 要 LLM 判斷 | 人工測 |
| `/precommit`、`/pr-description` | 要 LLM 判斷 | 人工測 |
-->

`precommit-guard.sh` 和 `settings.json` 是**決定性**的:同樣的輸入永遠得到同樣的輸出,所以能寫成斷言、交給 CI 反覆守。

但 `test-writer`、`code-reviewer`、`/precommit`、`/pr-description` 不一樣——它們的產出要**LLM 在場才有意義**。你沒辦法對「code-reviewer 有沒有抓到 retain cycle」寫一個 `assertEqual`,因為它每次的措辭、切入點都會變。這些只能人工測:故意寫一個 closure 捕獲 `self` 沒加 `[weak self]`,再叫 `code-reviewer` 審,看它抓不抓得到、標不標成 Critical。

所以分工是這樣一句話:**決定性的部分交給 CI 持續守,需要判斷的部分交給人當下驗。** 把兩者搞混——想幫 agent 寫單元測試、或反過來以為 hook「手動測過一次就永遠沒事」——只會兩頭落空。認清哪些能自動、哪些只能手動,你才知道 CI 的邊界該畫在哪。

---

## 總結

我們花很多力氣幫 AI 搭結構:hook 把關、agent 分工、command 收斂流程。但這篇想補上的是——**你為 AI 搭的結構,本身也是程式碼,也值得被結構守住。**

具體就三步,而且都很便宜:幫決定性的部分(hook、設定)寫行為測試、掛一條 Ubuntu 上九秒跑完的 CI、把需要判斷的部分(agents、commands)留給人工測。守門員自己也一直被守著,你才敢真的放手讓這套流程每天自動跑——因為你知道,哪天有人手滑把 `exit 2` 改成 `exit 0`,它連 push 都過不了。

*(在這裡插入圖片：ci-regression.png)*
![ci-regression](ci-regression.png)
<!-- 呼應開頭:Part 4 的綠燈之所以敢放手,是因為這道紅色安全網一直在。綠→紅→綠 的收尾。 -->

Part 4 那張九秒綠燈很好看,但真正讓你敢放手的,是它背後這道紅網——一有東西壞掉就亮起來。工具鏈越可靠,你越敢把手放開。

而「放手」還能再往前一步:你甚至不必自己開 GitHub 盯 CI——Claude Code 能直接驅動 `gh`,用 `gh run list` 看這次 push 紅還綠、`gh run view` 把失敗那關的 log 抓來讀。於是整條守護鏈接了起來:你改一行 → hook 把關 → CI 守 hook → Claude 替你看 CI 的結果。連「去看結果」這一步都能交出去——這條「讓 AI 顧 CI」的路,我留到下一篇細講。

---

## 參考資料

- [Claude Code Hooks 官方文件](https://code.claude.com/docs/en/hooks) — 本文 hook 的行為依據:PreToolUse 以 exit 2 擋下工具呼叫、把 stderr 回饋給 Claude、matcher 比對的是工具名稱。
- [GitHub Actions 官方文件](https://docs.github.com/actions)
- [ShellCheck](https://www.shellcheck.net/) — CI 第二關用的 shell 靜態檢查工具。
- [jq](https://jqlang.org/) — CI 第一關用來驗 `settings.json` 是不是合法 JSON。
- claude-code-workflow — 我把整套工作流設定(hook、agents、commands、權限)抽成的可重用種子庫,並在其上掛了本文的 CI。
- 系列前篇:[從 Demo 到 Production — 我用 Claude Code 產出一個功能的一天](https://medium.com/@n913239/%E5%BE%9E-demo-%E5%88%B0-production-%E6%88%91%E7%94%A8-claude-code-%E7%94%A2%E5%87%BA%E4%B8%80%E5%80%8B%E5%8A%9F%E8%83%BD%E7%9A%84%E4%B8%80%E5%A4%A9-e609d74729a0)——手動串起同一條流程的一天實錄
