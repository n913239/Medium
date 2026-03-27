*(在這裡插入封面圖：cover.png)*
<!-- Gemini 圖片描述：一間現代辦公室的俯瞰視角，中央有一台大型印表機，從印表機延伸出許多纏繞的電線和鎖鏈連接到四周的每張辦公桌電腦上，像蜘蛛網一樣。員工們表情無奈地被線纏住。印表機上方浮著一行程式碼「.shared」。整體氛圍是「方便卻失控」的感覺。風格：扁平化插畫、柔和的莫蘭迪色調、白色背景、適合作為技術文章封面。16:9 橫幅比例。 -->

# 你的 Singleton 正在搞壞你的 App 嗎？— 從生活理解依賴反轉

> 全公司只有一台印表機，方便還是災難？答案取決於你怎麼管理它。

---

## 前言

在 iOS 開發中，Singleton 大概是最早學到的設計模式之一。簡單、好用、到處都能存取 — 聽起來很美好，直到你的 App 越長越大，才發現測試寫不動、模組拆不開、改一個地方壞三個。

這篇文章會從生活場景出發，聊聊 Singleton 的正確用法、常見的踩坑方式，以及如何用「依賴反轉」來解救你的架構。

---

## 先講個故事：公司裡的印表機

想像你在一間公司上班，整層樓只有一台印表機。

- 所有人共用同一台 → 這就是 **Singleton**
- 印表機壞了，全公司都不能印 → **單點故障**
- 有人印了 500 頁的簡報，你只能等 → **資源競爭**
- 想換一台新的印表機？所有人的設定都要重來 → **緊耦合**

但如果是飲水機呢？全公司只有一台飲水機，其實完全合理 — 因為大家只是去裝水，不會佔用太久，也不需要客製化設定。

**重點不是「能不能只有一個」，而是「適不適合只有一個」。**

---

## Singleton 到底是什麼？

Singleton 模式確保一個類別在整個 App 生命週期中**只有一個實例**，並提供一個全域的存取點。

在 Swift 中，最標準的寫法：

```swift
class MusicPlayer {
    static let shared = MusicPlayer()
    private init() {}

    func play(song: String) {
        print("正在播放：\(song)")
    }
}

// 使用方式
MusicPlayer.shared.play(song: "晴天")
```

關鍵在兩件事：
1. `static let shared` — 全域唯一的存取點
2. `private init()` — 禁止外部建立新的實例

---

## 大寫 S 和小寫 s 的差別

Apple 自己的 API 裡其實有很多「小寫 s」的 singleton：

```swift
// 提供共享實例，但你也可以自己建立新的
let defaultSession = URLSession.shared
let customSession = URLSession(configuration: .ephemeral)

let standardDefaults = UserDefaults.standard
let appGroupDefaults = UserDefaults(suiteName: "group.com.myapp")
```

這些是**小寫 s 的 singleton** — 它們提供了一個方便的共享實例，但並沒有禁止你建立其他實例。這是一個比較彈性的做法。

相反的，**大寫 S 的 Singleton** 用 `private init()` 強制限制只能有一個實例，完全沒有彈性。

---

## Singleton vs 全域可變狀態：差很多

很多人把 Singleton 和「全域可變狀態」搞混了，但它們是不同的東西。

```swift
// Singleton — 不可變的共享參考（安全）
class AnalyticsTracker {
    static let shared = AnalyticsTracker()
    private init() {}

    func track(event: String) { /* ... */ }
}
```

```swift
// 全域可變狀態 — 可以被任何人隨時替換（危險）
class AppConfig {
    static var current = AppConfig()

    var apiBaseURL = "https://api.myapp.com"
    var isDebugMode = false
}

// 任何地方都可以這樣搞
AppConfig.current.apiBaseURL = "https://hack.bad.com"  // 😱
AppConfig.current = AppConfig()  // 整個被換掉了
```

`static let` 和 `static var` 只差一個字，但後果天差地遠：

- `static let` → 參考不可變，相對安全
- `static var` → 任何執行緒都能改，可能造成 race condition 和不一致的狀態

---

## 什麼適合當 Singleton？

### 適合的：一對一關係、API 簡單、不需要客製化

![適合當 Singleton 的場景](table-good-singleton.png)

<!--
| 場景 | 原因 |
|------|------|
| 事件追蹤器（Analytics） | 全 App 只需要一個追蹤入口 |
| Log 紀錄器 | 集中記錄，API 單純 |
| 飲水機 | 大家只是去裝水，不佔資源 |
-->

