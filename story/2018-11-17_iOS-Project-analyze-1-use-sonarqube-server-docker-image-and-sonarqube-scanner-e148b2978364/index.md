---
title: iOS Project analyze 1use sonarqube server docker image and sonarqube scanner
description: 今天的文章主要是分享，如何使用SonarQube來掃描iOS App Project，
date: '2018-11-17T16:59:07.561Z'
categories: []
keywords: []
slug: >-
  /@n913239/ios-project-analyze-1-use-sonarqube-server-docker-image-and-sonarqube-scanner-e148b2978364
---

iOS Project analyze 1  
use sonarqube server docker image and sonarqube scanner

#### 前言：

今天的文章主要是分享，如何使用SonarQube來掃描iOS App Project，

來看看專案是否有隱藏的臭蟲或是怪味道(code smell)．

主要使用到的技術與架構有：

採用docker的方式，來部署SonarQube Server在本機上(MAC OSX)，

由於SonarQube 需要使用一個資料庫來儲存掃描後的結果，

我們採用postgres 資料庫來做搭配，接者安裝SonarQube Scanner。

最後就是掃描我們現有的iOS App Project，並查看掃描的結果。

#### **實作過程：**

1.  首先要在MAC上安裝 Docker ([安裝參考連結](https://docs.docker.com/docker-for-mac/install/)），筆者使用的版本是Community Edition (CE)。

2\. 因為同時要使用兩個docker image來做部署Sonarqube Server，所以筆者採用docker-compose 的方式來做設定，將以下的程式碼儲存到MAC上，  
並命名為docker-compose.yml。

簡易說明：

1\. image 有 sonarqube lts & postgres

2\. sonarqube 使用接口 9000, 9002; postgres 使用接口 5432

3\. postgres 帳號/密碼 sonar / sonar@123

4\. 建立4個volumes對應到MAC主機上(大陸用語為宿主機)，以便之後重啟docker container時，裡面的資料能夠被保存。  
分別為：sonarqube\_conf, sonarqube\_data,  
sonarqube\_extensions, sonarqube\_bundled-plugins

3\. 接者開啟MAC的主控台，筆者個人是慣用iterm2 ([連結](https://www.iterm2.com/))，然後切換到有docker-compose.yml的路徑下，輸入指令『docker-compose-up -d』，啟動並執行容器，其中的-d參數為背景執行。

![](1__thhLt5L2AtMAnKf3CniaYA.png)

4\. 接者我們打開瀏覽器，連接網址『http://localhost:9000』，已經可以連接到SonarQube Server，並使用預設帳密『admin / admin』來做登入。

![](1__m7wkNRWSN2xahLGKdj3fiQ.png)

5\. 第一次登入，會出現教學模式，首先需要建立一個token，我們輸入swift，並按下Generate。

![](1__CDGC9JKXFLdbslOkxdb1Sw.png)

6\. 這邊要特別注意，這個token要自行保存，之後不會再次顯示，如果忘記，只能刪除再重新設定了。

![](1__hB9tt0IoRLuMt0qwpESznw.png)

7\. 接者選擇後面要掃描的語言，這邊我們選擇Other => macOS => 輸入project key => Done

![](1__Euv3sVJirLGnyLfkuLr5fw.png)

8\. 接者會出現後續掃描專案用的指令，也可以直接點選COPY到剪貼簿，畫面有個Download按鈕，點下後會連結到官方說明文件。

![](1__9cBbZPhOSM4hRF1jvrTA0Q.png)

9\. 到此我們先按下Skip this tutorial，我們已經完成了SonarQube Server的安裝。

#### **總結：**

今天介紹了採用Dokcer的方式，來部署設定SonarQube Server & Postgres DB，完成了之後要掃描 iOS App Project的前置準備動作，  
之後的文章裡，將會實際介紹如何掃描一個專案的程式碼，  
並查看相關的報表，感謝您的閱讀。

#### **Reference：**

1.  docker for mac

[**Get started with Docker for Mac**  
_Welcome to Docker for Mac! Docker is a full development platform for creating containerized apps, and Docker for Mac is…_docs.docker.com](https://docs.docker.com/docker-for-mac/ "https://docs.docker.com/docker-for-mac/")[](https://docs.docker.com/docker-for-mac/)

2\. docker compose 官方文件

[**Docker Compose**  
_Compose is a tool for defining and running multi-container Docker applications. To learn more about Compose refer to…_docs.docker.com](https://docs.docker.com/compose/ "https://docs.docker.com/compose/")[](https://docs.docker.com/compose/)

3\. SonarQube 官方文件

[**Continuous Inspection | SonarQube**  
_The leading product for continuous code quality_www.sonarqube.org](https://www.sonarqube.org/ "https://www.sonarqube.org/")[](https://www.sonarqube.org/)

4\. SonarQube Swift 官方文件

[**SonarSwift - Plugins - Doc SonarQube**  
_Assuming steps 1-3 above have already been completed, you'll want to encapsulate your analysis parameters in a…_docs.sonarqube.org](https://docs.sonarqube.org/display/PLUG/SonarSwift "https://docs.sonarqube.org/display/PLUG/SonarSwift")[](https://docs.sonarqube.org/display/PLUG/SonarSwift)