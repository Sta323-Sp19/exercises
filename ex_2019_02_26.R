library(rvest)
library(dplyr)
library(stringr)

## Example - Box office

base_url = "https://www.rottentomatoes.com/"

p = read_html(base_url)

df = tibble(
  movie = p %>%
    html_nodes("#Top-Box-Office .middle_col a") %>%
    html_text(),
  weekend_boxoffice = p %>% 
    html_nodes("#Top-Box-Office .right a") %>%
    html_text() %>%
    str_remove("^\\$") %>%
    str_remove("M$") %>%
    as.numeric(),
  score = p %>%
    html_nodes("#Top-Box-Office .tMeterScore") %>%
    html_text() %>%
    str_remove("%$") %>%
    as.numeric(),
  score_cat = p %>%
    html_nodes("#Top-Box-Office .tiny") %>%
    html_attr("class") %>%
    str_remove_all("icon |tiny ") %>%
    str_replace("_", " "),
  url = p %>%
    html_nodes("#Top-Box-Office .middle_col a") %>%
    html_attr("href") %>%
    paste0(base_url, .)
)

pages = purrr::map(df$url, read_html)

purrr::map_dbl(
  pages,
  function(page) {
    page %>% 
      html_nodes(".mop-ratings-wrap__percentage--audience") %>%
      html_text() %>%
      .[[1]] %>%
      str_remove_all("liked it") %>%
      str_remove_all("\\s") %>%
      str_remove("%$") %>%
      as.numeric()
  }
)

df$audience_score = purrr::map_chr(
  pages,
  function(page) {
    page %>% 
      html_nodes(".mop-ratings-wrap__percentage--audience") %>%
      html_text() %>%
      .[[1]] 
  }
) %>%
  str_remove_all("liked it") %>%
  str_remove_all("\\s") %>%
  str_remove("%$") %>%
  as.numeric()
  
df$poster_img = purrr::map_chr(
  pages,
  function(page) {
    page %>%
      html_nodes("#poster_link .js-lazyLoad") %>%
      html_attr("src") %>%
      paste0(base_url, .)
  }
)
   

df
  


p %>%
  html_nodes("#Top-Box-Office") %>%
  html_table() %>%
  .[[1]] %>%
  as_tibble() %>%
  setNames(c("score", "movie", "weekend_boxoffice"))
