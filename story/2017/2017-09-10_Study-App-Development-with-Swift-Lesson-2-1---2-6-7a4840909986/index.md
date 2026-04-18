---
title: Study App Development with Swift Lesson 2.1 ~ 2.6
description: 讀書計畫 2017/9/9
date: '2017-09-10T07:05:37.928Z'
categories: []
keywords: []
slug: >-
  /@n913239/study-intro-to-app-development-with-swift-lesson-2-1-2-6-7a4840909986
---

### 讀書計畫 2017/9/9

閱讀Apple官方電子書的計畫第二天，  
從Lesson 2開始閱讀。

這個單元分為兩個部分分別是Swift Lessons & SDK Lessons。

#### Lesson 2.1 Strings

**Vocabulary**

> case sensitivity、concatenation、equality、escape character、

> index、literal、range、string interpolation、

> substring、Unicode

大小寫相異，跳脫字元，String.isEmpty，\\()插入字串，字串與字元，

#### Lesson 2.2 Functions

**Vocabulary**

> argument label、parameter

> return type、return value

外部參數與內部參數，參數預設值(必須在最後)，回傳型別與回傳值

#### Lesson 2.3 Structures

**Vocabulary**

> computed property、function、initializer、initialization、

> instance method、memberwise initializer、method、property、

> self、structure、type

基本型別的init()初始值，結構的memberwise initializers，willSet & didSet，

#### Lesson 2.4 Classes, Inheritance

**Vocabulary**

> base class、class、inheritance、

> state、subclass、superclass

父類別與子類別，透過super呼叫父類別的方法，繼承與複寫

#### Lesson 2.5 Collections

**Vocabulary**

> array、dictionary

array型別(\[Int\] or Array<Int>)

array的幾個方法與屬性

myArray.isEmpty

numbers.contains(5)

names.append("Joe")

names.insert("Bob", at: 0)

dictionary

字典的初始化

var myDictionary = \[String: Int\]()

var myDictionary = Dictionary<String, Int>()

var myDictionary: \[String: Int\] = \[:\]  
  

字典的修改並取得修改之前的值

let oldValue = scores.updateValue(100, forKey: "Richard")

移除字典中的值

scores\["Richard"\] = nil

scores.removeValue(forKey: "Luke")

字典轉為陣列

let players = Array(scores.keys)

let points = Array(scores.values)

#### Lesson 2.6 Loops

**Vocabulary**

> for loop

> for-in loop

> while loop

for 迴圈與for (in)迴圈，while迴圈

回傳Tuple的enumerated()

看完Lesson 2.1 ~ 2.6，大多是介紹Swift的部分，這裏列出一些精簡的內容，

算是給自己看得筆記，未來就可以快速地掃過，

由於書的範例都很清楚，就沒有提供GitHub實作了

**參考資料：**

1.  Apple 電子書

[**Intro to App Development with Swift by Apple Education on iBooks**  
_Read a free sample or buy Intro to App Development with Swift by Apple Education. You can read this book with iBooks on…_itunes.apple.com](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11 "https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11")[](https://itunes.apple.com/us/book/intro-to-app-development-with-swift/id1118575552?mt=11)