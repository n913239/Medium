---
title: App Development with Swift
description: iOS 12 Edition
date: '2019-09-07T21:42:15.791Z'
categories: []
keywords: []
slug: /@n913239/app-development-with-swift-ce3add800385
---

### Unit1 (1.1–1.5)

此篇的內容是記錄觀看Apple 開發電子書所做的筆記，觀看的版本是2019年的iOS 12版。

首先是Unit1的學習重點

![](1__niC4NYUzu9OSkQv6gqeQVw.png)

官方版重點

| 學習重點 |    
// Swift Lessons   
Introduction to Swift and Playgrounds Constants,   
Variables, and Data Types Operators Control Flow  

// SDK Lessons Xcode Building, Running,   
and Debugging an App Documentation Interface Builder Basics

#### 1.1 「Introduction to Swift and Playgrounds」

主要介紹  
\* console  
\* open source  
\* playground  
\* results sidebar

#### 1.2 「Constants, Variables, and Data Types」

主要介紹常數，變數，與資料型別

![](1__e8lN5YCr5DRY1wB44bmLoQ.png)

**underscores numbers**

var largeUglyNumber = 1000000000  
var largePrettyNumber = 1\_000\_000\_000

**Type INFERENCE**  
\* 自動判斷型別  
\* 如果不給預設值(初始化)，就要指定型別  
\* 型別都是大寫開頭

// => String  
var name = "mike"

// => Int  
var number:Int

// error  
var x

#### 1.3「Operators」

基本運算

let x 51  
let y 4  
let z= x y // z has a value of 12

let x: Double = 51  
let y Double = 4  
let z x y // z has a value of 12.75

let a = 5  
let b = a % 3 // b has a value of 2

#### 1.4 「Control Flow」

*   基本流程控制

參考文件

[**Control Flow - The Swift Programming Language (Swift 5.1)**  
_Swift provides a variety of control flow statements. These include while loops to perform a task multiple times; if …_developer.apple.com](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID120 "https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID120")[](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID120)

**Switch**

var distance = 500  
switch distance {  
case 0…9:  
 print (“Your destination is close.”)  
case 10…99:  
 print (“Your destination is a medium distance from here.”)  
case 100…999:  
 print (“Your destination is far from here.”)  
default:  
 print (“Are you sure you want to travel this far?”)  
}

**TENARY OPERATOR**

var largest: Int  
let a = 15  
let b = 4  
largest = a > b ? a : b

#### 1.5 「Xcode」

*   IDE 基本操作介紹
*   [shortcuts download](https://github.com/SwiftEducation/teaching-app-dev-swift/blob/master/Overview/XcodeKeyboardShortcuts.pages?raw=true)

#### GitHub

[**chiron-wang/AppDevelopment2019**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/AppDevelopment2019 "https://github.com/chiron-wang/AppDevelopment2019")[](https://github.com/chiron-wang/AppDevelopment2019)

#### Reference

[**‎App Development with Swift**  
_‎This course is designed to teach you the skills needed to be an app developer capable of bringing your own ideas to…_books.apple.com](https://books.apple.com/tw/book/app-development-with-swift/id1465002990 "https://books.apple.com/tw/book/app-development-with-swift/id1465002990")[](https://books.apple.com/tw/book/app-development-with-swift/id1465002990)

[**‎App Development with Swift Teacher Guide**  
_‎This Teacher Guide, a companion to the two-semester long App Development with Swift course, is designed for you to use…_books.apple.com](https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285 "https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285")[](https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285)