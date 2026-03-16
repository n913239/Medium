---
title: 網路與Api測試的零散筆記
description: UrlSession/Api/Constraint
date: '2020-03-03T08:55:28.447Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E7%B6%B2%E8%B7%AF%E8%88%87api%E6%B8%AC%E8%A9%A6%E7%9A%84%E9%9B%B6%E6%95%A3%E7%AD%86%E8%A8%98-561755cbb640
---

UrlSession/Api/Constraint

#### 前言

這一段時間事情不少，因此也很久沒有寫文章了，就寫篇文章，來記錄一下最近練習的幾個簡單項目，關於細節內容，請直接參考程式碼。

#### 練習項目

由於對應到各自字的ViewController內，因此就採用VC來做簡單的分類，當然有些重複練習的功能項目，就不會重複列出。

**ViewController**

*   程式碼加入UIButton, StackView
*   使用程式碼設定constraint, widthAnchor, heightAnchor, centerXAnchor, centerYAnchor…

![](1__HFLRQFdYPZs04W8kQaoDWQ.png)

**PhotoViewController**

*   使用URLSession下載圖片，並設定到畫面上的四個UIImageView
*   設定UI必須在主執行緒中執行

DispatchQueue.main.async {

  configUI()

}

![](1__YKzy8ExeZH20B5IBSMVVrg.png)

**MemeViewController**

*   練習呼叫MemeAPI
*   練習解析ISO8601的時間格式 (DateFormatter)

ref:

[https://some-random-api.ml/meme](https://some-random-api.ml/meme)

![](1__M4HDqQKyGxGx3wgf80zLgw.png)

**SongViewController**

*   練習呼叫Api中帶有中文字的處理
*   使用JSONDecoder()解析呼叫Api結果
*   練習播放/停止 下載的音樂
*   結果陣列中亂數取出其中一個
*   練習參數completionHandler() 傳入func

ref:

https://itunes.apple.com/search?term=戴佩妮&media=music

![](1__e98mWQF8RSITyQKpDFk8hg.png)

**SongTableViewController**

*   練習使用Xib來建立UITableViewController & UITableViewCell
*   在viewDidLoad()中註冊Cell
*   使用propertyKeys來存放對應的key名稱
*   練習static let shared = XXX的風格程式碼
*   練習titleForHeaderInSection => 從JSON中取得
*   使用section分群，分群條件為作者名稱
*   使用IndexPath.row來取得作者的每一首歌曲
*   練習DateFormatter()指定時間格式 (yyyy/MM/dd)

![](1__B3YGKurLsRs__yjGEApz57Q.png)

**其他練習**

**套件 netfox**

*   在AppDelegate啟動
*   手機或模擬器搖晃，可以叫出call Api的資料(request, response…)
*   Podfile修改，在iOS13遇到啟動閃退問題，加入以下兩行

#use\_frameworks!

use\_modular\_headers!

**Model建立練習，並遵從 Codable rotocol**

*   Mame
*   Song => 遵從 Hashable，後面篩選資料用
*   加入func == (lhs:rhs:), func hash(into:inout:)

**Helpers 共用程式庫引入**

*   搭配git submodule

使用方式參考：

[**chiron-wang/SwiftHelpers**  
_Swift Helpers. Contribute to chiron-wang/SwiftHelpers development by creating an account on GitHub._github.com](https://github.com/chiron-wang/SwiftHelpers "https://github.com/chiron-wang/SwiftHelpers")[](https://github.com/chiron-wang/SwiftHelpers)

**extension練習**

*   加入 Array+removeDuplicates.swift
*   命名風格為『型別 + 方法』

ref:

[**How to remove duplicate items from an array**  
_Swift version: 5.1 Paul Hudson @twostraws There are several ways of removing duplicate items from an array, but one of…_www.hackingwithswift.com](https://www.hackingwithswift.com/example-code/language/how-to-remove-duplicate-items-from-an-array "https://www.hackingwithswift.com/example-code/language/how-to-remove-duplicate-items-from-an-array")[](https://www.hackingwithswift.com/example-code/language/how-to-remove-duplicate-items-from-an-array)

#### 總結

本文中所做的內容，大部分都是看教材一邊練習的簡單功能，

嘗試接了幾隻線上的API(Meme, Itunes..)，而程式碼並沒有特別做過整理，

請多多包涵。

而練習的過程中，發現許多程式碼的寫法，是Swift語言的風格，以及參考Apple官方文件的風格所寫，看一些別人的專案，會發現大家也都有類似的風格。

也可以參考Raywenderlich的這一篇。

[**raywenderlich/swift-style-guide**  
_This style guide is different from others you may see, because the focus is centered on readability for print and the…_github.com](https://github.com/raywenderlich/swift-style-guide#function-declarations "https://github.com/raywenderlich/swift-style-guide#function-declarations")[](https://github.com/raywenderlich/swift-style-guide#function-declarations)

#### GitHub

[**chiron-wang/NetworkTest**  
_Network test lab. 程式碼加入UIButton, StackView 使用程式碼設定constraint, widthAnchor, heightAnchor, centerXAnchor…_github.com](https://github.com/chiron-wang/NetworkTest "https://github.com/chiron-wang/NetworkTest")[](https://github.com/chiron-wang/NetworkTest)