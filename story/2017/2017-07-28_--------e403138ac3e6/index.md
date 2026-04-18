---
title: 格子計算的練習
description: 這是一個8*8的二維陣列的故事，首先我們會先定義一個Int的二維陣列，並在陣列中填入行數與列數相乘的數值，接者開始計算總和的三個練習
date: '2017-07-28T12:09:58.645Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E6%A0%BC%E5%AD%90%E8%A8%88%E7%AE%97%E7%9A%84%E7%B7%B4%E7%BF%92-e403138ac3e6
---

這是一個8\*8的二維陣列的故事，首先我們會先定義一個Int的二維陣列，  
並在陣列中填入行數與列數相乘的數值，接者開始計算總和的三個練習

**陣列的資料圖：**

![](1__6gogGI4PKP3TGjhmgwQuoQ.png)

> 可以看到陣列內的數值，其實就是行數與列數的相乘結果

**練習一，算全部格子的總和：**

我們要將所有行列中的數，全部做加傯

**練習二，奇數行的數字總合：**

我們一樣要算出所有奇數行的數字加總，可以採用where條件的方式來做篩選

**練習三，所有格子的總合，除列數>=行數的格子：**

一樣是所有格子的數做加總，但是加上了排除列數≥行數格子的條件

在這個格子的練習中，我們學習到了陣列以及迴圈的應用，而apple的官方電子書還有許多Collection的用法與介紹，有時間的話可以慢慢細讀，相信可以得到更多啟發，以及更進階的寫法。

**小技巧筆記：**

1.  參考彼得潘的顯示彩色程式碼
2.  apple官方電子書
3.  stackoverflow也有很多問題的解答

**GitHub**：

[**n913239/_Lab-for-Swift-Function_**  
Lab-for-Swift-Functiongithub.com](https://github.com/n913239/Lab-for-Swift-Function "https://github.com/n913239/Lab-for-Swift-Function")[](https://github.com/n913239/Lab-for-Swift-Function)

**參考資料：**

1\. Apple官方電子書

[**The Swift Programming Language (Swift 4): Collection Types**  
_The definitive guide to Swift, Apple's programming language for building iOS, macOS, watchOS, and tvOS apps._developer.apple.com](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID105 "https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID105")[](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID105)

2\. Tony Yeh的文章

[**\[swift\] 練習計算格子內數字的總和**  
_算全部格子的總和_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/swift-%E7%B7%B4%E7%BF%92%E8%A8%88%E7%AE%97%E6%A0%BC%E5%AD%90%E5%85%A7%E6%95%B8%E5%AD%97%E7%9A%84%E7%B8%BD%E5%92%8C-4068f727a30a "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/swift-%E7%B7%B4%E7%BF%92%E8%A8%88%E7%AE%97%E6%A0%BC%E5%AD%90%E5%85%A7%E6%95%B8%E5%AD%97%E7%9A%84%E7%B8%BD%E5%92%8C-4068f727a30a")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/swift-%E7%B7%B4%E7%BF%92%E8%A8%88%E7%AE%97%E6%A0%BC%E5%AD%90%E5%85%A7%E6%95%B8%E5%AD%97%E7%9A%84%E7%B8%BD%E5%92%8C-4068f727a30a)

3\. 顯示漂亮的彩色程式碼

[**在 Medium 顯示彩色的 Swift 程式碼**  
_搭配 gist 可顯示彩色的程式碼片段，方法如下:_medium.com](https://medium.com/@apppeterpan/%E5%9C%A8-medium-%E9%A1%AF%E7%A4%BA%E5%BD%A9%E8%89%B2%E7%9A%84-swift-%E7%A8%8B%E5%BC%8F%E7%A2%BC-26b18e93b65 "https://medium.com/@apppeterpan/%E5%9C%A8-medium-%E9%A1%AF%E7%A4%BA%E5%BD%A9%E8%89%B2%E7%9A%84-swift-%E7%A8%8B%E5%BC%8F%E7%A2%BC-26b18e93b65")[](https://medium.com/@apppeterpan/%E5%9C%A8-medium-%E9%A1%AF%E7%A4%BA%E5%BD%A9%E8%89%B2%E7%9A%84-swift-%E7%A8%8B%E5%BC%8F%E7%A2%BC-26b18e93b65)

4\. enumerated()方法

[**enumerated() - Array | Apple Developer Documentation**  
_Returns a sequence of pairs ( n, x), where n represents a consecutive integer starting at zero, and x represents an…_developer.apple.com](https://developer.apple.com/documentation/swift/array/1687832-enumerated "https://developer.apple.com/documentation/swift/array/1687832-enumerated")[](https://developer.apple.com/documentation/swift/array/1687832-enumerated)