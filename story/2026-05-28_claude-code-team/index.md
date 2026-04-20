<!-- Tags: Claude Code, Team Collaboration, Developer Tools, AI Adoption, Software Development -->

*(在這裡插入封面圖：cover.png)*
![cover](cover.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration. Five chibi engineer characters sit around a round table, each with a laptop. In the center of the table, a glowing holographic Claude logo floats above a shared document. The characters are pointing at each other's screens and smiling, clearly collaborating. One whiteboard in the background shows a simple checklist. Soft pastel colors (mint, peach, lavender), white background, clean and simple. 16:9 ratio.
-->

# 團隊導入 — 讓整個團隊開始信任 Claude Code

> 個人用順了不代表團隊會順。導入的難點不在工具，在信任和共識。

---

## 前言

這個系列前幾篇講的都是個人使用：怎麼設定 CLAUDE.md、怎麼用 Hooks 自動化、怎麼整合 MCP、怎麼讓 Claude 參與 Git 流程。

但實際工作的場景是團隊，不是一個人。

一個人用得很順，不代表整個團隊都能順起來。團隊導入面對的問題是不同的：有人不信任 AI 生成的程式碼，有人擔心每個人用法不同導致風格不一致，有人覺得 Claude 會取代自己。

這篇是這個系列的最後一篇，講怎麼把 Claude Code 從個人工具變成團隊標準。

---

## Part 1：個人使用 vs 團隊使用

*(在這裡插入圖片：gap.png)*
![gap](gap.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration. On the left, one chibi engineer sits alone at a desk with a glowing laptop, looking happy and productive. On the right, five chibi engineers sit separately at desks, each with different colored screens showing different outputs — slightly chaotic. In the middle, a small bridge labeled "CLAUDE.md" connects the two sides. Soft pastel colors (mint, peach, lavender), white background, clean and simple. 16:9 ratio.
-->

個人用 Claude Code，只要對自己有用就算成功。

團隊使用的標準更高：

- **一致性**：不同人叫 Claude 做同一件事，結果要夠接近
- **可信任**：團隊成員能 review AI 生成的程式碼，知道怎麼判斷好壞
- **可維護**：Claude 的設定（CLAUDE.md、Hooks）要有人維護，不能只有一個人懂

這三個條件，靠一份好的 CLAUDE.md 加上明確的 review 流程，大部分都能解決。

---

## Part 2：分階段導入

*(在這裡插入圖片：table-rollout-phases.png)*
![table-rollout-phases](table-rollout-phases.png)
<!--
| 階段 | 做什麼 | 目標 |
|------|--------|------|
| 試用期（1–2 週） | 1–2 人先跑，記錄有效和無效的用法 | 找出適合這個專案的使用模式 |
| 共識期（1–2 週） | 把有效的用法寫進 CLAUDE.md，開會對齊 | 建立團隊共同的基準 |
| 全員期（持續） | 全團隊使用，定期回顧 CLAUDE.md | 維持一致性，持續改善 |
-->

### 試用期：先讓 1–2 個人跑

不要一開始就全員推。讓對 AI 工具比較有興趣的人先試用 1–2 週，記錄：

- 哪些任務 Claude 表現好（寫測試、重構、解釋程式碼）
- 哪些任務 Claude 容易出錯（複雜業務邏輯、對外部系統高度依賴的程式碼）
- 用什麼樣的 prompt 效果最好

這些觀察是後續 CLAUDE.md 的素材。

### 共識期：把有效用法寫進 CLAUDE.md

試用一輪後，把結論整理成團隊版 CLAUDE.md：

```markdown
# 團隊 Claude Code 設定

## 適合讓 Claude 做的事
- 寫單元測試
- 重構現有程式碼
- 解釋不熟悉的程式碼區塊
- 產生 commit message 和 PR description

## 需要人工確認的事
- 牽涉到 API 合約的改動
- 資料庫 migration
- 權限和安全相關邏輯

## Commit message 格式
Conventional Commits：feat / fix / refactor / test / docs
```

把這份文件開一次短會，讓所有人理解並討論。不是宣布規定，是建立共識。

### 全員期：使用、觀察、調整

全員開始用之後，每兩週回顧一次 CLAUDE.md：

- 有沒有新的有效用法值得加進去？
- 有沒有規則已經不適用了？
- 有沒有人踩到新的坑？

CLAUDE.md 不是一次寫完的規格書，是持續演進的團隊記憶。

---

## Part 3：建立 Code Review 標準

*(在這裡插入圖片：review.png)*
![review](review.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration. Two chibi engineer characters sit side by side at a desk. One holds a magnifying glass inspecting a glowing code scroll. The scroll has small icons floating around it: a shield (security), a gear (logic), a bug with an X. The other character takes notes on a clipboard. They look focused but calm. Soft pastel colors (mint, peach, lavender), white background, clean and simple. 16:9 ratio.
-->

AI 生成的程式碼需要 review，這一點和人寫的程式碼一樣——只是關注點略有不同。

### Review 的關注點

**邏輯正確性**
Claude 理解你的描述，但不一定理解你的業務背景。確認邏輯符合實際需求，不只是「看起來對」。

**邊界條件**
Claude 處理主線流程通常沒問題，但邊界條件（空值、超出範圍、並發）容易被跳過。特別留意。

**安全性**
涉及使用者輸入、API token、資料庫操作的程式碼，要和審查一般程式碼一樣仔細。

**測試覆蓋**
Claude 寫的測試有時只覆蓋 happy path。確認是否有對應的 edge case 測試。

### 不用每行都細看

AI 生成的程式碼不需要比人寫的程式碼更嚴格地 review，也不需要更寬鬆。用同樣的標準即可。

差別在於：當你不確定某段邏輯時，可以直接問 Claude：

```
這段程式碼為什麼這樣寫？有沒有可能在 X 情況下出問題？
```

Claude 對自己生成的程式碼有完整的上下文，解釋起來很清楚。

---

## Part 4：常見疑慮

**Q：Claude 會取代我的工作嗎？**

Claude 很擅長執行明確定義的任務。但「決定要做什麼」、「判斷這樣做對不對」、「理解業務背景」——這些仍然是人做的事。

更實際的比喻：Claude 像一個執行力很強的初級工程師，你是 lead。你的工作從「把事情做完」變成「決定做什麼、確認做對了」。

**Q：每個人用法不同，程式碼風格會亂掉嗎？**

這是 CLAUDE.md 要解決的問題。把風格規範寫進去，Claude 會遵守。重要的不是每個人用一樣的 prompt，而是 Claude 對每個人輸出一致的風格。

**Q：AI 生成的程式碼安全嗎？**

和人寫的程式碼一樣——需要 review，不能盲目信任。Claude 不會故意寫出有漏洞的程式碼，但可能沒考慮到你的系統的特定風險。安全性 review 的責任還是在人身上。

**Q：Claude 寫錯了怎麼辦？**

就像其他任何程式碼一樣——找出來、修掉、弄清楚為什麼錯了。如果是 CLAUDE.md 沒有說清楚導致的，把規則加進去。每次修正都是讓 CLAUDE.md 更精準的機會。

---

## 總結

把 Claude Code 導入團隊，核心是兩件事：

**建立共識：**
- 分階段導入，試用期先找出有效用法
- 把有效用法寫進 CLAUDE.md，開會對齊
- 定期回顧和更新，讓 CLAUDE.md 持續反映團隊現況

**建立信任：**
- 用同樣的標準 review AI 生成的程式碼
- 遇到不確定的邏輯，直接問 Claude
- 把每次修正都當成改進規範的機會

工具不難推，難的是讓每個人都覺得這個工具值得信任、用起來有把握。這需要時間，也需要刻意經營——但一旦建立起來，這個信任是整個團隊的資產。

感謝閱讀這個系列。

---

## 參考資料

- [Claude Code Docs — Memory](https://docs.anthropic.com/en/docs/claude-code/memory) — CLAUDE.md 完整說明
- [Claude Code Docs — Settings](https://docs.anthropic.com/en/docs/claude-code/settings) — 團隊設定選項
