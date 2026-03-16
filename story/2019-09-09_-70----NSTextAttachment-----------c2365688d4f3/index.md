---
title: '#70 利用 NSTextAttachment 製作包含圖片的字串'
description: 吃飽才有力氣寫App
date: '2019-09-09T20:36:29.574Z'
categories: []
keywords: []
slug: >-
  /@n913239/70-%E5%88%A9%E7%94%A8-nstextattachment-%E8%A3%BD%E4%BD%9C%E5%8C%85%E5%90%AB%E5%9C%96%E7%89%87%E7%9A%84%E5%AD%97%E4%B8%B2-c2365688d4f3
---

### 吃飽才有力氣寫App

今天要練習的題目是文字中包含小圖(emoji)，結合成比較豐富的圖文並茂的句子。

參考內容

[**#70 利用 NSTextAttachment 製作包含圖片的字串**  
_想要顯示文字和圖片，一般我們會用 label & image view 實現。彼得潘為了促進台灣經濟發展，想用 label & image view 顯示以上畫面，每天喝十杯珍奶，每天吃一百顆小籠包，珍奶和小籠包以可愛的圖片表示。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/70-%E5%88%A9%E7%94%A8-nstextattachment-%E8%A3%BD%E4%BD%9C%E5%8C%85%E5%90%AB%E5%9C%96%E7%89%87%E7%9A%84%E5%AD%97%E4%B8%B2-88ad39d3a741 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/70-%E5%88%A9%E7%94%A8-nstextattachment-%E8%A3%BD%E4%BD%9C%E5%8C%85%E5%90%AB%E5%9C%96%E7%89%87%E7%9A%84%E5%AD%97%E4%B8%B2-88ad39d3a741")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/70-%E5%88%A9%E7%94%A8-nstextattachment-%E8%A3%BD%E4%BD%9C%E5%8C%85%E5%90%AB%E5%9C%96%E7%89%87%E7%9A%84%E5%AD%97%E4%B8%B2-88ad39d3a741)

先來看看

#### 成品圖

![](1____X22L50ji0cTuDVBJH3zEg.png)

#### 不及閤大學士翻譯版

> 穿者藍白拖逛夜市，拿出百元買臭豆腐，吃飽才有力氣寫App

#### 程式碼

*   使用兩個字串集合來儲存文字與圖片名稱
*   再搭配一個for loop組合變數 (其實是懶得寫太多)

#### Github

[**chiron-wang/Peter13**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/Peter13/tree/exercise/Playground "https://github.com/chiron-wang/Peter13/tree/exercise/Playground")[](https://github.com/chiron-wang/Peter13/tree/exercise/Playground)

#### Reference

[**#70 利用 NSTextAttachment 製作包含圖片的字串**  
_想要顯示文字和圖片，一般我們會用 label & image view 實現。彼得潘為了促進台灣經濟發展，想用 label & image view 顯示以上畫面，每天喝十杯珍奶，每天吃一百顆小籠包，珍奶和小籠包以可愛的圖片表示。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/70-%E5%88%A9%E7%94%A8-nstextattachment-%E8%A3%BD%E4%BD%9C%E5%8C%85%E5%90%AB%E5%9C%96%E7%89%87%E7%9A%84%E5%AD%97%E4%B8%B2-88ad39d3a741 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/70-%E5%88%A9%E7%94%A8-nstextattachment-%E8%A3%BD%E4%BD%9C%E5%8C%85%E5%90%AB%E5%9C%96%E7%89%87%E7%9A%84%E5%AD%97%E4%B8%B2-88ad39d3a741")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84%E8%A9%A6%E7%85%89-%E5%8B%87%E8%80%85%E7%9A%84-100-%E9%81%93-swift-ios-app-%E8%AC%8E%E9%A1%8C/70-%E5%88%A9%E7%94%A8-nstextattachment-%E8%A3%BD%E4%BD%9C%E5%8C%85%E5%90%AB%E5%9C%96%E7%89%87%E7%9A%84%E5%AD%97%E4%B8%B2-88ad39d3a741)

[**Taiwan Emoji Project**  
_Emoji is becoming the world's first truly universal language. However, we noticed that there are not many emojis about…_www.taiwanemoji.com](https://www.taiwanemoji.com/?source=post_page-----88ad39d3a741---------------------- "https://www.taiwanemoji.com/?source=post_page-----88ad39d3a741----------------------")[](https://www.taiwanemoji.com/?source=post_page-----88ad39d3a741----------------------)