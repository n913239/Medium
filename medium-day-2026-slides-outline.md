# Medium Day 2026 — 投影片大綱草案

**Title:** From Demos to Production: The Claude Code Setup I Actually Ship With
**Track:** Perspectives → Technology & AI
**Length:** 30 minutes(主講 ~28 min + Q&A handoff 1 min + buffer 1 min)
**Audience:** Medium 廣泛讀者(對 AI 有興趣,但不一定是 iOS / 重度開發者)

---

## 🎯 整場的單一論點(One Sentence)

> "AI coding tools become production-grade not because of better models, but because of the structure you build around them."

每一張投影片都要服務這句話。任何「酷但離題」的內容請砍掉。

---

## 結構總覽

| # | 段落 | 時長 | 投影片數 | 任務 |
|---|---|---|---|---|
| 1 | Opening Hook | 2 min | 3 | 抓住注意力 + 自我介紹 |
| 2 | Part 1: Slash Commands | 8 min | 5–6 | 重複 prompt → 結構化 command |
| 3 | Part 2: Custom Agents | 8 min | 5–6 | 大型任務 → 委派給 agent |
| 4 | Part 3: Hooks | 8 min | 4–5 | 補捉 test 漏掉的 bug |
| 5 | Synthesis | 3 min | 2 | 結構論點收尾 |
| 6 | Closing + Q&A | 1 min | 1 | 一句帶回家 + 邀請提問 |

**總投影片數:** 約 20–23 張(平均每張 ~1.3 分鐘,符合人類注意力節奏)

---

## Section 1:Opening Hook(2 min)

### 目標
讓觀眾在 30 秒內知道「為什麼我該聽下去」。

### Slide 1.1 — Title
- 標題:From Demos to Production
- 副標:The Claude Code Setup I Actually Ship With
- 角落:Your name · Solo iOS Developer from Taiwan · Medium Day 2026

### Slide 1.2 — The Hook(對比畫面)
- 左:典型 AI demo 畫面(乾淨、神奇)
- 右:真實開發者的螢幕(亂、有 bug、build failure)
- 一句字:**"The gap between these two is where most AI tools die."**

### Slide 1.3 — Who I Am(快速自介)
- Solo iOS developer · 4 years · 3 production apps
- Published 10+ articles on Claude Code in the past 3 months
- One key fact: **"No team catches the AI's mistakes for me."**

### 開場逐字建議(英文,等級 7 友善)

> "Most AI coding demos I see online look magical. Then I open my real codebase, and the magic breaks. Today I'll show you why — and what I built to close that gap. I'm a solo iOS developer from Taiwan. There's no team to catch the AI's mistakes for me. So I had to build the structure myself. That structure is what this talk is about."

(約 60 秒,留 60 秒給自介 + 過渡)

---

## Section 2:Slash Commands(8 min)

### 目標
讓觀眾理解:**重複的 prompt 就是該被結構化的訊號。**

### Slide 2.1 — The Problem
- 「Have you ever typed the same prompt 20 times this week?」
- 列出 4–5 個你每天重複輸入的 prompt(脫敏處理)
- 一句結論:**"Every repeated prompt is a slash command waiting to be born."**

### Slide 2.2 — What Is a Slash Command?
- 簡單定義:把常用 prompt 存成檔案,用 `/name` 一鍵呼叫
- Show 一張 `.claude/commands/` 資料夾截圖
- 對比:**Typing 80 words vs typing `/precommit`**

### Slide 2.3 — Live Example: `/precommit`
- 顯示這個 command 的實際內容(code snippet)
- 用人話解釋每一行做什麼
- **不要假設觀眾知道什麼是 CLI** — 用「像 Word 巨集」的類比

### Slide 2.4 — Another Example: `/pr-description`
- 給第二個例子加深印象
- 重點:這個 command 怎麼從你某次「我又要寫 PR 描述了」的痛點長出來

### Slide 2.5 — When Does a Prompt Become a Command?
- 三個訊號:
  1. **Repetition** — 你這週用過 3 次以上
  2. **Stability** — prompt 內容大致不變
  3. **Scope** — 範圍清楚有界

### Slide 2.6 — Transition
- "Slash commands work great for repeated prompts. But what about tasks that are bigger than one prompt?"
- → 進 Part 2

---

## Section 3:Custom Agents(8 min)

### 目標
讓觀眾理解:**有些任務需要的不是 command,是 specialist。**

### Slide 3.1 — When Commands Aren't Enough
- 舉一個 command 撐不住的例子:「Review this PR for security issues」
- 為什麼撐不住:需要多步推理、需要專業視角、需要工具

