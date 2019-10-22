##################################################
## This is an R Script that uses custom functions# 
## to get tweets from twitter and analyze them.  #
##################################################

## Load packages -----
library(openxlsx)

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


## Export -----
write.xlsx(dataFrame, paste0("data_",Sys.Date(),".xlsx"))

