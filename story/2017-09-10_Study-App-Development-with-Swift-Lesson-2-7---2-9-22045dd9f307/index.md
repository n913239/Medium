---
title: Study App Development with Swift Lesson 2.7 ~ 2.9
description: 今天閱讀的是Lesson 2.7，使用iPad來閱讀很方便，回到MAC會自動同步回來。
date: '2017-09-10T20:58:39.157Z'
categories: []
keywords: []
slug: /@n913239/study-intro-to-app-development-with-swift-lesson-2-7-22045dd9f307
---

今天閱讀的是Lesson 2.7，使用iPad來閱讀很方便，  
回到MAC會自動同步回來。

#### Lesson 2.7 Introduction to UIKit

**Vocabulary**

> button、control、control event、date picker、image view、

> UIKit、label、navigation bar、scroll view、segmented control、

> slider、switch、tab bar、table view、text field、toolbar

介紹的控制項(UILabel, UIImageView, TextView, UIScrollView, UITableView, UIToolbar, UINavigationBar, UITabBar, UIButton, Segmented Controls, UITextField, UISlider, UISwitch, UIDatePicker, UIViewController, )，

IBAction與UIControlEventPrimaryActionTriggered

#### Lesson 2.8 Displaying Data

**Vocabulary**

> aspect ratio、clipping、content mode、

> dynamic data、frame、static data

文字與圖片內容的控制項介紹，以及一個實作Hobby Tutorial.

![](1__8Jd__rTMJWTcNjEsUEd4Vqg.png)



#### Lesson 2.9 Controls In Action

**Vocabulary**

> gesture recognizer

Lab for CommonInputControls

IBAction & Outlet 連接的建立，UIButton的Touch Up Inside事件

熟悉控制項的事件(UIButton, UISwitch, UISlider, UITapGestureRecognizer)

UITapGestureRecognizer的Taps & Touches & location

UIButton在viewDidLoad()內手動註冊事件 ( .addTarget() )

// add button event  
button.addTarget(self, action: #selector(buttonTapped(\_:)), for: .touchUpInside)

在Lesson有一個簡單的實作，在Lesson 2.9也有兩個實作，主要是熟悉基本控制項的事件，包含了Outlet & Action，也介紹了UIButton怎麼手動註冊事件，做完練習之後會有初步的認識，實作的專案，在對應的資料夾內。

**GitHub：**

[**n913239/Study-App-Development-with-Swift**  
_Contribute to Study-App-Development-with-Swift development by creating an account on GitHub._github.com](https://github.com/n913239/Study-App-Development-with-Swift "https://github.com/n913239/Study-App-Development-with-Swift")[](https://github.com/n913239/Study-App-Development-with-Swift)

**參考資料：**

1.  Apple 電子書

[**Intro to App Development with Swift by Apple Education on iBooks**  
_Read a free sample or buy Intro to App Development with Swift by Apple Education. You can read this book with iBooks on…_itunes.apple.com](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11 "https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11")[](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11)