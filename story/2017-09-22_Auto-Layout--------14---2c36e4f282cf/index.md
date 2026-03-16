---
title: Auto Layout的逆襲，格鬥天王14復刻
description: >-
  今天要把以前的作品KOF14，加上Auto
  Layout，來讓各個裝置，都可以看到較為一致的版面，並加入一個新功能，透過讀取網頁的WKWebView元件，讓App可以播放當初提過的冠軍影片。
date: '2017-09-22T14:11:11.835Z'
categories: []
keywords: []
slug: >-
  /@n913239/auto-layout%E7%9A%84%E9%80%86%E8%A5%B2-%E6%A0%BC%E9%AC%A5%E5%A4%A9%E7%8E%8B14%E5%BE%A9%E5%88%BB-2c36e4f282cf
---

今天要把以前的作品KOF14，加上Auto Layout，來讓各個裝置，  
都可以看到較為一致的版面，並加入一個新功能，  
透過讀取網頁的WKWebView元件，讓App可以播放當初提過的冠軍影片。

#### **版面調整：**

1\. 首先透過約束條件將圖片為100，寬度設定為230，並將文字的高度設定為100，寬度設定為125。

![](1__o7Iv3chiPRc4__FINcdAGvQ.png)
![](1__Y3jU06__1MqTJ6VxN4eLsEw.png)

2\. 接者同時選取圖片與文字，並加入Stack View。可以發現圖片和文字被包入一個Stack View內。此時我們針對Stack View來做版面調整即可。設定上下間隔5，左右間隔10。  
※這邊要注意的是Constrain to Margins **_不要_**勾選。

![](1__3CIPwV1dVqp5AyHU9RxNsw.png)
![](1__fkevSfeFEVyoVjMRVHyf3w.png)

3\. 到這邊會出現紅色警告，系統會提示請刪除過多的約束條件，請由於stack的距離已經設定好了，圖片與文字的大小也設定好了。此時，我們可以刪除圖片與文字的高度約束條件，以及文字的寬度約束條件，因為系統已經可以自動計算了。

4\. 將所有的TableView Cell都依序做設定，到這邊就完成了列表的Auto Layout部分。

5\. 接者是隊伍的隊員介紹選擇畫面，由於之前是用三個按鈕來做設定，這邊不用Stack View，採用另外一個作法來設定Auto Layout。首先選擇第一個按鈕，設定寬高與上左下的對齊。第二與第三個按鈕也做相對設定。最後，將三個按鈕設定等比例的縮放。

6\. 將剩下隊員隊伍也依序做設定，在這邊也可以採用前面Auto Layout的方法 ，將三個按鈕整合到一個Horizontal Stack View內。

7\. 最後是個人隊伍頁面，照片的設定，設定上左右對齊為0，並設定等比例的縮放就完成。

**UI完成圖：**

![](1__N7ei8vliBrxhXcMciOmP2w.png)
![](1__Kl__2XSZ__FTd8omwP5Vdl7w.png)
![](1__0__bxyJhW1Nub5xylYicN1A.png)

8\. 接者我們新增一個View到畫面上(以及新增類別)，並嵌入Navigation Controller，準備用來等下顯示冠軍的影片。

9\. 拉入一個WKWebView到新的ViewController上，並加入Outlet，  
記得別忘了要引用。  
※要特別注意的是這個元件，在**iOS 11** 才有支援喔

import WebKit

10\. 加入WKWebView的讀取頁面程式碼，並加入UIActivityIndicator

#### **網頁示範：**

![](1__5JHgyneO1eSI1HJdgS8__qg.gif)

#### **GitHub：**

[**n913239/KOF14Story**  
_Contribute to KOF14Story development by creating an account on GitHub._github.com](https://github.com/n913239/KOF14Story "https://github.com/n913239/KOF14Story")[](https://github.com/n913239/KOF14Story)

參考資料：

1\. Apple官方文件 Auto Layout

[**Auto Layout Guide: Understanding Auto Layout**  
_Describes the constraint-based system for laying out user interface elements._developer.apple.com](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/index.html "https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/index.html")[](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/index.html)

2\. APPCODE的Auto Layout文章

[**Swift 新手系列之三：Auto Layout 介紹**  
_Auto Layout是一個以約束條件為基礎的佈局系統（constraint-based layout system），它讓開發者能夠開發一個能自我調整型的UI，可以依照螢幕的尺寸以及裝置的方向來調整。有些初學者會覺得這個部分很難，而儘…_www.appcoda.com.tw](https://www.appcoda.com.tw/auto-layout/ "https://www.appcoda.com.tw/auto-layout/")[](https://www.appcoda.com.tw/auto-layout/)