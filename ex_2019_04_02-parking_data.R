library(tidyverse)

nyc = readr::read_csv("/data/nyc_parking/nyc_parking_2014.csv") 

nyc = nyc %>%
  janitor::clean_names() %>%
  select(registration_state:issuing_agency, 
         violation_location, violation_precinct, violation_time,
         house_number:intersecting_street, vehicle_color) %>%
  mutate(issue_date = mdy(issue_date)) %>% 
  mutate(issue_day = day(issue_date),
         issue_month = month(issue_date),
         issue_year = year(issue_date),
         issue_wday = wday(issue_date, label=TRUE)) %>%
  filter(issue_year %in% 2013:2014)



## Create a plot of the weekly pattern 
## (tickets issued per day of the week) - 
## When are you most likely to get a ticket 
## and when are you least likely to get a ticket?

nyc %>%
  count(issue_wday) %>%
  ggplot(aes(x=issue_wday, y=n)) +
    geom_point()
  

## Which precinct issued the most tickets to Toyotas?

nyc %>%
  filter(vehicle_make == "TOYOT") %>%
  count(violation_precinct) %>%
  arrange(desc(n))

