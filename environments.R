####################
### Environments ###
####################

# Environment is the data structure that powers scoping
# behaves like hashmap


# Q1. List at least three ways that an environment is different to a list.
#  1) every object in an environment must have a name; 2) order doesn't matter;
#  3) environment has parents; 4) environment has reference semantics
#
# Q2. What is the parent of the global environment? What is the only environment that doesn’t have a parent?
#  parent environment of global environment is the last package loaded; empty environment
#
# Q3. What is the enclosing environment of a function? Why is it important?
#  just the environment where it was created
#
# Q4. How do you determine the environment from which a function was called?
#  parent.frame()
#
# Q5. How are <- and <<- different?
#  <- creates a binding in current environment; 
#  <<- rebinds an existing name in a parent of the current environment
library(pryr)

### 1. Basics
# the job of environment is to bind a set of names to a set of values (think it as a bag of names)
# they can point to the same object, they can have same values
# parent is used to implement lexical scoping: if a name is not found in an environment, R will look in its parent
# every environment has a parent except empty environment
# environment is made up two components: frame and parent environment
# BUT, parent.frame() doesn't give the parent frame, it gives the calling environment

# four special environment:
#  (1) globalenv()
#  (2) baseenv() --> parent is empty environment
#  (3) emptyenv()
#  (4) environment() --> return current environment
?search() #to list all parents of the global environment, this is called search path:
# from globalenv() all the way to the baseenv() --> emptyenv(),
# objects in these environments can be found from the top-level interactive workspace
# it contains one environment for each attached package and any other object we've attach()

# access any environment on the search list using as.environment()
as.environment('package:stats')

# create a new environment
ne <- new.env()  
ne$a <- FALSE
ne$b <- 'a'
ne$c <- 1.21
ne$d <- 1:4

# get the parent
parent.env(ne)

# list the bindings in the environment
ls(ne)

# we can modify the bindings in an environment like lists
ne$a <- 1
ne$b <- 2
ls(ne)
ls(ne, all.names = TRUE)

# we can also use str(), ls.str()
str(ne)
ls.str(ne)

# given the name, we can extract the value to which it is bound with $, [[, get()
ne$a
ne[['a']]
get('a', envir = ne)

# use rm()to remove the binding
rm('a', envir = ne)

# we can determine if a binding exists in the environment with exists()
exists('b', envir = ne)

# we can compare environment using identical
identical(globalenv(), environment())


### 2. Recursing over environments
# environments form a tree, therefore we can use the idea of recursion

# e.g.: search object using pryr::where()
x <<- 1
where('x')

where('select')
where('summarise')

# where() is written recursively, with args: name to look for, the environent in which to start with


### 3. Function environments
# four types of environments associated with a function:
# enclosing, binding, execution, calling

##  (1) enclosing
# enclosing environment is the environment that function is created (only one)
# enclosing environment belongs to the function and never changes even function is moved to a different environment
# every package has two environments: namespace envir / package envir
# namespaces keep packages independent, where two packages could have function with same names

##  (2) binding
# binding a function to a name with <- defines a binding environment
environment(sd)
where('sd')

x <- 1:10
var <- function(x, na.rm = TRUE) 100
sd(x)  # sd is not affected by the above var() function

##  (3) execution
# calling a function creates an ephemeral execution environment to store variables

# every time that a function call is a fresh start (see function section)
# the parent of the execution environment is the enclosing environment of the function (this envir is thrown away when function has completed)
# when you create the child function, its enclosing environment is the execution environment of the parent function (execution envir is no longer ephemeral)
plus <- function(x) {
  function(y) x + y
}
plus_one <- plus(1)
identical(parent.env(environment(plus_one)), environment(plus)) # --> TRUE

##  (4) calling
# every execution environment is associated with a calling environment, tell us where the function is called

h <- function() {
  x <- 10
  function() {
    x
  }
}
i <- h()
x <- 20
i() # --> 10
# x is 10 in the environment where h() is defined, but it is 20 in the calling environment of h()

# we can access this enviroment using parent.frame() --> environment where the function is called
f2 <- function() {
  x <- 10
  function() {
    def <- get("x", environment())
    cll <- get("x", parent.frame())
    list(defined = def, called = cll)
  }
}
g2 <- f2()
x <- 20
str(g2())

# more complicated case
x <- 0
y <- 10
f <- function() {
  x <- 1
  g()
}
g <- function() {
  x <- 2
  h()
}
h <- function() {
  x <- 3
  x + y
}
f()

# from the book:
# Note that each execution environment has two parents: a calling environment and an enclosing environment
# R’s regular scoping rules only use the enclosing parent; parent.frame() allows you to access the calling parent
# Looking up variables in the calling environment rather than in the enclosing environment is called dynamic scoping


### 4. Binding names to values
# assignment: binding a name to a value in an environment
# in R we can bind value to names and expressions or even functions
# we cannot assign value to reserved word, and name cannot start with _
?Reserved

# and we can...
`a+b` <- 3
`:-)` <- 666

## Quotes
# two other types of binding: delayed and active
