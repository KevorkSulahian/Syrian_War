# 1) data_id rename it to ID

#2) ISO
unique(syria$iso) # delete 

#3)  event_id_cnty <- DELETE
#4) event_id_no_cnty <- DELETE

#5) event_date keep, add year_month

#6) year

#7) time_percision <- DELETE

#8) event_type <-type of event turn them into factors

#9) actor1 <- team1 turn into factors (russia syria = 1, terris =2)

#10)  assoc_actor1 <- team1_helper

#11) inter1 <- delete

#12) actor2 <- team2

#13) assoc_actor2 <- team2_helper

#14) inter2 <- delete

#15) interaction <- delete

#16) region <- delete

#17) country <- delete

#18) admin1, 19) admin2, 20) admin3, 21) location <- state, city, street, delete
#ceck 24

#22) lat, 23) long <- delete

#24) geo_percision if 1 then all there are the same (state, city, street) city and street not given
# if 2 then city and street are the same. street not given
# if 3 then all are different. all are given

# 25), 26) source, source_scale not needed

#27) notes could be useful

#28) fatalities

#29 timestamp <- delete

#30 iso3 <- delete
