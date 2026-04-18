---
title: '#2 擇偶條件App － 我的寵物龜日記'
description: 這一篇的學習目的為：
date: '2017-08-01T17:33:00.834Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E6%93%87%E5%81%B6%E6%A2%9D%E4%BB%B6app-%E6%88%91%E7%9A%84%E5%AF%B5%E7%89%A9%E9%BE%9C%E6%97%A5%E8%A8%98-77450139f77b
---

**這一篇的學習目的為：**

> 目的: 學習 IBOutlet 和 IBAction，熟練從程式存取內建的 UI 元件。

這一篇文章模仿擇偶條件App，來實作一個『我的養龜日記』App，  
讓喜歡烏龜的朋友們，從寵物龜三大天王中(圖一)，快速挑選到適合自己的烏龜。此外，如果未滿14歲的朋友們，也建議在父母的陪同下一同飼養。

![](1__XShOm6d71Y5C7kh4AMMzPA.png)
![](1__6BxVlMSFBdub7LizryVtXw.png)
![](1__ODK__7zkeBqwDHaneQ6fkNw.png)

看完了可愛的烏龜圖片，接者介紹我們今天會用到的幾個元件，  
以及在此App中的應用方法。

**Outlet**

![](1__NBOTzgdW5MjjBuRc6LYAhw.png)

**Action & Both**

![](1__UIgH83__1UfPa8fSWOAnq3Q.png)

Outlet的程式碼

Action改變文字Label的相關程式碼，這邊要注意的地方是，要取得對應的數值，必須在建立Action連結的時候，先選好對應的型別，或是在程式碼中轉換，共兩種方法

最後是點選按鈕後，會得到的飼養龜種建議。

**完成圖：**

![](1__yp__qz0e__0D0k2RzJL4W__NQ.gif)

**GitHub：**

[**n913239/turtleLove**  
_turtleLove - 擇偶條件App － 我的寵物龜日記_github.com](https://github.com/n913239/turtleLove "https://github.com/n913239/turtleLove")[](https://github.com/n913239/turtleLove)

**小技巧筆記：**

1.  目前在Outlet變數的後面加上註解『// XXX』，Xcode(Beta 4)，好像非常容易當掉，註解改加在上面就不會了，等後面改版後，再觀察看看
2.  要選擇程式碼的時候，可以按下『Option(Alt)』，等游標出現一個十字箭頭的時候，在點選程式碼，這樣在選擇程式碼的時候，就可以排除縮排的空白，十分方便

參考資料：

1.  彼得潘的擇偶條件APP

[**#2 擇偶條件App**  
_目的: 學習 IBOutlet 和 IBAction，熟練從程式存取內建的 UI 元件。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E6%93%87%E5%81%B6%E6%A2%9D%E4%BB%B6-app-%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-ios-app-%E4%BD%9C%E6%A5%AD-45823196267d "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E6%93%87%E5%81%B6%E6%A2%9D%E4%BB%B6-app-%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-ios-app-%E4%BD%9C%E6%A5%AD-45823196267d")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/%E6%93%87%E5%81%B6%E6%A2%9D%E4%BB%B6-app-%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-ios-app-%E4%BD%9C%E6%A5%AD-45823196267d)