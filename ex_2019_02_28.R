library(tidyverse)
library(jsonlite)

## Example 0

?jsonlite::read_json

jsonlite::read_json(
  "https://restcountries.eu/rest/v2/name/united?fields=name;capital;currencies",
  simplifyVector = FALSE
) %>%
  View()


## Exercise 1

### How many countries are in this data set?

system.time(
  jsonlite::read_json(
    "https://restcountries.eu/rest/v2/all",
    simplifyVector = FALSE
  ) %>%
    length()
)

system.time(
  jsonlite::read_json(
    "https://restcountries.eu/rest/v2/all?fields=name",
    simplifyVector = FALSE
  ) %>%
    length()
)
  
### Which countries are members of ASEAN (Association of Southeast Asian Nations)?

jsonlite::read_json(
  "https://restcountries.eu/rest/v2/regionalbloc/asean?fields=name",
  simplifyVector = FALSE
) %>%
  length()


### What are all of the currencies used in the Americas?

l = jsonlite::read_json(
  "https://restcountries.eu/rest/v2/region/americas?fields=currencies",
  simplifyVector = FALSE
)

purrr::map(
  l,
  function(l) {
    purrr::map_chr(l$currencies, "name", .default=NA)
  }
) %>%
  unlist() %>%
  unique()

## Example 1 - GitHub

jsonlite::read_json(
  "https://api.github.com/users/rundel"
)

jsonlite::read_json(
  "https://api.github.com/repos/tidyverse/dplyr/issues"
) %>%
  map_chr("title")

jsonlite::read_json(
  "https://api.github.com/repos/tidyverse/dplyr/issues?state=closed"
) %>%
  map_chr("title")

jsonlite::read_json(
  "https://api.github.com/repos/tidyverse/dplyr/issues?state=open&page=6"
) %>%
  map_chr("title")


## Example 2

jsonlite::read_json(
  "https://nominatim.openstreetmap.org/search.php?q=Duke%20University&format=json"
)

