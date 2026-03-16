---
title: '#89 當SwiftUI遇到石虎抱抱'
description: 關心石虎～～人人有責
date: '2019-10-02T05:20:34.695Z'
categories: []
keywords: []
slug: >-
  /@n913239/89-%E7%95%B6swiftui%E9%81%87%E5%88%B0%E7%9F%B3%E8%99%8E%E6%8A%B1%E6%8A%B1-a4d62eca769f
---

關心石虎～～人人有責

### 前言

今天我們要建立UI為SwiftUI的專案，並實際來練習Path繪圖，由於SwiftUI還沒有時間深入的研究，因此先練習一個小題目(ref2)。  
在兩年前有去台北上過彼得潘的課程，現在重頭開始學習iOS App開發，也可以接者練習網站上的一百道題目考驗(ref3)，有許多題目都非常的有趣。

現在，我們馬上開始！

#### 練習目標

今天我們要建立Swift專案，並利用Path來描繪可愛的石虎，首先參考一下原圖

![](1__92qOHP03VTn45VN4EeFQOA.png)

#### 練習過程

1\. 首先建立SwiftUI的專案，建立的過程都與Day13相同(如下方連結)，唯一要注意的是**User Interface**要選『SwiftUI』(如下圖)

![](1__Wk7Cmg75PwmrwK0Tr88cIQ.png)

2\. 首先加入原圖當作背景圖，置放於下方區塊，繪圖區在我們的左上角

// background

Image("Cat3")  
 .resizable()  
 .scaledToFit()  
 .frame(width: 300, height: 400, alignment: .bottom)

3\. 接者畫出個別區塊，首先是頭部的區塊

4\. 接者依序畫出耳朵，眼睛，鬍鬚，嘴巴等等各區塊，由於程式碼很多，請直接參考Github專案，這邊就不再列出

#### 完成圖

![](1__WholB95b91piJLLbLGMVnA.png)

可以看到上方的石虎抱抱，是我們用Path所描繪出來的。而下方的背景圖，則是原圖

#### 總結

在今天的文章裡，我們練習建立了SwiftUI專案，  
也練習了SwiftUI的使用Path來繪製可愛的石虎抱抱。  
今天的內容就到這邊，感謝讀者們的閱讀。

#### Github

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/LeopardCat "https://github.com/chiron-wang/Peter13/tree/exercise/LeopardCat")[](https://github.com/chiron-wang/Peter13/tree/exercise/LeopardCat)

#### Reference

1\. 南投縣友善石虎農作促進會《石虎家族的綠保運動》

[**南投縣友善石虎農作促進會《石虎家族的綠保運動》**  
_亞洲豹貓（Asian Leopard…_bnwinfor.com](https://bnwinfor.com/2018/04/21/%E5%8D%97%E6%8A%95%E7%B8%A3%E5%8F%8B%E5%96%84%E7%9F%B3%E8%99%8E%E8%BE%B2%E4%BD%9C%E4%BF%83%E9%80%B2%E6%9C%83%E3%80%8A%E7%9F%B3%E8%99%8E%E5%AE%B6%E6%97%8F%E7%9A%84%E7%B6%A0%E4%BF%9D%E9%81%8B%E5%8B%95/ "https://bnwinfor.com/2018/04/21/%E5%8D%97%E6%8A%95%E7%B8%A3%E5%8F%8B%E5%96%84%E7%9F%B3%E8%99%8E%E8%BE%B2%E4%BD%9C%E4%BF%83%E9%80%B2%E6%9C%83%E3%80%8A%E7%9F%B3%E8%99%8E%E5%AE%B6%E6%97%8F%E7%9A%84%E7%B6%A0%E4%BF%9D%E9%81%8B%E5%8B%95/")[](https://bnwinfor.com/2018/04/21/%E5%8D%97%E6%8A%95%E7%B8%A3%E5%8F%8B%E5%96%84%E7%9F%B3%E8%99%8E%E8%BE%B2%E4%BD%9C%E4%BF%83%E9%80%B2%E6%9C%83%E3%80%8A%E7%9F%B3%E8%99%8E%E5%AE%B6%E6%97%8F%E7%9A%84%E7%B6%A0%E4%BF%9D%E9%81%8B%E5%8B%95/)

2\. 俄羅斯插畫家親繪石虎送台灣 有望登上彩繪列車！

[**俄羅斯插畫家親繪石虎送台灣 有望登上彩繪列車！ | 聯合新聞網**  
_號稱「全台首座移動美術館」的集集彩繪列車 爭議不斷，車身上的彩繪石虎 像花豹，又被爆出是花數百元購買俄羅斯插畫家作品，觀光局塗掉原本設計，昨公布新的石虎設計圖。 俄羅斯插畫家今天公開親手繪製的石虎圖像，免費公開讓台灣使用…_udn.com](https://udn.com/news/story/7266/4013861 "https://udn.com/news/story/7266/4013861")[](https://udn.com/news/story/7266/4013861)

3\. #86 利用 SwiftUI 的 Path 繪圖

[**#86 利用 SwiftUI 的 Path 繪圖**  
_利用 SwiftUI 的 Path 繪製喜歡的可愛圖案， logo 或 emoji。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/86-%E5%88%A9%E7%94%A8-swiftui-%E7%9A%84-path-%E7%B9%AA%E5%9C%96-8de990bc7eaf "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/86-%E5%88%A9%E7%94%A8-swiftui-%E7%9A%84-path-%E7%B9%AA%E5%9C%96-8de990bc7eaf")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/86-%E5%88%A9%E7%94%A8-swiftui-%E7%9A%84-path-%E7%B9%AA%E5%9C%96-8de990bc7eaf)

4\. 火車環島3671藍皮普快紀念品

[**火車環島3671藍皮普快紀念品**  
_第一次的SwiftUI練習題_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%81%AB%E8%BB%8A%E7%92%B0%E5%B3%B63671%E8%97%8D%E7%9A%AE%E6%99%AE%E5%BF%AB%E7%B4%80%E5%BF%B5%E5%93%81-89b5390d1d36 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%81%AB%E8%BB%8A%E7%92%B0%E5%B3%B63671%E8%97%8D%E7%9A%AE%E6%99%AE%E5%BF%AB%E7%B4%80%E5%BF%B5%E5%93%81-89b5390d1d36")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E7%81%AB%E8%BB%8A%E7%92%B0%E5%B3%B63671%E8%97%8D%E7%9A%AE%E6%99%AE%E5%BF%AB%E7%B4%80%E5%BF%B5%E5%93%81-89b5390d1d36)