###############################
### Non-standard Evaluation ###
###############################

# R has powerful tools for computing not only on values,
# but also on the actions that lead to those values

### 1. Capturing expressions
# substitute() function - see the code to compute the value
f <- function(x) {
  substitute(x)
}

x <- 1
f(x) # --> x
f(x + 1) # --> x + 1

# deparse() - take an expression and turns it into a character vector
g <- function(x) {
  deparse(substitute(x))
}

g(x) # --> "x"


### 2. Non-standard evaluation in subset()
# subset() is one example (unevaluated code?)
subset(df, col_a >= 3)

# col_a >= 3 is evaluated in data frame, not global environment (essence of non-standard evaluation)
# how does this work? we need eval(), quote()
quote(1:10)
quote(x)
quote(quote(x))

eval(quote(1:10)) # <=> 1:10

# eval() can also be specified environment
eval(quote(a), df) # evaluate 'a' in df

# idea of subset()
subset2 <- function(x, condition) {
  condition_call <- substitute(condition)
  r <- eval(condition_call, x)
  x[r, ]
}
subset2(sample_df, a >= 4)


### 3. Scoping issue
parent.frame()


### 4. Calling from another function


### 5. Substitute


### 6. Downside of NSE
ggplo2 <- 'dplyr'
library(ggplot2) # ggplot2 or dplyr?
library('ggplot2') # this one is recommended
