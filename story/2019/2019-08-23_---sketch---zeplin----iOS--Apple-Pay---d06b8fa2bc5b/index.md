---
title: 搭配 sketch & zeplin 製作 iOS 的Apple Pay畫面
description: Apple Pay
date: '2019-08-23T16:25:13.732Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E6%90%AD%E9%85%8D-sketch-zeplin-%E8%A3%BD%E4%BD%9C-ios-%E7%9A%84apple-pay%E7%95%AB%E9%9D%A2-d06b8fa2bc5b
---

### Apple Pay

今天的文章主要介紹，如果使用 sketch匯出到 ziplin 後，查看每個元件的大小以及間距，首先練習了健康App

[**搭配 sketch & zeplin 製作 iOS 的健康 App 和 App Store 畫面**  
_本篇文章的目標在讓剛學會 Storyboard 的朋友利用 sketch & zeplin，一步步模仿做出和 iOS 的健康 App 一模一樣的畫面。不過由於假設讀者還不會 Auto Layout 技術，因此接下來的教學將以做出符合…_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E6%90%AD%E9%85%8D-sketch-zeplin-%E8%A3%BD%E4%BD%9C-ios-%E7%9A%84%E5%81%A5%E5%BA%B7-app-%E7%95%AB%E9%9D%A2-b6f077b5a023 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E6%90%AD%E9%85%8D-sketch-zeplin-%E8%A3%BD%E4%BD%9C-ios-%E7%9A%84%E5%81%A5%E5%BA%B7-app-%E7%95%AB%E9%9D%A2-b6f077b5a023")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E6%90%AD%E9%85%8D-sketch-zeplin-%E8%A3%BD%E4%BD%9C-ios-%E7%9A%84%E5%81%A5%E5%BA%B7-app-%E7%95%AB%E9%9D%A2-b6f077b5a023)

對於整體有些熟悉之後，接者開始練習今日的Apple Pay，預計完成的成品  
如下圖

![](1__Qe5UJCrBc0knpq6fSBuYDQ.png)

看了畫面後，預計使用兩個ImageView ，一個Label，一個Button來實現本次的App 實作。在本畫面中，有幾個圖檔需要匯出，可以參考以下文章

[**如何將 sketch 畫面裡的圖片輸出到 zeplin，輸出 App 需要的 assets**  
_1 點選 sketch 裡想要輸出的圖片。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E5%B0%87-sketch-%E7%95%AB%E9%9D%A2%E8%A3%A1%E7%9A%84%E5%9C%96%E7%89%87%E8%BC%B8%E5%87%BA%E5%88%B0-zeplin-9faa86ce1c90 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E5%B0%87-sketch-%E7%95%AB%E9%9D%A2%E8%A3%A1%E7%9A%84%E5%9C%96%E7%89%87%E8%BC%B8%E5%87%BA%E5%88%B0-zeplin-9faa86ce1c90")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E5%B0%87-sketch-%E7%95%AB%E9%9D%A2%E8%A3%A1%E7%9A%84%E5%9C%96%E7%89%87%E8%BC%B8%E5%87%BA%E5%88%B0-zeplin-9faa86ce1c90)

將所需要的圖片素材都準備好之後，就可以開始今天的練習。

1\. 記得先把剛剛的圖片，匯入到Xcode的Assets中，接者透過Ziplin的畫面可以看到，上方信用卡的長寬分別為343 , 217，把他加入到App的畫面中，並設定對應的位置

![](1__xw__YgYOsRIInPcc4a6YNgQ.png)
![](1__oj9WWCZPYPh0kx755j20VQ.png)

2\. 接下來加入下方的按鈕，這邊直接使用一個UIButton，下方的文字使用UILabel，並參考對應的字體大小與字型

![](1__PhjephwyTs26MtyRl9hIJg.png)
![](1__VySFpp__ZdBEIXDgWi8kZLg.png)

3\. 重複步驟1，加入下方的UIImage

![](1__NI__mN0TQtNIwMyeDtXUgfg.png)

### 完成品

這個練習算比較簡單的，只有幾個元件，重點是了解UI中的元件大小位置，以及間距，這樣未來與設計師能夠做比較好的配合。

而這個練習中所使用的設備主要是 iPhone8，因此記得將storyboard中的device，以及模擬器一併調整為iPhone8

![](1__pJoLX4YDfbwdQqoGnoeQcg.png)

### GitHub:

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/ApplePayFake "https://github.com/chiron-wang/Peter13/tree/exercise/ApplePayFake")[](https://github.com/chiron-wang/Peter13/tree/exercise/ApplePayFake)

### Reference:

[**iOS 11 GUI for iPhone X and iPhone 8**  
_A massive collection of core components and over 60 (x2) selected screens found in the public release of iOS 11 made…_iosdesignkit.io](https://iosdesignkit.io/ios-11-gui/ "https://iosdesignkit.io/ios-11-gui/")[](https://iosdesignkit.io/ios-11-gui/)