library(dplyr)
df1 <- read.csv("data - 2018-12-20.csv")
df2 <- read.csv("data - 2018-12-31.csv")
df3 <- read.csv("data - 2019-01-07.csv")
df4 <- read.csv("data - 2019-01-15.csv")
df <- union(df1,df2) %>%
    union(.,df3) %>%
    union(.,df4)
myTwitter$getPlot(df)


ggplot(df, aes(x = created, y = sentScore, fill = sentType)) + 
  geom_jitter(aes(colour = sentType)) +
  expand_limits(y = c(-1.0, 1.0)) 
