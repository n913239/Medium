*(Insert cover image: cover.png)*

# Is Your Singleton Quietly Wrecking Your App? — Understanding Dependency Inversion

> One printer for the whole office — convenient or a disaster? Depends on how you manage it.

---

## Intro

Singleton is probably one of the first design patterns you learn in iOS development. Simple, easy to use, accessible from anywhere — sounds great, until your app grows and suddenly you can't write tests, can't separate modules, and changing one thing breaks three others.

This article uses real-life analogies to look at when Singleton makes sense, the traps it hides, and how dependency inversion can save your architecture.

---

## A Story About the Office Printer

Imagine your whole floor shares one printer.

- Everyone uses the same one → that's a **Singleton**
- The printer breaks → the whole office is stuck → **single point of failure**
- Someone's printing a 500-page deck, you just have to wait → **resource contention**
- Want to swap it out? Everyone's settings break → **tight coupling**

Now think about the water dispenser. One for the whole office — totally fine. People grab water and leave, no customization needed, no one's hogging it for an hour.

**The question isn't "can there be just one?" — it's "does it make sense to have just one?"**

---

## What Even Is a Singleton?

The Singleton pattern ensures a class has **exactly one instance** throughout the app's lifecycle, with a single global access point.

The standard Swift way to write it:

```swift
class MusicPlayer {
    static let shared = MusicPlayer()
    private init() {}

    func play(song: String) {
        print("Now playing: \(song)")
    }
}

// Usage
MusicPlayer.shared.play(song: "Sunny Day")
```

Two things make it work:
1. `static let shared` — the one global access point
2. `private init()` — nobody outside can create a new instance

---

## Uppercase S vs Lowercase s

Apple's own APIs actually have a lot of lowercase-s singletons:

```swift
// Offers a shared instance, but you can still create your own
let defaultSession = URLSession.shared
let customSession = URLSession(configuration: .ephemeral)

let standardDefaults = UserDefaults.standard
let appGroupDefaults = UserDefaults(suiteName: "group.com.myapp")
```

These are **lowercase-s singletons** — they give you a convenient shared instance, but they don't stop you from creating others. Much more flexible.

**Uppercase-S Singletons** use `private init()` to enforce "one and only one." No flexibility at all.

---

## Singleton vs Global Mutable State — Not the Same Thing

A lot of people mix these up, but they're very different.

```swift
// Singleton — immutable shared reference (safe)
class AnalyticsTracker {
    static let shared = AnalyticsTracker()
    private init() {}

    func track(event: String) { /* ... */ }
}
```

```swift
// Global mutable state — anyone can replace it anytime (dangerous)
class AppConfig {
    static var current = AppConfig()

    var apiBaseURL = "https://api.myapp.com"
    var isDebugMode = false
}

// Anyone can do this anywhere
AppConfig.current.apiBaseURL = "https://hack.bad.com"  // 😱
AppConfig.current = AppConfig()  // The whole thing just got replaced
```

One letter difference — `static let` vs `static var` — but the consequences are completely different:

- `static let` → reference can't be replaced, relatively safe
- `static var` → any thread can mutate it, race conditions and inconsistent state incoming

---

## When Should You Use Singleton?

### Good candidates: simple API, no customization needed, truly one-to-one

![Good Singleton candidates](../2026-03-26_singleton-dependency-inversion/table-good-singleton.png)

<!--
| Use case | Why it works |
|----------|-------------|
| Analytics tracker | One entry point for events is all you need |
| Logger | Centralized logging, dead simple API |
| Water dispenser | Everyone just grabs water, no one holds it hostage |
-->

*(Insert image: good-singleton-example.png)*

### Bad candidates: short lifecycle, needs multiple instances, complex state

![Bad Singleton candidates](../2026-03-26_singleton-dependency-inversion/table-bad-singleton.png)

<!--
| Use case | Why it breaks |
|----------|--------------|
| Shopping cart | Multi-account apps would share cart contents — disaster |
| ViewModel | Every screen needs its own |
| Network client | Different APIs need different configs (timeout, headers) |
| Office printer | One person printing 500 pages and everyone's stuck |
-->

*(Insert image: bad-singleton-example.png)*

Simple rule: **only use Singleton when having exactly one instance is necessary or genuinely makes sense. Otherwise, don't.**

---

## The Real Problem Isn't Singleton — It's Tight Coupling

Here's a pattern you've probably seen (or written):

```swift
class OrderViewModel {
    func placeOrder(items: [Item]) {
        // Calling Singletons directly
        PaymentManager.shared.charge(amount: items.totalPrice)
        AnalyticsTracker.shared.track(event: "order_placed")
        NotificationSender.shared.send(title: "Order confirmed")
    }
}
```

Looks convenient, right? But now:

