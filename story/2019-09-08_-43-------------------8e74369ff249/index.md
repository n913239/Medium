---
title: '#43 從程式製作國旗圖案 — 布吉納法索'
description: 布吉納法索
date: '2019-09-08T21:09:16.162Z'
categories: []
keywords: []
slug: >-
  /@n913239/43-%E5%BE%9E%E7%A8%8B%E5%BC%8F%E8%A3%BD%E4%BD%9C%E5%9C%8B%E6%97%97%E5%9C%96%E6%A1%88-%E5%B8%83%E5%90%89%E7%B4%8D%E6%B3%95%E7%B4%A2-8e74369ff249
---

雖然目前已與台灣斷交，但是我們依然可以繪製他們國家的國旗

[**中華民國與布吉納法索關係**  
_Edit description_zh.wikipedia.org](https://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E8%88%87%E5%B8%83%E5%90%89%E7%B4%8D%E6%B3%95%E7%B4%A2%E9%97%9C%E4%BF%82 "https://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E8%88%87%E5%B8%83%E5%90%89%E7%B4%8D%E6%B3%95%E7%B4%A2%E9%97%9C%E4%BF%82")[](https://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E8%88%87%E5%B8%83%E5%90%89%E7%B4%8D%E6%B3%95%E7%B4%A2%E9%97%9C%E4%BF%82)

今天要練習的題目，學習怎麼使用addSubView和UIBezierPath

[**#43 從程式製作國旗圖案**  
_目的: 從程式製作畫面，學習 addSubview 和 UIBezierPath。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/43-%E5%BE%9E%E7%A8%8B%E5%BC%8F%E8%A3%BD%E4%BD%9C%E5%9C%8B%E6%97%97%E5%9C%96%E6%A1%88-b3a1a913fe2e "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/43-%E5%BE%9E%E7%A8%8B%E5%BC%8F%E8%A3%BD%E4%BD%9C%E5%9C%8B%E6%97%97%E5%9C%96%E6%A1%88-b3a1a913fe2e")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/43-%E5%BE%9E%E7%A8%8B%E5%BC%8F%E8%A3%BD%E4%BD%9C%E5%9C%8B%E6%97%97%E5%9C%96%E6%A1%88-b3a1a913fe2e)

照例先上圖

#### 成品圖

![](1__GYPH5MSLxSNTQDxUTEuA0Q.png)

#### 程式碼

程式碼簡易說明

*   首先建立一個View作為Top上方區塊
*   接者建立第二個View作為bottom底部
*   使用UIBezierPath來繪製中間的星星圖案

#### 小技巧

練習過程中發現，Apple已經內建了非常方便的『數位測色計』

![](1__2rzI4EUpcgAoR1__HBVlF6A.png)

這邊介紹如何呼叫與使用

_1._ 按下『cmd + space(空白)』來呼叫Spotlight搜尋

> 這招超好用，每天在用

2\. 接者輸入『digital color / 數位測色計』

![](1__TcZhN8DqZtPP7qsyPB9sjw.png)

3\. 打開數位測色計後，移動到你想要吸取的顏色上，按下『cmd + L』鎖定位置(顏色)即可，如果要繼續吸取其他顏色，只要再次按下熱鍵來解除鎖定

![](1__qHhF7pRit5ov8RbgWuE6rw.png)

#### GitHub

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/Playground "https://github.com/chiron-wang/Peter13/tree/exercise/Playground")[](https://github.com/chiron-wang/Peter13/tree/exercise/Playground)

#### Reference

[**#43 從程式製作國旗圖案**  
_目的: 從程式製作畫面，學習 addSubview 和 UIBezierPath。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/43-%E5%BE%9E%E7%A8%8B%E5%BC%8F%E8%A3%BD%E4%BD%9C%E5%9C%8B%E6%97%97%E5%9C%96%E6%A1%88-b3a1a913fe2e "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/43-%E5%BE%9E%E7%A8%8B%E5%BC%8F%E8%A3%BD%E4%BD%9C%E5%9C%8B%E6%97%97%E5%9C%96%E6%A1%88-b3a1a913fe2e")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/43-%E5%BE%9E%E7%A8%8B%E5%BC%8F%E8%A3%BD%E4%BD%9C%E5%9C%8B%E6%97%97%E5%9C%96%E6%A1%88-b3a1a913fe2e)

[**中華民國與布吉納法索關係**  
_Edit description_zh.wikipedia.org](https://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E8%88%87%E5%B8%83%E5%90%89%E7%B4%8D%E6%B3%95%E7%B4%A2%E9%97%9C%E4%BF%82 "https://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E8%88%87%E5%B8%83%E5%90%89%E7%B4%8D%E6%B3%95%E7%B4%A2%E9%97%9C%E4%BF%82")[](https://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E8%88%87%E5%B8%83%E5%90%89%E7%B4%8D%E6%B3%95%E7%B4%A2%E9%97%9C%E4%BF%82)

[**將 view 變成任意形狀的三種方法**  
_iOS 的 App 畫面因為有著各式各樣的元件而變得美麗，然而不管是 view，label，image view 還是 button，它們預設都是長方形的形狀。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%B0%87-view-%E8%AE%8A%E6%88%90%E4%BB%BB%E6%84%8F%E5%BD%A2%E7%8B%80%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95-d43e6e4b8fb5 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%B0%87-view-%E8%AE%8A%E6%88%90%E4%BB%BB%E6%84%8F%E5%BD%A2%E7%8B%80%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95-d43e6e4b8fb5")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%B0%87-view-%E8%AE%8A%E6%88%90%E4%BB%BB%E6%84%8F%E5%BD%A2%E7%8B%80%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95-d43e6e4b8fb5)

[**運用 UIBezierPath 繪製各種形狀**  
_開發 iOS App 時，我們可以利用 UIBezierPath 繪製路徑，然後搭配 CAShapeLayer 做出任意形狀的 view。接下來我們先從基本的三角形開始，然後再一步步挑戰像是上弦月之類較為複雜的圖形吧。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E9%81%8B%E7%94%A8-uibezierpath-%E7%B9%AA%E8%A3%BD%E5%BD%A2-3c858e194676)