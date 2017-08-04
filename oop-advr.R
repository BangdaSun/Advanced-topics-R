######################
### OO fields in R ###
###################### 

# R has four OO systems:
# (1) S3
#   implements a style of OOP called generic-function OO. No formal def of classes
#   it will decide which method to call
#
# (2) S4
#   similar to S3 but more formal, with descriptions of representation (constructor) and inheritance
#   also has definition of generics and methods
#
# (3) RC (reference classes)
#   implements message-passing OO like Java/C++, methods belong to classes not functions ($ operator)

# (4) base type

library(pryr)

### 1. Base types 
#   underlying every R object is a C structure (struct) that how that object is store in memory.
#   most importantly for this section is *type*
#   data structures explains the most common base types; base types also encompass functions, 
#   environments and other objects like names, calls

# typeof()
# is.___()

# the type of a function is closure
f <- function() {}
typeof(f)
is.function(f)

# the type pf primitive function is builtin
typeof(sin)
is.primitive(sin)

#   see also about mode() storage.mode()


### 2. S3 
#   (1) Recogonising objects, generic function and methods
#   most objects that we encounter in R are S3. But there is not simple way to test if it is S3
# is.object(x) & !isS4(x) --> an object but not S4
df <- data.frame(x = 1:10, y = letters[1:10])
is.object(sin)
is.object(mean)
is.object(df)

otype(df)
otype(f)
otype(sin)

#   in S3, methods belong to generic functions
#   to determine if the function is an S3 object, use UseMethod() --> figure out the correct method to call
#   the process of method dispatch
mean
ftype(mean)
ftype(f)

#   these function are also S3 generics, but they don't call UseMethod() since they are implemented in C
#   they call the C functions DispatchGroup() or DispatchOrEval()
ftype('[')
ftype(sum)
ftype(cbind)

#   in general the form looks like this: generic.class(), e.g. print.factor()
#   that's reason why morden style guides discourage the use of . in function names
#   that way will mix the function name and methods
ftype(t.test)
ftype(t.data.frame)

#   methods() - list all methods belong to a generic
methods('mean')
methods(class = 'ts')

#   (2) Defining classes and creating objects
#   to make an object an instance of a class, you just take an existing base object
#   and set the class attribute.

#   structure()
foo <- structure(list(), class = 'foo')
class(foo)

#   class<-()
foo <- list()
class(foo) <- 'foo'

#   S3 classes are usually built on top of lists or atomic vectors with attributes
#   we can determine the class of any object using class()
#   and see if any object inherits from a specific class using inherits
class(foo)
inherits(foo, 'foo')

#   class of S3 object can be a vector, which describes behaviour from most to least specific
#   (idea of inheritance?)
#   e.g.: glm objects --> c('glm', 'lm') indicating that glm inherit from lm

#   name issue: underscore --> my_class, CamelCase --> MyClass are both fine

#   we can use this form of constructor: this ensure we are creating the class with correct component
foo <- function(x) {
  if (!is.numeric(x)) stop('X must be numeric')
  structure(list(x), class = 'foo')
}


#   (3) Creating new methods and generics
#   UseMethod() - two args: name of generic function and method dispatch

f <- function(x) UseMethod('f')
# then create some methods with form generic.class
f.a <- function(x) 'class a'
# where a is ...
a <- structure(list(), class = 'a')
f(a)

#   (4) Method dispatch
#   UseMethod() creates a vector of function names and looks for each in turn
#   'default' class makes it possible to set up fall back
f.default <- function(x) 'Unkown class'

f(structure(list, class = 'a'))  # we pass an a class into f --> expect to invoke f.a
f(structure(list, class = 'c'))  # we pass a c class into f --> no other methods, use default

?groupGeneric

#    we can also call an S3 generic with a non-S3 object # ???
iclass <- function(x) {
  if (is.object(x)) {
    stop('x is not a primitive type', call. = FALSE)
  }
  
  c(
    if (is.matrix(x)) 'matrix',
    if (is.array(x) && !is.matrix(x)) 'array',
    if (is.double(x)) 'double',
    if (is.integer(x)) 'integer',
    mode(x)
  )
}

iclass(matrix(1:5))
iclass(array(1.5))


### 3. S4
#   S4 adds formality abd rigour (methods still belong to functions)
#   classes have formal definitions which describe their fields and inheritance structures
#   method dispatch can be based on multiple arguments to a generic function rather than one
#   use @ operator to extract slots (fields)

#   all S4 related code is stored in methods package

#   (1) Recognising objects, generic functions and methods
#   we can identify S4 object using --> isS4(), pryr::otype()
library(stats4)
y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8)
nLL <- function(lambda) -sum(dpois(y, lambda, log = TRUE))
fit <- mle(nLL, start = list(lambda = 5), nobs = length(y))
isS4(fit)
pryr::otype(fit)
ftype(nobs)  # for functions

#   retrieve an S4 method
mle_nobs <- method_from_call(nobs(fit))
isS4(mle_nobs)
ftype(mle_nobs)
is(fit)
is(fit, 'mle')  # list all classes that an object inherits from

?getGenerics()

#   (2) Defining classes and creating objects
#   in S4, we cannot casually set class like in S3, we must define the representation
#   setClass()
#   and create a new object with new()

#   S4 class has three key properties: class name; slots; string giving the class inherits from
setClass('Person', slots = list(name = 'character', age = 'numeric'))
setClass('Employee', slots = list(boss = 'Person'), contains = 'Person')

bob    <- new('Person', name = 'Bob', age = 50)
bangda <- bew('Employee', name = 'Bangda', age = 23, boss = bob)

bangda@age  # like $
slot(bangda, 'boss')  # like [[

#   (3) Creating new methods and generics
#   setGeneric() -> setMethod()

# e.g.: union on data frames
setGeneric('union')
setMethod('union', 
          c(x = 'data.frame', y = 'data.frame'),
          function(x, y) {
            unqiue(rbind(x, y))
          })

# if we create a new generic from scratch, we meed tp supply a function called standardGeneric(). Just like UseMethod() in S3
setGeneric('myGeneric',
           function(x) {
             standardGeneric('myGeneric')
           })

#   (4) Method dispatch


### 4. RC
#   in RC, methods belong to objects rather than functions, and RC objects are mutable! not copy-on-modify

#   (1) Defining classes and creating objects

Account <- setRefClass('Account')
Account$new()

Account <- setRefClass('Account',
                       fields = list(balance = 'numeric'))

myAccount <- Account$new(balance = 1000)
myAccount$balance

#   NOTICE: RC OBJECTS ARE MUTABLE
fakeAccount <- myAccount
fakeAccount$balance

myAccount$balance <- 0
fakeAccount$balance  # expected to be 0 too

# for this reason, copy() is recommended
notfakeAccount <- myAccount$copy()

#   define methods
Account <- setRefClass('Account',
                       fields = list(balance = 'numeric'),
                       methods = list(
                         withdraw = function(x) {balance <<- balance - x},
                         deposit  = function(x) {balance <<- balance + x}
                       ))

myAccount <- Account$new(balance = 200)

#    inheritance
AdvancedAccount <- setRefClass('AdvancedAccount',
                               contains = 'Account',
                               methods = list(
                                 withdraw = function(x) {
                                   if (balance < x) stop('Not enough money')
                                   balance <<- balance - x
                                 }
                               ))

#   see also: callSuper(), field(), export(), show()

#   (2) Recognising objects and methods
pryr::otype()

#   (3) Method dispatch