*(在這裡插入圖片：good-singleton-example.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration. A cheerful kawaii water dispenser in the center with a happy smiling face. Three small chibi-style characters with round faces taking turns filling their cups, each with a relaxed and content expression. Clean white background. Soft pastel colors: mint green, sky blue, warm peach. Simple and uncluttered composition. No text. 16:9 ratio. -->

### 不適合的：生命週期短、需要多個實例、狀態複雜

![不適合當 Singleton 的場景](table-bad-singleton.png)

<!--
| 場景 | 原因 |
|------|------|
| 購物車 | 多帳號切換時，購物車內容不該共用 |
| ViewModel | 每個畫面都該有自己的 ViewModel |
| 網路請求物件 | 不同 API 可能需要不同設定（timeout、header） |
| 印表機 | 有人印 500 頁你就卡住了 |
-->

*(在這裡插入圖片：bad-singleton-example.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration. A kawaii printer in the center with a stressed and overwhelmed expression (sweat drops, wavy mouth). Four small chibi-style characters in a long queue, each holding a huge stack of papers, all with impatient or frustrated expressions. Soft pastel colors with a hint of red/orange for the printer to convey stress. Clean white background. Simple composition. No text. 16:9 ratio. -->

判斷標準很簡單：**如果系統中只有一個實例是「必要的」或「合理的」，才用 Singleton。否則，不要用。**

---

## 真正的問題不是 Singleton 本身，而是緊耦合

來看一個常見的寫法：

```swift
class OrderViewModel {
    func placeOrder(items: [Item]) {
        // 直接使用 Singleton
        PaymentManager.shared.charge(amount: items.totalPrice)
        AnalyticsTracker.shared.track(event: "order_placed")
        NotificationSender.shared.send(title: "訂單成立")
    }
}
```

看起來很方便對吧？但問題來了：

1. **測試怎麼寫？** 你沒辦法在測試中把 `PaymentManager.shared` 換成假的，每次跑測試都會真的扣款？
2. **換支付方式呢？** 從信用卡改成 Apple Pay，你要改多少個檔案？
3. **想在預覽中看效果？** SwiftUI Preview 也會觸發真的支付邏輯。

這就是**緊耦合** — 你的 `OrderViewModel` 被釘死在特定的實作上，動彈不得。

---

## 用依賴反轉解救你的架構

解法其實只要 4 步：

### 第 1 步：定義抽象介面（Protocol）

先想清楚「我需要什麼能力」，而不是「我要用哪個物件」：

```swift
protocol PaymentService {
    func charge(amount: Decimal) async throws
}

protocol EventTracking {
    func track(event: String)
}
```

### 第 2 步：讓 ViewModel 依賴抽象，而非具體

```swift
class OrderViewModel {
    private let paymentService: PaymentService
    private let tracker: EventTracking

    init(paymentService: PaymentService, tracker: EventTracking) {
        self.paymentService = paymentService
        self.tracker = tracker
    }

    func placeOrder(items: [Item]) async throws {
        try await paymentService.charge(amount: items.totalPrice)
        tracker.track(event: "order_placed")
    }
}
```

### 第 3 步：讓現有的實作去遵循 Protocol

```swift
extension PaymentManager: PaymentService {
    func charge(amount: Decimal) async throws {
        // 原本的支付邏輯
    }
}

extension AnalyticsTracker: EventTracking {
    // track(event:) 已經存在，自動符合
}
```

### 第 4 步：在組合層注入依賴

```swift
// 在 App 的進入點或 Coordinator 組合
let viewModel = OrderViewModel(
    paymentService: PaymentManager.shared,
    tracker: AnalyticsTracker.shared
)
```

*(在這裡插入圖片：dependency-inversion-diagram.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration split into two halves. Left half labeled "Before" in red: a small stressed chibi character (OrderViewModel) with tangled colorful cables directly attached to three kawaii box-shaped objects (PaymentManager, AnalyticsTracker, NotificationSender), all frowning. Right half labeled "After" in green: the same chibi character now connected through a friendly glowing cloud/bubble (Protocol), and behind the cloud three happy box characters. Left side has a red X, right side has a green checkmark. Soft pastel colors, white background. No extra text. 16:9 ratio. -->

---

## 改完之後，測試變得超簡單

```swift
// 測試用的假實作
struct MockPaymentService: PaymentService {
    var shouldFail = false

    func charge(amount: Decimal) async throws {
        if shouldFail {
            throw PaymentError.declined
        }
    }
}

struct MockTracker: EventTracking {
    var trackedEvents: [String] = []

    mutating func track(event: String) {
        trackedEvents.append(event)
    }
}

// 測試
@Test func 下單成功應該追蹤事件() async throws {
    var tracker = MockTracker()
    let vm = OrderViewModel(
        paymentService: MockPaymentService(),
        tracker: tracker
    )

    try await vm.placeOrder(items: testItems)

    #expect(tracker.trackedEvents.contains("order_placed"))
}
```

不用動到真的支付系統，不用擔心網路狀態，測試跑起來又快又穩。

---

## 依賴圖怎麼看？

如果你想用圖表來視覺化元件之間的關係，以下是 4 種最常見的箭頭：

*(在這裡插入圖片：diagram-arrows-overview.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel reference card with a 2x2 grid layout. Each cell shows a different arrow type between two small kawaii rounded boxes. (1) Solid line with hollow triangle arrow, labeled "inherits from". (2) Dashed line with hollow triangle arrow, labeled "conforms to". (3) Solid line with filled arrow, labeled "has a". (4) Dashed line with filled arrow, labeled "uses a". Each arrow is a different pastel color. Soft rounded corners, white background, gentle hand-drawn style. 16:9 ratio. -->

### 1. 實線空心箭頭 →「繼承」

```swift
class PremiumOrderViewModel: OrderViewModel { }
```

`PremiumOrderViewModel` **繼承自** `OrderViewModel`

*(在這裡插入圖片：diagram-inheritance.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration. Two kawaii rounded boxes with gentle faces. Left box is a small chibi character labeled "PremiumOrderViewModel", right box labeled "OrderViewModel". A solid line with a hollow triangle arrow points from left to right. The right box looks like a parent figure, slightly larger and with a warm smile. Soft mint green and lavender colors. Clean white background. Simple and minimal. No extra decorations. -->

### 2. 虛線空心箭頭 →「遵循 Protocol」

```swift
class StripePaymentService: PaymentService { }
```

`StripePaymentService` **遵循** `PaymentService` 協定

*(在這裡插入圖片：diagram-conformance.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration. Two kawaii shapes: left is a solid rounded box labeled "StripePaymentService" with a friendly face, right is a dashed-border rounded box labeled "PaymentService" with a soft glowing outline (representing a protocol/abstract interface). A dashed line with a hollow triangle arrow connects left to right. Soft peach and sky blue pastel colors. Clean white background. Minimal and simple. -->

### 3. 實線實心箭頭 →「強依賴（擁有）」

```swift
class OrderViewModel {
    private let paymentService: PaymentService  // 沒有它就不能建立
}
```

`OrderViewModel` **擁有** 一個 `PaymentService`，少了它連編譯都過不了。

*(在這裡插入圖片：diagram-strong-dependency.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration. Two kawaii rounded boxes: left labeled "OrderViewModel" holding tightly onto a rope/chain, right labeled "PaymentService". A solid line with a filled arrow connects them, the rope looks sturdy and firm. The left character looks nervous without the right one. Soft coral and mint green colors. Clean white background. Simple composition. -->

### 4. 虛線實心箭頭 →「弱依賴（使用）」

```swift
class OrderViewModel {
    func export(using exporter: DataExporter) {  // 用完即丟
        exporter.export(data)
    }
}
```

`OrderViewModel` **使用** `DataExporter`，但沒有它也能存在。

*(在這裡插入圖片：diagram-weak-dependency.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration. Two kawaii rounded boxes: left labeled "OrderViewModel" waving hello casually, right labeled "DataExporter" appearing temporarily with a dotted/faded outline. A dashed line with a filled arrow connects them loosely. The left character looks relaxed and independent. Soft lavender and yellow pastel colors. Clean white background. Simple and light composition. -->

---

## 回到印表機的比喻

![改造前後對比](table-before-after.png)

<!--
| 改造前 | 改造後 |
|--------|--------|
| 全公司直接走去那台印表機 | 每個人只知道「有個東西可以印」 |
| 印表機壞了大家都卡住 | 換一台新的，大家照用 |
| 想測試列印功能？要真的印出來 | 用假的印表機，確認流程正確就好 |
| 程式碼到處都是 `Printer.shared` | 只有組合層知道是哪台印表機 |
-->

*(在這裡插入圖片：before-after-comparison.png)*
<!-- Gemini prompt: A cute Ghibli-inspired soft pastel illustration split into two halves. Left half "Before": three stressed chibi characters all crowded around one overwhelmed kawaii printer, tangled cables everywhere, everyone looks frustrated. Right half "After": each chibi character sits happily at their own desk, connected through a glowing soft interface button, with different printer characters behind (each unique and happy). Left side has a soft red tint, right side has a soft green tint. White background. No text. 16:9 ratio. -->

---

## 總結

1. **Singleton 不是壞東西**，但要用在對的地方 — 系統中真正只需要一個實例的場景
2. **避免全域可變狀態**（`static var`），它是 bug 的溫床
3. **問題的根源是緊耦合**，不是 Singleton 本身 — 到處直接呼叫 `.shared` 才是問題
4. **依賴反轉只要 4 步**：定義 Protocol → 依賴抽象 → 現有類別遵循 → 在組合層注入
5. **畫張依賴圖**，就能看清楚哪裡耦合太緊、哪裡可能有 retain cycle

下次當你準備打 `.shared` 的時候，先停下來想一秒：「這個依賴，是不是應該從外面傳進來？」

---

感謝閱讀。如果你也曾被 Singleton 搞到頭痛，歡迎留言分享你的經驗。

---

## 知識來源

本文的核心概念（Singleton 的正確使用時機、全域可變狀態的風險、依賴反轉的實作步驟、依賴圖的閱讀方式）源自 **[iOS Lead Essentials](https://www.essentialdeveloper.com/ios-lead-essentials)** 課程中的 Module 3 — *Are Singletons and Global Instances Damaging your System Design and Testability?*

文章中的比喻（印表機、飲水機）與程式碼範例（`OrderViewModel`、`MockPaymentService`）為本人依課程觀念自行改寫，並非課程原文。
