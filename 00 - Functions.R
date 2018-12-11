##################################################
## This is where all the functions are for the   #
## sentiment analysis project.                   #
##################################################

## Load packages -----
library(twitteR)
library(tm)
library(httr)
library(dplyr)
library(data.table)
library(ggplot2)

myTwitter <- list()

## Login to twitter -----
myTwitter$login <- function(ck = consumer_key, cs = consumer_secret, at = access_token, as = access_secret) {
  setup_twitter_oauth(ck, cs, at, as)
}

myTwitter$getSome <- function(termA, termB, numA = 1, numB = 1, max = max) {
  searchString <- paste(termA[numA], " +", termB[numB], sep="")
  print(searchString)
  results <- searchTwitter(searchString, max)
  if (length(results) >= 1) {       
    df <- twListToDF(results)       
    return(df)                      
  }
}

## Get max number of tweets -----
myTwitter$getAll <- function(termA, termB, max = 500) {
  a <- 0
  myTweetData <- list()                              
  for (x in termA) {         
    a <- a + 1
    b <- 0                                             
    for (y in termB) {   
      b <- b + 1 
      item <- paste(x, "_", y, sep = "")
      #print(item)
      df <- myTwitter$getSome(termA, termB, numA = a, numB = b, max = max)    
      myTweetData[[item]] <- df                     
    }                               
  }
  myTweetDataDF <- do.call(rbind, myTweetData)
  return(myTweetDataDF)
}


## Remove Username and ID from the Data Frame -----
myTwitter$removeUsername <- function(df) {
  df[, "screenName"] <- NULL
  return(df)
}

myTwitter$removeTweetID <- function(df) {
  df[, "id"] <- NULL
  return(df)
}

## Remove retweets for redundancy -----
myTwitter$removeRTs <- function(df) {
  df <- dataFrame[which(dataFrame$isRetweet == FALSE),]
  return(df)
}

## Covert emojis to from UTF -----
myTwitter$convertEmojis <- function(df, textcol = "text", newcol = "ASCII") {
  df[,newcol] <- iconv(df[,textcol], from = "UTF-8", to = "ASCII", "byte")
  return(df)
}

## Replace emoji coding with the name of the emoji per the Emoji Dictionary -----
myTwitter$findNReplace <- function(df, emDict, dfcol = "ASCII", dictcol = "Code", dictdesc = "CLDR Short Name") {
  n <- 0
  for (a in emDict[,dictcol]) {
  n <- n + 1
    nn <- 0
    # emDict$Freq[n] <- length(which(c(grepl(a, df[,dfcol]) == TRUE)))
    print(length(which(c(grepl(a, df[,dfcol]) == TRUE))))
    for (b in df[,dfcol]) {
      nn <- nn + 1
      repl <- paste0("<<", "emoji", emDict[,dictdesc][n], ">>")
      repl <- gsub(" ", "_", repl)
      df[,dfcol][nn] <- gsub(a, repl, b)
    }
    print(repl)
  }
  return(df)
}

## Make a corpus of the words -----
myTwitter$freqTable <- function(df, textvec = "ASCII") {
    dictStopWords <- unlist(dict)
    Qcorp <- paste(df[[textvec]], collapse = " ")
    Qcorp <- Corpus(VectorSource(Qcorp))
    Qcorp <- tm_map(Qcorp, content_transformer(tolower))
    Qcorp <- tm_map(Qcorp, removePunctuation)
    Qcorp <- tm_map(Qcorp, PlainTextDocument)
    Qcorp <- tm_map(Qcorp, removeWords, c(stopwords("english"), dictStopWords)) 
    #Qcorp <- tm_map(Qcorp, stemDocument)
    Qcorp <- tm_map(Qcorp, stripWhitespace)
    Qdtm <- DocumentTermMatrix(Qcorp) 
    Qfreq <- colSums(as.matrix(Qdtm)) 
    Qord <- order(Qfreq) 
    Qfreq <- Qfreq[Qord]
  return(Qfreq)
}


## Make a frequency table from the corpus -----
myTwitter$getFreq <- function(df, freq) {
  freq1 <- as.data.frame(freq)
  freq1$words  <- rownames(freq1)
  colnames(freq1)[1] <- "Frequency"
  freq1  <- subset(freq1, Frequency >= 3)
return(freq1)
}

## Convert words to a data frame -----
myTwitter$wordListtoDF <- function(list) {
  words <- unlist(lapply(list, function(x) lapply(x, "[[", "word")))
  score <- unlist(lapply(list, function(x) lapply(x, "[[", "score")))
  df <- data.frame(words = words, score = score)
  
  return(df)
}

