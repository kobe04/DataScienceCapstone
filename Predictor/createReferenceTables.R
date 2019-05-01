### This file creates the necessary reference-tables for the word predictor


### DON'T RUN THE CODE. IT´S ONLY TO SHOW THE CODE THAT WAS USED. ###


#### Load the neccessary packages ####
suppressPackageStartupMessages(c(library(readr), library(quanteda), library(data.table),
                                 library(stringr), library(rstudioapi)))

#### Read in the data ####
con <- file("./MilestoneReport/Data/final/en_US/en_US.blogs.txt",
            encoding = "UTF-8", method = "r")
blogData <- readLines(con, skipNul = TRUE)
close(con)

con <- file("./MilestoneReport/Data/final/en_US/en_US.news.txt",
            encoding = "UTF-8", method = "r")
newsData <- read_lines(con, skip = 0)
close(con)

con <- file("./MilestoneReport/Data/final/en_US/en_US.twitter.txt",
            encoding = "UTF-8", method = "r")
twitterData <- readLines(con, skipNul = TRUE)
close(con)

##### Create Complete Data set ####
completeData <- c(twitterData, blogData, newsData)
writeLines(completeData, "./Predictor/Data/completeData.txt")
rm(list = c("completeData", "twitterData", "newsData"))
restartSession() # To clear RAM

# Load in profanityList ####
profanityList <- c("shit", "piss", "fuck", "cunt", "cocksucker", "motherfucker", "tits")

# Set quanteda to use 6 threads. ####
### PLEASE CHECK HOW MANY THREADS YOUR COMPUTER HAS! ###
quanteda_options(threads = 6)
quanteda_options("threads")

# Function to create corpus ####
corpusCreate <- function(txt){
    txt <- char_tolower(txt)
    dataCorpus <- corpus(txt)
}

### REPEAT THE FOLLOWING STEPS FOR ALL 3 SOURCES!! ####
blogData <- gsub("[[:digit:]]+", "", blogData)
blogData <- gsub("pm", "", blogData)
blogData <- gsub("oz", "", blogData)
blogData <- gsub("mm", "", blogData)

# Create corpus
corpusBlogData <- corpusCreate(blogData)
rm(blogData)

# Function to clean the corpus, tokenize it, and create DFM
tokensClean <- function(corp, n){
    tokenized <- tokens(corp, what = "word", remove_numbers = TRUE, remove_punct = TRUE,
                        remove_symbols = TRUE, remove_separators = TRUE, remove_url = TRUE,
                        remove_hyphens = TRUE, remove_twitter = TRUE)
    tokenized <- tokens_remove(tokenized, profanityList)
    tokenized <- tokens_ngrams(tokenized, n, concatenator = " ")
    DFM <- dfm(tokenized)
    return(DFM)
}

# Create the DFMs
dfmUnigram <- tokensClean(corpusBlogData, 1)
saveRDS(dfmUnigram, "./Predictor/Data/dfmUnigramBlog.rds")
rm(dfmUnigram)
restartSession() # To clear RAM

dfmBigram <- tokensClean(corpusBlogData, 2)
saveRDS(dfmBigram, "./Predictor/Data/dfmBigramBlog.rds")
rm(dfmBigram)
restartSession() # To clear RAM

dfmTrigram <- tokensClean(corpusBlogData, 3)
saveRDS(dfmTrigram, "./Predictor/Data/dfmTrigramBlog.rds")
rm(dfmTrigram)
restartSession() # To clear RAM

dfmQuadgram <- tokensClean(corpusBlogData, 4)
saveRDS(dfmQuadgram, "./Predictor/Data/dfmQuadgramBlog.rds")
rm(dfmQuadgram)
restartSession() # To clear RAM

dfmQuintgram <- tokensClean(corpusBlogData, 5)
saveRDS(dfmQuintgram, "./Predictor/Data/dfmQuintgramBlog.rds")
rm(list = c("corpusBlogData", "dfmQuintgram"))
restartSession() # To clear RAM

# Create function to make data.tables in different way (with help of textstat_frequency())
createDT <- function(df) {
    dataTable <- data.table(feature = df$feature, frequency = df$frequency, keep.rownames = NULL,
                            stringsAsFactors = FALSE)
    dataTable <- dataTable[order(-frequency)]
    return(dataTable)
}

# Create data.tables
dfmUnigram <- readRDS("./Predictor/Data/dfmUnigramBlog.rds")
dfUnigram <- textstat_frequency(dfmUnigram)
uniDTBlog <- createDT(dfUnigram)
saveRDS(uniDTBlog, "./Predictor/Data/uniDTBlog.rds")
rm(list = c("dfmUnigram", "uniDTBlog", "dfUnigram"))
restartSession() # To clear RAM

