---
title: '#13 快打旋風之龍騰虎嘯— 調色大師'
description: 猴溜肯
date: '2019-09-16T22:37:34.422Z'
categories: []
keywords: []
slug: >-
  /@n913239/13-%E5%BF%AB%E6%89%93%E6%97%8B%E9%A2%A8%E4%B9%8B%E9%BE%8D%E9%A8%B0%E8%99%8E%E5%98%AF-%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-ea920da4d886
---

快打旋風還記得小時候第一個接觸的大型電玩，應該就是快打旋風(街頭霸王)，先來段影片

> 《街霸5》世界顶级隆(Ryu)梅原(daigo)排位赛巧遇天梯最强肯(Ken)

看不過癮的還有2004年的這一場傳奇逆轉

> 【電玩達人】EVO 2004 快打旋風3 梅原大吾成為傳奇的背水の逆転劇

#### Ryu & Ken (隆與肯)

應該是裡面大家最熟悉的角色，之前的公司還有個同事英文名字就叫做ken，有一次我問他你英文名字怎麼來的，他說就是這個遊戲。(果然是骨灰級玩家)

[**隆**  
_是個為了面對更強的對手、而不斷自我修行的格鬥家。在最早1987年的《快打旋風》裡為參加世界格鬥技的選手，之後在1991年的《快打旋風II》便修改定位成「獨自一人不斷地在世界各地旅行、找尋好對手、追求『真格鬥家』之道」的孤高形象至今。個性上則…_zh.wikipedia.org](https://zh.wikipedia.org/wiki/%E9%9A%86 "https://zh.wikipedia.org/wiki/%E9%9A%86")[](https://zh.wikipedia.org/wiki/%E9%9A%86)

#### 今天要練習的題目是

[**#13 彼得潘的影子 — 調色大師**  
_作業目的: 熟練 outlet，action，UISlider, UIColor。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-swift-ios-app-%E4%BD%9C%E6%A5%AD-a8ab4d968034 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-swift-ios-app-%E4%BD%9C%E6%A5%AD-a8ab4d968034")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-swift-ios-app-%E4%BD%9C%E6%A5%AD-a8ab4d968034)

原圖是

![](1__0Hbb1JGpCjlGjzgrPFH6ng.png)

雖然我印象中這題目有人做過了 XDDDD

不過我們還是來練習一下

#### 練習過程

1.  首先將圖片去背(波動拳的區塊)
2.  加上RGB的調整
3.  加上Alpha的調整
4.  加上colorSliderChanged()事件
5.  加上漸層效果 (由左到右)
6.  加上邊框效果 (背景圖外框)
7.  加入漸層與邊框的修改與清除程式碼

由於參考了許多的作業，減少了很多卡關的過程，花比較多的時間地方是UI的調整，以及過程中程式碼調整的部分(嘗試錯誤)。

然後在漸層與邊框效果，切換到Off (!isOn)的狀態時，嘗試加入清除的效果。最後在稍微整理重構程式碼。

#### 成品圖

![](1__EMKY6Q__fIHGufgwP39T8Xw.png)

以及Red, Green, Blue & Alpha 還有漸層，邊框效果的成品圖

![](1__L0Q8essqd53llxxMN__dTxQ.png)
![](1__f5xLX2MtQWvMJ8SudlApow.png)
![](1__IWzR2xScx8VQYvkl3PqCdw.png)

#### 程式碼

*   sliderChanged事件有三個方法  
    1.更新顏色  
    2\. 漸層與邊框效果  
    3\. 更新Label的文字
*   frameSwitched主要有三個方法   
    1\. 清除漸層效果  
    2\. 清除邊框效果  
    3\. 設定所有Slider的狀態

*   漸層效果事件
*   邊框效果事件

*   清除漸層與邊框的效果事件

> 漸層的清除花了比較多的時間嘗試，才有現在的寫法

*   這個部分比較簡單，直接讓值與Switch開關相同即可

#### Github

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/StreetFighter "https://github.com/chiron-wang/Peter13/tree/exercise/StreetFighter")[](https://github.com/chiron-wang/Peter13/tree/exercise/StreetFighter)

#### Reference

[**Ryu In Super Smash Bros. Can Use Street Fighter-Style Inputs**  
_By Ishaan . June 14, 2015 . 1:41am Super Smash Bros. for Wii U and Super Smash Bros. for Nintendo 3DS adhere to the…_www.siliconera.com](https://www.siliconera.com/2015/06/14/ryu-in-super-smash-bros-can-use-street-fighter-style-inputs/ "https://www.siliconera.com/2015/06/14/ryu-in-super-smash-bros-can-use-street-fighter-style-inputs/")[](https://www.siliconera.com/2015/06/14/ryu-in-super-smash-bros-can-use-street-fighter-style-inputs/)

[**#13 彼得潘的影子 — 調色大師**  
_作業目的: 熟練 outlet，action，UISlider, UIColor。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-swift-ios-app-%E4%BD%9C%E6%A5%AD-a8ab4d968034 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-swift-ios-app-%E4%BD%9C%E6%A5%AD-a8ab4d968034")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-swift-ios-app-%E4%BD%9C%E6%A5%AD-a8ab4d968034)

[**利用 UIView 的 mask 為圖片文字染上美麗的漸層**  
_利用 UIView 的 mask，我們可以快速做出漸層的圖片和文字。接下來就讓我們以彼得潘的影子當例子，瞧瞧如何做出漸層的彼得潘影子吧。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uiview-%E7%9A%84-mask-%E8%A3%BD%E4%BD%9C%E6%BC%B8%E5%B1%A4%E7%9A%84%E5%9C%96%E7%89%87%E5%92%8C%E6%96%87%E5%AD%97-2130cd4f3f53 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uiview-%E7%9A%84-mask-%E8%A3%BD%E4%BD%9C%E6%BC%B8%E5%B1%A4%E7%9A%84%E5%9C%96%E7%89%87%E5%92%8C%E6%96%87%E5%AD%97-2130cd4f3f53")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-uiview-%E7%9A%84-mask-%E8%A3%BD%E4%BD%9C%E6%BC%B8%E5%B1%A4%E7%9A%84%E5%9C%96%E7%89%87%E5%92%8C%E6%96%87%E5%AD%97-2130cd4f3f53)

[**利用 CAGradientLayer 製作漸層**  
_開發 iOS App 時，我們時常希望畫面上出現美麗的漸層。(或是偉大的美術設計師希望) 製作漸層有很多方法，其中最簡單的莫過於利用 CAGradientLayer。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-cagradientlayer-%E8%A3%BD%E4%BD%9C%E6%BC%B8%E5%B1%A4-e86cee69f3a0 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-cagradientlayer-%E8%A3%BD%E4%BD%9C%E6%BC%B8%E5%B1%A4-e86cee69f3a0")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-cagradientlayer-%E8%A3%BD%E4%BD%9C%E6%BC%B8%E5%B1%A4-e86cee69f3a0)

#### 參考同學作業

[**調色App — 斑馬**  
_如果老虎跟斑馬有辦法雜交的話大概就會變這樣吧_medium.com](https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2app-%E6%96%91%E9%A6%AC-30a5d98539be "https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2app-%E6%96%91%E9%A6%AC-30a5d98539be")[](https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2app-%E6%96%91%E9%A6%AC-30a5d98539be)

[**調色大師 — 製作專屬於你的勵志小語小卡！**  
_(1) App 操作的動畫影片 gif_medium.com](https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-%E8%A3%BD%E4%BD%9C%E5%B0%88%E5%B1%AC%E6%96%BC%E4%BD%A0%E7%9A%84%E5%8B%B5%E5%BF%97%E5%B0%8F%E8%AA%9E%E5%B0%8F%E5%8D%A1-ce6f5135feda "https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-%E8%A3%BD%E4%BD%9C%E5%B0%88%E5%B1%AC%E6%96%BC%E4%BD%A0%E7%9A%84%E5%8B%B5%E5%BF%97%E5%B0%8F%E8%AA%9E%E5%B0%8F%E5%8D%A1-ce6f5135feda")[](https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-%E8%A3%BD%E4%BD%9C%E5%B0%88%E5%B1%AC%E6%96%BC%E4%BD%A0%E7%9A%84%E5%8B%B5%E5%BF%97%E5%B0%8F%E8%AA%9E%E5%B0%8F%E5%8D%A1-ce6f5135feda)

[**調色大師**  
_Customize iPhone_medium.com](https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-71e1165e4563 "https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-71e1165e4563")[](https://medium.com/%E6%B5%B7%E5%A4%A7-ios-app-%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/%E8%AA%BF%E8%89%B2%E5%A4%A7%E5%B8%AB-71e1165e4563)

[**#13 莫莉**  
_作業： #13 彼得潘的影子 — 調色大師，熟練 outlet、action、UISlider、UIColor。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/13-%E8%8E%AB%E8%8E%89-fe47c67e8631 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/13-%E8%8E%AB%E8%8E%89-fe47c67e8631")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/13-%E8%8E%AB%E8%8E%89-fe47c67e8631)