## Get the sentiment type, score, and ratio for tweets using the twinword API -----
myTwitter$getSentiment <- function(df, key) {
  df$sentType <- NA
  df$sentScore <- NA
  df$sentRatio <- NA
  
  words <- list()
  
  n <- 0
  for(a in df$text) {
    n <- n + 1
    
    headers <- c("X-Mashape-Key" = key)                           
    url <- parse_url("https://twinword-sentiment-analysis.p.mashape.com/analyze/")
    url$query <- list("text" = a)                                            
    response <- POST(build_url(url), add_headers(headers),         
                     content_type("application/x-www-form-urlencoded"),   
                     accept_json())
    #response <<- response
    content <- content(response, "parsed")
    
    print(paste(n, content$result_msg, sep = " "))
    
    df$sentType[n] <- content$type
    df$sentScore[n] <- content$score
    df$sentRatio[n] <- content$ratio
    
    words[[n]] <- content$keywords
  }
  
  words <- myTwitter$wordListtoDF(words)
  
  final <- list(df = df, words = words)
  return(final)
}

## Makes a GGPlot of how negative and positive the words are per the twinword API -----
myTwitter$getPlot <- function(df)  {
  sentPlot <- ggplot(dataFrame, aes(x = created, y = sentScore, fill = sentType)) + geom_point(aes(colour = sentType))
  sentPlot
  return(sentPlot)
}

myTwitter$removeDFblanks <- function(df, col = "ASCII", dictlist) {
  ##Make a tm corpus and dtm
  t <- Corpus(VectorSource(df[["ASCII"]]))
  
  #t <- tm_map(t, PlainTextDocument)
  t <- tm_map(t, tolower)
  t <- tm_map(t, removeWords, stopwords("english"))
  t <- tm_map(t, removeWords, unlist(dictlist))
  t <- tm_map(t, removePunctuation)
  t <- tm_map(t, stemDocument)
  t <- tm_map(t, removeNumbers)
  t <- tm_map(t, stripWhitespace)
  
  dtm <- DocumentTermMatrix(t)

  df <- df[!rowSums(as.matrix(dtm)) == 0,]
  return(df)
}

## Build a corpus for clustering -----
myTwitter$clustCorp <- function(textvec, dictlist) {
  ##Make a tm corpus and dtm
  t <- Corpus(VectorSource(textvec))
  
  #t <- tm_map(t, PlainTextDocument)
  t <- tm_map(t, tolower)
  t <- tm_map(t, removeWords, stopwords("english"))
  t <- tm_map(t, removeWords, unlist(dictlist))
  t <- tm_map(t, removePunctuation)
  t <- tm_map(t, stemDocument)
  t <- tm_map(t, removeNumbers)
  t <- tm_map(t, stripWhitespace)
  
  return(t)
}

## Build a matrix for clustering -----
myTwitter$clustMatrix <- function(df, corpus) {
  dtm <- DocumentTermMatrix(df$ASCII)
  dtm_tfidf <- weightTfIdf(dtm)##Make weighted matrix
  m <- as.matrix(dtm_tfidf)
  rownames(m) <- 1:nrow(m)##Make a matrix
  return(m)
}

myTwitter$clustExcludes <- function (df, dict, thresh = .8) {
  excludes <- list()
  for(i in sort(unique(as.numeric(df$kcluster)))) {
    x <- myTwitter$clustCorp(df$ASCII[df$kcluster == i], dict)
    x <- DocumentTermMatrix(x)
    x <- tail(sort(colSums(as.matrix(x))), 5)
    y <- x >= length(df$ASCII[df$kcluster == i]) * .8
    if (length(x[y]) >= 4) {excludes[i] <- i}
  }
  excludes <- as.numeric(unlist(excludes))
  return(excludes)
}

myTwitter$excludeUsers <- function(df, dict) {
  x <- unlist(dict)
  x <- paste(x, collapse = "|")
  df <- df[!grepl(x, df$screenName),]
  return(df)
}

myTwitter$getClustTop <- function(df) {
  themedf <- as.data.frame(matrix(nrow = length(unique(df$kcluster)), ncol = 2))
  names(themedf) <- c("kcluster", "kclust_theme")
  
  n <- 0
  for(i in unique(df$kcluster)) {
    n <- n + 1
    x <- myTwitter$clustCorp(df$ASCII[df$kcluster == i], dict)
    x <- DocumentTermMatrix(x)
    x <- rev(tail(sort(colSums(as.matrix(x))), 5))
    themedf$kcluster[n] <- i
    theme <- paste(names(x[1]), names(x[2]), sep = "_")
    themedf$kclust_theme[n] <- theme
  }
  return(themedf)
}


