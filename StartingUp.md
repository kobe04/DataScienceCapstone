---
title: "Preliminary Milestone Report"
author: "K. van Splunter"
date: "April 2019"
output: 
  html_document: 
    keep_md: yes
---


## Introduction


## Loading the initial data

This part of the code downloads the data to the computer and unzips it. It checks if the data is already downloaded and unzipped. If the names of the original files are not changed, this process will only download the files once.


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
sizeBlogs <- file.size("./Data/final/en_US/en_US.blogs.txt")/(10^6)
sizeNews <- file.size("./Data/final/en_US/en_US.news.txt")/(10^6)
sizeTwitter <- file.size("./Data/final/en_US/en_US.twitter.txt")/(10^6)
```

There are three files. They respectively hold texts about blogs, news, and tweets.
The size of the files is quite big. The data of the blogs is 210.160014 MB.
The news-data is 205.811889 MB. The twitter-data is 167.105338 MB.
Because the files are this big, the files are sampled and a new (smaller) datafile is created.

## Creating a sample

To assure that this project is reproducible, the seed is set. Then, the samples are taken and combined into one new file.

```r
set.seed(824039)
```
##
