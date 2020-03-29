# using tuber! https://cran.r-project.org/web/packages/tuber/vignettes/tuber-ex.html

install.packages("tuber")
library(tuber)
library(magrittr) # Pipes %>%, %T>% and equals(), extract().
library(tidyverse) # all tidyverse packages
library(purrr) 

client_?d <- "X"
client_secret <- "B"

yt_oauth(app_id = client_id,
 app_secret = client_secret,
 token = '')

get_all_comments(video_id = "6ZN02boWKhM")
comments <- get_all_comments(video_id = "6ZN02boWKhM")

write.csv(comments, file = "gougecomment.csv", fileEnc?ding = "CP949")

goucomments <- read_csv("gougecomment.csv",locale = locale(encoding = "CP949"))

only_comm <- goucomments$textDisplay

library(jiebaR)
seg <- qseg[only_comm]
seg <- seg[nchar(seg)>1]
seg <- table(seg)
seg <- seg[!grepl('[0-9]+', names(seg)?]
seg <- seg[!grepl('[A-Z]+', names(seg))]
seg <- seg[!grepl('[a-z]+', names(seg))]
length(seg)
seg <- sort(seg, decreasing = TRUE)[1:100]
seg

library(wordcloud2)
wordcloud2(seg)


