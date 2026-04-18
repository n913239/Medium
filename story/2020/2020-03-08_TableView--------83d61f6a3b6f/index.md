---
title: TableView測試的零散筆記
description: UITableView/Cell/Header
date: '2020-03-08T03:43:21.930Z'
categories: []
keywords: []
slug: >-
  /@n913239/tableview%E6%B8%AC%E8%A9%A6%E7%9A%84%E9%9B%B6%E6%95%A3%E7%AD%86%E8%A8%98-83d61f6a3b6f
---

UITableView/Cell/Header

#### 前言

延續前一篇文章，這一篇也來記錄一下關於UITableView的幾個練習項目，關於細節內容，請直接參考程式碼。

#### 練習項目

由於對應到各自字的ViewController內，因此就採用VC來做簡單的分類，當然有些重複練習的功能項目，就不會重複列出。

而這一篇的初始畫面比較簡單，直接使用StackView內，包含各個連結的按鈕，並使用segue來做轉場

![](1__UgNBDG__QcNA2CM3WTgCQRw.png)

#### Lyrics

![](1__Ou3eiD__UQ__RQPcRvUo__C3Q.png)

*   AVSpeechSynthesizer() 練習如何點選Cell後，說出對應的文字

#### Lover  
List/Edit/Add

![](1__OItqKWP9FmqW0ywcGXw7bw.png)
![](1__Umyzr6LLXXic9wBXxOlDaw.png)
![](1__VJD8FAMhATqrl5QhasJ73Q.png)

*   設定所有cell的高度
*   IBSegueAction
*   unwindToLoverTableView (分為新增/修改)
*   viewWithTag()
*   convert(:to:)課堂中的幾個相關練習，Cell, Model建立，轉場以及傳值
*   TableView直接拉入View，當作Header (Edit頁面)
*   自訂HeaderView，繼承自『UITableViewHeaderFooterView』(Add頁面)
*   TableView內註冊自訂HeaderView
*   tableView的deleteRow

#### AutoLayoutCell

![](1__cLY4SMBy1cD4FAjKEt9gLg.png)

*   念奴嬌，練習讓Cell自動計算高度 (ref1)
*   由subview的constraint決定superview的大小

#### TableViewDiffableDataSource

![](1__mb890TR__Z81Z93pWnF1WJg.png)
![](1__m58Wjje__7gNSHYtB7VXXcg.png)

*   iOS 13利用diffable data source顯示表格內容 (ref2)

#### Static Cells Height

![](1__1BcY1WB6X2MwAqLM0CARAg.png)

*   如何讓 Static Cells 自動計算高度 (ref3)

#### ReOrder

![](1__B85uFOTif0QWfaYKiAybSQ.png)

*   Making table cells reorderable (ref4)

**其他練習**

**Storyboard分拆**

*   選擇要拆分的VC => Editor => Refactor to Storyboard =>   
    Enter new SB name

![](1__fWiGjNu3nFHG4hDA3a0Jmw.png)
![](1__d7uK2wN__jH87Tjsxk5jBlQ.png)

**extension練習**

*   加入String+isBlank.swift
*   命名風格為『型別 + 方法』
*   判斷空白的好方法 (ref5)

使用方式範例：

private func getErrors() -> \[String\] {

  var result: \[String\] = \[\]

  if nameTextField.text?.isBlank == true {

    result.append("名字")

  }

  if introTextField.text?.isBlank == true {

    result.append("簡介")

  }

  return result

}

#### 總結

本文中所做的內容，大部分都是看教材一邊練習的簡單功能，以及補充教材的練習項目。也加上了一些自己想練習的項目，細節請參考Github程式碼。

#### Reference

1.  從 auto layout 算出 cell 高度的 Interface Builder — Xcode 11 新功能

