---
title: WWDC 觀賞祕技
description: 追劇小技巧
date: '2019-10-18T19:30:35.775Z'
categories: []
keywords: []
slug: /@n913239/wwdc-%E8%A7%80%E8%B3%9E%E7%A5%95%E6%8A%80-57a01cf82e61
---

#### 前言

身為一個蘋果開發者，當然每年都要追WWDC，本文將介紹如何在本機觀看WWDC的幾個小技巧。

以**WWDC2016 \[708\]**為例

[**Advanced Notifications - WWDC 2016 - Videos - Apple Developer**  
_3D Touch on Notifications provides users with access to media attachments and live content. See how your app can take…_developer.apple.com](https://developer.apple.com/videos/play/wwdc2016/708/ "https://developer.apple.com/videos/play/wwdc2016/708/")[](https://developer.apple.com/videos/play/wwdc2016/708/)

![](1__lFKy6DsLXFEraiE7XImHYQ.png)

#### 下載所有資源

1.  下載影片 (SD / HD)

2\. PDF還有連結等等

#### 下載影片字幕

1.  首先在頁面中，打開Chrome的開發人員工具，快速鍵(alt + cmd + I)

2\. 切換到Network頁面

![](1__EY__U58WIyQXc0bRQLcQ0Nw.png)

3\. 等待影片載入完成

4\. 點選右下角的『…』 => 字幕 => 簡體中文(英文也可以)

![](1__uxWplqJ5Xt5qre__orlmHBw.png)
![](1__lz3F3vcawq4WP4altjyfYA.png)
![](1__Q1RQNfMfQZ5VEpVg__wxE__A.png)

5\. 繼續播放影片，確認已經看到字幕了

![](1__jQhD5eGst2ga5ilwBWM9nw.png)

6\. 回到開發人員工具，可以看到Network內，有一堆『\*.webvtt』的檔案，接者滑鼠右鍵 => Open in newtab，然後下載字幕檔

![](1__171t6rCtARj3AkzX__6LOIQ.png)

\* 記得字幕檔編號是從０開始

\* 目前作者只知道一個一個單檔下載的方式 (有更好的方法，歡迎提供)

\* Chrome 可以先修改下載設定，讓他自動下載到指定資料夾，效率更好

7\. 此時我們已經有了全部的字幕檔28個(0–27)

![](1__oZSsvZsNzn5OzOPEoY1d3w.png)

8\. 如果使用curl指令搭配，可以一次下載所有字幕

curl -O [https://devstreaming-cdn.apple.com/videos/wwdc/2015/408509vyudbqvts/408/subtitles/eng/fileSequence\[0-45\].webvtt](https://devstreaming-cdn.apple.com/videos/wwdc/2015/408509vyudbqvts/408/subtitles/eng/fileSequence4.webvtt)

簡易說明：

參數 -O 為符合格式的所有檔案

而\[0–45\]中括弧內，可以放入會比對到的數字，也可以搭配正則表達式使用

#### 合併字幕

合併字幕非常簡單，只要在主控台下指令就可以

1\. 打開終端機，並把剛剛的資料夾拖曳到視窗內，會自動產生路徑。接者只要移動到最前面加上『cd 』再換行，

![](1__SKg79TVB4kAwH7yXTcbxfA.png)

2\. 使用『ls』指令確認檔案都正確

![](1__0UUL1WjRXe8__AhuMo7UoZw.png)

3\. 輸入以下指令結合所有檔案到單一檔案

cat file\* > wwdc2016708.webvtt

4\. 使用文字編輯器，確認是我們要的字幕內容(作者使用Visual Studio Code)

![](1__1W4IXL4hmsK5EOpP5x8FNg.png)

5\. 將這個整理好的字幕檔上傳到此網站，完成後下載.srt字幕檔

[**Convert Subtitles to Srt**  
_Subrip (srt) is a very basic subtitle format, because of this you will almost always lose some functionality or effects…_subtitletools.com](https://subtitletools.com/convert-to-srt-online "https://subtitletools.com/convert-to-srt-online")[](https://subtitletools.com/convert-to-srt-online)

> Download

![](1__04EeoKPi32ts8AMpCihw__g.png)

6\. 下載後，一樣透過文字編輯工具確認內容正確。此時，其餘的檔案通通都可以刪除了

\* 選擇English的讀者，到這一步已經結束，可以觀賞影片了

#### 簡體轉繁體

雖然我們閱讀簡體字沒有什麼問題，

可身為~~(假)~~的我們更加的熱愛繁體字

因此，我們透過Visual Studio Code的簡繁體轉換工具來幫忙

1\. 安裝『簡體與繁體互轉』套件

[https://marketplace.visualstudio.com/items?itemName=cipchk.zh-hans-tt-hant-vscode](https://marketplace.visualstudio.com/items?itemName=cipchk.zh-hans-tt-hant-vscode)

2\. 在Visual Studio Code中打開命令列(快捷鍵：cmd + P)，並輸入以下指令

\> zh-hans-to-zh-hant

![](1__fbk__S__PFCQXDg5uCGg__vzw.png)

轉換前：

![](1__Gdo__ToQlVDaT943OIylzlg.png)

轉換後：

![](1__iLQ3Dhg6IHaGJtFhi__3LBg.png)

> 終於看到具有美感的繁體中文

#### 總結

我們觀賞WWDC影片的同時，Apple官方已經佛心的提供了高畫質影片下載。並使用chrome的開發人員工具，來幫助我們下載所有的字幕。

下載簡體中文的讀者，也可以透過各種工具來做簡繁的轉換。  
接者我們就可以開心的追劇(WWDC)，快快樂樂的學習新技術了。

今天的文章就這邊，感謝讀者的閱讀。

#### 參考資料與延伸閱讀

Apple WWDC2016 708

[**Advanced Notifications - WWDC 2016 - Videos - Apple Developer**  
_3D Touch on Notifications provides users with access to media attachments and live content. See how your app can take…_developer.apple.com](https://developer.apple.com/videos/play/wwdc2016/708/ "https://developer.apple.com/videos/play/wwdc2016/708/")[](https://developer.apple.com/videos/play/wwdc2016/708/)