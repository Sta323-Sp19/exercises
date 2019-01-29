library(nycflights13)
library(dplyr)

# Demo 1

flights %>% 
  filter(dest == "LAX") %>%                           ## How many flights to Los Angeles (LAX) 
  filter(carrier %in% c("AA", "UA", "DL", "US")) %>%  ## did each of the legacy carriers (AA, UA, DL or US) 
  filter(month == 5) %>%                              ## have in May 
  filter(origin == "JFK") %>%                         ## from JFK
  group_by(carrier) %>%
  summarize(                                          ##, and what was *their* average duration?
    origin = origin[1],
    dest = dest[1],
    month = month[1],
    avg_dur = mean(air_time, na.rm=TRUE)
  ) %>%
  as.data.frame()

# Demo 2

## What was the shortest flight out of each airport in terms of distance?

  
flights %>%
  group_by(origin) %>%
  arrange(distance) %>%
  select(origin, dest, distance, air_time)  %>%
  slice(1)

flights %>%
  group_by(origin) %>%
  arrange(distance) %>%
  select(origin, dest, distance, air_time)  %>%
  summarize(distance = distance[1])

flights %>%
  group_by(origin) %>%
  arrange(distance) %>%
  select(origin, dest, distance)  %>%
  filter(distance == min(distance)) %>%
  distinct()

flights %>%
  group_by(origin) %>%
  arrange(distance) %>%
  select(origin, dest, distance, air_time)  %>%
  summarize(distance = min(distance))

# flights %>%
#   group_by(origin) %>%
#   arrange(distance) %>%
#   select(origin, dest, distance, air_time)  %>%
#   top_n(1)


## In terms of duration?

flights %>%
  group_by(origin) %>%
  arrange(air_time) %>%
  select(origin, dest, distance, air_time)  %>%
  slice(1)

flights %>%
  group_by(origin) %>%
  arrange(air_time) %>%
  select(origin, dest, air_time)  %>%
  filter(air_time == min(air_time, na.rm = TRUE)) %>%
  distinct()
