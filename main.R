library(dplyr)
library(ggplot2)
library(lubridate)
syria <- read.csv("data.csv")


syria <- data[c("data_id","event_date", "year", "event_type", "actor1", "assoc_actor_1", "actor2" ,"assoc_actor_2",
                "admin1", "admin2", "admin3", "geo_precision", "fatalities")]


syria <- syria[-1,]

sapply(syria, class)
# event_date is factor
# fatalities in factor

syria$event_date <- as.Date(syria$event_date, format = "%Y-%m-%d")

#syria$year_month <- substr(syria$event_date, 0,07)

syria$fatalities <- as.numeric(syria$fatalities)

colnames(syria) <- c("ID", "date", "year", "type", "team1", "team1_assister", "team2",
                     "team2_assister", "state", "city", "street", "geo_precision", "fatalities")

by_month <- syria %>%
  group_by(month = floor_date(date, "month")) %>%
  summarize(death = sum(fatalities)) 


by_month$year <- substr(by_month$month, 0,04)
by_month$month_abb <- months(as.Date(by_month$month), abbreviate = TRUE)
by_month$month <- as.numeric(format(as.Date(by_month$month), "%m"))


ggplot(by_month, aes(x = factor(month, levels = c(1:12)), y = death, group = year, colour=year)) + 
  geom_line() +
  geom_point() +
  scale_x_discrete(breaks = by_month$month, labels = by_month$month_abb, name = "months")
