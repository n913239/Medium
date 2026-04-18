---
title: PrinceCRM Project 4
description: 小王子客戶管理系統 第四章
date: '2017-09-05T13:12:41.080Z'
categories: []
keywords: []
slug: /@n913239/princecrm-project-4-9402caae64c2
---

小王子客戶管理系統 第四章

延續前一篇已經實作好的查詢與Details的功能，本文主要實作的功能為新增與刪除，並包含了修改的功能。

**實作過程：**

1\. 首先是將上次已經寫好的Details明細功能，修改為可以編輯的畫面，這邊一樣是採用TableView的部分來做呈現。這邊製作了兩個Cell，透過程式來決定要採用哪一個。其中有id的樣板為搭配UITextField來做輸入，而公司名稱的樣板，則搭配UITextView來做多行文字的輸入。

![](1__hsrAiQUpiSgCe8iHsSZzCw.png)

2\. 由於等等要取得與編輯畫面的輸入元件資料，我們建立一個UITableViewCell的class，並拉好Outlet以備後面使用。同時，別忘了畫面上的class要指定給UITableViewCell

class CompanyDetailsTableViewCell: UITableViewCell {

@IBOutlet weak var shortLabel: UILabel!

@IBOutlet weak var shortTextField: UITextField!

@IBOutlet weak var longLabel: UILabel!

@IBOutlet weak var longTextView: UITextView!

......

}

![](1__GgPzYRpSAddmYceWpHw7yQ.png)

3\. 同時在CompanyDetailsTableViewCell上自訂一個取值的方法，方便等下在主要畫面的程式中來使用

extension CompanyDetailsTableViewCell {

    func getTextFieldDic() -> (String, String) {

        if let short = shortTextField {

            return (short.restorationIdentifier!, short.text!

        }

        if let long = longTextView {

            return (long.restorationIdentifier!, long.text!)

        }

        return ("","")

    }

}

}

4\. 接者回到Details的畫面，我們開始來設定TableViewCell，為了畫面的簡潔，我們將它抽離到func內。

5\. 由於欄位的外觀樣式總共有兩種，而且欄位的總數是固定的，其實在撰寫上可以寫成固定的就好，這邊主要是為了練習的原因，讓他透過程式來產生。所以……取值的方式，就很麻煩了，這邊搭配了兩個迴圈(巢狀)來做取值的動作，並透過call web api的方式，來將資料回傳到後端。

6\. 到這邊已經完成了編輯儲存的功能，接者要實作的刪除功能，就透過TabiewView的func來幫忙。

7\. 到現在為止，今天我們所要實作的功能都完成囉，想知道更多的細節部分，請參考GitHub專案的程式碼(tag: v3)。

**完成圖：**

![](1__GUqfydBbgv__wQ2Fm3f__U3w.png)
![](1__cmP8__4N5e7SMG3t__wClKoQ.png)
![](1__0PlCKImYP7kO162__qeMzIA.png)

**操作流程：**

![](1__bpSG4aPmYhW6PiCXWNxJrg.gif)

**總結：**

在今天的實作中，我們完成了資料操作流程中基本的CRUD，並實際的與web api 後端串接，將資料傳回後端。同時，在company的編輯畫面中，我們也透過程式來設定不同的鍵盤輸入類型。在後面的文章中，預計會陸續的加入所學習到的各種功能，例如地圖的Mapkit串接等等。

**GitHub：**

[**n913239/PrinceCRM**  
_Contribute to PrinceCRM development by creating an account on GitHub._github.com](https://github.com/n913239/PrinceCRM/tree/v3 "https://github.com/n913239/PrinceCRM/tree/v3")[](https://github.com/n913239/PrinceCRM/tree/v3)