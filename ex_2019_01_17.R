if (x == 1 | y == 2 | z == 3) {
  print("worked")
}

## Exercise 1

### Part 1 - What is the type of the following vectors? Explain why they have that type.

c(1, NA+1L, "C")
typeof(c(1, NA+1L, "C"))

c(1L / 0, NA)
typeof(c(1L / 0, NA))

c(1:3, 5)
typeof(c(1:3, 5))

c(3L, NaN+1L)
typeof(c(3L, NaN+1L))

c(NA, TRUE)
typeof(c(NA, TRUE))

### Part 2

#   Considering only the four (common) data types, what is R's implicit type conversion 
#   hierarchy (from highest priority to lowest priority)?

#   character > double > integer > logical



## Exercise 2


data = list(
  "firstName" = "John",
  "lastName" = "Smith",
  "age" = 25,
  "address" = 
    list(
      "streetAddress" = "21 2nd Street",
      "city" = "New York",
      "state" = "NY",
      "postalCode" = 10021
    ),
  "phoneNumber" = 
    list(
      list(
        "type" = "home",
        "number" = "212 555-1239"
      ),
      list(
        "type" = "fax",
        "number" = "646 555-4567"
      )
    )
)

View(data)
str(data)
str(data, max.level = 1)
str(data, max.level = 2)


raw = '{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25,
  "address": 
  {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": 10021
  },
  "phoneNumber": 
  [
    {
      "type": "home",
      "number": "212 555-1239"
    },
    {
      "type": "fax",
      "number": "646 555-4567"
    }
  ]
}'

jsonlite::fromJSON(raw, simplifyVector = FALSE)