[**從 auto layout 算出 cell 高度的 Interface Builder — Xcode 11 新功能**  
_為了讓表格 cell 的內容在不同大小的 iPhone 都能完整顯示，我們通常要為 cell 裡的元件加入 auto layout 條件。不過 Interface Builder 原本不太聰明，無法由我們設定的條件算出 cell 的高度。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%BE%9E-auto-layout-%E7%AE%97%E5%87%BA-cell-%E9%AB%98%E5%BA%A6%E7%9A%84-interface-builder-xcode-11-%E6%96%B0%E5%8A%9F%E8%83%BD-4ed68758d5e3 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%BE%9E-auto-layout-%E7%AE%97%E5%87%BA-cell-%E9%AB%98%E5%BA%A6%E7%9A%84-interface-builder-xcode-11-%E6%96%B0%E5%8A%9F%E8%83%BD-4ed68758d5e3")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%BE%9E-auto-layout-%E7%AE%97%E5%87%BA-cell-%E9%AB%98%E5%BA%A6%E7%9A%84-interface-builder-xcode-11-%E6%96%B0%E5%8A%9F%E8%83%BD-4ed68758d5e3)

2\. 利用 diffable data source 顯示表格內容

[**利用 diffable data source 顯示表格內容**  
_從 iOS 13 開始，搭配全新的 UITableViewDiffableDataSource，現在從程式設定表格內容變得更方便了。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-diffable-data-source-%E9%A1%AF%E7%A4%BA%E8%A1%A8%E6%A0%BC%E5%85%A7%E5%AE%B9-4e4aa0294bf6 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-diffable-data-source-%E9%A1%AF%E7%A4%BA%E8%A1%A8%E6%A0%BC%E5%85%A7%E5%AE%B9-4e4aa0294bf6")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-diffable-data-source-%E9%A1%AF%E7%A4%BA%E8%A1%A8%E6%A0%BC%E5%85%A7%E5%AE%B9-4e4aa0294bf6)

3\. 如何讓 Static Cells 自動計算高度

[**如何讓 Static Cells 自動計算高度**  
_使用 Static Cells 製作表格時，我們可在 storyboard 快速地設定表格內容，而不用麻煩地定義 UITableViewDataSource 的相關 function。_medium.com](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%AE%93-static-cell-%E8%87%AA%E5%8B%95%E8%A8%88%E7%AE%97%E9%AB%98%E5%BA%A6-cb493a522245 "https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%AE%93-static-cell-%E8%87%AA%E5%8B%95%E8%A8%88%E7%AE%97%E9%AB%98%E5%BA%A6-cb493a522245")[](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%A6%82%E4%BD%95%E8%AE%93-static-cell-%E8%87%AA%E5%8B%95%E8%A8%88%E7%AE%97%E9%AB%98%E5%BA%A6-cb493a522245)

4\. Making table cells reorderable

[**Making table cells reorderable**  
_This example shows how to make UITableView cells reorderable: Tested with Xcode 10.1 Download…_www.ralfebert.de](https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/reorderable-cells/ "https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/reorderable-cells/")[](https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/reorderable-cells/)

5\. Swift5中如何判断一个字符串是否为空字符串（包含多个空格的情况）

[**Swift5中如何判断一个字符串是否为空字符串（包含多个空格的情况）**  
_"xx".isEmpty --推荐 "xx".count == 0 --不推荐，因为需要遍历，费资源 但isEmpty无法判断这种情况： 这种全部是空格的字串也被判断成了非空，也就是说Swift认为" " 不是空字串。…_zhuanlan.zhihu.com](https://zhuanlan.zhihu.com/p/80520884 "https://zhuanlan.zhihu.com/p/80520884")[](https://zhuanlan.zhihu.com/p/80520884)

6\. Adding Headers and Footers to Table Sections

[**Adding Headers and Footers to Table Sections**  
_Use header and footer views as visual markers for the beginning and end of sections. Header and footer views are…_developer.apple.com](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/adding_headers_and_footers_to_table_sections "https://developer.apple.com/documentation/uikit/views_and_controls/table_views/adding_headers_and_footers_to_table_sections")[](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/adding_headers_and_footers_to_table_sections)

#### GitHub

[**chiron-wang/TableViewTest**  
_UITableView test. Contribute to chiron-wang/TableViewTest development by creating an account on GitHub._github.com](https://github.com/chiron-wang/TableViewTest "https://github.com/chiron-wang/TableViewTest")[](https://github.com/chiron-wang/TableViewTest)