---
title: The Reawakened Series (2)
description: 埃及王子叩酊趣
date: '2019-08-07T02:18:48.187Z'
categories: []
keywords: []
slug: /@n913239/the-reawakened-series-2-c8ae9095466a
---

### 埃及王子叩酊趣

本篇文章一樣延續前面的內容做各種練習，並加入相關的程式碼，

並將對應的版面做調整，練習的功能列表如下：

> #1 模仿FB動態牆練習  
> #2 Alamofire連結網頁 & segue  
> #3 Activity Indecator View  
> #4 設定 content size，實現水平捲動，上下捲動和分頁的 scroll view

### 模仿FB動態牆練習

[**如何製作非滿版的 cell (類似 FB 動態牆或卡片)**  
_以下以右上的卡片 cell 為例說明_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%A3%BD%E4%BD%9C%E9%A1%9E%E4%BC%BC-fb-%E5%8B%95%E6%85%8B%E7%89%86%E6%88%96%E5%8D%A1%E7%89%87%E7%9A%84-cell-9580c0483c3d "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%A3%BD%E4%BD%9C%E9%A1%9E%E4%BC%BC-fb-%E5%8B%95%E6%85%8B%E7%89%86%E6%88%96%E5%8D%A1%E7%89%87%E7%9A%84-cell-9580c0483c3d")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%A3%BD%E4%BD%9C%E9%A1%9E%E4%BC%BC-fb-%E5%8B%95%E6%85%8B%E7%89%86%E6%88%96%E5%8D%A1%E7%89%87%E7%9A%84-cell-9580c0483c3d)

主要參考這篇文章，並在View的區域內，加上圖片與按鈕，使用在BuyViewController中

成果如下圖：

![](1__Gyx6Oh5hkwyacPQforEdxA.png)

### Alamofire 連結網頁

(1) 採用CocoaPods來做安裝

(2) 透過segue來做場景的轉換

![](1__VOuG____XbTduwIBKVWSvayA.png)

並在轉換的過程中，透過prepare來傳值 (contentID)

(3) Alamofire 相關代碼

其實這邊可以直接使用WKWebview來讀取Youtube網頁就好，不過只是順道練習下Alamofire

(4) WKWebView 可以直接load就好

![](1__83DqXzZh__2DAJlDWXqOs2Q.png)

### Activity Indecator View

(1) 直接在storyboard上使用

應用在Buy1ViewController上，並拉一個@IBOutlet來做控制

**@IBOutlet** **weak** **var** loadingActivityIndecatorView: UIActivityIndicatorView!

(2) 直接使用程式碼加入Activity Indecator View

### 設定 content size，實現水平捲動，上下捲動和分頁的 scroll view

[**設定 content size，實現水平捲動，上下捲動和分頁的 scroll view**  
_對剛學會從 storyboard 製作 App 畫面，但還不會 Auto Layout 和寫程式的朋友，利用 table view controller 的 Static Cells…_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%9C%A8-storyboard-%E8%A8%AD%E5%AE%9A-content-size-%E5%AF%A6%E7%8F%BE%E6%B0%B4%E5%B9%B3%E6%8D%B2%E5%8B%95%E7%9A%84-scroll-view-2710fa247293 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%9C%A8-storyboard-%E8%A8%AD%E5%AE%9A-content-size-%E5%AF%A6%E7%8F%BE%E6%B0%B4%E5%B9%B3%E6%8D%B2%E5%8B%95%E7%9A%84-scroll-view-2710fa247293")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%9C%A8-storyboard-%E8%A8%AD%E5%AE%9A-content-size-%E5%AF%A6%E7%8F%BE%E6%B0%B4%E5%B9%B3%E6%8D%B2%E5%8B%95%E7%9A%84-scroll-view-2710fa247293)

使用在首頁的三張圖片上

(1) 加入一個scroll view，並設定contentSize為三張圖片的寬度

(2) 加入一個view在scroll底下，並加入三張圖片

### Github

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/Reawakened "https://github.com/chiron-wang/Peter13/tree/exercise/Reawakened")[](https://github.com/chiron-wang/Peter13/tree/exercise/Reawakened)

### Reference

1.  FB動態牆

[**如何製作非滿版的 cell (類似 FB 動態牆或卡片)**  
_以下以右上的卡片 cell 為例說明_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%A3%BD%E4%BD%9C%E9%A1%9E%E4%BC%BC-fb-%E5%8B%95%E6%85%8B%E7%89%86%E6%88%96%E5%8D%A1%E7%89%87%E7%9A%84-cell-9580c0483c3d "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%A3%BD%E4%BD%9C%E9%A1%9E%E4%BC%BC-fb-%E5%8B%95%E6%85%8B%E7%89%86%E6%88%96%E5%8D%A1%E7%89%87%E7%9A%84-cell-9580c0483c3d")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%A3%BD%E4%BD%9C%E9%A1%9E%E4%BC%BC-fb-%E5%8B%95%E6%85%8B%E7%89%86%E6%88%96%E5%8D%A1%E7%89%87%E7%9A%84-cell-9580c0483c3d)

2\. Alamofire Github

[**Alamofire/Alamofire**  
_Alamofire is an HTTP networking library written in Swift. ⚠️ ⚠️ ⚠️ WARNING ⚠️ ⚠️ ⚠️ This documentation is out of date…_github.com](https://github.com/Alamofire/Alamofire "https://github.com/Alamofire/Alamofire")[](https://github.com/Alamofire/Alamofire)

3\. UIActivityIndicatorView 的用法

[**Swift - 环形进度条（UIActivityIndicatorView）的用法**  
_Swift中，除了条形进度条外，还有环形进度条，效果图如下： Hides When Stopped：勾选后当环形进度条停止转动时自动隐藏 import UIKit class ViewController…_www.hangge.com](http://www.hangge.com/blog/cache/detail_703.html "http://www.hangge.com/blog/cache/detail_703.html")[](http://www.hangge.com/blog/cache/detail_703.html)

4\. Scroll View

[**設定 content size，實現水平捲動，上下捲動和分頁的 scroll view**  
_對剛學會從 storyboard 製作 App 畫面，但還不會 Auto Layout 和寫程式的朋友，利用 table view controller 的 Static Cells…_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%9C%A8-storyboard-%E8%A8%AD%E5%AE%9A-content-size-%E5%AF%A6%E7%8F%BE%E6%B0%B4%E5%B9%B3%E6%8D%B2%E5%8B%95%E7%9A%84-scroll-view-2710fa247293 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%9C%A8-storyboard-%E8%A8%AD%E5%AE%9A-content-size-%E5%AF%A6%E7%8F%BE%E6%B0%B4%E5%B9%B3%E6%8D%B2%E5%8B%95%E7%9A%84-scroll-view-2710fa247293")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%9C%A8-storyboard-%E8%A8%AD%E5%AE%9A-content-size-%E5%AF%A6%E7%8F%BE%E6%B0%B4%E5%B9%B3%E6%8D%B2%E5%8B%95%E7%9A%84-scroll-view-2710fa247293)