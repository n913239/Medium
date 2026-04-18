---
title: 研究 navigation bar 的欄位
description: >-
  今天的文章目的是研究Navigation Bar的欄位，如果直接將Navigation
  Controller拉進畫面中，會自動產生一個帶有TableView的Root View
  Controller(如下圖1)，反而會造成我們的不便，所以我們採用Embed in的方式…
date: '2017-07-29T07:36:39.425Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E7%A0%94%E7%A9%B6-navigation-bar-%E7%9A%84%E6%AC%84%E4%BD%8D-758dffc62f6c
---

**今天的文章目的**是研究Navigation Bar的欄位，  
如果直接將Navigation Controller拉進畫面中，  
會自動產生一個帶有TableView的Root View Controller(如下圖1)，  
反而會造成我們的不便，所以我們採用Embed in的方式  
來加入Navigation Controller(如下圖2)。

![](1__wxKDkdaU8MVhXAckVBChyA.png)
![](1__batE__cQrkFESFXFjtSI__ng.png)

**一切準備就緒後**，現在立馬開始我們今天的Navigation Bar的欄位研究之旅

![](1__Naeh1Ld6g6__s20__3pSbdow.jpeg)

1.  **Bar Tint**

此欄位就是整個Navigation Bar列的背景顏色，  
我們將採用Blue連色來做識別

![](1__QP6vNf__bp__vqMuqPD6Fn1Q.png)

**2\. Translucent**

半透明的效果，有開啟如圖四中左邊的效果，  
如果沒有開啟則為不透明，如圖四中右邊模擬器的效果

![](1____L__95JeLt2NkpItfMFZ25w.png)

**3\. Title Font**

![](1__sAVN9tRwLn2ofOK1eI__DFQ.png)

這個欄位就是Navigation Bar上面所顯示的字體(型)，  
身為一個App開發魔法師，等寬字體的魔力無疑是我們強大魔法的原力，  
本文中就採用『Menlo』來當例子。

**4\. Title Color**

這個欄位就是Navigation Bar上面所顯示的文字顏色，  
我們將文字改為strawberry這個顏色，以作識別。

![](1__yFbfrbs__B6kLLWUusLinJg.png)

介紹完Navigation Bar的幾個欄位之後，我們繼續來看MAC要如何新增字體？在App開發的奇幻魔法世界中，魔法可是有千千萬萬種，現在我們馬上**來修煉等寬字體的魔法**。

1\. 首先打開字體簿(應用程式 => 字體簿)

2\. 下載對應的字體，這邊以『Source Code Pro』為例

3\. 打開字型的預覽視窗，並點選『安裝字體』，到這邊就完成安裝

![](1__sG2E__s6nIHbH8PDAUsE0Yg.png)

4\. 在字體簿中可以看到我們剛剛安裝好的字體

![](1__X2__X8drTAVJO6MJJw1cdaQ.png)

5\. 如果要移除的話，可以點選字體，然後點選工具列的檔案 => 移除『Source Code Pro』系列

![](1__wait02Xy9cDpjY8dHHCHmw.png)

**小技巧筆記：**

1.  Label文字的內容如果超出大小框框大小，可以點選工具列的 Editor => Size to fit Content (快速鍵: **Cmd** 加 **\=**)來自動調整寬度。
2.  MAC新增字體
3.  如果要兩台模擬器做實驗對照，可以採用同一個專案不同Device(e.g. I7 & I7 Plus)，也是很方便的做法

GitHub：

[**n913239/NavigationBarProperty**  
_Contribute to NavigationBarProperty development by creating an account on GitHub._github.com](https://github.com/n913239/NavigationBarProperty/tree/master "https://github.com/n913239/NavigationBarProperty/tree/master")[](https://github.com/n913239/NavigationBarProperty/tree/master)

參考資料：

1\. 彼得潘 **研究 navigation bar 的欄位**

[**研究 navigation bar 的欄位**  
_1\. Bar Tint_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%A0%94%E7%A9%B6-navigation-bar-%E7%9A%84%E6%AC%84%E4%BD%8D-9299d86c46c1 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%A0%94%E7%A9%B6-navigation-bar-%E7%9A%84%E6%AC%84%E4%BD%8D-9299d86c46c1")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%A0%94%E7%A9%B6-navigation-bar-%E7%9A%84%E6%AC%84%E4%BD%8D-9299d86c46c1)

2\. MAC安裝字體

[**Mac Basics: Font Book**  
_Font Book is located in the Applications folder (in the Finder, choose Go > Applications). To manage or view fonts…_support.apple.com](https://support.apple.com/en-us/HT201749 "https://support.apple.com/en-us/HT201749")[](https://support.apple.com/en-us/HT201749)

3\. Source Code Pro字體

[**adobe-fonts/source-code-pro**  
_source-code-pro - Monospaced font family for user interface and coding environments_github.com](https://github.com/adobe-fonts/source-code-pro "https://github.com/adobe-fonts/source-code-pro")[](https://github.com/adobe-fonts/source-code-pro)