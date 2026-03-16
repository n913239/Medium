---
title: MacOS VPN Config
description: SSTP & L2TP / IPSec
date: '2019-02-09T12:40:29.861Z'
categories: []
keywords: []
slug: /@n913239/macos-vpn-config-1bdeef5ec29f
---

SSTP & L2TP / IPSec

### 前言：

今天的文章主要是分享，如何設定MacOS 使用VPN的相關設定，

主要介紹兩種協定 L2TP & SSTP 的VPN 連接．

筆者主要應用在透過VPN連線後，再連接到SMB的共用資料夾，

最後會到網頁上確認我們的IP是否改變。

### 實作過程：

#### L2TP / IPSec

由於這是MAC本身就支援的方式，所以設定上十分簡單。

1\. 打開Network網路設定，並點選左下角的『+』號來新增

![](1__hl33oPCsVf5QvW3mMeH2ow.png)

2\. 首先將Interface選VPN，並設定VPN Type為 L2TP，

而Service Name 可輸入自訂名稱，最後按下『Create』

![](1__jOvBjurRuBdKeUbPCz6hAg.png)

3\. 輸入Server Address與Account Name，

最後先按下『Authentication Settings』來設定密碼

![](1__g4FlIh9MqGSBF8r8Ji64RA.png)

4\. 輸入密碼後，按下OK

![](1__JhSUyBfeAuFYOn8LPRW1Nw.png)

5\. 按下Apply套用後，點選Connect連接

![](1__nQhxuM0dtYYxaJz8XaEVJg.png)

6\. 如果出現密碼視窗，就再次輸入密碼，並按下OK

![](1__CE2G__tNc__FoI0yc9tfj5xQ.png)

7\. 連線成功後，可以看到連線狀態，Show VPN status如果打勾，就可以在右上角的系統圖示中看到，方便管理

![](1__oqQaVkFt7WRO3DDiDoR__ww.png)

#### SSTP

由於MAC本身VPN的連線方式選單中不提供，

因此要連線比較麻煩一些，大概有幾個步驟，

首先安裝brew套件管理工具，接者使用brew來安裝sstp-client，

最後寫下我們的Mac shell script，以後點兩下就可以使用了。

1.  安裝brew套件管理工具

```
# install brew/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

安裝參考網頁

[**Homebrew**  
_The missing package manager for macOS (or Linux)._brew.sh](https://brew.sh/index_zh-tw "https://brew.sh/index_zh-tw")[](https://brew.sh/index_zh-tw)

2\. 安裝sstp-client

\# brew update

\# brew install sstp-client

3\. 等到安裝完成，準備以下指令，並另存為vpn.command，

並替換掉<user>, <password>, <server> 為你的個人設定

\- 如果要使用.sh，可以將副檔名改為.sh，並在指令最前面加上『sh 』

4\. 首次執行vpn.command 會跳出警告，沒有權限執行

![](1__bQcK6HIbpyTIDI6oc9lQLA.jpeg)

5\. 因此我們開啟terminal 視窗，並修改剛剛的vpn.command的權限為 『u+x』，其中u為設定owner，而x則是執行權限，  
注意這邊請自行確認vpn.command的檔案路徑。

chmod u+x vpn.command

6\. 修改執行權限後，再次執行剛剛的vpn.command，並輸入使用者密碼，

發現VPN已連接成功

![](1__dzSKXyoA__t3h4ht9jJieqQ.jpeg)

7\. 上網確認外部IP，已經更換為VPN Server的IP了

![](1__MgHv8ONc37jft7fBhGIKQg.png)

8\. 如果要斷開VPN連接，只要在原本的shell視窗，按下Ctrl + C即可關閉連線。

#### 總結：

今天介紹了MAC的VPN相關設定，與安裝brew套件管理工具，

並使用brew來安裝sstp-client，最後寫一個簡單的script來幫助VPN連線，

如果想使用GUI可以參考Reference的連結3，axot大大有實作GUI介面的連線工具， 感謝您的閱讀。

#### Reference：

1.  brew

[**Homebrew**  
_The missing package manager for macOS (or Linux)._brew.sh](https://brew.sh/index_zh-tw "https://brew.sh/index_zh-tw")[](https://brew.sh/index_zh-tw)

2\. sstp-client

[**sstpc command man page - sstp-client | ManKier**  
_By default, sstpc establishes the SSTP call to the SSTP server, and then starts an instance of pppd to manage the data…_www.mankier.com](https://www.mankier.com/8/sstpc "https://www.mankier.com/8/sstpc")[](https://www.mankier.com/8/sstpc)

3\. isstp

[**axot/isstp**  
_a SSTP Client for Mac OSX, the migration to GITHUB did not done, please wait. - axot/isstp_github.com](https://github.com/axot/isstp "https://github.com/axot/isstp")[](https://github.com/axot/isstp)