*(在這裡插入封面圖：cover.png)*
<!-- Gemini prompt: A warm Ghibli-inspired illustration. A chibi developer in casual work clothes sits at a wooden desk, with an open notebook showing keywords like TDD, Coordinator, and TestDouble. A computer screen beside them glows softly green, displaying "All Tests Passed ✓". Warm afternoon sunlight streams through the window, and handwritten architecture notes are pinned to the wall. The overall mood conveys "bringing learning back to real work". Soft pastel colors, warm beige background, 16:9 ratio. -->

# iOS TDD 與模組化設計實戰紀錄

> 學會了，然後呢？最難的部分，是把它帶進那個兩千行的 ViewController。

---

## 前言

課程中的範例很乾淨：每個依賴都可以注入，每段邏輯都有測試，每個模組都清楚分離。

但工作裡的程式碼不是這樣的。

你接手的 App 有著年久失修的 ViewController、全域的 Singleton、以及一個下週就要上線的新功能。在這樣的環境中落實課程所學，才是真正的挑戰。

這篇文章記錄我如何在一個企業級的 iOS App 中，一步一步地落實 TDD、領域建模與模組化設計——不是重寫，而是刻意地、持續地改善。

---

## 專案背景

這是一套企業員工管理系統的 iOS App，功能涵蓋請假申請、推播通知、出勤管理、出差申請、費用報銷等模組，不同的客戶端設定共用同一套架構基礎。

課程前的狀態：

- ViewController 動輒數千行
- 全域狀態透過 Singleton 直接存取，沒有任何抽象層
- 零測試覆蓋率
- Navigation 邏輯散落在各個畫面裡，改一處壞多處

這不是什麼罕見的情況，這就是大多數真實專案的樣貌。

---

## 落實 TDD：從 ViewController 的商業邏輯開始

課程強調：ViewController 裡往往藏著未被測試的商業邏輯。重點不是「不要在 VC 裡放邏輯」，而是「無論邏輯在哪裡，都要測試它」。

在請假管理模組中，判斷某筆假單是否可以編輯，有一條時間窗口規則。課程前，這個邏輯藏在 `tableView(_:canEditRowAt:)` 裡——沒有名字、沒有測試，悄悄地影響著使用者行為。

課程後，我把這個邏輯提取成獨立方法，並先寫測試：

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

兩個測試，幾分鐘的時間。這條規則現在以可執行程式碼的形式存在，任何人修改都會立刻看到結果。

---

## 落實 TDD：Persistence 層

App 使用一個 `UserDefaultsUtilities` 包裝器來儲存使用者狀態——使用者類型、登入狀態、快取設定資料。課程前，這個物件被全域存取，沒有契約、沒有測試。

套用課程 Persistence 模組的做法，注入一個隔離的 `UserDefaults` suite，補上測試：

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

第二個測試揭露了一個重要的設計意圖：登出時，裝置推播 token 不應該被清除。邏輯本來就正確，但在有測試之前，沒有人知道這是刻意的——也沒有任何東西保護它不被未來的修改意外破壞。

---

## 領域建模：讓角色成為型別

課程的一個核心概念：把領域中真實存在的事物，用型別表達出來，而不是用字串或數字代替。

這個 App 中，使用者可以是主管、員工、人資或系統管理員，每種角色有不同的功能權限與 UI 呈現。

課程前：這些角色以原始字串散落在各處，`if role == "Manager"` 這樣的判斷到處都是。

課程後：

```swift
enum UserType {
    case manager
    case employee
    case hr
    case admin
    case unknown
}
```

一旦領域概念有了型別，測試就變得直觀：

```swift
func test_getUserType_hr_returnsHREnum() {
    sut.save(key: "userType", value: "HR")
    XCTAssertEqual(sut.getUserType(), .hr)
}
```

更重要的是，編譯器開始幫你抓那些字串永遠抓不到的錯誤。

---

## TestDouble：隔離 UIKit 依賴

