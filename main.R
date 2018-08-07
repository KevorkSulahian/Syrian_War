library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)
library(ggmap)

syria <- read.csv("data.csv", stringsAsFactors = F)


syria <- syria[c("data_id","event_date", "year", "event_type", "actor1", "assoc_actor_1", "actor2" ,"assoc_actor_2",
                "admin1", "admin2", "admin3", "geo_precision", "fatalities")]

syria <- syria[-1,]

syria$state <- str_replace_all(syria$state, pattern = "^As-", replacement = "Al-")
syria$city <- str_replace_all(syria$city, pattern = "^As-", replacement = "Al-")
syria$street <- str_replace_all(syria$street, pattern = "^As-", replacement = "Al-")

sapply(syria, class)
# event_date is factor
# fatalities in factor

syria$event_date <- as.Date(syria$event_date, format = "%Y-%m-%d")

syria$fatalities <- as.numeric(syria$fatalities)

colnames(syria) <- c("ID", "date", "year", "type", "team1", "team1_assister", "team2",
                     "team2_assister", "state", "city", "street", "geo_precision", "fatalities")

fighters <- as.data.frame(unique(syria$team1))

military_syria <- str_extract_all(syria$team1, pattern = "^Military Forces of Syria")

syria_attack <- {}
j = 1
for(i in military_syria) {
  if(length(i)> 0) {
    syria_attack[j] = T
    j = j+1
  } else {
    syria_attack[j] = F
    j = j+1
  }
}
syria$government_attack <- syria_attack
by_month <- syria %>%
  group_by(month = floor_date(date, "month")) %>%
  summarize(death = sum(fatalities),
            attack = sum(government_attack)) 


by_month$year <- substr(by_month$month, 0,04)
by_month$month_abb <- months(as.Date(by_month$month), abbreviate = TRUE)
by_month$month <- as.numeric(format(as.Date(by_month$month), "%m"))
by_month$attack <- as.numeric(by_month$attack)

ggplot(by_month, aes(x = factor(month, levels = c(1:12)), y = death, group = year, colour=year)) + 
  geom_line() +
  geom_point() +
  scale_x_discrete(breaks = by_month$month, labels = by_month$month_abb) +
  labs(x = "months", y = "deaths", title = "difference in the number of deaths between 2017 and 2018")

ggplot(by_month, aes(x = factor(month, levels = c(1:12)), y = attack, group = year, colour=year)) + 
  geom_line() +
  geom_point() +
  scale_x_discrete(breaks = by_month$month, labels = by_month$month_abb) +
  labs(x = "months", y = "attack", title = "difference in the number of attack between 2017 and 2018")

### by state

by_state <- syria %>%
  group_by(state) %>%
  summarize(death = sum(fatalities),
            attack = sum(government_attack)) 


ggplot(by_state, aes(y  =  death, x = state, fill = state)) + geom_bar(stat = "identity")


## Hama only

get_hama <- syria %>%
  filter(state == "Hama") 

get_hama <- distinct(get_hama, street, .keep_all = TRUE)

df.Hama_locations <- tibble(location = c(get_hama$state, get_hama$city, get_hama$street))

df.Hama_locations <- geocode(df.Hama_locations$location)

get_map("Syria Hama", zoom = 8) %>% ggmap() +
  geom_point(data = df.Hama_locations,aes(x = lon, y = lat),
             color = "red", size = 3)



## all states

get_states <- distinct(syria, street, .keep_all = TRUE)

df.state_location <- tibble(location = c(get_states$state, get_states$city, get_states$street))

df.state_location <- geocode(df.state_location$location)

get_map("Syria", zoom = 8) %>% ggmap() +
geom_point(data = df.state_location, aes( x = lon, y= lat),
           color = "red", size = 3)
