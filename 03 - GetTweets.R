##################################################
## This is an R Script that uses custom functions# 
## to get tweets from twitter and analyze them.  #
##################################################

## Set working directory -----
setwd("~/Documents/GitHub/Twitter-Sentiment-Analysis/")

## Load sources -----
source("00 - Functions.R")
source("../01 - Configurations.R")
source("02 - Dictionary.R")
# source("08a - Clustering Example.R")

## Make connection and get data -----
myTwitter$login()
dataFrame <- myTwitter$getAll(dict$LW, dict$LHash)
dataFrame_backup <- dataFrame 

dataFrame <- myTwitter$excludeUsers(dataFrame, dict)
dataFrame <- unique(dataFrame)

##Remove the tweets by users with dictionaries in their name using grep -----
dataFrame <- myTwitter$removeUsername(dataFrame)
dataFrame <- myTwitter$removeTweetID(dataFrame)
dataFrame_backup <- dataFrame 

dataFrame <- myTwitter$removeRTs(dataFrame)
dataFrame <- myTwitter$convertEmojis(dataFrame)
dataFrame <- myTwitter$findNReplace(dataFrame, emDict)
dataFrame_backup <- dataFrame

results <- myTwitter$getSentiment(dataFrame, key)
dataFrame <- results[[1]]
words <- results[[2]]

myPlot <- myTwitter$getPlot(dataFrame)
myPlot

freq <- myTwitter$freqTable(dataFrame)
freq <- data.frame(words = names(freq), freq)
words <- left_join(words, freq)

# remove(freq, results)
# remove(access_secret, access_token, consumer_key, consumer_secret, mykey, path)
# remove(dict, emDict)
# remove(dataFrame_backup)

## Export -----
#filename <- "DataFrame1.csv" 

#path <- paste(path, as.character(Sys.Date()), "_", filename, sep = "")

#write.csv(myTweetDataDF, path)


