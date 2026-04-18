---
title: >-
  研究 navigation controller 手勢觸發 bar 隱藏的功能: navigation controller 元件的 Hide Bars
  欄位
description: 現在我才知道……原來標題可以打這麼多字ＸＤＤＤＤ，沒錯，今天的目的就是研究bar 隱藏的功能。
date: '2017-07-29T15:19:14.143Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E7%A0%94%E7%A9%B6-navigation-controller-%E6%89%8B%E5%8B%A2%E8%A7%B8%E7%99%BC-bar-%E9%9A%B1%E8%97%8F%E7%9A%84%E5%8A%9F%E8%83%BD-navigation-controller-%E5%85%83%E4%BB%B6%E7%9A%84-hide-bars-%E6%AC%84%E4%BD%8D-dfbc31666927
---

**現在我才知道……  
**原來標題可以打這麼多字ＸＤＤＤＤ，  
沒錯，今天的目的就是研究bar 隱藏的功能。

> 分別有四種效果：  
> a.滑動觸發隱藏,   
> b.點擊觸發隱藏,   
> c.開啟鍵盤觸發隱藏,   
> d.切換到垂直緊密觸發隱藏Navigation Bar

按照慣例，先上圖

**Bar 尚未隱藏前：**

![](1__vLELIeG1NbtYUg8NaCl__cg.png)

**完成圖：**

![](1__eCZKAQSKforgp9GPicxcpg.gif)

**說明：**

從完成圖可以看到一開始畫面的上方有一個Bar( ̶b̶e̶e̶r̶B̶a̶r̶)，  
第一個隱藏Bar的方法，是滑動手勢來觸發隱藏Bar，  
緊接者第二個方法是點擊來觸發隱藏，  
第三個是切換螢幕方向來觸發隱藏，  
最後是開啟輸入鍵盤來觸發隱藏。  
由於要收合虛擬鍵盤，要透過寫程式的方式，在本範例中就先不示範了。

**小技巧筆記：**

1.  Apple開發者網站，可以快速搜尋需要的資料 (e.g. UIKit)
2.  Navigation Controller在程式碼內，也有對應的property可以設定
3.  原來medium的文章標題可以打很多很多字

**GitHub：**

[**n913239/NavigationHideBars**  
_Contribute to NavigationHideBars development by creating an account on GitHub._github.com](https://github.com/n913239/NavigationHideBars "https://github.com/n913239/NavigationHideBars")[](https://github.com/n913239/NavigationHideBars)

**參考資料：**

1\. Apple開發者網站 The Adaptive Model

[**View Controller Programming Guide for iOS: The Adaptive Model**  
_Explains how to use view controllers to implement radio, navigation, and modal interfaces._developer.apple.com](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/TheAdaptiveModel.html "https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/TheAdaptiveModel.html")[](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/TheAdaptiveModel.html)

2\. Apple開發者網站UINavationController

[**hidesBarsWhenVerticallyCompact - UINavigationController | Apple Developer Documentation**  
_When the value of this property is , the navigation controller hides its navigation bar and toolbar when it transitions…_developer.apple.com](https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621869-hidesbarswhenverticallycompact "https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621869-hidesbarswhenverticallycompact")[](https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621869-hidesbarswhenverticallycompact)

3\. Leo Shih大大的文章

[**作業3- 研究 navigation controller 手勢觸發 bar 隱藏的功能: navigation controller 元件的 Hide Bars 欄位**  
_Hide Bars是手勢觸發Navigation Bar隱藏的功能，_medium.com](https://medium.com/@lionshih/x%E4%BD%9C%E6%A5%AD3-%E7%A0%94%E7%A9%B6-navigation-controller-%E6%89%8B%E5%8B%A2%E8%A7%B8%E7%99%BC-bar-%E9%9A%B1%E8%97%8F%E7%9A%84%E5%8A%9F%E8%83%BD-navigation-controller-%E5%85%83%E4%BB%B6%E7%9A%84-hide-bars-%E6%AC%84%E4%BD%8D-b5dfda460a7d "https://medium.com/@lionshih/x%E4%BD%9C%E6%A5%AD3-%E7%A0%94%E7%A9%B6-navigation-controller-%E6%89%8B%E5%8B%A2%E8%A7%B8%E7%99%BC-bar-%E9%9A%B1%E8%97%8F%E7%9A%84%E5%8A%9F%E8%83%BD-navigation-controller-%E5%85%83%E4%BB%B6%E7%9A%84-hide-bars-%E6%AC%84%E4%BD%8D-b5dfda460a7d")[](https://medium.com/@lionshih/x%E4%BD%9C%E6%A5%AD3-%E7%A0%94%E7%A9%B6-navigation-controller-%E6%89%8B%E5%8B%A2%E8%A7%B8%E7%99%BC-bar-%E9%9A%B1%E8%97%8F%E7%9A%84%E5%8A%9F%E8%83%BD-navigation-controller-%E5%85%83%E4%BB%B6%E7%9A%84-hide-bars-%E6%AC%84%E4%BD%8D-b5dfda460a7d)

4\. IOS大小類別

[**\[iOS\] 大小類別 (Size Class)**  
_大小類別 (Size Class)是iOS 8新釋出的類別，主要目的是想要解決設備歧異的問題，透過實作Size Class，我們可以減少許多客製設備類別 (iPhone、iPad)與螢幕大小 (iPhone：3.5吋、4吋、4.7吋、5…_cg2010studio.com](https://cg2010studio.com/2014/12/13/ios-%E5%A4%A7%E5%B0%8F%E9%A1%9E%E5%88%A5-size-class/ "https://cg2010studio.com/2014/12/13/ios-%E5%A4%A7%E5%B0%8F%E9%A1%9E%E5%88%A5-size-class/")[](https://cg2010studio.com/2014/12/13/ios-%E5%A4%A7%E5%B0%8F%E9%A1%9E%E5%88%A5-size-class/)