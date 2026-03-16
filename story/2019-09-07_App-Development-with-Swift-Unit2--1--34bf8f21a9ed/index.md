---
title: App Development with Swift Unit2 (1)
description: iOS 12 Edition
date: '2019-09-07T21:58:08.000Z'
categories: []
keywords: []
slug: /@n913239/app-development-with-swift-unit2-1-34bf8f21a9ed
---

此篇的內容是記錄觀看Apple 開發電子書所做的筆記，觀看的版本是2019年的iOS 12版。

首先是Unit2的學習重點

![](1__VarXzNfsNy0z1HRXzi3QEA.png)

官方版重點

```
| 學習重點 |2019年7月30日 （第 113 頁）// Swift LessonsStringsFunctionsStructuresClasses and InheritanceCollectionsLoops// SDK LessonsIntroduction to UIKitDisplaying DataControls in ActionAuto layout and Stack Views// What You'll BuildApple Pie is a simple word-guessing game, where the user must guess a word, letter by letter, before all the apples fall off of the apple tree. If there are apples remaining, the user wins—and can eat delicious Apple Pie.
```

#### 2.1 「Introduction to Swift and Playgrounds」

主要介紹  
\* 字串定義  
\* 字串比較  
\* 字串填入

參考文件

[**Strings and Characters - The Swift Programming Language (Swift 5.1)**  
_A string is a series of characters, such as "hello, world" or "albatross" . Swift strings are represented by the String…_docs.swift.org](https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html "https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html")[](https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html)

> **multiline**

```
let joke = """  Q: Why did the chicken cross the road?  A: To get to the other side!  """print(joke)
```

> escape character

```
2019年7月30日 （第 116 頁）
```

```
Double quote: \"Single quote: \'Backslash: \\Tab: \tCarriage return (return to beginning of the line): \r
```

> String 常用 method

```
// lowercasedlet month = "January"month.lowercased()
```

```
// hasPrefix(_:) & hasSuffix(_:)let greeting = "Hello, world!"greeting.hasPrefix("Hello") // truegreeting.hasSuffix("world!") // true
```

```
// containsgreeting.contains(", world!") // true
```

```
// countgreeting.count // 13
```

> Character

```
let someCharacter: Character = "e" // e
```

#### 2.2 Functions

主要介紹

*   Functions 定義
*   Functions 使用
*   return type 回傳型別
*   參數

參考文件

