################
### OOP in R ###
################

#
# Chapter 9. The Art of R Programming, Norman Matloff
#

### S3 class
#   Most class in R are S3. It has a list, with a class name attribute and dispatch.
#   dispatch capability enables the use of generic functions.
#   S4 class were developed later, meaning that you cannot accidentally access a 
#   class component that is not already existence

#   S3 generic functions
#   there are different methods could be revoked for one function for different input,
#   e.g. print(), summary(), plot()

#   example: lm()
#   where we can create a lm class
?lm()
x = c(1, 2, 3)
y = c(1, 3, 8)
lmout = lm(y ~ x)
class(lmout)
print(lmout)  # when we print this, print() will revoke print.lm() method

print         # where we can see it's generic, just revoke methods
methods(print)      # see methods
showMethods(print)  # not S4?
summary.lm
methods(summary)
showMethods(summary)
predict.lm
showMethods(predict)

#   Remove class, get a list
unclass(lmout)

#   Check all generic functions
methods(class = "default")

#   for the functions with star, they are nonvisible function, we can use getAnywhere()
getAnywhere(print.lm)

#   Write S3
#   use attr() and class() to set the attribute of class, then define method
j = list(name = "Joe", salary = 55000, union = TRUE)
class(j)
class(j) = "employee"
attr(j)    # doesn't work
attributes(j)

#   then we define print method for employee class
j
print.employee = function(wrkr) {
  cat(wrkr$name, "\n")
  cat("salary", wrkr$salary, "\n")
  cat("union member", wrkr$union, "\n")
}

methods( ,"employee") # check the methods of employee class
j

#   Inheritance
#   define a new class hour employee for employee
k = list(name = "Kate", salary = 68000, union = FALSE, hrsthismonth = 2)
class(k) = c("hrlyemployee", "employee")
k
print.employee(k)

#   One more example: write a class for upper triangular matrix
#
#   1 5 12
#   0 6 9
#   0 0 2
#
#   component "mat: will store the matrix. Only diagonal and above-diagonal element
#   will be stored, in column-major order. For example: mat = c(1, 5, 6, 12, 9, 2)
#   We will also include a component ix in this class, to show where in mat the various
#   column begins. Here ix = c(1, 2, 4), column 1 start at mat[1], col2 - mat[2], col3 - mat[4]

#   ##################################################################################################
#   class "ut", compact storage of upper triangular matrices

#   utility function, return 1 + 2 + ... + i
sum1toi = function(i) return(i*(i + 1) / 2)

#   create an object of class ut from the full matrix inmat
#   ut is the constructor
ut = function(inmat) {
  n           = nrow(inmat)
  rtrn        = list()   # start building object
  class(rtrn) = "ut"
  
  rtrn$mat = vector(length = sum1toi(n))
  rtrn$ix  = sum1toi(0:(n-1)) + 1
  
  for (i in 1:n) {
    # store column i
    ixi = rtrn$ix[i]
    rtrn$mat[ixi:(ixi + i - 1)] = inmat[1:i, i]
  }
  
  return(rtrn)
}

#   uncompress utmat to a full matrix
expandut = function(utmat) {
  n = length(utmat$ix) # numbers of rows and columns of matrix
  fullmat = matrix(nrow = n, ncol = n) # initializa with NA
  
  for (j in 1:n) {
    # fill jth column
    start        = utmat$ix[j]
    fin          = start + j - 1
    abovediagj   = utmat$mat[start:fin] # above-diagonal part of column j
    fullmat[, j] = c(abovediagj, rep(0, n - j))
  }
  
  return(fullmat)
}

#   print matrix
print.ut = function(utmat) {
  print(expandut(utmat))
}

#   multiplication
"%mut%" = function(utmatLeft, utmatRight) {
  n      = length(utmatLeft$ix)
  utprod = ut(matrix(0, nrow = n, ncol = n))
  for (i in 1:n) {
    # compute col i of product
      
    # let a[j] and bj denote columns j of utmatLeft and utmatRight
    # then col i of the result is utmatLeft %*% colj utmatRight 
    #   
    # find index of start of column i in utmatRight
    startbi = utmatRight$ix[i]
    
    # initialize vector that will become the col i of the result
    prodcoli = rep(0, i)
    for (j in 1:i) {
      # find bi[j] * a[j], add to prodcoli
      startaj   = utmatLeft$ix[j]
      bielement = utmatRight$mat[startbi + j - 1]
      prodcoli[1:j] = prodcoli[1:j] + bielement * utmatLeft$mat[startaj:(startaj + j  - 1)]
    }
    
    # now need to tack on the lower 0s
    startprodcoli = sum1toi(i-1) + 1
    utprod$mat[startbi:(startbi + i - 1)] = prodcoli
  }
  
  return(utprod)
}

#   test
test = function() {
  utmatLeft  = ut(rbind(1:2, c(0, 2)))
  utmatRight = ut(rbind(3:2, c(0, 1)))
  utmatProd  = utmatLeft %mut% utmatRight
  print(utmatLeft)
  print(utmatRight)
  print(utmatProd)
}

test
test()
#   ##################################################################################################

### S4 class
#   for safety reasons, S4 class is introduced. e.g., for employee class
#   three possible errors:
#     forget to give "union"; misspell "union"; set other classes to be employee by mistake
#   while S3 will not warn these mistakes.

#   +------------------------+-------------------------+--------------+
#   + operation              + S3                      + S4           +
#   + -----------------------+-------------------------+--------------+
#   + define class           + implicit in constructor + setClass()   +
#   + create object          + build list, set attr    + new()        +
#   + refer  attribute       + $                       + @            + 
#   + implement generic func + define f.classname()    + setMethod()  +
#   + declare generic        + UseMethod()             + setGeneric() +
#   +-----------------------------------------------------------------+

#   Write S4 class
#   still use employee example
setClass("employee",
         representation(
           name   = "character",
           salary = "numeric",
           union  = "logical"
         ))

joe = new("employee", name = "Joe", salary = 55000, union = TRUE)
joe
joe@name
joe@salary
slot(joe, "salary")
slot(joe, "salary") = 65000
slot(joe, "salary") 

#   Generic functions on S4
show(joe)
setMethod("show", "employee",
          function(object) {
            inorout = ifelse(object@union, "is", "is not")
            cat(object@name, "has a salary of", object@salary, "and", inorout, "in the union", "\n")
          })
show(joe)

### Comparison of S3 and S4
