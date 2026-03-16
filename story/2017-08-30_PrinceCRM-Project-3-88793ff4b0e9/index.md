---
title: PrinceCRM Project 3
description: 小王子客戶管理系統 第三話
date: '2017-08-30T17:41:15.411Z'
categories: []
keywords: []
slug: /@n913239/princecrm-project-3-88793ff4b0e9
---

小王子客戶管理系統 第三話

今天要實作的部分是公司資料的管理，可以讓使用者查看所有公司的資料列表，並在點擊之後，進一步查看公司明細。在過程中，採用UserDefault來存放一些使用者資料，取代在不同Controller的傳遞資料方法。

**實作過程：**

1\. 首先是資料表的設計，請參考company.tsql。

2\. 接者是web api的部分，為了實作上的方便(其實是偷懶)，採用自訂Route的設計，來達到方法區別，取資料的部分，實作上會比較簡單。

3\. 現在回到我們本文的重點，iOS App的設計部分，由於我們要透過程式來控制TableView表格的資料，所以我們先建立一個Cocoa Touch Class檔案，並繼承自UITableViewControll，命名為CompanyTableView，有了這個檔案，我們就可以開始寫程式了。

4\. 同時，我們在Models資料夾內，設定一個Company.cs類別，準備用來存放後面接收api資料用，這邊為了方便，一樣只設計了兩個init()方法。

5\. 這邊要注意的地方是，從api取回資料後，要更新畫面上的資料，一樣要回到主執行緒上面去做修改。

// 更新UI

func updateUI() {

    DispatchQueue.main.async {

        self.tableView.reloadData()

    }

}

6\. 點選Cell後，這邊採用Segue的方法，將畫面轉場帶入到Details內，並透過prepare來傳遞資料。

7\. 我們增加一個CompanyDetailsTableViewController檔案，準備等等寫程式用。記得畫面上的TableView，要選擇剛剛建立的自訂Class，並且我們將轉場的segue的id設定為companyDetails。

8\. 到這邊我們已經完成了所有畫面上的設定，剩下程式的部分，詳細部分請參考GitHub的專案。

**完成圖：**

![](1__YRrTSFy861GDTOAJSjzGHw.png)
![](1__UFmUciiTY9ad8IsSRmTLVw.png)
![](1__Xvamq7Icgtv3xpJrYDfApw.png)

**操作流程：**

![](1__hfRszzcB5mUQt29MZoWGUw.gif)

**總結：**

在今天的實作中，我們使用了UserDefaults來存放使用者的資料，並透過segue的方法來做轉場以及資料部分的傳遞。現在的公司資料部分只能做查看列表及細節，將會在後面的實作中，加入新增與刪除。

**GitHub：**

[**n913239/PrinceCRM**  
_Contribute to PrinceCRM development by creating an account on GitHub._github.com](https://github.com/n913239/PrinceCRM/tree/v2 "https://github.com/n913239/PrinceCRM/tree/v2")[](https://github.com/n913239/PrinceCRM/tree/v2)

**參考資料：**

1.  GitBook 儲存資訊 NSUserDefaults

[**儲存資訊 NSUserDefaults · Swift 起步走**  
_iOS 系統提供儲存資訊的方式有很多種，最為簡單的就是 NSUserDefaults ，像是儲存使用者的開啟次數、使用時間或是有沒有使用過了哪些功能等等，這些少量資訊就可以使用 NSUserDefaults 來儲存。(大量資訊就不建議使…_itisjoe.gitbooks.io](https://itisjoe.gitbooks.io/swiftgo/content/uikit/nsuserdefaults.html "https://itisjoe.gitbooks.io/swiftgo/content/uikit/nsuserdefaults.html")[](https://itisjoe.gitbooks.io/swiftgo/content/uikit/nsuserdefaults.html)