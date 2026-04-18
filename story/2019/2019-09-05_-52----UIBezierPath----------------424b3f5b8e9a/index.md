---
title: '#52 運用 UIBezierPath 繪製可愛圖案 — 荷魯斯之眼'
description: >-
  荷魯斯之眼又稱真知之眼、埃及烏加眼，是一個自古埃及時代便流傳至今的符號，也是古埃及文化中最令外人印象深刻的符號之一。荷魯斯之眼顧名思義，它是鷹頭神荷魯斯的眼睛。
date: '2019-09-05T21:39:31.342Z'
categories: []
keywords: []
slug: >-
  /@n913239/52-%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%8F%AF%E6%84%9B%E5%9C%96%E6%A1%88-%E8%8D%B7%E9%AD%AF%E6%96%AF%E4%B9%8B%E7%9C%BC-424b3f5b8e9a
---

> 荷魯斯之眼又稱真知之眼、埃及烏加眼，是一個自古埃及時代便流傳至今的符號，也是古埃及文化中最令外人印象深刻的符號之一。荷魯斯之眼顧名思義，它是鷹頭神荷魯斯的眼睛。

[**荷魯斯之眼**  
_荷魯斯之眼又稱 真知之眼、 埃及烏加眼，是一個自 古埃及時代便流傳至今的 符號，也是 古埃及文化中最令外人印象深刻的符號之一。荷魯斯之眼顧名思義，它是 鷹頭神 荷魯斯的眼睛。荷魯斯的右眼象徵完整無缺的太陽，依據傳說，因荷魯斯戰勝…_zh.wikipedia.org](https://zh.wikipedia.org/zh-tw/%E8%8D%B7%E9%AD%AF%E6%96%AF%E4%B9%8B%E7%9C%BC "https://zh.wikipedia.org/zh-tw/%E8%8D%B7%E9%AD%AF%E6%96%AF%E4%B9%8B%E7%9C%BC")[](https://zh.wikipedia.org/zh-tw/%E8%8D%B7%E9%AD%AF%E6%96%AF%E4%B9%8B%E7%9C%BC)

本文主要練習的是『運用 UIBezierPath 繪製可愛圖案』，

實作的項目是荷魯斯之眼

![](0__oI0gRz4tWLGsWPtf.jpg)

參考文章

[**#52 運用 UIBezierPath 繪製可愛圖案，比方雪人，米奇 & 可愛動物**  
_關於特殊形狀的繪製，可參考以下連結，本次作業主要使用連結裡提到的方法一 mask。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%8F%AF%E6%84%9B%E5%9C%96%E6%A1%88-%E6%AF%94%E6%96%B9%E9%9B%AA%E4%BA%BA-%E7%B1%B3%E5%A5%87-%E5%8F%AF%E6%84%9B%E5%8B%95%E7%89%A9-12d3a5ef1d6c "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%8F%AF%E6%84%9B%E5%9C%96%E6%A1%88-%E6%AF%94%E6%96%B9%E9%9B%AA%E4%BA%BA-%E7%B1%B3%E5%A5%87-%E5%8F%AF%E6%84%9B%E5%8B%95%E7%89%A9-12d3a5ef1d6c")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%8F%AF%E6%84%9B%E5%9C%96%E6%A1%88-%E6%AF%94%E6%96%B9%E9%9B%AA%E4%BA%BA-%E7%B1%B3%E5%A5%87-%E5%8F%AF%E6%84%9B%E5%8B%95%E7%89%A9-12d3a5ef1d6c)

#### 成品圖

![](1__B24IM3Zs0KNT8FuSTSwCtA.png)

本次練習主要用到的項目UIBezierPath，用來繪製線條(整體)以及區塊(眼睛)的部分，比較困難的點是，一開始不知道怎麼繪製線條，花了一些時間，而後面調整線條的曲度也花了些時間。

眼睛比較簡單，只要畫一個正方形並搭配ovalIn即可。

> 利用 UIBezierPath 的 init(ovalIn:) 繪製橢圓，參數 ovalIn 的長方形決定橢圓的寬高。

參考文章

[**運用 UIBezierPath 繪製各種形狀**  
_開發 iOS App 時，我們可以利用 UIBezierPath 繪製路徑，然後搭配 CAShapeLayer 做出任意形狀的 view。接下來我們先從基本的三角形開始，然後再一步步挑戰像是上弦月之類較為複雜的圖形吧。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676)

