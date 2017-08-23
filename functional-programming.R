##############################
### Functional Programming ###
##############################

# prerequisite: lexical scoping
library(pryr)

### 1. Motivation
# copy-and-paste is easy to make bugs, and hard to adjust to changes
# DO NOT REPEAT YOURSELF

# lapply() is a way, called functional

# we can also use closures: make/create functions
# example: make a summariy statistics of data
# for R rookie:
mean(df$a)
median(df$a)
sd(df$a)
mad(df$a)
IQR(df$a)

mean(df$b)
median(df$b)
sd(df$b)
mad(df$b)
IQR(df$b)

# for R expert:
summary <- function(x) {
  funs <- c(mean, median, sd, mad, IQR)
  lapply(funs, function(f) f(x, na.rm = TRUE))
}


### 2. Anonymous functions
# we already did this when we use apply family functions
# and it actually has more applications
Filter(function(x) !is.numeric(x), mtcars)
# see Map(), Find(), Negate() etc, functional programming...

# still remember three components of functions?
formals(function(x) g(x) + h(x))
body(function(x) g(x) + h(x))
environment(function(x) g(x) + h(x))


### 3. Closures
# One of the most common uses for anonymous functions is to create closures: functions made by other functions. 

# example: create function using function
power <- function(exponent) {
  function(x) {
    x ^ exponent
  }
}

square <- power(2)
square(3)

cube <- power(3)
cube(4)

# square and cube are called closures.
square
cube

# the difference is the enclosing environment, environment(square)
as.list(environment(square))
pryr::unenclose(square)

# the parent environment of a closure is the execution environment of the function that create it
power <- function(exponent) {
  print(environment())
  function(x) x^exponent
}

zero <- power(0)
environment(zero)

## Function factories
# although we can re-define power() use multiple args, there are still advantages:
# (1) different levels are more complex, with multiple args and complicate bodies
# (2) some work only needs to be done once, when the function is generated

## Mutable state
# example
new_counter <- function() {
  i <- 0
  function() {
    i <<- i + 1
    i
  }
}

counter_one <- new_counter()
counter_two <- new_counter()

counter_one() # --> 1
counter_one() # --> 2
counter_two() # --> 1


### 4. Lists of functions
# we can store functions in list, work with groups of related functions

# example: compare the performance of multiple ways to computing the arithmetic mean
computed_mean <- list(
  base = function(x) mean(x)
  sum  = function(x) sum(x) / length(x)
  manual = function(x) {
    total <- 0
    n <- length(x)
    for (i in seql)
  }
)

x <- runif(1e5)
system.time(compute_mean$base(x))
system.time(compute_mean[[2]](x))
system.time(compute_mean[["manual"]](x))

# call each function in the list
lapply(compute_mean, function(f) f(x))
