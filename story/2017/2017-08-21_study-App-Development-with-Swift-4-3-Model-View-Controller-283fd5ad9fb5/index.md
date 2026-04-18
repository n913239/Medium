---
title: study App Development with Swift 4.3 Model View Controller
description: 今天依舊是讀書的好日子，身為一個(假)文青，總是要閱讀一些英文書籍……
date: '2017-08-21T05:08:34.931Z'
categories: []
keywords: []
slug: >-
  /@n913239/study-app-development-with-swift-4-3-model-view-controller-283fd5ad9fb5
---

今天依舊是讀書的好日子，身為一個(假)文青，  
總是要閱讀一些英文書籍……

先來看看

**名詞列表：**

> Abstraction：抽象化

> Architecture：框架(架構)

> Controller：控制器，為Model與View之間的協調者

> Model：模型，用於存放資料的物件

> Modal-View-Controller：MVC的一種設計模式

> View：泛指使用者的ＵＩ以及互動的部分

在內文中用了Meal這個生活化的項目，來做Controller與Model的相關介紹，  
例如列表清單的『MealListViewController』，以及進一步點擊後的明細項目『MealListViewController』，並採用了一個名稱為Meal的struct來當作Model。

最後會練習一個名為『FavoriteAthlete』的Lab，當中會練習到segue所觸發的prepare()方法，並傳入資料到下一個畫面內。以及透過unwind segue，來將編輯(新增)後的資料，帶回原本的畫面，並且轉場到原本的畫面。

**完成圖：**

![](1__7pUwSjlLKKubwYmjTYfLeQ.png)
![](1__pO1fDf9R0qgKk1SaRkzXrg.png)
![](1__e4ESGeOe7LShu7bRN9qgqg.png)

**操作示範：**

![](1__njv0FAbqY6ylUAY0J8ko__w.gif)

**小技巧筆記：**

1.  使用unwind segue有轉場回之前(N個)場景的能力，並且可以透過property的方式來帶值回原本的畫面
2.  使用『segue.source』可以取得轉場的觸發者  
    (轉場之前的原畫面 e.g. A => B 當中的A)
3.  可以使用『tableView.indexPathForSelectedRow』  
    來取得目前TableView所選取的Row
4.  可以使用『tableView.deselectRow』來取消選取的狀態

**GitHub：**

[**n913239/Study-App-Development-with-Swift**  
_Contribute to Study-App-Development-with-Swift development by creating an account on GitHub._github.com](https://github.com/n913239/Study-App-Development-with-Swift/tree/master/L4_3 "https://github.com/n913239/Study-App-Development-with-Swift/tree/master/L4_3")[](https://github.com/n913239/Study-App-Development-with-Swift/tree/master/L4_3)

**參考資料：**

1\. Apple官方電子書

[**Intro to App Development with Swift by Apple Education on iBooks**  
_Read a free sample or buy Intro to App Development with Swift by Apple Education. You can read this book with iBooks on…_itunes.apple.com](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11 "https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11")[](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11)

2\. Apple developer文章

[**Model-View-Controller**  
_A collection of short articles on the core concepts, patterns, and mechanisms in Cocoa programming._developer.apple.com](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html "https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html")[](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)