---
title: 研讀 optional 文章 － 心得
description: >-
  在App的魔法世界裡，走在腳下的每一步總是充滿驚奇，就在有一天遇到了一位奇男子，江湖人稱可有可無的Swift小炫風~Apple魔法會的湯姆嗑吐司~~~Optional。
date: '2017-08-02T05:44:15.523Z'
categories: []
keywords: []
slug: >-
  /@n913239/%E7%A0%94%E8%AE%80-optional-%E6%96%87%E7%AB%A0-%E5%BF%83%E5%BE%97-4e4ae13dc39
---

在App的魔法世界裡，走在腳下的每一步總是充滿驚奇，就在有一天遇到了一位奇男子，江湖人稱可有可無的Swift小炫風~Apple魔法會的湯姆嗑吐司~~~Optional。

在一陣鋪陳(虎爛)後，

**首先列出Optional的幾個特性：**

> 1\. 使用Optional的變數(常數)，可以不用設定數值，會自動初始化為『nil』

> 2\. Optional變數使用前，要先解開包裝

> 3\. Optional的取值方法：force-unwrap，Optional Binding…

> 4\. 自動取值的Implicitly Unwrapped Optional (但是有風險，遇到nil送你閃退回家)，可以搭配if判斷使用

> 5\. 變出預設值的雙重問號，取不到值會自動使用預設值

**很虛的總結：**

在開發魔法App的過程中，遇到Optional要小心處理，  
可以採用比較安全的Optional Binding來取值，  
也可以用很方便的雙重問號，來處理取不到值的狀況，  
使用Guard也是一種方式。

**參考資料：**

1\. peterpan — Swift的問號與驚嘆號：可有可無的 Optional

[**Swift的問號與驚嘆號：可有可無的 Optional**  
_可有可無的 Optional 是 Swift 裡一個非常特別的角色。你看它號稱可有可無，我們卻還要認識他，就知道他多特別了。有了它，不管何種型別的變數或常數，都可以沒有任何內容，也就是無值的狀態。至於這有什麼好呢? 這故事得回到很久很久…_www.appcoda.com.tw](https://www.appcoda.com.tw/swift-optional-intro/ "https://www.appcoda.com.tw/swift-optional-intro/")[](https://www.appcoda.com.tw/swift-optional-intro/)

2\. Swift 2 初學者指南

[**Swift 2 初學者指南**  
_去年 Apple 帶來了 Swift，一個為針對 iOS 以及 OS 的全新程式語言。當它第一次宣布時，就跟其他開發者一樣。我非常的興奮，因為這宣稱是一個既快且安全的語言。跟預期一樣，這家公司今年在 WWDC 導入了 Swift 2。這…_www.appcoda.com.tw](https://www.appcoda.com.tw/swift2/ "https://www.appcoda.com.tw/swift2/")[](https://www.appcoda.com.tw/swift2/)

3\. GitBook

[**使用 Guard 判斷式 · 從 Objective-C 到 Swift**  
_Edit description_dearhui.gitbooks.io](https://dearhui.gitbooks.io/objective-c-to-swift/content/guard.html "https://dearhui.gitbooks.io/objective-c-to-swift/content/guard.html")[](https://dearhui.gitbooks.io/objective-c-to-swift/content/guard.html)

4\. Apple官方文件Optional

[**Optional - Swift Standard Library | Apple Developer Documentation**  
_You use the type whenever you use optional values, even if you never type the word . Swift's type system usually shows…_developer.apple.com](https://developer.apple.com/documentation/swift/optional "https://developer.apple.com/documentation/swift/optional")[](https://developer.apple.com/documentation/swift/optional)