dfmBigram <- readRDS("./Predictor/Data/dfmBigramBlog.rds")
dfBigram <- textstat_frequency(dfmBigram)
biDTBlog <- createDT(dfBigram)
saveRDS(biDTBlog, "./Predictor/Data/biDTBlog.rds")
rm(list = c("dfmBigram", "biDTBlog", "dfBigram"))
restartSession() # To clear RAM

dfmTrigram <- readRDS("./Predictor/Data/dfmTrigramBlog.rds")
dfTrigram <- textstat_frequency(dfmTrigram)
triDTBlog <- createDT(dfTrigram)
saveRDS(triDTBlog, "./Predictor/Data/triDTBlog.rds")
rm(list = c("dfmTrigram", "dfTrigram", "triDTBlog"))
restartSession() # To clear RAM

dfmQuadgram <- readRDS("./Predictor/Data/dfmQuadgramBlog.rds")
dfQuadgram <- textstat_frequency(dfmQuadgram)
quadDTBlog <- createDT(dfQuadgram)
saveRDS(quadDTBlog, "./Predictor/Data/quadDTBlog.rds")
rm(list = c("dfmQuadgram", "dfQuadgram", "quadDTBlog"))
restartSession() # To clear RAM

dfmQuintgram <- readRDS("./Predictor/Data/dfmQuintgramBlog.rds")
dfQuintgram <- textstat_frequency(dfmQuintgram)
quintDTBlog <- createDT(dfQuintgram)
saveRDS(quintDTBlog, "./Predictor/Data/quintDTBlog.rds")
rm(list = c("dfmQuintgram", "dfQuintgram", "quintDTBlog"))
restartSession() # To clear RAM


### Repeat the steps above for all 3 sources!!! ###

# Now, combine the 3 data.tables (one for each source), into one ####
# unigram
DTBlog <- readRDS("./Predictor/Data/uniDTBlog.rds")
DTNews <- readRDS("./Predictor/Data/uniDTNews.rds")
names(DTBlog) <- c("feature", "freqblog")
names(DTNews) <- c("feature", "freqnews")
mergeStep <- merge(DTBlog, DTNews, by = "feature", all.x = T, all.y = T)
rm(list = c("DTBlog", "DTNews"))

DTTwit <- readRDS("./Predictor/Data/uniDTTwit.rds")
names(DTTwit) <- c("feature", "freqtwit")
mergeTot <- merge(mergeStep, DTTwit, by = "feature", all.x = T, all.y = T)
rm(list = c("mergeStep", "DTTwit"))
restartSession()
mergeTot <- mergeTot[,lapply(.SD, function(x){ifelse(is.na(x), 0, x)})] # to change NA into 0
mergeTot[,frequency:= sum(freqblog, freqnews, freqtwit), by = feature] # to calculate frequency over all 3 sources
mergeTot <- mergeTot[,-c("freqblog", "freqnews", "freqtwit")]
saveRDS(mergeTot, "./Predictor/Data/uniDTComplete.rds")
rm(mergeTot)
restartSession() # To clear RAM

# bigram
DTBlog <- readRDS("./Predictor/Data/biDTBlog.rds")
DTNews <- readRDS("./Predictor/Data/biDTNews.rds")
names(DTBlog) <- c("feature", "freqblog")
names(DTNews) <- c("feature", "freqnews")
mergeStep <- merge(DTBlog, DTNews, by = "feature", all.x = T, all.y = T)
rm(list = c("DTBlog", "DTNews"))

DTTwit <- readRDS("./Predictor/Data/biDTTwit.rds")
names(DTTwit) <- c("feature", "freqtwit")
mergeTot <- merge(mergeStep, DTTwit, by = "feature", all.x = T, all.y = T)
rm(list = c("mergeStep", "DTTwit"))
restartSession() # To clear RAM

mergeTot <- mergeTot[,lapply(.SD, function(x){ifelse(is.na(x), 0, x)})] # to change NA into 0
mergeTot[,frequency:= sum(freqblog, freqnews, freqtwit), by = feature] # to calculate frequency over all 3 sources
mergeTot <- mergeTot[,-c("freqblog", "freqnews", "freqtwit")]
saveRDS(mergeTot, "./Predictor/Data/biDTComplete.rds")
rm(mergeTot)
restartSession() # To clear RAM

