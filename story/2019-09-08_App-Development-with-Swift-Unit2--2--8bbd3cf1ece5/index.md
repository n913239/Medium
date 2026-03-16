---
title: App Development with Swift Unit2 (2)
description: iOS 12 Edition
date: '2019-09-08T05:24:54.000Z'
categories: []
keywords: []
slug: /@n913239/app-development-with-swift-unit2-2-8bbd3cf1ece5
---

iOS 12 Edition

#### Unit2 (2.6–2.10)

此篇的內容是記錄觀看Apple 開發電子書所做的筆記，觀看的版本是2019年的iOS 12版。

> _本文將延續前一篇文章做後續介紹_

[**App Development with Swift Unit2 (1)**  
_iOS 12 Edition_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/app-development-with-swift-unit2-1-34bf8f21a9ed "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/app-development-with-swift-unit2-1-34bf8f21a9ed")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/app-development-with-swift-unit2-1-34bf8f21a9ed)

首先是Unit2的學習重點

![](1__oNhABkk__BOvFh22VbrJdWg.png)

官方版重點

```
| 學習重點 |2019年7月30日 （第 113 頁）// Swift LessonsStringsFunctionsStructuresClasses and InheritanceCollectionsLoops// SDK LessonsIntroduction to UIKitDisplaying DataControls in ActionAuto layout and Stack Views// What You'll BuildApple Pie is a simple word-guessing game, where the user must guess a word, letter by letter, before all the apples fall off of the apple tree. If there are apples remaining, the user wins—and can eat delicious Apple Pie.
```

#### 2.6 「Loops」

主要介紹

*   使用迴圈
*   使用range
*   迴圈條件設定

參考文件

[**Control Flow - The Swift Programming Language (Swift 5.1)**  
_Swift provides a variety of control flow statements. These include while loops to perform a task multiple times; if …_docs.swift.org](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID121 "https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID121")[](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID121)

[**Control Flow - The Swift Programming Language (Swift 5.1)**  
_Swift provides a variety of control flow statements. These include while loops to perform a task multiple times; if …_docs.swift.org](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID124 "https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID124")[](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID124)

> For Loops

```
for index in 1...5 {    print("This is number \(index)")}
```

```
for _ in 1..<4 {    print("Hello!")}
```

```
let names = [“Joseph”, “Cathy”, “Winston”]for name in names {    print(“Hello \(name)”)}
```

```
for letter in “ABCD” {    print(“The letter is \(letter)”)}
```

```
for (index, letter) in “ABCD”.enumerated() {    print(“\(index): \(letter)”)}
```

```
let vehicles = [“unicycle” 1, “bicycle” : 2, “tricycle” : 3, “quad bike” : 4]for (vehicleName, wheelCount) in vehicles {    print (“A \(vehicleName) has \(wheelCount) wheels”)}
```

> While Loops

```
var numberOfLives = 3while numberOfLives > 0 {    playMove()    updateLivesCount()}
```

> Control Transfer Statements

```
// break will break the code execution within the loop//Prints -3 throughfor counter in -3...3 {    print(counter)    if counter == 0 {        break    }}
```

```
// continue will move onto the next iteration.for person in people {    if person.age < 18 {    continue    }    sendEmail (to: person)}
```

> 2.7 「Introduction to UIKit」

主要介紹

*   UIKit介紹
*   UIKit Controls介紹

參考文件

