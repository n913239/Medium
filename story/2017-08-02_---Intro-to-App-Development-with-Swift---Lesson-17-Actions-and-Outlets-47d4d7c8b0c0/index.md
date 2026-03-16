---
title: 研讀 Intro to App Development with Swift 的 Lesson 17 Actions and Outlets
description: 今天的題目是蘋果的電子書其中一個章節研讀
date: '2017-08-02T16:52:05.301Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E7%A0%94%E8%AE%80-intro-to-app-development-with-swift-%E7%9A%84-lesson-17-actions-and-outlets-47d4d7c8b0c0
---

今天的題目是蘋果的電子書其中一個章節研讀

[**Intro to App Development with Swift by Apple Education on iBooks**  
_Read a free sample or buy Intro to App Development with Swift by Apple Education. You can read this book with iBooks on…_itunes.apple.com](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11 "https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11")[](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11)

**先列一下此章節的導覽**

> 17.1 如何建立 Outlet連接

> 17.2 如何建立 Action連接

> 17.3 多個Action & Outlet

> 17.4 Slider元件

> 17.5 Reset Button

> 17.6 介面美化 (拉皮)

這個章節主要是透過一個Project的練習，來熟悉Action與Outlet，要怎麼建立連結，或是切斷連結，以及幾個UI元件的使用。

**幾個注意事項：**

1.  驚嘆號exclamation point表示空的連接，會導致App的crash
2.  func中的sender ，指的就是觸發Action的實體(instance)，而sender的type會與元件相同(e.g. switch)
3.  在connection Inspector 可以點X 來切斷連接
4.  一個物件可以同時建立Action & Outlet
5.  客製化Switch

**總結：**

在閱讀 Apple電子書的時候，由於有一些看不懂的單字，可以搭配辭典查詢十分方便(OSX & IOS都有)。除了書中的圖片可以放大以外，有些地方還很貼心的附帶影片，可以讓讀者有更好的理解。

每一個小節的後面都有一個總結(Summary)，可以幫助讀者快速理解文章重點，在整個章節(Lession 17)全部看完以後，還有一個小測驗。透過練習，可以確認自己對整體內容理解度有多少，真的是很棒的設計。

參考蘋果的Project自己也實作了一個專案，不同的地方在於將畫面的美化部分，改寫在Main.storyboard裡面，原本的專案是寫在ViewDidLoad()的程式碼裡面。

**完成圖：**

![](1__JthzrJVzXc__5t4L5O1HmWA.gif)

**GitHub：**

[**n913239/ColorMix**  
_Contribute to ColorMix development by creating an account on GitHub._github.com](https://github.com/n913239/ColorMix "https://github.com/n913239/ColorMix")[](https://github.com/n913239/ColorMix)

**小技巧：**

1.  快速鍵Cmd + D 來快速複製
2.  『Option(Alt)』加上滑鼠點擊 Controller，可快速開啟Assistant Editor
3.  看英文電子書當然要搭配辭典，點兩下即可查詢單字

**參考資料：**

1\. Apple官方文件

[**UIView - UIKit | Apple Developer Documentation**  
_Normally, you create views in your storyboards by dragging them from the library to your canvas. You can also create…_developer.apple.com](https://developer.apple.com/documentation/uikit/uiview "https://developer.apple.com/documentation/uikit/uiview")[](https://developer.apple.com/documentation/uikit/uiview)

2\. Apple 電子書

[**Intro to App Development with Swift by Apple Education on iBooks**  
_Read a free sample or buy Intro to App Development with Swift by Apple Education. You can read this book with iBooks on…_itunes.apple.com](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11 "https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11")[](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11)

3\. Mac 內建字典安裝繁體英漢辭典

[**\[分享\] Mac 內建字典安裝繁體英漢辭典 - iPhone4.TW**  
_網誌好讀（無廣告）http://dairy.taskinghouse.com/posts/383137 如果使用 MacBook 系列筆電，或是 iMac 搭配了一個 Magic Trackpad，在 Mac 系統偏好設定中－觸控式軌跡…_iphone4.tw](http://iphone4.tw/forums/showthread.php?t=218236 "http://iphone4.tw/forums/showthread.php?t=218236")[](http://iphone4.tw/forums/showthread.php?t=218236)