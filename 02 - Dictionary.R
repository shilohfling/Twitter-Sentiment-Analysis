##################################################
## This is an R file to create a working         #
## dictionary for the twitteR project.           #
##################################################
dict <- list()
dict$LW <- c("unlv", "UNLV")

dict$LHash <- c("FFS", "FTW", "FTL", "FML", "LMAO", "LOL", "OMFG", "OMG", "STFU", "TMI", 
                      "WTF", "IMO", "FWIW", "IMHO", "BTW", "WTH")
dict$LHash <- sapply(dict$LHash, tolower)

# dict$trends <- c("kyrie", "irving", "duke", "earth", "flat", "astronomy")
# dict$moreStopWords <- c("dont", "wont", "just", "ive", "amp", "thats", "gonna", 
#                        "wanna", "isnt")


##Open Emoji R dictionary
tmp <- tempfile()
emDict <- download.file("https://unicode.org/emoji/charts/full-emoji-list.html",
                        destfile = tmp, method = "curl")
# emDict <- read.csv(tmp, sep = ";")

remove(tmp)                   