[**Themes - iOS - Human Interface Guidelines - Apple Developer**  
_Aesthetic integrity represents how well an app's appearance and behavior integrate with its function. For example, an…_developer.apple.com](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/ "https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/")[](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)

> View Hierachy

![](0__jvjd98zxgabsvx2d.png)

> Common System View

以下圖片資料來源為[Apple 官方電子書](https://books.apple.com/tw/book/app-development-with-swift/id1465002990)

*   Label (UILabel)

![](0__0hN82T9LvAEQuh__a.png)

*   Image View (UIImageView)

![](0__hlwy92__9BnBS50ng.png)

*   Text View (UITextView)

![](0__mmmaaN7Sm1RrUtkH.png)

*   Scroll View (UIScrollView)

![](0__jMu3jCG8cXAiXG8M.png)

*   Table View (UITableView)

![](0__trwuegWkarOSEwfb.png)

*   Toolbars (UIToolbar)

![](0__tsijxMHc__Zv8wLG__.png)

*   Navigation Bars (UINavigationBar)

[https://developer.apple.com/documentation/uikit/uinavigationbar](https://developer.apple.com/documentation/uikit/uinavigationbar)

![](0__M2xiLx8iIRgp93A3.png)

*   Tab Bars (UITabBar)

[https://developer.apple.com/documentation/uikit/uitabbar](https://developer.apple.com/documentation/uikit/uitabbar)

![](0__07__9c__6tEQpT4DaQ.png)

> Contorls

*   Button (UIButton)

[https://developer.apple.com/documentation/uikit/uibutton](https://developer.apple.com/documentation/uikit/uibutton)

![](0__3k__PIgIpG17CDHdQ.png)

*   Segmented Controls (UISegmented Control)

[https://developer.apple.com/documentation/uikit/uisegmentedcontrol](https://developer.apple.com/documentation/uikit/uisegmentedcontrol)

![](0__rj5ooRZMKLW0T6xn.png)

*   Text Fields (UIText Field)

[https://developer.apple.com/documentation/uikit/uitextfield](https://developer.apple.com/documentation/uikit/uitextfield)

![](0__mQjwkEn3zG6dBj6A.png)

*   Sliders (UISlider)

[https://developer.apple.com/documentation/uikit/uislider](https://developer.apple.com/documentation/uikit/uislider)

![](0__Pzkh8YTHV8Zhcic8.png)

*   Switches (UISwitch)

[https://developer.apple.com/documentation/uikit/uiswitch](https://developer.apple.com/documentation/uikit/uiswitch)

![](0__JeEiTWEWN4mjOx6X.png)

*   Date Pickers (UIDatePicker)

[https://developer.apple.com/documentation/uikit/uidatepicker](https://developer.apple.com/documentation/uikit/uidatepicker)

![](0__4b25U9AD7oVd8fzH.png)

> View Controllers

*   UIViewController

[https://developer.apple.com/documentation/uikit/uiviewcontroller](https://developer.apple.com/documentation/uikit/uiviewcontroller)

#### 2.8 「Displaying Data」

主要介紹

*   Interface Builder介紹
*   使用Label, UIImageView

> 顯示資料

*   Label
*   Text View
*   UIImage

#### 2.9 「Controls In Action」

主要介紹

*   使用Button, Slider, TextView

> Common input Controls

*   IBAction

![](0__rkpJ0E60tOUZ0tu2.png)

```
@IBAction func buttonTapped ( sender: Any) {    print(“Button was tapped!”)}
```

*   Switch

![](0__spvae0cUwYT0kj56.png)

```
@IBAction func switchToggled (_ sender: UISwitch) {    if sender.isOn {        print(“The switch is on!”)    } else {    print (“The switch is off.”)    }}
```

*   Sliders

![](0__ZdG5hFaQoW5TFNX3.png)

```
@IBAction func sliderValueChanged (_ sender: UISlider) {    print (sender.value)}
```

*   Text Field

![](0__G88hkqgDApB25LmM.png)

```
@IBAction func keyboardReturnKeyTapped (_ sender: UIText Field) {    if let text = sender.text {        print (text)    }}
```

```
@IBAction func textChanged(_ sender: UITextField) {    if let text = sender.text {        print (text)    }}
```

> Actions And Outlets

```
@IBOutlet var toggle: UISwitch!@IBOutlet var slider: UISlider!
```

```
@IBAction func buttonTapped (_ sender: UIButton) {    print (“Button was tapped!”)
```

```
    if toggle.isOn {        print (“The switch is on!”)    } else {        print(“The switch is off.”)    }    print (“The slider is set to \(slider.value)”)}
```

*   Gesture Recognizers

![](0__Yb60tXis__j7ALJh0.png)

*   Programmatic Actions

```
button.addTarget(self, action: #selector (button Tapped (_:)), for: .touchUpInside)
```

*   LAB-Basic Interactions

```
class ViewController: UIViewController {
```

```
    @IBOutlet var textField: UITextField!    @IBOutlet var label: UILabel!    @IBOutlet var setTextButton: UIButton!        override func viewDidLoad() {        super.viewDidLoad()                setTextButton.addTarget(self, action: #selector (setTextButtonTapped(_:)), for: .touchUpInside)    }        @IBAction func setTextButtonTapped(_ sender: UIButton) {        label.text = textField.text    }        @IBAction func clearTextButtonTapped(_ sender: Any) {        textField.text = ""        label.text = ""    }}
```

#### 2.10 「Auto Layout and Stack Views」

主要介紹

*   Auto Layout 簡介
*   Stack View 簡介
*   建立約束

參考文件

[**Understanding Auto Layout**  
_Auto Layout dynamically calculates the size and position of all the views in your view hierarchy, based on constraints…_developer.apple.com](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/ "https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/")[](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/)

[**UIStackView**  
_Stack views let you leverage the power of Auto Layout, creating user interfaces that can dynamically adapt to the…_developer.apple.com](https://developer.apple.com/documentation/uikit/uistackview "https://developer.apple.com/documentation/uikit/uistackview")[](https://developer.apple.com/documentation/uikit/uistackview)

[**UITraitCollection**  
_Declaration The iOS trait environment is exposed though the property of the protocol. This protocol is adopted by the…_developer.apple.com](https://developer.apple.com/documentation/uikit/uitraitcollection "https://developer.apple.com/documentation/uikit/uitraitcollection")[](https://developer.apple.com/documentation/uikit/uitraitcollection)

[**Getting Started with Multitasking on iPad in iOS 9 - WWDC 2015 - Videos - Apple Developer**  
_iOS 9 on iPad introduces the ability to view and interact with more than one app at a time. Discover how to update your…_developer.apple.com](https://developer.apple.com/videos/play/wwdc2015/205/ "https://developer.apple.com/videos/play/wwdc2015/205/")[](https://developer.apple.com/videos/play/wwdc2015/205/)

> Stack View Attributes

![](0__t3QP6Hqv3JqWDMR6.png)

> Calculator 實作練習

[**chiron-wang/AppDevelopment2019**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/AppDevelopment2019/tree/master/Unit2/Calculator "https://github.com/chiron-wang/AppDevelopment2019/tree/master/Unit2/Calculator")[](https://github.com/chiron-wang/AppDevelopment2019/tree/master/Unit2/Calculator)

#### Apple Pie Project

算是整個Unit2的總結，與一個比較大的練習，在這個練習中會學習到Stack View的使用，以及基本的Auto Layout，素材與程式碼都可以在書中找到，如果做到一半卡關，也可以參考教師版本。

> 猜字母的遊戲

*   注意版面的設計
*   Stack View 的排版運用
*   畫面與程式碼的連結 Outlet & Actions

![](0__mFWD2gEHuS1cYzhF.png)

#### Github

[**chiron-wang/AppDevelopment2019**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/AppDevelopment2019 "https://github.com/chiron-wang/AppDevelopment2019")[](https://github.com/chiron-wang/AppDevelopment2019)

#### Reference

[**‎App Development with Swift**  
_‎This course is designed to teach you the skills needed to be an app developer capable of bringing your own ideas to…_books.apple.com](https://books.apple.com/tw/book/app-development-with-swift/id1465002990 "https://books.apple.com/tw/book/app-development-with-swift/id1465002990")[](https://books.apple.com/tw/book/app-development-with-swift/id1465002990)

[**‎App Development with Swift Teacher Guide**  
_‎This Teacher Guide, a companion to the two-semester long App Development with Swift course, is designed for you to use…_books.apple.com](https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285 "https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285")[](https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285)