library(dplyr)

nyc = readRDS("/data/nyc_parking/nyc_parking_2014_cleaned.rds")
db = dplyr::src_sqlite("/data/nyc_parking/nyc_parking_2014_cleaned.sqlite")

nyc_sql = tbl(db, "nyc")

addr = nyc_sql %>%
  select(issue_date, precinct = violation_precinct, house_number, street_name) %>%
  filter(precinct >=1, precinct <= 34)


addr %>% 
  mutate(address = paste(house_number, street_name) %>% tolower()) %>%
  mutate(address = replace(address, " th ", " "))

