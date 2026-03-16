---
title: IOSLight App － 實作練習
description: 今天的作業是Ligth App的練習，參考peterpan的文章，
date: '2017-08-07T02:56:24.453Z'
categories: []
keywords: []
slug: /@n913239/ioslight-app-%E5%AF%A6%E4%BD%9C%E7%B7%B4%E7%BF%92-63507dbde5ad
---

今天的作業是Ligth App的練習，參考peterpan的文章，

**練習重點如下：**

> 目的:   
> 基本題: 研讀 Apple 官方電子書 App Development with Swift 第一章，完成它的 Guided Project，Light，學習 IBOutlet 和 IBAction。  
> 進階題: 學習 UIColor 物件，UIImage 物件和亂數。

首先我們參考Apple官方電子書，先來實作一個簡易版本

主要是透過一個Bool型別的property來存放現在的狀態，共有黑(false)白(true)兩色，並且透過Tap Gesture來連結Action

**簡易版完成圖：**

![](1__rer5C2ctTrq4gKJX8c5Icg.gif)

**接者我們練習有七色彩虹的進階版本**，這邊用到的三個變數與一個func，

> randomNumber： 用來產生亂數 (別忘了import GameplayKit)

> colorIndex： 存放目前的顏色索引

> rainbowColors： 用來存放七種顏色的彩虹以及RGB數值的Dictionary

> setRainbowColor()： 設定七色彩虹的背景顏色

首先在App啟動的時候，先產生一個亂數的顏色，接者後面點擊，會依據彩虹顏色的順序(紅,橙,紅,綠,藍,靛,紫)，來修改背景色

**進階版完成圖：**

![](1__wAKvINyu0wf1vcVQ1VRHFQ.gif)

**GitHub：**

[**n913239/Light**  
_Contribute to Light development by creating an account on GitHub._github.com](https://github.com/n913239/Light "https://github.com/n913239/Light")[](https://github.com/n913239/Light)

**參考資料：**

1\. peterpan

[**#7 Light App**  
_目的:   
基本題: 研讀 Apple 官方電子書 App Development with Swift 第一章，完成它的 Guided Project，Light，學習 IBOutlet 和 IBAction。  
進階題: 學…_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/7-light-app-9202ba830172 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/7-light-app-9202ba830172")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/7-light-app-9202ba830172)

2\. Apple電子書

[**App Development with Swift by Apple Education on iBooks**  
_Read a free sample or buy App Development with Swift by Apple Education. You can read this book with iBooks on your…_itunes.apple.com](https://itunes.apple.com/tw/book/app-development-with-swift/id1219117996?mt=11 "https://itunes.apple.com/tw/book/app-development-with-swift/id1219117996?mt=11")[](https://itunes.apple.com/tw/book/app-development-with-swift/id1219117996?mt=11)

3\. Apple開發者文件UIColor

[**UIColor - UIKit | Apple Developer Documentation**  
_The most common way to use a object is to provide it to some other object in UIKit. For example, the class (and its…_developer.apple.com](https://developer.apple.com/documentation/uikit/uicolor "https://developer.apple.com/documentation/uikit/uicolor")[](https://developer.apple.com/documentation/uikit/uicolor)