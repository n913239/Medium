---
title: PrinceCRM Project 5
description: 小王子客戶管理系統 第五回
date: '2017-09-07T06:32:49.327Z'
categories: []
keywords: []
slug: /@n913239/princecrm-project-5-cec7fd5a2b73
---

小王子客戶管理系統 第五回

今天主要實作的內容，是將現有的公司資料中的地址，搭配Map View來做顯示地圖的功能，並加上公司名稱的地圖標記。

\================我不是分隔線================

**實作過程：**

1\. 由於今天要加上一個新的按鈕，用來點擊之後顯示地圖，所以我們在原本的Controller內，新增一個Cell類型，並調整對應的AutoLayout。

![](1__zVDWuOktZxe3pLGGAiwTNg.png)

2\. 加入一個新的View Controller，用來準備顯示公司的地圖，並拉入Map Kit View，別忘了要建立一個class，等等程式中會用到。同時我們先將Map元件的Outlet拉好。

![](1__j__YsGZIWC0vmcS940O__q__Q.png)
![](1__pxQo96WIS6mb0oNvXS90Rg.png)
![](1__yq4__NS2__U2Mwf8rxBu1NVw.png)

3\. 這一次我們直接透過segue的功能來轉場，將Button連接到新的Controller內，並選擇show。

![](1__ZSMDggwrlrERugjtsE__rHA.png)

4\. 透過轉場的時候，所觸發prepare來傳遞公司資料到下一個畫面。

5\. 最後是地圖頁面的顯示，由於公司地址是String，要先將它轉換為座標，所以寫了一個func來輔助使用。

6\. 最後在viewDidLoad()事件中，載入地圖。

7\. 到現在為止，今天我們所要實作的功能都完成囉，想知道更多的細節部分，請參考GitHub專案的程式碼(tag: v4)。

**完成圖：**

![](1__fdsAEywfYbonbhY1K8N__aA.png)
![](1__iYEfhVDOB7HE21__6mA6gSg.png)
![](1__dX4aA37Pa__9nvixkyzM7YQ.png)

**操作流程：**

![](1__OSjzLusNckd6rCCLrIA10g.gif)

**總結：**

在今天的實作中，我們地圖的Map Kit View的串接，並加入了地圖標記。也寫了一個將地址轉換為座標系統的func()，在當下有想到這個部分要透過串接Google Map API來完成，但是經過查詢，Apple本身就有提供這個功能了，就直接採用Apple內建的涵式來實作了。

**小技巧筆記：**

1.  在模擬器中如果要縮放地圖，可以按住『Option (Alt)』按鍵，然後向外拉(放大)或是向內拉(縮小)來調整地圖的視野

**GitHub：**

[**n913239/PrinceCRM**  
_Contribute to PrinceCRM development by creating an account on GitHub._github.com](https://github.com/n913239/PrinceCRM/tree/v4 "https://github.com/n913239/PrinceCRM/tree/v4")[](https://github.com/n913239/PrinceCRM/tree/v4)

**參考資料：**

1\. stackoverflow Geocoder()

[**Open map in a given address using MapKit and Swift**  
_I am having a bit of trouble understanding Apple's MapKit in Swift 3. I found an example here: How to open maps App…_stackoverflow.com](https://stackoverflow.com/questions/43918842/open-map-in-a-given-address-using-mapkit-and-swift "https://stackoverflow.com/questions/43918842/open-map-in-a-given-address-using-mapkit-and-swift")[](https://stackoverflow.com/questions/43918842/open-map-in-a-given-address-using-mapkit-and-swift)

2\. 用 Swift 開發一個 iOS 地域定向 App

[**用 Swift 開發一個 iOS 地域定向 App**  
_在本文，我會演示如何在 iOS 上實現地域定向。我會介紹蘋果傳統的 CLRegion 類。我還將介紹如何對這種不常見的功能進行測試。我們還會演示如何實現複雜的跟蹤邏輯。最後，我將解釋如何創建你「自訂的」region，以及爲什麽要使用「自…_www.appcoda.com.tw](https://www.appcoda.com.tw/geo-targeting-ios/ "https://www.appcoda.com.tw/geo-targeting-ios/")[](https://www.appcoda.com.tw/geo-targeting-ios/)