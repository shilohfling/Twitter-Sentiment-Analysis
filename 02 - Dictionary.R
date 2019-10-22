##################################################
## This is an R file to create a working         #
## dictionary for the twitteR project.           #
##################################################
dict <- list()
dict$LW <- c("unlv", "UNLV", "University of Nevada, Las Vegas", "myunlv", "University of Nevada")
dict$LHash <- c("FFS", "FTW", "FTL", "FML", "LMAO",
                "LOL", "OMFG", "OMG", "STFU", "TMI",
                "WTF", "IMO", "FWIW", "IMHO", "BTW", "WTH")
dict$LHash <- sapply(dict$LHash, tolower)


##Open Emoji R dictionary
# tmp <- tempfile()
# emDict <- download.file("https://unicode.org/emoji/charts/full-emoji-list.html",
#                         destfile = tmp, method = "curl")
# # emDict <- read.csv(tmp, sep = ";")
# 
# remove(tmp)                   


##Open Emoji R dictionary
tmp <- tempfile()
download.file("https://raw.githubusercontent.com/today-is-a-good-day/Emoticons/master/emDict.csv",
              destfile = tmp, method = "curl")
emDict <- read.csv(tmp, sep = ";")

remove(tmp)