# trigram
DTBlog <- readRDS("./Predictor/Data/triDTBlog.rds")
DTNews <- readRDS("./Predictor/Data/triDTNews.rds")
names(DTBlog) <- c("feature", "freqblog")
names(DTNews) <- c("feature", "freqnews")
mergeStep <- merge(DTBlog, DTNews, by = "feature", all.x = T, all.y = T)
rm(list = c("DTBlog", "DTNews"))

DTTwit <- readRDS("./Predictor/Data/triDTTwit.rds")
names(DTTwit) <- c("feature", "freqtwit")
mergeTot <- merge(mergeStep, DTTwit, by = "feature", all.x = T, all.y = T)
rm(list = c("mergeStep", "DTTwit"))
restartSession() # To clear RAM

mergeTot <- mergeTot[,lapply(.SD, function(x){ifelse(is.na(x), 0, x)})] # to change NA into 0
mergeTot[,frequency:= sum(freqblog, freqnews, freqtwit), by = feature] # to calculate frequency over all 3 sources
mergeTot <- mergeTot[,-c("freqblog", "freqnews", "freqtwit")]
saveRDS(mergeTot, "./Predictor/Data/triDTComplete.rds")
rm(mergeTot)
restartSession() # To clear RAM

# quadgram
DTBlog <- readRDS("./Predictor/Data/quadDTBlog.rds")
DTNews <- readRDS("./Predictor/Data/quadDTNews.rds")
names(DTBlog) <- c("feature", "freqblog")
names(DTNews) <- c("feature", "freqnews")
mergeStep <- merge(DTBlog, DTNews, by = "feature", all.x = T, all.y = T)
rm(list = c("DTBlog", "DTNews"))

DTTwit <- readRDS("./Predictor/Data/quadDTTwit.rds")
names(DTTwit) <- c("feature", "freqtwit")
mergeTot <- merge(mergeStep, DTTwit, by = "feature", all.x = T, all.y = T)
rm(list = c("mergeStep", "DTTwit"))
restartSession() # To clear RAM

mergeTot <- mergeTot[,lapply(.SD, function(x){ifelse(is.na(x), 0, x)})] # to change NA into 0
mergeTot[,frequency:= sum(freqblog, freqnews, freqtwit), by = feature] # to calculate frequency over all 3 sources
mergeTot <- mergeTot[,-c("freqblog", "freqnews", "freqtwit")]
saveRDS(mergeTot, "./Predictor/Data/quadDTComplete.rds")
rm(mergeTot)
restartSession() # To clear RAM

# quintgram
DTBlog <- readRDS("./Predictor/Data/quintDTBlog.rds")
DTNews <- readRDS("./Predictor/Data/quintDTNews.rds")
names(DTBlog) <- c("feature", "freqblog")
names(DTNews) <- c("feature", "freqnews")
mergeStep <- merge(DTBlog, DTNews, by = "feature", all.x = T, all.y = T)
rm(list = c("DTBlog", "DTNews"))

DTTwit <- readRDS("./Predictor/Data/quintDTTwit.rds")
names(DTTwit) <- c("feature", "freqtwit")
mergeTot <- merge(mergeStep, DTTwit, by = "feature", all.x = T, all.y = T)
rm(list = c("mergeStep", "DTTwit"))
restartSession() # To clear RAM

mergeTot <- mergeTot[,lapply(.SD, function(x){ifelse(is.na(x), 0, x)})] # to change NA into 0
mergeTot[,frequency:= sum(freqblog, freqnews, freqtwit), by = feature] # to calculate frequency over all 3 sources
mergeTot <- mergeTot[,-c("freqblog", "freqnews", "freqtwit")]
saveRDS(mergeTot, "./Predictor/Data/quintDTComplete.rds")
rm(mergeTot)
restartSession() # To clear RAM

# Add the source-column and the predict-column to the n-grams (except the unigram) ####
# bigram
biDT <- readRDS("./Predictor/Data/biDTComplete.rds")
biDT[,source := word(string = feature, start = 1, end = 2-1, sep = fixed(" "))]
biDT[,predict := word(string = feature, start = 2, end = 2, sep = fixed(" "))]
biDT <- biDT[,-"feature"]
saveRDS(biDT, "./Predictor/Data/biDTComplete.rds")
rm(biDT)
restartSession() # To clear RAM

# trigram (already dropping entries with frequency = 1)
triDT <- readRDS("./Predictor/Data/triDTComplete.rds")
triDT <- triDT[frequency != 1,]
triDT[,source := word(string = feature, start = 1, end = 3-1, sep = fixed(" "))]
triDT[,predict := word(string = feature, start = 3, end = 3, sep = fixed(" "))]
triDT <- triDT[,-"feature"]
saveRDS(triDT, "./Predictor/Data/triDTSmall.rds")
rm(triDT)
restartSession() # To clear RAM