#### 程式碼

#### GitHub

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/Playground "https://github.com/chiron-wang/Peter13/tree/exercise/Playground")[](https://github.com/chiron-wang/Peter13/tree/exercise/Playground)

#### Reference

[**#52 運用 UIBezierPath 繪製可愛圖案，比方雪人，米奇 & 可愛動物**  
_關於特殊形狀的繪製，可參考以下連結，本次作業主要使用連結裡提到的方法一 mask。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%8F%AF%E6%84%9B%E5%9C%96%E6%A1%88-%E6%AF%94%E6%96%B9%E9%9B%AA%E4%BA%BA-%E7%B1%B3%E5%A5%87-%E5%8F%AF%E6%84%9B%E5%8B%95%E7%89%A9-12d3a5ef1d6c "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%8F%AF%E6%84%9B%E5%9C%96%E6%A1%88-%E6%AF%94%E6%96%B9%E9%9B%AA%E4%BA%BA-%E7%B1%B3%E5%A5%87-%E5%8F%AF%E6%84%9B%E5%8B%95%E7%89%A9-12d3a5ef1d6c")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%8F%AF%E6%84%9B%E5%9C%96%E6%A1%88-%E6%AF%94%E6%96%B9%E9%9B%AA%E4%BA%BA-%E7%B1%B3%E5%A5%87-%E5%8F%AF%E6%84%9B%E5%8B%95%E7%89%A9-12d3a5ef1d6c)

[**將 view 變成任意形狀的三種方法**  
_iOS 的 App 畫面因為有著各式各樣的元件而變得美麗，然而不管是 view，label，image view 還是 button，它們預設都是長方形的形狀。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%B0%87-view-%E8%AE%8A%E6%88%90%E4%BB%BB%E6%84%8F%E5%BD%A2%E7%8B%80%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95-d43e6e4b8fb5 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%B0%87-view-%E8%AE%8A%E6%88%90%E4%BB%BB%E6%84%8F%E5%BD%A2%E7%8B%80%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95-d43e6e4b8fb5")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%B0%87-view-%E8%AE%8A%E6%88%90%E4%BB%BB%E6%84%8F%E5%BD%A2%E7%8B%80%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95-d43e6e4b8fb5)

[**運用 UIBezierPath 繪製各種形狀**  
_開發 iOS App 時，我們可以利用 UIBezierPath 繪製路徑，然後搭配 CAShapeLayer 做出任意形狀的 view。接下來我們先從基本的三角形開始，然後再一步步挑戰像是上弦月之類較為複雜的圖形吧。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676)

[**addCurve(to:controlPoint1:controlPoint2:)**  
_Declaration This method appends a cubic Bézier curve from the current point to the end point specified by the endPoint…_developer.apple.com](https://developer.apple.com/documentation/uikit/uibezierpath/1624357-addcurve?source=post_page-----3c858e194676---------------------- "https://developer.apple.com/documentation/uikit/uibezierpath/1624357-addcurve?source=post_page-----3c858e194676----------------------")[](https://developer.apple.com/documentation/uikit/uibezierpath/1624357-addcurve?source=post_page-----3c858e194676----------------------)

[**搭配網站查詢圖片的座標畫圖**  
_1 連到網站 iview_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E6%90%AD%E9%85%8D%E7%B6%B2%E7%AB%99%E6%9F%A5%E8%A9%A2%E5%9C%96%E7%89%87%E7%9A%84%E5%BA%A7%E6%A8%99%E7%95%AB%E5%9C%96-f257743264a5 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E6%90%AD%E9%85%8D%E7%B6%B2%E7%AB%99%E6%9F%A5%E8%A9%A2%E5%9C%96%E7%89%87%E7%9A%84%E5%BA%A7%E6%A8%99%E7%95%AB%E5%9C%96-f257743264a5")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E6%90%AD%E9%85%8D%E7%B6%B2%E7%AB%99%E6%9F%A5%E8%A9%A2%E5%9C%96%E7%89%87%E7%9A%84%E5%BA%A7%E6%A8%99%E7%95%AB%E5%9C%96-f257743264a5)