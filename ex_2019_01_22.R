# Exercise 1

levels = c("sun", "partial clouds", "clouds", "rain", "snow")

factor(c("sun", "clouds", "rain", "rain", "clouds"))

class(factor(c("sun", "clouds", "rain", "rain", "clouds")))

c( factor(c("sun", "clouds", "rain", "rain", "clouds")), "snow" )


factor(c("sun", "clouds", "rain", "rain", "clouds"), levels = levels)


f = c(1L, 3L, 4L, 4L, 3L)

attr(f, "levels") = levels
attr(f, "class") = "factor"

class(f)
class(c(1L, 3L, 4L, 4L, 3L))
