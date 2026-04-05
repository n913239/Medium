*(Insert cover image here: cover.png)*
<!-- Gemini prompt: A warm Ghibli-inspired illustration. A chibi developer in casual work clothes sits at a wooden desk, with an open notebook showing keywords like TDD, Coordinator, and TestDouble. A computer screen beside them glows softly green, displaying "All Tests Passed ✓". Warm afternoon sunlight streams through the window, and handwritten architecture notes are pinned to the wall. The overall mood conveys "bringing learning back to real work". Soft pastel colors, warm beige background, 16:9 ratio. -->

# iOS TDD and Modular Design: A Real-World Application

> You've learned it — now what? The hardest part is bringing it into that 2,000-line ViewController.

---

## Introduction

Course examples are clean. Every dependency is injectable, every piece of logic has a test, every module is clearly separated.

But real-world code isn't like that.

The app you inherit has aging ViewControllers, global Singletons, and a new feature due next week. Applying what you've learned in that environment is the real challenge.

This article documents how I incrementally applied TDD, domain modeling, and modular design in a production enterprise iOS app — not a rewrite, but a series of deliberate, sustained improvements.

---

## Project Background

This is an enterprise employee management iOS app, covering modules for leave requests, push notifications, attendance tracking, business trips, and expense reimbursement. Multiple client configurations share a common architecture.

State before the course:

- ViewControllers often running into thousands of lines
- Global state accessed directly through Singletons, with no abstraction layer
- Zero test coverage
- Navigation logic scattered across every screen — change one thing, break three others

This isn't unusual. It's what most real-world projects look like.

---

## Applying TDD: ViewController Business Logic

The course makes it clear: ViewControllers often hide untested business logic. The point isn't "don't put logic in VCs" — it's "wherever the logic lives, test it."

In the leave management module, whether a leave record is editable depends on a time window rule. Before TDD, this logic was buried inside `tableView(_:canEditRowAt:)` — unnamed, untested, silently affecting user behavior.

After the course, I extracted it into a dedicated method and wrote the tests first:

```swift
class LeaveListVCBusinessLogicTests: XCTestCase {
    var sut: LeaveListViewController!

    override func setUp() {
        sut = LeaveListViewController()
    }

    func test_setupCellCanEdit_withinEditWindow_returnsTrue() {
        let recentDate = Calendar.current.date(
            byAdding: .day, value: -10, to: Date()
        )!
        XCTAssertTrue(sut.setupCellCanEdit(recentDate))
    }

    func test_setupCellCanEdit_outsideEditWindow_returnsFalse() {
        let oldDate = Calendar.current.date(
            byAdding: .day, value: -45, to: Date()
        )!
        XCTAssertFalse(sut.setupCellCanEdit(oldDate))
    }
}
```

Two tests, a few minutes. The rule now exists as executable code — anyone who changes it will immediately see the result.

---

## Applying TDD: The Persistence Layer

The app uses a `UserDefaultsUtilities` wrapper to store user state — user type, login status, cached setup data. Before the course, this was accessed globally with no contract and no tests.

Applying the persistence module approach, I injected an isolated `UserDefaults` suite and wrote tests around it:

```swift
class UserDefaultsUtilitiesTests: XCTestCase {
    var sut: UserDefaultsUtilities!

    override func setUp() {
        sut = UserDefaultsUtilities(
            userDefaults: UserDefaults(suiteName: "TestSuite")!
        )
    }

    override func tearDown() {
        sut.clean()
    }

    func test_getUserType_manager_returnsManagerEnum() {
        sut.save(key: "userType", value: "Manager")
        XCTAssertEqual(sut.getUserType(), .manager)
    }

    func test_clean_preservesDeviceToken() {
        sut.save(key: "deviceToken", value: "abc-123")
        sut.clean()
        XCTAssertEqual(sut.getDeviceToken(), "abc-123")
    }
}
```

The second test revealed an important design invariant: device push tokens must not be cleared on logout. The logic was already correct — but without a test, no one knew it was intentional, and nothing protected it from being accidentally broken in the future.

---

## Domain Modeling: Making Roles into Types

A core course concept: represent real domain entities as types, not raw strings or numbers.

In this app, a user can be a manager, employee, HR staff, or system admin — each with different permissions and UI. Before the course, these roles were raw strings scattered through conditionals: `if role == "Manager"` everywhere.

After:

