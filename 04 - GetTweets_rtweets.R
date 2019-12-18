## Load packages -----
library(rtweet)
library(ggplot2)

## Set working directory -----
setwd("~/Documents/GitHub/Twitter-Sentiment-Analysis/")

## Load sources -----
source("../01 - Configurations.R")
get_token()

## Get data -----
dict <- c("unlv", "UNLV", "University of Nevada, Las Vegas", "myunlv", "University of Nevada")
## search for 18000 tweets using the rstats hashtag
rt <- search_tweets(
    dict, n = 18000, include_rts = FALSE, retryonratelimit = TRUE
)

## preview tweets data
rt

## plot time series (if ggplot2 is installed)
ts_plot(rt)

## View emojis
View(emojis)