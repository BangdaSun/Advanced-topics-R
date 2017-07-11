############################
### Data structures in R ###
############################

# +-----------+ ------------------+---------------------+
# + dimension + homogeneous dtype + heterogeneous dtype + 
# + ----------+-------------------+---------------------+
# +    1d     +   atomic vector   +        list         +
# +    2d     +      matrix       +     data frame      +
# +    nd     +      array        +                     +
# +-----------+-------------------+---------------------+

# Q1: three properties of a vector, other than its content?
#   type, length, attributes -> typeof(), length(), attributes()
#
# Q2: four types of common types of atomic vectors and two rare typs
#   integer, double, character, logical; complex, raw
#
# Q3: what are attributes? how to get and set them?
#   attr(), attributes()
#
# Q4: how list different from atomic vector? how data frame different from matrix?
#   list and data frame is generlization version of atomic vector and matrix,
#   they can contain different data types
#
# Q5: Can data frame have a column that is a matrix?
#   Yes

### 1. Vectors

# is.vector() is not the right function to test if the object is vector, it return
# TRUE only if the object is a vector with no attributes apart from names
# use is.atomic() or is.list()
is.vector(c(0,1))
is.vector(factor(c(0,1)))

is.atomic(factor(0, 1))
is.list(factor(0, 1))

#   Atomic vectors
#   four basic types, use (as/is).(integer/double/numeric/logical/character)

#   List - recursive vectors (list can contain list)
#   use unlist() -> atomic vector

#   Attributes
#   all objects can have extra attributes to store metadata about the object.
x <- 1:10
attributes(x)
attr(x, 'x_attribute') <- 'this is x'  # add attributes
attributes(x)

y <- 1:10
identical(x, y)  # FALSE

# use structure() return a new object with modified attributes
y <- structure(1:10, x_attribute = 'this is x')
identical(x, y)  # TRUE

# most attributes are lost when modifying, except: (names, dimension, class)

#   Names
x <- c(a = 1, b = 2, c = 3)
names(x)
unname(x)

#   Factors
#   built on top of integer vectors using attributes: class(factor) and levels
x <- factor(c('a', 'b', 'a', 'c'))
attributes(x)

# factors with different levels cannot be combined (must have same levels)
# if there are some non-numeric value in data frame, that column will be treat as factor
# na.strings = '.' in read.csv()
# also, in loading data, many functions will convert characters to factors, use
# stringAsFactors = FALSE to control this behavior

### 2. Matrices and arrays

# adding a dim attribute to an atomic vector will make it behave like multi-dim array, and 
# a special case of array is matrices

### 3. Data frames

# with attributes names(), colnames(), rownames()
# length() = ncol(), names() = colnames()
# subset: 1. 1d way; 2. 2d way
# also has option: stringAsFactor = FALSE