課程講得很清楚：真實的 UIKit 物件不屬於單元測試。我們為測試建立了輕量的替代品：

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

透過這些 Mock，可以驗證登入後是否推入了正確的 VC、資料更新後 TableView 是否正確刷新——不需要啟動任何真實的 UI 畫面，測試速度快，結果穩定。

---

## 模組化設計：Coordinator Pattern

課程前，Navigation 是大家的責任，也是沒有人的責任。ViewController 直接呼叫 `navigationController?.pushViewController(...)`，每個畫面都需要知道下一個畫面是誰。

Coordinator Pattern 把這個職責集中起來：

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

`AppCoordinator` 集中管理 App 的流程決策：

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

ViewController 現在只負責自己的畫面邏輯，不再需要知道 App 的下一步是什麼。Navigation 邏輯可以被獨立測試；VC 也因為少了這個依賴而更容易測試、更容易替換。

*(在這裡插入圖片：coordinator-flow.png)*
<!-- Gemini prompt: A warm Ghibli-inspired illustration. A chibi character in work clothes stands at the center, holding a conductor's baton like an orchestra conductor, coordinating smaller chibi characters around them. The central character is labeled "AppCoordinator". The surrounding characters are labeled "LoginCoordinator", "TabCoordinator", "LoginViewController", and "LeaveViewController", connected by softly glowing lines. The ViewController characters focus only on their own task cards and don't need to look at anyone else. Warm beige background, cheerful and relaxed atmosphere. Soft pastel colors, white background, 16:9 ratio. -->

---

## 現實的阻力

課程說這個階段會不舒服，確實如此。

**「我們沒時間寫測試。」** 這個反對聲音出現得很早。我沒有用理論反駁，而是等待機會。後來一個日期計算的 bug 被測試在 code review 前抓住——那之後，這個討論就再也沒出現過。

**「舊程式碼根本沒辦法測試。」** 這是事實。但這不是拒絕的理由。解法是：先從今天寫的新程式碼開始，不要試圖一次測完所有東西。讓新增的部分變好，舊的部分慢慢跟上。

**「重構現有的 VC 太危險。」** 沒有測試的程式碼，任何重構都是在賭博。答案是：先寫 Characterization Test 把現有行為固定住，再放心地重構。

---

## 結語

在工作中落實所學，從來不像課程範例那樣乾淨。

你面對的是真實的 deadline、legacy 程式碼、以及有不同優先順序的隊友。不會有人給你一週的時間「把架構整理好」，改善只能在日常的開發工作中悄悄發生。

但這些模式是有效的。

每一個被提取出來的方法，就是一個可以被測試的邏輯單元。每一個 Coordinator，就是從 ViewController 中拿走的一個職責。每一個 TestDouble，就是從測試中移除的一個真實依賴。複利效應很慢，但它是真實的。

課程給了我語彙和模式，工作專案給了我練習和證明。

*(在這裡插入圖片：before-after.png)*
<!-- Gemini prompt: A warm Ghibli-inspired illustration with a left-right contrast layout. Left half "Before" in soft warm red tones: a tired chibi developer drowning in scattered code papers labeled push(...), "Manager", and UserDefaults.standard, looking overwhelmed. Right half "After" in soft cool green tones: the same chibi developer looks relaxed, with neatly arranged cards labeled UserType, Coordinator, and Test Passed on the desk, a small green light glowing nearby. A dashed line divides the two worlds in the middle. Soft pastel colors, white background, 16:9 ratio. -->

---

感謝閱讀。如果你也正在嘗試把課程所學帶回工作，歡迎留言分享你的經驗。

---

## 知識來源

本文的核心概念（TDD、領域建模、TestDouble、Coordinator Pattern、依賴注入）源自 **[iOS Lead Essentials](https://www.essentialdeveloper.com/ios-lead-essentials)** 課程。

文章中的程式碼範例（`LeaveListViewController`、`UserDefaultsUtilities`、`NavigationControllerMock`、`AppCoordinator` 等）源自本人實際工作專案，依課程概念重構後去識別化呈現。
