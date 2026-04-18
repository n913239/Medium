---
title: 利用 UIBezierPath 設計特別形狀的圖片 — 比方斜邊 & 愛心
description: 地獄廚神之刀功對決
date: '2019-09-09T14:03:08.157Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E5%88%A9%E7%94%A8-uibezierpath-%E8%A8%AD%E8%A8%88%E7%89%B9%E5%88%A5%E5%BD%A2%E7%8B%80%E7%9A%84%E5%9C%96%E7%89%87-%E6%AF%94%E6%96%B9%E6%96%9C%E9%82%8A-%E6%84%9B%E5%BF%83-7b5e7363affd
---

### 地獄廚神之刀功對決

我們沒有鬼斧神工的地獄刀功，但是我們也可以使用UIBezierPath()來幫助我們斜切料理圖。

[**戈登·拉姆齊**  
_戈登·拉姆齊以他主持的美食及廚藝節目而聞名，在英國他參與的節目有：《》、《》、《》、《》、《》、《》；而他在美國參與的節目則有：《 美版地獄廚房》、《 廚房噩夢》、《 廚神當道》、《 地獄酒店 》。…_zh.wikipedia.org](https://zh.wikipedia.org/wiki/%E6%88%88%E7%99%BB%C2%B7%E6%8B%89%E5%A7%86%E9%BD%8A "https://zh.wikipedia.org/wiki/%E6%88%88%E7%99%BB%C2%B7%E6%8B%89%E5%A7%86%E9%BD%8A")[](https://zh.wikipedia.org/wiki/%E6%88%88%E7%99%BB%C2%B7%E6%8B%89%E5%A7%86%E9%BD%8A)

今天練習的題目是設計特別形狀的圖片

[**利用 UIBezierPath 設計特別形狀的圖片 — 比方斜邊 & 愛心**  
_彼得潘看到同學做的玩具總動員 App 十分可愛，App 裡的圖片加了斜邊，粉紅豬變得格外有時尚感。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uibezierpath-%E8%A8%AD%E8%A8%88%E7%89%B9%E5%88%A5%E5%BD%A2%E7%8B%80%E7%9A%84%E5%9C%96%E7%89%87-%E6%AF%94%E6%96%B9%E6%96%9C%E9%82%8A-%E6%84%9B%E5%BF%83-9741747f0063 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uibezierpath-%E8%A8%AD%E8%A8%88%E7%89%B9%E5%88%A5%E5%BD%A2%E7%8B%80%E7%9A%84%E5%9C%96%E7%89%87-%E6%AF%94%E6%96%B9%E6%96%9C%E9%82%8A-%E6%84%9B%E5%BF%83-9741747f0063")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uibezierpath-%E8%A8%AD%E8%A8%88%E7%89%B9%E5%88%A5%E5%BD%A2%E7%8B%80%E7%9A%84%E5%9C%96%E7%89%87-%E6%AF%94%E6%96%B9%E6%96%9C%E9%82%8A-%E6%84%9B%E5%BF%83-9741747f0063)

延續之前練習過的地獄廚神的菜單專案

[**#39 地獄廚神的菜單Fake**  
_地獄廚神Chefs Fake_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/39-%E5%9C%B0%E7%8D%84%E5%BB%9A%E7%A5%9E%E7%9A%84%E8%8F%9C%E5%96%AEfake-9597a8349764 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/39-%E5%9C%B0%E7%8D%84%E5%BB%9A%E7%A5%9E%E7%9A%84%E8%8F%9C%E5%96%AEfake-9597a8349764")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/39-%E5%9C%B0%E7%8D%84%E5%BB%9A%E7%A5%9E%E7%9A%84%E8%8F%9C%E5%96%AEfake-9597a8349764)

一樣先上圖

#### 成品圖

![](1__oT45mDkwQhhsNOL8nhaT9Q.png)

#### 程式碼

#### Github

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/ChefsFake "https://github.com/chiron-wang/Peter13/tree/exercise/ChefsFake")[](https://github.com/chiron-wang/Peter13/tree/exercise/ChefsFake)

#### Reference

[**Gordon Ramsay**  
_Gordon James Ramsay (born 8 November 1966) is a British chef, restaurateur, writer, television personality and food…_en.wikipedia.org](https://en.wikipedia.org/wiki/Gordon_Ramsay "https://en.wikipedia.org/wiki/Gordon_Ramsay")[](https://en.wikipedia.org/wiki/Gordon_Ramsay)

[**利用 UIBezierPath 設計特別形狀的圖片 — 比方斜邊 & 愛心**  
_彼得潘看到同學做的玩具總動員 App 十分可愛，App 裡的圖片加了斜邊，粉紅豬變得格外有時尚感。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uibezierpath-%E8%A8%AD%E8%A8%88%E7%89%B9%E5%88%A5%E5%BD%A2%E7%8B%80%E7%9A%84%E5%9C%96%E7%89%87-%E6%AF%94%E6%96%B9%E6%96%9C%E9%82%8A-%E6%84%9B%E5%BF%83-9741747f0063 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uibezierpath-%E8%A8%AD%E8%A8%88%E7%89%B9%E5%88%A5%E5%BD%A2%E7%8B%80%E7%9A%84%E5%9C%96%E7%89%87-%E6%AF%94%E6%96%B9%E6%96%9C%E9%82%8A-%E6%84%9B%E5%BF%83-9741747f0063")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uibezierpath-%E8%A8%AD%E8%A8%88%E7%89%B9%E5%88%A5%E5%BD%A2%E7%8B%80%E7%9A%84%E5%9C%96%E7%89%87-%E6%AF%94%E6%96%B9%E6%96%9C%E9%82%8A-%E6%84%9B%E5%BF%83-9741747f0063)