library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)
# library(ggmap)
library(plotGoogleMaps)

syria <- read.csv("data.csv")


syria <- syria[c("data_id","event_date", "year", "event_type", "actor1", "assoc_actor_1", "actor2" ,"assoc_actor_2",
                "admin1", "admin2", "admin3", "geo_precision", "fatalities", "longitude", "latitude")]

syria <- syria[-1,]

sapply(syria, class)
# event_date is factor
# fatalities in factor

syria$event_date <- as.Date(syria$event_date, format = "%Y-%m-%d")

#syria$year_month <- substr(syria$event_date, 0,07)

syria$fatalities <- as.numeric(syria$fatalities)

colnames(syria) <- c("ID", "date", "year", "type", "team1", "team1_assister", "team2",
                     "team2_assister", "state", "city", "street", "geo_precision", "fatalities", "long", "lat")

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


lon <- syria$long
# lon <- str_replace_all(lon, pattern = "\\..*", replacement = "")
lon <- as.numeric(levels(lon))[lon]
lat <- syria$lat

lat <- as.numeric(levels(lat))[lat]


coords <- as.data.frame(cbind(lon=lon,lat=lat))
coordinates(coords) <- ~lat+lon 


mapgilbert <- get_map(location = c(lon = mean(df$lon), lat = mean(df$lat)), zoom = 4,
                      maptype = "satellite", scale = 2)
