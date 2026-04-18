---
title: '#53 照片牆的歷史'
description: 地獄廚神外傳
date: '2019-08-26T19:38:29.187Z'
categories: []
keywords: []
slug: >-
  /@n913239/53-%E7%85%A7%E7%89%87%E7%89%86%E7%9A%84%E6%AD%B7%E5%8F%B2-425a85062df7
---

### 地獄廚神外傳

之照片牆的歷史，今天要練習#53照片牆這個題目，練習了三種作法，內容請參考此篇文章

[**#53 照片牆(Grid Photo Wall)**  
_功能需求:_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/53-collection-view-%E7%85%A7%E7%89%87%E7%89%86-c03f156de0c "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/53-collection-view-%E7%85%A7%E7%89%87%E7%89%86-c03f156de0c")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/53-collection-view-%E7%85%A7%E7%89%87%E7%89%86-c03f156de0c)

#### 架構圖

![](1__E0J__N5__EIRqQAj5ZFj1s9w.png)

#### 練習一

不用寫程式，並搭配TableView來做照片牆的呈現，

這邊列出幾個練習的步驟：

*   將 table view 的分隔線拿掉。(Separator 設為 None) => 引用上面文章
*   Header & Footer 設為最小
*   三張圖片用 StackView 包住，對齊設定為Top

#### 成品圖

![](1____AomE1m1JFMtAAEVRqltDQ.png)

#### 練習二

使用CollectionView Controller 來做練習，可參考此篇文章

[**利用 flow layout 的 collection view 製作照片牆**  
_目標: 利用 flow layout 的 collection view 製作人見人愛的小王子照片牆。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-flow-layout-%E7%9A%84-collection-view-%E8%A3%BD%E4%BD%9C%E7%85%A7%E7%89%87%E7%89%86-e31dad55a7ac "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-flow-layout-%E7%9A%84-collection-view-%E8%A3%BD%E4%BD%9C%E7%85%A7%E7%89%87%E7%89%86-e31dad55a7ac")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-flow-layout-%E7%9A%84-collection-view-%E8%A3%BD%E4%BD%9C%E7%85%A7%E7%89%87%E7%89%86-e31dad55a7ac)

原則上照者文章做就差不多了，然後使用一個變數來存圖片名稱，並用亂數來取出圖片

**let** ImageNames = \["Beef", "Chicken", "Pork"\]  
  

**let** cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\\(ChefsCollectionViewCell.**self**)", for: indexPath) **as**! ChefsCollectionViewCell

**let** imageName = ImageNames\[Int.random(in: 0...2)\]

cell.chefsImageView.image = UIImage(named: imageName)

**return** cell

#### 完成圖

![](1__I4vlky6WkOLz__5gbbiJMCg.png)

#### 練習三

使用UIViewController加上UICollectionView來實作，首先要實作兩個protocol『UICollectionViewDataSource, UICollectionViewDelegate』，  
以及實作對應的方法。而點選圖片轉換到另外一張大圖(ViewController)，  
使用segue來達成，程式碼細節請參考GitHub，

#### 完成圖

![](1__NXvHBI0w0b1bgKiITOET6Q.png)
![](1__p3UygsS____8Y__zImJKo1DGQ.png)

### GitHub

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/ChefsFake "https://github.com/chiron-wang/Peter13/tree/exercise/ChefsFake")[](https://github.com/chiron-wang/Peter13/tree/exercise/ChefsFake)