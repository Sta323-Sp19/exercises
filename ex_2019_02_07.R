library(repurrrsive)
library(dplyr)
library(purrr)
library(tidyr)

## prev example

fix_sw_number = function(x) {
  ifelse(x == "unknown", NA, x) %>%
    stringr::str_remove(",") %>%
    as.numeric()
}

dplyr::tibble(
  name = map_chr(sw_people, "name"),
  mass = map_chr(sw_people, "mass") %>% fix_sw_number(),
  height = map_chr(sw_people, "height") %>% fix_sw_number(),
  films = map(sw_people, "films")
) %>%
  mutate(
    n_films = map_int(films, length)
  )


## Working on one row

sw_people[[1]] %>% as.data.frame()

map(
  sw_people[[1]],
  function(entry) {
    if (length(entry) > 1) {
      list(entry)
    } else {
      entry
    }
  }
) %>% 
  as_tibble()

fix_list_cols = function(entry) {
  if (length(entry) > 1) {
    list(entry)
  } else {
    entry
  }
}

map(sw_people[[1]], fix_list_cols) %>% 
  as_tibble()

## Putting it together

map(
  sw_people,
  function(char) {
    map(char, fix_list_cols) %>% 
      as_tibble
  }
)

map_dfr(
  sw_people[1:4],
  function(char) {
    map(char, fix_list_cols) %>% 
      as_tibble
  }
)

sw_people[1:4] %>% View()



## Dealing with list columns that arnt always lists

col_check = map_dfr(
  sw_people, 
  ~ map(., length) %>% as_tibble()
) %>%
  map_lgl(~ any(. > 1, na.rm = TRUE))

list_cols = names(col_check)[col_check]



fix_list_cols = function(entry, name) {
  if (name %in% list_cols) {
    list(entry)
  } else {
    entry
  }
}

map2(sw_people[[1]], names(sw_people[[1]]), fix_list_cols) %>%
  as_tibble()

sw_tbl = map_dfr(
  sw_people,
  function(char) {
    map2(char, names(char), fix_list_cols) %>% 
      as_tibble
  }
)

sw_tbl %>%
  mutate(
    n_starships = map_int(starships, length)
  ) %>%
  filter(n_starships != 0) %>%
  unnest(starships) %>% 
  View()

replace_empty = function(entry) {
  if (is.null(entry)) {
    NA
  } else {
    entry
  }
}

sw_tbl %>%
  mutate(
    starships = map(starships, replace_empty)
  ) %>% 
  unnest(starships, .drop = FALSE) %>%
  View()



# Github API Data

library(gh)

dplyr = gh("GET /repos/:owner/:repo/issues", 
           owner="tidyverse", repo="dplyr", state="open", 
           .limit = 200)

df = tibble(
  id = map_int(dplyr, "number"),
  user = map_chr(dplyr, c("user","login")),
  title = map_chr(dplyr, "title"),
  created = map_chr(dplyr, "created_at")
)

df %>%
  mutate(
    created = as.POSIXct(created),
    wday = lubridate::wday(created, label=TRUE)
  ) %>%
  count(wday) %>%
  arrange(desc(n))

df %>% 
  count(user) %>%
  arrange(desc(n))


