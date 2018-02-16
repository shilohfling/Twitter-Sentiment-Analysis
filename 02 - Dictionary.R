## This is an R file to create a working dictionary for the twitteR project
## It currently holds learning words and hashtags, but I would like to expand it to emojis

dict <- list()
dict$LW <- c("professor", "lecture", "syllabus")

dict$LHash <- c("FFS", "FTW", "FTL", "FML", "LMAO", "LOL", "OMFG", "OMG", "STFU", "TMI", 
                      "WTF", "IMO", "FWIW", "IMHO", "BTW", "WTH")
dict$LHash <- sapply(dict$LHash, tolower)

# dict$trends <- c("kyrie", "irving", "duke", "earth", "flat", "astronomy")
# dict$moreStopWords <- c("dont", "wont", "just", "ive", "amp", "thats", "gonna", 
#                        "wanna", "isnt")


##Open Emoji R dictionary
tmp <- tempfile()
download.file("https://raw.githubusercontent.com/today-is-a-good-day/Emoticons/master/emDict.csv",
                        destfile = tmp, method = "curl")
emDict <- read.csv(tmp, sep = ";")

remove(tmp)                   
