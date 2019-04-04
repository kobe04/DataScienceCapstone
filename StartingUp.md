---
title: "Preliminary Milestone Report"
author: "K. van Splunter"
date: "April 2019"
output: 
  html_document: 
    keep_md: yes
---


## Introduction

This report provides an introduction to the Capstone Project for the Data Science Specialization on [Coursera][1]. The overall goal of the project is to develop a word predictor. It will be deployed as a Shiny app and be accompanied by a Presentation that pitches the app. The project is done in partnership with [SwiftKey][2].

The goal of this report is to provide some exploratory analysis of the data.

To keep this report tidy and short, most of the code is not included. However, the code can easily be found and checked [here][3]!

## Loading the initial data

This part of the code downloads the data to the computer and unzips it. It checks if the data is already downloaded and unzipped. If the names of the original files are not changed, this process will only download the files once. Furthermore, the necessary packages are loaded.


```r
# Create a directory for the data
if(!file.exists("./Data")){
    dir.create("./Data")
}
# Download the data
URL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
if(!file.exists("./Data/SwiftkeyData.zip")){
    download.file(URL, destfile = "./Data/SwiftkeyData.zip")
}
# Unzip the data
if(!file.exists("./Data/final")){
    unzip(zipfile = "./Data/SwiftkeyData.zip", exdir = "./Data")
}
dir("./Data/final/en_US")
```

```
## [1] "en_US.blogs.txt"   "en_US.news.txt"    "en_US.twitter.txt"
```

```r
# Calculate the size of the files
sizeBlogs <- round(file.size("./Data/final/en_US/en_US.blogs.txt")/(10^6), 3)
sizeNews <- round(file.size("./Data/final/en_US/en_US.news.txt")/(10^6), 3)
sizeTwitter <- round(file.size("./Data/final/en_US/en_US.twitter.txt")/(10^6), 3)

library(readr); library(tm)
```

```
## Loading required package: NLP
```

There are three files. They respectively hold texts about blogs, news, and tweets.
The size of the files is quite big. The data of the blogs is 210.16 MB.
The news-data is 205.812 MB. The twitter-data is 167.105 MB.
Because the files are this big, the files are sampled and a new (smaller) datafile is created.

## Creating a sample

To assure that this project is reproducible, the seed is set. Then, the samples are taken and combined into one new file. It is decided that about 5% of the data in the files is included in the sample. These are the first three entries in the sample.


```
## [1] "Life is busy!"                               
## [2] "Acts 9:7-8"                                  
## [3] "How long did it take you to write your book?"
```


## Exploratory analysis

First, several characteristics of the original data and the sample are shown. These are the size, the length (how many entries), and the (estimated) total amount of words.


```
##   DataSource    Size  Length    Words
## 1      Blogs 210.160  899288 38601602
## 2       News 205.812 1010242 35624468
## 3    Twitter 167.105 2360148 31105021
## 4     Sample  29.027  213483  5246813
```

For further analysis, the sample is cleaned. As the first three entries show, 





[1]: https://www.coursera.org/specializations/jhu-data-science "Coursera"
[2]: https://www.microsoft.com/en-us/swiftkey?rtc=1&activetab=pivot_1%3aprimaryr2 "SwiftKey"
[3]: https://github.com/kobe04/DataScienceCapstone "here"