# quadgram (already dropping entries with frequency = 1)
quadDT <- readRDS("./Predictor/Data/quadDTComplete.rds")
quadDT <- quadDT[frequency != 1,]
quadDT[,source := word(string = feature, start = 1, end = 4-1, sep = fixed(" "))]
quadDT[,predict := word(string = feature, start = 4, end = 4, sep = fixed(" "))]
quadDT <- quadDT[,-"feature"]
saveRDS(quadDT, "./Predictor/Data/quadDTSmall.rds")
rm(quadDT)
restartSession() # To clear RAM

# quintgram (already dropping entries with frequency = 1)
quintDT <- readRDS("./Predictor/Data/quintDTComplete.rds")
quintDT <- quintDT[frequency != 1,]
quintDT[,source := word(string = feature, start = 1, end = 5-1, sep = fixed(" "))]
quintDT[,predict := word(string = feature, start = 5, end = 5, sep = fixed(" "))]
quintDT <- quintDT[,-"feature"]
saveRDS(quintDT, "./Predictor/Data/quintDTSmall.rds")
rm(quintDT)
restartSession() # To clear RAM


# Adjust the data.tables to more compact forms ####
# Only keep the top-10 entries of the unigram
uniDT <- readRDS("./Predictor/Data/uniDTComplete.rds")
uniDT <- uniDT[order(-frequency)]
uniDT <- uniDT[1:10,]
saveRDS(uniDT, "./Predictor/Data/uniDTfinal.rds")
# Creating vector of top-10 of unigram
uniVec <- c(uniDT[1,1], uniDT[2,1], uniDT[3,1], uniDT[4,1], uniDT[5,1], uniDT[6,1], uniDT[7,1],
            uniDT[8,1], uniDT[9,1], uniDT[10,1])
uniVec <- unlist(uniVec)
uniVec <- unname(uniVec)
saveRDS(uniVec, "./Shinyapp/WordPredictor/top10.rds")
rm(list = c("uniDT", "uniVec"))

# Retain only the top-3 possibilities for the bi, tri, quad, and quintgrams
biDT <- readRDS("./Predictor/Data/biDTComplete.rds")
biDT <- biDT[order(source, -frequency)]
biDT = biDT[ave(frequency, source, FUN = seq_along) <= 3, ]
saveRDS(biDT, "./Predictor/Data/biDTfinal.rds")
rm(biDT)
restartSession() # To clear RAM

triDT <- readRDS("./Predictor/Data/triDTSmall.rds")
triDT <- triDT[order(source, -frequency)]
triDT = triDT[ave(frequency, source, FUN = seq_along) <= 3, ]
saveRDS(triDT, "./Predictor/Data/triDTfinal.rds")
rm(triDT)
restartSession() # To clear RAM

quadDT <- readRDS("./Predictor/Data/quadDTSmall.rds")
quadDT <- quadDT[order(source, -frequency)]
quadDT = quadDT[ave(frequency, source, FUN = seq_along) <= 3, ]
saveRDS(quadDT, "./Predictor/Data/quadDTfinal.rds")
rm(quadDT)
restartSession() # To clear RAM

quintDT <- readRDS("./Predictor/Data/quintDTSmall.rds")
quintDT <- quintDT[order(source, -frequency)]
quintDT = quintDT[ave(frequency, source, FUN = seq_along) <= 3, ]
saveRDS(quintDT, "./Predictor/Data/quintDTfinal.rds")
restartSession() # To clear RAM

# Creating one Data.table from 2-5gram ####
biDT <- readRDS("./Predictor/Data/biDTfinal.rds")
triDT <- readRDS("./Predictor/Data/triDTfinal.rds")
quadDT <- readRDS("./Predictor/Data/quadDTfinal.rds")

biDT <- biDT[order(source, -frequency)]
triDT <- triDT[order(source, -frequency)]
quadDT <- quadDT[order(source, -frequency)]
quintDT <- quintDT[order(source, -frequency)]

totalDT <- rbind(biDT, triDT, quadDT, quintDT)
totalDT <- totalDT[,-"frequency"]

object.size(totalDT) # to check size of object, should be lower than 1 GB

saveRDS(totalDT, "./Shinyapp/WordPredictor/Data/refDT.rds")

rm(list = c("biDT", "triDT", "quadDT", "quintDT", "totalDT"))
restartSession() # To clear RAM


##### End #####