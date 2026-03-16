---
title: 研讀 Intro To App Development with Swift Lesson 18 Adaptive User Interfaces
description: 今天的文章是研讀Apple電子書L18的一些心得與實作部分，這個章節主要是介紹AutoLayout與stackview的使用，並有幾個實作的Lab。
date: '2017-08-11T10:52:08.214Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E7%A0%94%E8%AE%80-intro-to-app-development-with-swift-lesson-18-adaptive-user-interfaces-94511595cd12
---

今天的文章是研讀Apple電子書L18的一些心得與實作部分，  
這個章節主要是介紹AutoLayout與stackview的使用，  
並有幾個實作的Lab。

首先我們先來看看

**大綱：**

> 18.1 SimpleCenter

> 18.2 ElementQuiz

> 18.3 AnimalSounds

首先在18.1的部分，有一個簡單的實作，主要是利用Align來達成水平與垂直置中的效果。  
在18.2的章節中，做了一個簡單的問答App，並使用了StackView來幫助完成AutoLayout的排版。  
最後是18.3的部分，有一個很好玩的AniamlSound，可以透過點擊動物的圖片，來發出叫聲，同時我們也會練習到如何讓App發出聲音。  
在練習中都採用Iphone 4S來做 main.storyboard的裝置，在後面的內容也提到了，可以先採用較小的裝置來做設計，也是一個不錯的技巧。另外，在Xcode 9 Beta5的版本中，將檔案拉進去的時候，似乎不會自動做連結。此時，可以到Build Phases視窗中，自行增加。

**完成圖：**

![](1__gFkEJ7dk8ZiWVUUrB9HmXQ.png)
![](1__1vS2DEH3aTDSdbN2h__kK__w.png)
![](1__hGkOxMrzycafTdaMIqerlQ.png)

**操作示意圖：**

![](1__33TzCC4CqPDBqXcxkzcgRg.gif)

在18.3的Lab中，透過了『restorationIdentifier』來做識別，所以三個動物按鈕，只需要建立一個方法：

**小技巧筆記：**

1.  按下『Ctrl + Cmd + Space』，可以快速叫出Emoji的字元視窗
2.  可以在App的設定視窗中，裡面的Build Phases中，來確認Bundle Resource的相關資源
3.  在UIButton中，可以用『restorationIdentifier』或『currentTitle』來識別，被按下的是哪一個按鈕

**GitHub：**

[**n913239/Lab-for-Adaptive-User-Interfaces**  
_Contribute to Lab-for-Adaptive-User-Interfaces development by creating an account on GitHub._github.com](https://github.com/n913239/Lab-for-Adaptive-User-Interfaces "https://github.com/n913239/Lab-for-Adaptive-User-Interfaces")[](https://github.com/n913239/Lab-for-Adaptive-User-Interfaces)

**參考資料：**

1.  Apple官方電子書

[**Intro to App Development with Swift by Apple Education on iBooks**  
_Read a free sample or buy Intro to App Development with Swift by Apple Education. You can read this book with iBooks on…_itunes.apple.com](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11 "https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11")[](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11)