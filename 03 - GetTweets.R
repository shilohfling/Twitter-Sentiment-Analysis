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

## Make connection and get data -----
myTwitter$login()

dataFrame <- myTwitter$getAllWOHash(dict$LW)
dataFrame_backup <- dataFrame 

dataFrame <- unique(dataFrame)

results <- myTwitter$getSentiment(dataFrame, key)
dataFrame <- results[[1]]
words <- results[[2]]

myPlot <- myTwitter$getPlot(dataFrame)
myPlot
# ggsave(paste0("Rplot - ",Sys.Date(),".jpg"), myPlot, width = 8, height = 4)


## Export -----
write.csv(dataFrame, paste0("data - ",Sys.Date(),".csv"))

remove(results)
remove(access_secret, access_token, consumer_key, consumer_secret, mykey, path)
remove(dict)
remove(dataFrame_backup)

# head(as.data.frame(dataFrame))

