## Example

text = c("apple", "(219) 733-8965", "(329) 293-8753")

str_detect(text, "(\d\d\d) \d\d\d-\d\d\d\d")

str_detect(text, "(\\d\\d\\d) \\d\\d\\d-\\d\\d\\d\\d")

str_detect(text, "\\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d\\d\\d")



## Exercise 1

names = c("Haven Giron", "Newton Domingo", "Kyana Morales", "Andre Brooks", 
          "Jarvez Wilson", "Mario Kessenich", "Sahla al-Radi", "Trong Brown", 
          "Sydney Bauer", "Kaleb Bradley", "Morgan Hansen", "Abigail Cho", 
          "Destiny Stuckey", "Hafsa al-Hashmi", "Condeladio Owens", "Annnees el-Bahri", 
          "Megan La", "Naseema el-Siddiqi", "Luisa Billie", "Anthony Nguyen"
)


# detects if the person's first name starts with a vowel (a,e,i,o,u)

names[ str_detect(names, "^[AEIOU]") ]

 
# detects if the person's last name starts with a vowel

names[ str_detect(names, " [AEIOUaeiou]") ]

 
# detects if either the person's first or last name start with a vowel

names[ str_detect(names, "^[AEIOU]| [AEIOUaeiou]") ]


# detects if neither the person's first nor last name start with a vowel

names[ str_detect(names, "^[^AEIOU].* [^AEIOUaeiou]") ]

names[!str_detect(names, "^[AEIOU]") & !str_detect(names, " [AEIOUaeiou]")]

## Exercise 2

text = c(
  "apple", 
  "219 733 8965", 
  "329-293-8753",
  "Work: (579) 499-7527; Home: (543) 355 3679"
)


str_match(text, "(\\d{3}) (\\d{3}) (\\d{4})")


str_match(text, "(\\d{3})[ -](\\d{3})[ -](\\d{4})")

str_match(text, "\\((\\d{3})\\)[ -](\\d{3})[ -](\\d{4})")

str_match(text, "\\(?(\\d{3})\\)?[ -](\\d{3})[ -](\\d{4})")

res = str_match_all(text, "\\(?(\\d{3})\\)?[ -](\\d{3})[ -](\\d{4})")

purrr::map_dfr(res, ~ as.data.frame(.[, 2:4, drop=FALSE]))


m = matrix(1:6, 2, 3)




## Example

library(dplyr)

text = c(
  "apple", 
  "219 733 8965", 
  "329-293-8753",
  "Work: (579) 499-7527; Home: (543) 355 3679"
)


str_split(text, ";") %>% 
  unlist() %>%
  str_match("\\(?(\\d{3})\\)?[ -](\\d{3})[ -](\\d{4})")
