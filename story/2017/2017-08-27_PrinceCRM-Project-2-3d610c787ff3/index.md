---
title: PrinceCRM Project 2
description: 小王子客戶管理系統 第二彈
date: '2017-08-27T15:16:12.337Z'
categories: []
keywords: []
slug: /@n913239/princecrm-project-2-3d610c787ff3
---

小王子客戶管理系統 第二彈

開始實作PrinceCRM，由於我的美工天份與peter一樣被埋沒了 ̶1̶8̶年，所以……還是乖乖地找一個版來套，透過Sketch將畫面轉換到Zeplin內，作為樣搞參考。其中的背景圖片，也是採用Sketch來做匯出的動作，並且十分貼心的有1x, 2x, 3x三個檔案。

1\. 因為DB放在docker內首先透過寫好的Shell來啟動資料庫

#!/bin/bash

\# 啟動Docker Container => Linux MS-SQL 939XXXX為Id  
docker container start 939XXXX

2\. 由於不知道MAC上用哪一套管理MS-SQL比較方便，所以這邊先使用SSMS來幫忙，有需要資料表的朋友，可以在GitHub專案內，找到建立資料表與會員資料的script。

3\. 會員資料建立好之後，接者開始撰寫web api的登入方法，密碼的部分預計採用MD5來作加密，並利用Token來製作安全機制。由於之後我們要採用https的加密連線，所以我們要產生憑證檔，並放置到網站的根目錄。

openssl req -new -x509 -newkey rsa:2048 -keyout localhost.key -out localhost.cer -days 365 -subj /CN=localhost openssl pkcs12 -export -out certificate.pfx -inkey localhost.key -in localhost.cer

同時要在本地端加入憑證檔([傳送門](https://support.apple.com/kb/PH7297?locale=zh_TW&viewlocale=zh_TW))，並同時修改信任設定([傳送門](https://support.apple.com/kb/PH6335?locale=zh_TW&viewlocale=zh_TW))為信任所有。

4\. 接者開始設計iOS App的UI以及程式，今天要製作的是登入畫面，首先輸入帳號密碼，如果帳號或密碼錯誤的話，會使用UIAlertController來show出一個錯誤的警告視窗，同時，我們將這個方法獨立到另外一個func來reuse。

5\. 如果帳號密碼正確，在登入成功後，透過present()方法，來做場景轉場的效果，並將值傳到第二個頁面的property內，以供之後使用。這邊要注意的地方，由於我們的轉換方法寫在uploadTask的Closure內，所以呼叫的時候，要使用主執行緒來完成，不然就會報錯。

**完成圖：**

![](1__vdAT4OPemtl4kdrzH8yraQ.png)
![](1__G8mh50rfa8GM40ymV__zFAw.png)
![](1__hqkR29kUFpdygZfC6uKPXw.png)

**操作流程：**

![](1__jWBr6s__iqwuv__O0uGAYUkw.gif)

**小技巧筆記：**

1.  如果是在背景執行序作業的方法，要修改畫面上的UI，一定要透過主執行緒的方法來完成，不然會錯誤。

**GitHub：**

[**n913239/PrinceCRM**  
_Contribute to PrinceCRM development by creating an account on GitHub._github.com](https://github.com/n913239/PrinceCRM "https://github.com/n913239/PrinceCRM")[](https://github.com/n913239/PrinceCRM)

**參考資料：**

1\. 搭配 Sketch 和 Zeplin ，以 Auto Layout 製作 iOS App 畫面

[**#14 搭配 Sketch 和 Zeplin ，以 Auto Layout 製作 iOS App 畫面**  
_作業目的: 學習搭配 Sketch 和 Zeplin，以 Auto Layout 製作 iOS App 畫面。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/14-%E6%90%AD%E9%85%8D-sketch-%E5%92%8C-zeplin-%E4%BB%A5-auto-layout-%E8%A3%BD%E4%BD%9C-ios-app-%E7%95%AB%E9%9D%A2-740c7acf4f19 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/14-%E6%90%AD%E9%85%8D-sketch-%E5%92%8C-zeplin-%E4%BB%A5-auto-layout-%E8%A3%BD%E4%BD%9C-ios-app-%E7%95%AB%E9%9D%A2-740c7acf4f19")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/14-%E6%90%AD%E9%85%8D-sketch-%E5%92%8C-zeplin-%E4%BB%A5-auto-layout-%E8%A3%BD%E4%BD%9C-ios-app-%E7%95%AB%E9%9D%A2-740c7acf4f19)

2\. 如何將 Sketch 的 App 畫面加入 Zeplin 專案

[**如何將 Sketch 的 App 畫面加入 Zeplin 專案**  
_1 連到 Zeplin 網站，註冊帳號。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E5%B0%87-sketch-%E7%9A%84-app-%E7%95%AB%E9%9D%A2%E5%8A%A0%E5%85%A5-zeplin-%E5%B0%88%E6%A1%88-b2883ecd0aac "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E5%B0%87-sketch-%E7%9A%84-app-%E7%95%AB%E9%9D%A2%E5%8A%A0%E5%85%A5-zeplin-%E5%B0%88%E6%A1%88-b2883ecd0aac")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E5%B0%87-sketch-%E7%9A%84-app-%E7%95%AB%E9%9D%A2%E5%8A%A0%E5%85%A5-zeplin-%E5%B0%88%E6%A1%88-b2883ecd0aac)

3\. 如何用 sketch 切圖，輸出 iOS App 需要的 1x, 2x, 3x 圖片

[**如何用 sketch 切圖，輸出 iOS App 需要的 1x, 2x, 3x 圖片**  
_以下以輸出 Nike logo 為例子說明:_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E7%94%A8-sketch-%E5%88%87%E5%9C%96-%E8%BC%B8%E5%87%BA-ios-app-%E9%9C%80%E8%A6%81%E7%9A%84-1x-2x-3x-%E5%9C%96%E7%89%87-d34628c3cf3f "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E7%94%A8-sketch-%E5%88%87%E5%9C%96-%E8%BC%B8%E5%87%BA-ios-app-%E9%9C%80%E8%A6%81%E7%9A%84-1x-2x-3x-%E5%9C%96%E7%89%87-d34628c3cf3f")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E7%94%A8-sketch-%E5%88%87%E5%9C%96-%E8%BC%B8%E5%87%BA-ios-app-%E9%9C%80%E8%A6%81%E7%9A%84-1x-2x-3x-%E5%9C%96%E7%89%87-d34628c3cf3f)

4\. Apple開發者文件 URLSession

[**URLSession - Foundation | Apple Developer Documentation**  
_The URLSession API involves many different classes working together in a fairly complex way that may not be obvious if…_developer.apple.com](https://developer.apple.com/documentation/foundation/urlsession "https://developer.apple.com/documentation/foundation/urlsession")[](https://developer.apple.com/documentation/foundation/urlsession)