
library(dplyr)
library(readr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(scales)
library(PerformanceAnalytics)

setwd('D:/LGR/logistics_fees/settlement')
dir()

# 데이터 불러오기 
temp = list.files(pattern="*.csv")
for (i in 1:length(temp)) assign(temp[i], read_csv(temp[i]))

rm(oldloc)

View(settle_201901.csv)

s1 <- settle_201901.csv
s2 <- settle_201902.csv
s3 <- settle_201903.csv
s4 <- settle_201904.csv
s5 <- settle_201905.csv
s6 <- settle_201906.csv
glimpse(s1)

# settlement 1-6월치 합치기
s1to6 <- rbind(s1,s2,s3,s4,s5,s6)

# 필요한 변수만 뽑기 
settle <- s1to6[c(1,3,6,8,11)]
str(settle)


# time 변수factor -> datae 
settle$Payment_time <-  as.Date(settle$Payment_time)

# 년/월/일/매출&환불로 구분 후 정렬하기
settle <- settle %>%
  mutate(year = format(Payment_time, "%Y"),
         month = format(Payment_time, "%m"), 
         day = format(Payment_time,"%d"),
         remark = ifelse(Fee_rmb_amount < 0, 'Refund', 'Payment')) %>% 
  select(year, month, day, Fee_type, Fee_rmb_amount, Payment_time, Remark, remark)
head(settle, 10)
colnames(settle)

# tmall logistic fee by month
logis_day <- settle %>% 
  filter(remark == 'Payment', 
         Fee_type=='Tmall Logisitic') %>%
  group_by(Payment_time) %>% 
  summarise(sum=sum(Fee_rmb_amount),
            n=n(),
            avg = round(sum/n,2)) %>% 
  ungroup()
logis_day

boxplot(logis_day$sum)
boxplot(logis_day$n)
boxplot(logis_day$avg)
# logistics 보통 14원 수준, max로 49원 나왔을 경우가 있었다.

# 도식화
ggplot(logis_day) + aes(Payment_time, avg) +
  stat_summary(fun.y = sum, geom = "bar") +  scale_x_date(labels = date_format("%Y-%m"),
                          breaks = "2 month")
logis_day <- as.data.frame(logis_day)
cor <- logis_day[-1]


cor(as.matrix(cor))
plot(cor)
pairs(cor, panel=panel.smooth)
chart.Correlation(cor, histogram=TRUE, pch=19)

cor_real <- cor(cor)
corrplot(cor_real, method= "number")

# my account 값 불러오기 

setwd('D:/LGR/logistics_fees/myaccount')
dir()

# 데이터 불러오기 
temp1 = list.files(pattern="*.csv")
for (i in 1:length(temp1)) assign(temp1[i], read.csv(temp1[i]))

a1 <- myaccount_201901.csv
a2 <- myaccount_201902.csv
a3 <- myaccount_201903.csv
a4 <- myaccount_201904.csv
a5 <- myaccount_201905.csv
a6 <- myaccount_201906.csv

# myaccount 1-6월치 합치기
a1to6 <- rbind(a1,a2,a3,a4,a5,a6)
glimpse(a1to6)

# 필요한 변수만 뽑기 
a16 <- a1to6[c(1,3,5,7,10)]
glimpse(a16)

# time 변수factor -> datae 
a16$Time <-  as.Date(a16$Time)

table(a16$Details)
