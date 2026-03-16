---
title: 研究 navigation controller 的返回功能
description: 這一篇文章的主要是研究關於navigation controller的返回功能，返回的兩種方式
date: '2017-07-26T05:42:55.106Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E7%A0%94%E7%A9%B6-navigation-controller-%E7%9A%84%E8%BF%94%E5%9B%9E%E5%8A%9F%E8%83%BD-53e90ae25c14
---

這一篇文章的主要是研究關於navigation controller的返回功能，  
返回的兩種方式

引用IOS界情歌小王子 彼得潘的文章：

> 方法1. 按左上角的按鈕返回

> 方法2. 按住畫面左邊的邊緣後，向右邊拖曳。

**我們一樣看圖說故事：**

![](1__VPhTT__0ywscZqV6jlX2HiQ.png)
![](1__25wOPp5DeHqQukheW9pisA.png)
![](1__4wMWz0FLH6OhP2yyTn3A8Q.png)

首先我們在第一頁點選『前往第二頁』，在第二頁中我們可以看到左上角有顯示Back的，接者點選『前往第三頁』，可以看到左上角的文字，被更改為『第二頁』了。

> 因為我們將第二頁的中的『**Navigation Item**』文字，修改為第二頁

而由於第一頁的Navagation Item文字，我們並沒有做更動保持預設值，  
所以看到的還是原本的Back。

**完成圖：**

![](1__ZfZZj01dyHHqk__hv7iAd__g.gif)

我們在影片中，分別示範了從左上角點選返回上一頁，以及在左邊範圍點選後向右滑動的返回方式。

**小技巧筆記：**

1.  可以先點選左邊選單中ViwController，然後按者『Option』(Alt)按鍵不放，拖曳到視窗中，即可快速複製一個ViewController，其他元件也可以用這種方式快速複製。
2.  如果用筆電的觸控板操作模擬器，可以用一隻手指按者，再用一隻手指滑動，來模擬手機的滑動效果。

**GitHub**：

[**n913239/navigationControllerTest**  
_Contribute to navigationControllerTest development by creating an account on GitHub._github.com](https://github.com/n913239/navigationControllerTest "https://github.com/n913239/navigationControllerTest")[](https://github.com/n913239/navigationControllerTest)

**參考資料：**

1\. 研究 navigation controller 的返回功能

[**研究 navigation controller 的返回功能**  
_返回方式:_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%A0%94%E7%A9%B6-navigation-controller-%E7%9A%84%E8%BF%94%E5%9B%9E%E5%8A%9F%E8%83%BD-6e01a3dcceda "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%A0%94%E7%A9%B6-navigation-controller-%E7%9A%84%E8%BF%94%E5%9B%9E%E5%8A%9F%E8%83%BD-6e01a3dcceda")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%A0%94%E7%A9%B6-navigation-controller-%E7%9A%84%E8%BF%94%E5%9B%9E%E5%8A%9F%E8%83%BD-6e01a3dcceda)