[**Functions - The Swift Programming Language (Swift 5.1)**  
_Functions are self-contained chunks of code that perform a specific task. You give a function a name that identifies…_docs.swift.org](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#//apple_ref/doc/uid/TP40014097-CH10-ID158 "https://docs.swift.org/swift-book/LanguageGuide/Functions.html#//apple_ref/doc/uid/TP40014097-CH10-ID158")[](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#//apple_ref/doc/uid/TP40014097-CH10-ID158)

> Argument Labels

```
func sayHello(from firstName: String) {    print ("Hello, \(firstName)!")}
```

> Return value

```
func multiply ( firstNumber: Int, secondNumber: Int) -> Int {    let result    firstNumber * secondNumber    return result}
```

#### 2.3 「Structures」

主要介紹

*   Struct 定義
*   Struct 使用
*   Struct method, property 定義

參考文件

[**Structures and Classes - The Swift Programming Language (Swift 5.1)**  
_Structures and classes are general-purpose, flexible constructs that become the building blocks of your program's code…_developer.apple.com](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82 "https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82")[](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82)

> struct => Mem

```
struct Car {    var make: String    var model: String    var year: Int    var topSpeed: Int}
```

```
// Memberwise initializerlet firstCar = Car (make: "Honda", model: "Civic", year: 2010, topSpeed: 120)
```

_When you add a custom initializer to a type definition, you must define your own memberwise initializer_

> Computed Properties

```
struct Temperature {    var celsius: Double    var fahrenheit: Double {        return celsius * 1.8 +32    }    var kelvin: Double    }
```

> Property Observers

```
struct StepCounter {    var totalSteps: Int = 0 {        willSet {            print ("About to set totalSteps to \(newValue)")        }        didSet {            if totalSteps > oldValue {                print ("Added \(totalSteps - oldValue) steps")            }        }    }}
```

#### 2.4 「Classes, Inheritance」

主要介紹

*   Class 定義，使用
*   繼承

參考文件

[**Inheritance - The Swift Programming Language (Swift 5.1)**  
_A class can inherit methods, properties, and other characteristics from another class. When one class inherits from…_docs.swift.org](https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html "https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html")[](https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html)

[**Structures and Classes - The Swift Programming Language (Swift 5.1)**  
_Structures and classes are general-purpose, flexible constructs that become the building blocks of your program's code…_docs.swift.org](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82 "https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82")[](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID82)

> Inheritance

```
// base(super) classclass Vehicle {    var currentSpeed = 0.0    var description: String {    return "traveling at \(currentSpeed) miles per hour"    }    func makeNoise ( )}// subclassclass Bicycle: Vehicle {    var hasBasket = false}
```

> Override Methods and Properties

```
class Train: Vehicle {    override func makeNoise() {        print("Choo Choo!")    }}let train = Train()train.makeNoise() // Choo Choo!
```

```
class Car: Vehicle {    var gear = 1    override var description: String {        return super.description "in gear \(gear)"    }}
```

> Override Initializer

```
class Person {    let name: String    init(name: String)    self.name = name}
```

```
class Student: Person {    var favoriteSubject: String    init (name: String, favoriteSubject: String) {        self.favoriteSubject = favoriteSubject        super init(name: name)    }}
```

#### 2.5 「Collections」

主要介紹

*   定義常數與變數集合
*   集合操作
*   陣列，字典操作

參考文件

[**Collection Types - The Swift Programming Language (Swift 5.1)**  
_Swift provides three primary collection types, known as arrays, sets, and dictionaries, for storing collections of…_developer.apple.com](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID105 "https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID105")[](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID105)

> Arrays

```
// contains(_:)let numbers = [4, 5, 6]if numbers.contains (5) {    print("There is a 5")}
```

```
// Array Typesvar myArray: [Int] = []var myArray: Array<Int> = []var myArray = [Int]()
```

> WORKING WITH ARRAYS

```
var myArray = [Int](repeating: 0, count: 100)
```

```
let count = myArray.countif myArray.isEmpty { }
```

```
let firstName = names[0]
```

```
names[1] = "Mike"
```

> Array append

```
var names = ["Amy"]names.append("Joe")names += ["Keith", "Jane"]print (names) //["Amy", "Joe", "Keith", "Jane"]
```

```
names.insert("Bob", at: 0)
```

```
var myNewArray = firstArray + secondArray
```

> Array remove

```
var names = ["Amy", "Brad", "Chelsea", "Dan"]let chelsea = names.remove(at:2)let dan = names.removeLast ()names.removeAll()
```

> Nested Array

```
let array1=[1,2,3]let array2=[4,5,6]let containerArray = [array1, array2] //[ [1,2,3], [4,5,6]
```

```
let firstArray = containerArray [0] //[1,2,3]let firstElement = containerArray[0][0] //1
```

> Dictionaries

```
var scores = ["Richard": 500, "Luke": 400, "Cheryl": 800]
```

```
var myDictionary = [String: Int] ( )var myDictionary = Dictionary<String, Int>()var myDictionary: [String: Int] = [:]
```

> Add/Remove/Modify A Dictionary

```
scores["Oli") = 399
```

```
let oldValue = scores.updateValue (100, forkey: "Richard")
```

```
if let oldValue = scores.updateValue ( 100, forkey: "Richard") {    print("Richard’s old value was \(0ldValue)")}
```

> Deictionary Remove

```
var scores = ["Richard": 100, "Luke": 400, "Cheryl": 800]scores["Richard"] = nil //["Luke": 400, "Cheryl": 800]
```

```
if let oldValue = scores.removeValue(forKey: "Luke") {    print("Luke’s score was \(oldValue) before he stopped playing")}
```

> Accessing A Dictionary

```
var scores = ["Richard" 500, "Luke": 400, "Cheryl": 800]
```

```
let players = Array(scores.keys) //["Richard", "Luke", "Chery1"let points = Array(scores.values) //[500, 400, 800]
```

```
if let myScore = scores["Luke"] {    print(myScore) // 400}if let henrysScore = scores["Henry"] {    print (henrys Score) //not executed; "Henry" is not a key in the dictionary}
```

#### GitHub

[**chiron-wang/AppDevelopment2019**  
_You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…_github.com](https://github.com/chiron-wang/AppDevelopment2019 "https://github.com/chiron-wang/AppDevelopment2019")[](https://github.com/chiron-wang/AppDevelopment2019)

#### Reference

[**‎App Development with Swift**  
_‎This course is designed to teach you the skills needed to be an app developer capable of bringing your own ideas to…_books.apple.com](https://books.apple.com/tw/book/app-development-with-swift/id1465002990 "https://books.apple.com/tw/book/app-development-with-swift/id1465002990")[](https://books.apple.com/tw/book/app-development-with-swift/id1465002990)

[**‎App Development with Swift Teacher Guide**  
_‎This Teacher Guide, a companion to the two-semester long App Development with Swift course, is designed for you to use…_books.apple.com](https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285 "https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285")[](https://books.apple.com/tw/book/app-development-with-swift-teacher-guide/id1465003285)