### Slide 3.2 — What Is a Custom Agent?
- 定義:**一個有專屬 system prompt + 工具權限 + 範圍的 sub-AI**
- 比喻:command 是助理,agent 是專員
- Show agent config 簡單範例

### Slide 3.3 — Live Example: `code-reviewer` Agent
- 你實際用的 code-reviewer agent
- 它有什麼 system prompt
- 它有什麼工具權限(可以讀檔、不能寫檔)

### Slide 3.4 — Another Example: `test-writer` Agent
- 對比:這個 agent 跟 reviewer 的差別
- 重點:**Specialization matters more than capability**

### Slide 3.5 — Command vs Agent: How to Choose
- 表格對照:
  | 用 Slash Command | 用 Custom Agent |
  |---|---|
  | 單步、輸入清楚 | 多步推理 |
  | 跑完即結束 | 需要中間決策 |
  | 全域使用 | 特定情境 |

### Slide 3.6 — Transition
- "Commands and agents handle what you ask them to do. But what about the things you forget to ask?"
- → 進 Part 3

---

## Section 4:Hooks(8 min)

### 目標
讓觀眾理解:**有些 bug 永遠不會出現在 test 裡,但 hook 抓得到。**

### Slide 4.1 — The Problem Tests Don't Solve
- 一個你親身踩過的 bug 範例
- 為什麼 test 沒抓到(例如:不是邏輯錯,是流程錯)
- 一句結論:**"Tests verify what you remember to check. Hooks watch what you forget."**

### Slide 4.2 — What Is a Hook?
- 定義:**在某個事件發生時自動跑的 script(pre-commit、post-tool、etc.)**
- Show 一個 hook config 範例

### Slide 4.3 — Live Example: Pre-Commit Hook
- 你實際在用的 pre-commit hook
- 它檢查什麼(例如:沒留 console.log、沒留 TODO、沒留 secrets)
- 它抓過什麼真實 bug

### Slide 4.4 — When to Use Hooks
- 三種情境:
  1. **Repetitive guards**(每次都要檢查的東西)
  2. **Safety nets**(忘記做會壞事的東西)
  3. **Style enforcement**(風格、規範)

### Slide 4.5 — Transition
- "Three structures — commands, agents, hooks. They look different, but they share one principle."
- → 進 Synthesis

---

## Section 5:Synthesis(3 min)

### 目標
把三個技術整合成一個論點,觀眾記得帶回家。

### Slide 5.1 — The Pattern
- 三個結構共同的形狀:
  - **Slash Commands** = encoding repetition
  - **Custom Agents** = encoding specialization
  - **Hooks** = encoding guardrails
- 一句話:**"All three replace mental discipline with structural discipline."**

### Slide 5.2 — Why This Matters More for Solo Developers
- 團隊有:reviewer、QA、conventions、tribal knowledge
- 一個人:全部要自己長出來
- 結論:**"For a solo developer, structure isn't optional. It's survival."**

---

## Section 6:Closing + Q&A Handoff(1 min)

### Slide 6.1 — Takeaway + Resources
- 一句帶回家:
  > "Better models won't save bad workflows. Structure will."
- Where to find more:
  - Medium: @n913239
  - 系列連結
- Q&A 邀請:
  > "I'd love to take your questions. Feel free to drop them in the Zoom chat."

### 閉場逐字建議

> "If you remember one thing from today, let it be this: better models won't save bad workflows. Structure will. Thank you. I'd love to take your questions — feel free to drop them in the Zoom chat."

(約 25 秒)

---

## ⚠️ ESL 講者的注意事項

1. **每段開頭一句話 + 結尾一句話請寫死、背熟** — 銜接點最容易卡
2. **避免縮寫和俚語** — "AI's gonna" → "AI is going to"
3. **每張投影片放關鍵字,不要放完整句子** — 觀眾看字會分心,你也會被誘惑去念
4. **demo 截圖比 live demo 安全** — 第一次講不建議 live coding
5. **過渡句固定模板**:"That's [X]. Next, let's talk about [Y]."

---

## 下一步動作

- [ ] 確認這個大綱的時間分配是否合理(8/8/8 三大段太均勻?要不要其中一段壓到 6 min?)
- [ ] 確認每個段落的「Live Example」要用哪一個實際 command/agent/hook
- [ ] 為每個 Live Example 截圖(用真實的 `.claude/` 設定)
- [ ] 開始 Action 3(逐字稿)— 從 Part 1 開始寫
- [ ] 找一張對比圖當 Slide 1.2 的視覺(可以用 AI 生成)

---

## 一句結論

**這份大綱不是終稿,是工作底稿。**Section 2/3/4 的 Live Example 是最需要花時間決定的 — 選的越具體,演講越有力。
