##http://michael.hahsler.net/SMU/CSE7337/install/tm.R
library(tm)
library(dplyr)
library(proxy)

source("00 - Functions.R")
source("02 - Dictionary.R")

tweets <- myTwitter$clustCorp(dataFrame$ASCII, dict)
m <- myTwitter$clustMatrix(tweets)

##Hierarchical clustering does a good job of removing news and other languages
myTwitter$hCluster <- function(m) {
  d <- dist(m, method="cosine")
  hc <- hclust(d, method="average")
  hier_cl <- cutree(hc, 50)
  cat <- names(table(hier_cl))[table(hier_cl) %in% max(table(hier_cl))]##Find the giant cluster
  dataFrame <- dataFrame[hier_cl == cat,]
}

##KMEANS

dataFrame <- myTwitter$removeDFblanks(dataFrame, "ASCII", dict)
tweets <- myTwitter$clustCorp(dataFrame$ASCII, dict)
m <- myTwitter$clustMatrix(tweets)

#Rebuild the corpus and matrix - Rinse and Repeat - TODO - add to a function
myTwitter$kCluster <- function(m) {
  norm_eucl <- function(m) m/apply(m, MARGIN=1, FUN=function(x) sum(x^2)^.5)
  m_norm <- norm_eucl(m)
  kmeans_cl <- kmeans(m_norm, 30)

  dataFrame$kcluster <- kmeans_cl$cluster

  ex <- myTwitter$clustExcludes(dataFrame, dict)
  dataFrame <- dataFrame[!dataFrame$kcluster %in% ex,]
}
######
myTwitter$getThemes <- function(df) {
  themes <- myTwitter$getClustTop(dataFrame)
  dataFrame <- left_join(dataFrame, themes)
  dataFrame <- dataFrame[!grepl("job", dataFrame$kclust_theme),]##Job posts cluster but aren't cleared earlier
}
dataFrame <- dataFrame %>% group_by(kcluster) %>% mutate(kclustsentmean = mean(sentScore))


dataFrame$hClust <- myTwitter$hCluster() 
dataFrame$ASCII <- myTwitter$kCluster() 
