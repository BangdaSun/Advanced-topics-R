#################
### Functions ###
#################

### 1. Function components

# three components: body(), formals(), environment()
# new attributes can be added

f <- function(x) x^3
body(f)
formals(f)
environment(f)

# but, primitive functions don't have these three components

### 2.Lexical scoping

# scoping is the set of rules that govern how R looks up the value of a symbol
x <- 10
x
# here scoping is the set of rules that R applies to go from the symbol x to 10

# four basic principles: name masking; functions vs variables; a fresh start; dynamic lookup

#   Name masking: all the way to the global environment
x <- 1
h <- function() {
  y <- 2
  i <- function() {
    z <- 3
    c(x, y, z)
  }
  i()
}
h()  # --> 1, 2, 3

#   Functions vs. variables
n <- function(x) x / 2
o <- function() {
  n <- 10
  n(n)
}
o()  # --> 5

#   A fresh start
j <- function() {
  if (!exists("a")) {
    a <- 1
  } else {
    a <- a + 1
  }
  a
}
j()  # --> 1 every time, function call are independent

#   Dynamic lookup

# use this function to avoid the corecion of variable 
codetools::findGlobals(o)

# another way: change its environment e.g. emptyenv(), but nothing will be there, even '+'!
environment(o) <- emptyenv()

### 3. Every operation is a function call
#   even +/-/*//, [ (subset operator)

lst <- list(
  a = c(a = 1, b = 2, c = 3, d = 4),
  b = c(a = 4, b = 5, c = 6),
  c = c(a = 7, b = 8)
)
sapply(lst, '[[', 2)
sapply(lst, '[', 2)

### 4. Function arguments
#   Calling functions
# when calling a function you can specify args by position, by complete name, by partial name
# args are matched first by exact name, then by prefix matching, and finally by position

#   Call function given a list of arguments - do.call()
arg <- list(1:10, na.rm = TRUE)
do.call(mean, arg)

#   Missing values
# can use missing(), but... (from hadley)
# "I usually set the default value to NULL and use is.null() to check if the argument was supplied."

#   Lazy evaluation
# by default, R function args are only evaluated if they are actuall used
f <- function(x) {
  10
}

f(stop('This is an error!'))

# ensure the args is evaluated
f <- function(x) {
  force(x)
  10
}
f(stop('This is an error!'))

### 5.Special calls

#   Infix functions: +/-, %in% ...

#   Replacement functions
# they return the modified object in place, like names(), colnames()
# they have two arguments: (x, value)
'second<-' <- function(x, value) {
  x[2] <- value
  x
}
x <- 1:10
`second<-`(x, 3)
second(x) <- 4


### 6. Return values
# the last expression evaluated in a function becomes the return value
# pure functions have no side effects

# functions can return invisible value with invisible(). use () to display

# On exit
