library(repurrrsive)
View(sw_people)

## Exercise 1


### Loop

name = c()
for(person in sw_people) {
  name = c(name, person$name)
}

name = rep(NA, length(sw_people))
i = 1
for(person in sw_people) {
  name[i] = person$name
  i = i + 1
}

name = rep(NA, length(sw_people))
for(i in seq_along(sw_people)) {
  name[i] = sw_people[[i]]$name
}


### apply

lapply(
  sw_people,
  function(person) {
    person$name
  }
)

sapply(
  sw_people,
  function(person) {
    person$name
  }
)

## Exercise 2


library(purrr)

map_chr(
  sw_people,
  ~ .x$name
)

library(dplyr)

fix_sw_number = function(x) {
  ifelse(x == "unknown", NA, x) %>%
    stringr::str_remove(",") %>%
    stringr::str_remove("$") %>%
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
