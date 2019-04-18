library(dplyr)
library(ggplot2)
library(sparklyr)


#spark_available_versions(show_hadoop = TRUE)
#spark_install()

spark_home_set("/data/spark/spark-2.4.0-bin-hadoop2.7/")

conf = spark_config()
conf[["sparklyr.shell.driver-memory"]] = "32G"

sc = spark_connect(
  master = "local[8]",
  config = conf
)


# https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt

ghcnd = spark_read_csv(sc, "ghcnd", "/data/ghcnd/ghcnd_2018*.csv")

ghcnd %>% count()

ghcnd %>% filter(element == "TAVG") %>% count()

### tbl version
ghcnd %>% head() %>% collect() %>%
  filter(element = "TAVG") %>% count()

### spark
ghcnd %>%
  filter(element = "TAVG") %>% count() 


ghcnd %>% head() %>% collect()


View(ghcnd %>% head() %>% collect()) 


### parquet

spark_write_parquet(ghcnd, path = "/data/ghcnd/ghcnd_2018_par")
ghcnd_par = spark_read_parquet(sc, "ghcnd_par", "/data/ghcnd/ghcnd_2018_par")

### Additional Data

stations = spark_read_csv(sc, "stations", "/data/ghcnd/ghcnd_stations.csv")
countries = readr::read_csv("/data/ghcnd/ghcnd_countries.csv")

stations %>%
  ggplot(aes(x=longitude, y=latitude, color=elevation)) +
    geom_point()

nc_stations = stations %>%
  filter(state == "NC") %>%
  compute("nc_station")

nc_stations %>%
  ggplot(aes(x=longitude, y=latitude, color=elevation)) +
  geom_point()

nc_data = ghcnd_par %>%
  inner_join(nc_stations) %>%
  filter(element == "TAVG") %>%
  mutate(value = value / 10) 

nc_data %>% show_query()

nc_data %>%
  ggplot(aes(x=date, y=value, color=elevation)) +
    geom_point() +
    geom_smooth()

nc_data %>%
  group_by(date) %>%
  summarize(avg_avg_temp = mean(value, na.rm=TRUE)) %>%
  ggplot(aes(x=date, y=avg_avg_temp)) +
    geom_point() +
    geom_smooth()

### Several states

st_stations = stations %>%
  filter(state %in% c("NC", "CA", "FL", "MA"))

st_data = ghcnd_par %>%
  inner_join(st_stations) %>%
  filter(element == "TAVG") %>%
  mutate(value = value / 10) 

st_data %>% show_query()


st_data %>%
  group_by(date, state) %>%
  summarize(avg_avg_temp = mean(value, na.rm=TRUE)) %>%
  ggplot(aes(x=date, y=avg_avg_temp, color=state)) +
  geom_point() +
  geom_smooth()


### Countries

stringr::str_extract("USW00003889", "^[A-Z]{2}")


#### Stringr - no good - not base R
ghcnd_par %>% 
  mutate(code = stringr::str_extract(id, "^[A-Z]{2}"))

ghcnd_par %>% head() %>% collect() %>%
  mutate(code = stringr::str_extract(id, "^[A-Z]{2}"))

#### substr

substr("abcdef", 1, 3)
ghcnd_par %>% head() %>% collect() %>% pull(id) %>% substr(1,2)

ghcnd_par %>% 
  mutate(code = substr(id, 1, 2)) %>%
  show_query()

#### spark's regexp_extract


ghcnd_par %>% head() %>% collect() %>%
  mutate(code = regexp_extract(id, "^([A-Z]{2})"))

countries

ct = ghcnd_par %>% 
  mutate(code = regexp_extract(id, "^([A-Z]{2})")) %>%
  filter(code %in% c("US","AS","BF")) %>%
  inner_join(countries, copy = TRUE) %>%
  compute("ct")

ct %>%
  inner_join(select(stations, -name)) %>%
  group_by(date, name) %>%
  summarize(avg_avg_temp = mean(value, na.rm=TRUE)) %>%
  ggplot(aes(x=date, y=avg_avg_temp, color=name)) +
    geom_point() +
    geom_smooth()
  
