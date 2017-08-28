###################
### Expressions ###
###################

# metaprogram: create programs with other programs

### 1. Structure of expressions
# difference between an operation and a result
x <- 4
y <- x * 10
y

# capture the action with quote()
z <- quote(y <- x * 10) # quote() return an expression object
z

# expression is also called an abstract syntax tree (AST)
pryr::ast(y <- x * 10)

# four possible components of an expression: constant, names, calls, pairlists

# (1) constant
ast('a')
ast(TRUE)

# quoting a constant returns it unchanged
identical(1, quote(1))

# (2) names
# will prefix name with a backtick
ast(y)
ast(mean)
ast(`2333`)

# (3) calls
# represent the action of calling a function
ast(f(g(), h(1, a)))
ast(a + b) # every operation is a function call

# (4) pairlists
# only used in one place: formal arguments of a function
ast(function(x = 1, y) x)
ast(function(x = 1, y = x * 2) {x / y})

# structures
str(quote(a))
str(quote(a + b))
str(quote(f()))


### 2. Names
# also called symbols
# quote() can also capture names
# as.name() / as.symbol() convert character to name object
# is.name() / is.symbol() to test
as.name('name')
is.name(as.name('name'))
is.name(quote(name))
identical(quote(name), as.name('name'))
identical(quote('name'), as.name('name'))


### 3. Calls
# a call is similar to a list
# it has length, [, [[ methods and could be recursive
# first element of the call is the function that gets called, remained are args
# call(), as.call(), is.call()
x <- quote(read.csv('train.csv', head = TRUE))
x[[1]]
x[[2]]
x[[3]]
x$head

is.name(x[1])
is.name(x[[1]])
is.name(x[[2]])

# since it's similar to a list, we can also modify a call

# create call: first name is a string which gives a function
call(':', 1, 10)
eval(call(':', 1, 10))

call('mean', quote(random(100)))


### 4. Capturing the current call
# many base R functions use the current call:
# the expression that caused the current function to be run
# capture the current call: sys.call(), match.call() (?match, return a vector of the position match of its first argument in its second)
