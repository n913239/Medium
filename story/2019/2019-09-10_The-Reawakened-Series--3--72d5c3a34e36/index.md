---
title: The Reawakened Series (3)
description: '#42 埃及王子詩情畫意'
date: '2019-09-10T08:20:41.311Z'
categories: []
keywords: []
slug: /@n913239/the-reawakened-series-3-72d5c3a34e36
---

### #42 埃及王子詩情畫意

身為一個(假)文青，沒事讀兩句情詩也是合情合理

今天的練習是讓畫面一進入後，就自動朗讀畫面上的情詩

參考內容

[**#42 利用 iOS SDK 各式型別生成東西，設定它的屬性和呼叫方法**  
_目的: 學習利用 iOS SDK 各式型別生成東西，設定它的屬性和呼叫方法。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E5%88%A9%E7%94%A8-ios-sdk-%E5%90%84%E5%BC%8F%E5%9E%8B%E5%88%A5%E7%94%9F%E6%88%90%E6%9D%B1%E8%A5%BF-%E8%A8%AD%E5%AE%9A%E5%AE%83%E7%9A%84%E5%B1%AC%E6%80%A7%E5%92%8C%E5%91%BC%E5%8F%AB%E6%96%B9%E6%B3%95-1c10c80758a3 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E5%88%A9%E7%94%A8-ios-sdk-%E5%90%84%E5%BC%8F%E5%9E%8B%E5%88%A5%E7%94%9F%E6%88%90%E6%9D%B1%E8%A5%BF-%E8%A8%AD%E5%AE%9A%E5%AE%83%E7%9A%84%E5%B1%AC%E6%80%A7%E5%92%8C%E5%91%BC%E5%8F%AB%E6%96%B9%E6%B3%95-1c10c80758a3")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E5%88%A9%E7%94%A8-ios-sdk-%E5%90%84%E5%BC%8F%E5%9E%8B%E5%88%A5%E7%94%9F%E6%88%90%E6%9D%B1%E8%A5%BF-%E8%A8%AD%E5%AE%9A%E5%AE%83%E7%9A%84%E5%B1%AC%E6%80%A7%E5%92%8C%E5%91%BC%E5%8F%AB%E6%96%B9%E6%B3%95-1c10c80758a3)

此篇內容延續前一篇

[**The Reawakened Series (2)**  
_埃及王子叩酊趣_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/the-reawakened-series-2-c8ae9095466a "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/the-reawakened-series-2-c8ae9095466a")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/the-reawakened-series-2-c8ae9095466a)

#### 朗讀內容

![](1__nbs8fZg3ly6Ct4lyoSpHYg.png)

*   進入畫面會，會自動朗讀textView的埃及情詩

Poem1 — THE WINE OF LOVE

> An Ancient Egyptian Love Poem

> Oh! when my lady comes,

> And I with love behold her,

> I take her into my beating heart

> And in my arms enfold her;

> My heart is filled with joy divine

> For I am hers and she is mine.

> Oh! when her soft embraces

> Do give my love completeness,

> The perfumes of Arabia

> Anoint me with their sweetness;

> And when her lips are pressed to mine

> I am made drunk and need not wine.

#### 程式碼

簡易說明

*   由於每次進入畫面都要念情詩，因此寫在viewWillAppear()事件中
*   language 參考Apple文件為 BCP-47
*   由於三個畫面UI相同內容不同，因此UIViewController用同一個，Outlet也拉到同一個

![](1__9L____RMJUT0peRWEU0r__8ZQ.png)

#### Github

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/blob/exercise/Reawakened/README.md "https://github.com/chiron-wang/Peter13/blob/exercise/Reawakened/README.md")[](https://github.com/chiron-wang/Peter13/blob/exercise/Reawakened/README.md)

#### Reference

[**#42 利用 iOS SDK 各式型別生成東西，設定它的屬性和呼叫方法**  
_目的: 學習利用 iOS SDK 各式型別生成東西，設定它的屬性和呼叫方法。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E5%88%A9%E7%94%A8-ios-sdk-%E5%90%84%E5%BC%8F%E5%9E%8B%E5%88%A5%E7%94%9F%E6%88%90%E6%9D%B1%E8%A5%BF-%E8%A8%AD%E5%AE%9A%E5%AE%83%E7%9A%84%E5%B1%AC%E6%80%A7%E5%92%8C%E5%91%BC%E5%8F%AB%E6%96%B9%E6%B3%95-1c10c80758a3 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E5%88%A9%E7%94%A8-ios-sdk-%E5%90%84%E5%BC%8F%E5%9E%8B%E5%88%A5%E7%94%9F%E6%88%90%E6%9D%B1%E8%A5%BF-%E8%A8%AD%E5%AE%9A%E5%AE%83%E7%9A%84%E5%B1%AC%E6%80%A7%E5%92%8C%E5%91%BC%E5%8F%AB%E6%96%B9%E6%B3%95-1c10c80758a3")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E5%88%A9%E7%94%A8-ios-sdk-%E5%90%84%E5%BC%8F%E5%9E%8B%E5%88%A5%E7%94%9F%E6%88%90%E6%9D%B1%E8%A5%BF-%E8%A8%AD%E5%AE%9A%E5%AE%83%E7%9A%84%E5%B1%AC%E6%80%A7%E5%92%8C%E5%91%BC%E5%8F%AB%E6%96%B9%E6%B3%95-1c10c80758a3)