1. **How do you test this?** You can't swap out `PaymentManager.shared` in tests — every test run actually charges a card?
2. **What if you switch payment providers?** Migrating from Stripe to Apple Pay means hunting through the whole codebase.
3. **SwiftUI Preview?** It'll trigger real payment logic. Good luck.

This is **tight coupling** — `OrderViewModel` is nailed to specific implementations and can't move.

---

## Dependency Inversion to the Rescue

The fix is just 4 steps:

### Step 1: Define an abstract interface (Protocol)

Think about "what capability do I need," not "which object do I want":

```swift
protocol PaymentService {
    func charge(amount: Decimal) async throws
}

protocol EventTracking {
    func track(event: String)
}
```

### Step 2: Make the ViewModel depend on abstractions, not concretions

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

### Step 3: Make your existing implementations conform to the protocols

```swift
extension PaymentManager: PaymentService {
    func charge(amount: Decimal) async throws {
        // existing payment logic
    }
}

extension AnalyticsTracker: EventTracking {
    // track(event:) already exists, conforms automatically
}
```

### Step 4: Wire everything together at the composition layer

```swift
// At your app entry point or Coordinator
let viewModel = OrderViewModel(
    paymentService: PaymentManager.shared,
    tracker: AnalyticsTracker.shared
)
```

*(Insert image: dependency-inversion-diagram.png)*

---

## After the Refactor — Testing Is a Breeze

```swift
// Fake implementations for testing
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

// Test
@Test func placingOrderShouldTrackEvent() async throws {
    var tracker = MockTracker()
    let vm = OrderViewModel(
        paymentService: MockPaymentService(),
        tracker: tracker
    )

    try await vm.placeOrder(items: testItems)

    #expect(tracker.trackedEvents.contains("order_placed"))
}
```

No real payment system involved. No network dependency. Tests run fast and reliably every time.

---

## Reading Dependency Diagrams

If you want to visualize how your components relate to each other, here are the 4 most common arrow types:

*(Insert image: diagram-arrows-overview.png)*

### 1. Solid line, hollow arrow → Inheritance

```swift
class PremiumOrderViewModel: OrderViewModel { }
```

`PremiumOrderViewModel` **inherits from** `OrderViewModel`

*(Insert image: diagram-inheritance.png)*

### 2. Dashed line, hollow arrow → Protocol conformance

```swift
class StripePaymentService: PaymentService { }
```

`StripePaymentService` **conforms to** the `PaymentService` protocol

*(Insert image: diagram-conformance.png)*

### 3. Solid line, filled arrow → Strong dependency ("has a")

```swift
class OrderViewModel {
    private let paymentService: PaymentService  // can't exist without it
}
```

`OrderViewModel` **has a** `PaymentService` — remove it and the code won't even compile.

*(Insert image: diagram-strong-dependency.png)*

### 4. Dashed line, filled arrow → Weak dependency ("uses a")

```swift
class OrderViewModel {
    func export(using exporter: DataExporter) {  // just passing through
        exporter.export(data)
    }
}
```

`OrderViewModel` **uses a** `DataExporter`, but can exist without one.

*(Insert image: diagram-weak-dependency.png)*

---

## Back to the Printer Analogy

![Before vs After](../2026-03-26_singleton-dependency-inversion/table-before-after.png)

<!--
| Before | After |
|--------|-------|
| Everyone walks to that one printer | Each person just knows "something can print" |
| Printer breaks, everyone's blocked | Swap it out, nobody notices |
| Testing print? You need an actual printout | Use a fake printer, verify the flow works |
| Code is littered with `Printer.shared` | Only the composition layer knows which printer |
-->

*(Insert image: before-after-comparison.png)*

---

## Wrapping Up

1. **Singleton isn't evil** — just use it where it actually makes sense: when one instance is genuinely all you need
2. **Avoid global mutable state** (`static var`) — it's a bug factory
3. **The real problem is tight coupling**, not Singleton itself — calling `.shared` everywhere is what kills you
4. **Dependency inversion in 4 steps**: define a Protocol → depend on abstraction → make implementations conform → inject at composition layer
5. **Draw a dependency diagram** — you'll immediately see where things are too tightly coupled or where retain cycles might hide

Next time you're about to type `.shared`, pause for a second and ask: "should this dependency be passed in from outside instead?"

---

Thanks for reading. If Singleton has ever given you a headache, drop a comment — I'd love to hear how you handled it.

---

## References

The core concepts in this article — when Singleton is appropriate, the risks of global mutable state, the 4-step dependency inversion refactor, and how to read dependency diagrams — come from Module 3 of the **[iOS Lead Essentials](https://www.essentialdeveloper.com/ios-lead-essentials)** program: *Are Singletons and Global Instances Damaging your System Design and Testability?*

The analogies (printer, water dispenser) and code examples (`OrderViewModel`, `MockPaymentService`) are my own rewrites based on the course concepts, not reproductions of the original material.
