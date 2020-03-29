rm(list = ls())

library(tidyverse)
library(webshot)
library(tabulizer)
webshot::install_phantomjs()
library(BenfordTests)

webshot("http://ncov.mohw.go.kr/bdBoardList_Real.do?brdId=1&brdGubun=13&ncvContSeq=&contSeq=&board_id=&gubun=", "covid19.pdf")

kore? <- extract_tables("covid19.pdf", encoding ="UTF-8")[2] %>% as.data.frame() %>% slice(4:n()) %>% select(c(1,3,5,7,9,11))

korea
chisq.benftest(korea$X5, digit= 2)
chisq.benftest(korea$X7, digit = 2)

