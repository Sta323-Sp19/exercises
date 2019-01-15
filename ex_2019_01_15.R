# Exercise 1

## * If x is greater than 3 and y is less than or equal to 3 then print "Hello world!"
##  
## * Otherwise if x is greater than 3 print "!dlrow olleH"
##  
## * If x is less than or equal to 3 then print "Something else ..."
##  
## * Stop execution if x is odd and y is even and report an error, don't print 
##   any of the text strings above.



x = 2
y = 4

## Bad

if ((x > 3) & (y <= 3)) {
  if ((x %% 2 == 1) & (y %% 2 == 0))
    stop("x is off and y is even!")

  print("Hello world!")
} else if (x > 3) {
  if ((x %% 2 == 1) & (y %% 2 == 0))
    stop("x is off and y is even!")

  print("!dlrow olleH")
} else if (x <= 3) {
  if ((x %% 2 == 1) & (y %% 2 == 0))
    stop("x is off and y is even!")
  
  print("Something else ...")
}

## Better

if ((x %% 2 == 1) & (y %% 2 == 0))
  stop("x is off and y is even!")

if ((x > 3) & (y <= 3)) {
  print("Hello world!")
} else if (x > 3) {
  print("!dlrow olleH")
} else if (x <= 3) {
  print("Something else ...")
}


## Best

if ((x %% 2 == 1) & (y %% 2 == 0))
  stop("x is off and y is even!")

if ((x > 3)){
  if (y <= 3)
    print("Hello world!")
  else
    print("!dlrow olleH")  
} else {
  print("Something else ...")
}



# Exercise 2

primes = c( 2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 
           43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)

for(x in c(3,4,12,19,23,51,61,63,78)) {
  is_prime = FALSE
  for(prime in primes) {
    if (x == prime) {
      is_prime = TRUE
      break
    }
  }
  
  if (!is_prime)
    print(x)
}


for(x in c(3,4,12,19,23,51,61,63,78)) {
  if (!(x %in% primes))
    print(x)
}


x = c(3,4,12,19,23,51,61,63,78)
x[!x %in% primes]



