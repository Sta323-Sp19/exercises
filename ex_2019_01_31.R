## Exercise 1

data("NETemp.dat", package = "spBayes")
ne_temp = as_tibble(NETemp.dat)

ne_temp %>%
  gather(month, temp, starts_with("y")) %>%
  separate(month, c("var","month")) %>%
  select(-var) %>%
  mutate(month = as.integer(month)) %>%
  mutate(
    year = floor( (month-1) / 12 ) + 2000,
    month = (month-1) %% 12 + 1,
    date = paste(year, month, 1, sep="/")
  ) %>% 
  sample_n(10)
 