```swift
enum UserType {
    case manager
    case employee
    case hr
    case admin
    case unknown
}
```

Once the domain concept has a type, tests become straightforward:

```swift
func test_getUserType_hr_returnsHREnum() {
    sut.save(key: "userType", value: "HR")
    XCTAssertEqual(sut.getUserType(), .hr)
}
```

More importantly, the compiler starts catching mistakes that strings never could.

---

## TestDoubles: Isolating UIKit Dependencies

The course is clear: real UIKit objects don't belong in unit tests. We created lightweight test doubles:

```swift
class NavigationControllerMock: UINavigationController {
    var lastPushedVC: UIViewController?

    override func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        lastPushedVC = viewController
    }
}
```

```swift
class TableViewMock: UITableView {
    var insertedIndexPaths: [IndexPath] = []
    var deletedIndexPaths: [IndexPath] = []

    override func insertRows(
        at indexPaths: [IndexPath],
        with animation: RowAnimation
    ) {
        insertedIndexPaths.append(contentsOf: indexPaths)
    }

    override func deleteRows(
        at indexPaths: [IndexPath],
        with animation: RowAnimation
    ) {
        deletedIndexPaths.append(contentsOf: indexPaths)
    }
}
```

These let us verify that the right VC was pushed after login, or that the table updated correctly after data changed — without launching any real UI, making tests fast and reliable.

---

## Modular Design: The Coordinator Pattern

Before the course, navigation was everyone's responsibility and no one's responsibility. ViewControllers called `navigationController?.pushViewController(...)` directly — every screen had to know what came next.

The Coordinator Pattern centralizes this responsibility:

```swift
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    weak var finishDelegate: CoordinatorFinishDelegate? { get set }
    var type: CoordinatorType { get }
    func start()
    func finish()
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case app, login, tab, notify
}
```

`AppCoordinator` owns all routing decisions:

```swift
final class AppCoordinator: Coordinator {
    var type: CoordinatorType = .app
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var finishDelegate: CoordinatorFinishDelegate?

    func start() {
        if UserSession.isLoggedIn {
            showMainFlow()
        } else {
            showLoginFlow()
        }
    }

    private func showLoginFlow() {
        let coordinator = LoginCoordinator(
            navigationController: navigationController
        )
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
```

ViewControllers now only handle their own screen logic — they no longer need to know what comes next in the app. Navigation logic can be tested in isolation, and VCs become easier to test and replace.

*(Insert image here: coordinator-flow.png)*
![coordinator-flow](../2026-04-05_tdd-modular-at-work/coordinator-flow.png)

---

## The Reality of Resistance

The course warned this phase would be uncomfortable. It was right.

**"We don't have time to write tests."** This objection came early. I didn't argue with theory — I waited. When a date-calculation bug was caught by a test before code review, the conversation never came up again.

**"Legacy code can't be tested."** True. But it's not a reason to refuse. The approach that worked: start with the code you're writing today. Don't try to test everything at once. Make the new parts better, and let the old parts catch up gradually.

**"Refactoring existing VCs is too risky."** Code without tests means every refactor is a gamble. The answer: write Characterization Tests to lock in the existing behavior first, then refactor with confidence.

---

## Wrapping Up

Applying what you've learned at work is never as clean as course examples. You're dealing with real deadlines, legacy code, and teammates with different priorities. No one will give you a week to "clean up the architecture" — improvements have to happen quietly, within everyday development.

But these patterns work.

Every extracted method is a testable unit. Every Coordinator removes a responsibility from a ViewController. Every TestDouble eliminates a real dependency from your tests. The compounding effect is slow, but it's real.

The course gave me the vocabulary and the patterns. The real project gave me the practice and the proof.

*(Insert image here: before-after.png)*
![before-after](../2026-04-05_tdd-modular-at-work/before-after.png)

---

Thanks for reading. If you're also working on bringing course learnings back to your job, feel free to share your experience in the comments.

---

## References

The core concepts in this article — TDD, domain modeling, TestDouble, Coordinator Pattern, and dependency injection — are sourced from the **[iOS Lead Essentials](https://www.essentialdeveloper.com/ios-lead-essentials)** course.

The code examples (`LeaveListViewController`, `UserDefaultsUtilities`, `NavigationControllerMock`, `AppCoordinator`, etc.) are drawn from real work projects, refactored according to course principles and de-identified for publication.
