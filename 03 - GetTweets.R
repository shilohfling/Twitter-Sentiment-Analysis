## This is an R Script that uses custom functions to get tweets from twitter and analyze them.
## This is for the twitteR project

######################Load all packages############################################################

#require("readxl")
#require("tm")
#require("worldcloud")

## Set active directory
#setwd("~/twitter learning")

######################Load sources#################################################################

source("00 - Functions.R")
source("01 - Configurations.R")
source("02 - Dictionary.R")
source("08a - Clustering Example.R")

######################Customized parameters########################################################

#path <- "~/Data/Personal/Archive/LearnTwitt/" 

###################################################################################################

myTwitter$login()
dataFrame <- myTwitter$getAll(dict$LW, dict$LHash, max = 10)
dataFrame_backup <- dataFrame 

dataFrame <- myTwitter$excludeUsers(dataFrame, dict)
##TODO: Remove Identical rows
# dataFrame <- unique(dataFrame)
##TODO: Feed row names back in as factor

##Remove the tweets by users with dictionaries in their name using grep

dataFrame <- myTwitter$removeUsername(dataFrame)
dataFrame <- myTwitter$removeTweetID(dataFrame)
dataFrame_backup <- dataFrame #Have a back up dataFrame in case something goes wrong

dataFrame <- myTwitter$removeRTs(dataFrame)
dataFrame <- myTwitter$convertEmojis(dataFrame)
dataFrame <- myTwitter$findNReplace(dataFrame, emDict)
dataFrame_backup <- dataFrame

results <- myTwitter$getSentiment(dataFrame, mykey)
dataFrame <- results[[1]]
words <- results[[2]]

# myPlot <- myTwitter$getPlot(dataFrame)
# myPlot

freq <- myTwitter$freqTable(dataFrame)
freq <- data.frame(words = names(freq), freq)
words <- left_join(words, freq)

remove(freq, results)
remove(access_secret, access_token, consumer_key, consumer_secret, mykey, path)
remove(dict, emDict)
remove(dataFrame_backup)

######################Save#########################################################################

#filename <- "DataFrame1.csv" 

#path <- paste(path, as.character(Sys.Date()), "_", filename, sep = "")

#write.csv(myTweetDataDF, path)

######################Clean########################################################################



###################################################################################################
