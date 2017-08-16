############################################
### High Performance functions with Rcpp ###
############################################

# C++ can address bottlenecks in R:
# (1) loops that cannot be easily vertorised because the subsequent iterations depend on previous one
# (2) recursive functions, or process that will call the function many times
# (3) advanced data structures are needed, C++ can use STL

library(Rcpp)
# main functions: cppFunction(), sourceCpp()
# Rtools is also needed


### 1. Get started with C++
# don't forget ; at the end of line
# index start from 0
# must include return clause in function
# difference of int and double: 1 is not comparable with 1.0
# .size() --> length()
# .nrow(), .ncol()

#   e.g.1: simple function
cppFunction(
  'int add(int x, int y, int z) {
     int sum = x + y + z;
     return sum;
  }'
)

add
add(1, 2, 3)

# data types (C++):
# int, double, String, bool
# NumericVector, IntegerVector, CharacterVector, LogicalVector

##  (1) No input - scalar output
# R func:
one <- function() 1L

# C++ func:
cppFunction(
  'int one() {
     return 1;
  }'
)

##  (2) Scalar input - scalar output

##  (3) Vector input - scalar output

##  (4) Vector input - vector output
# R func
pdistR <- function(x, ys) {
  sqrt((x - ys) ^ 2)
}

# C++ func 
cppFunction(
  'NumericVector pdistC(double x, NumericVector ys) {
     int n = ys.size();
     NumericVector out(n);
      
     for (int n = 0; i < n; ++i) {
       out[i] = sqrt(pow(ys[i] - x, 2.0));
     }
  }'
)

##  (5) Matrix input - vector output
cppFunction(
  'NumericVector rowSumsC(NumericMatrix x) {
     int nrow = x.nrow(), ncol = x.ncol();
     NumericVector out(nrow);
    
     for (int i = 0; i < nrow; i++) {
       double total = 0.0;
       for (int j = 0; i < ncol; j++) {
         total += x(i, j);
       }
       out[i] = total;
     }
     return out;
  }'
)


##  (6) Using sourceCpp
# use separate C++ files
# start with 
# 
#   #include <Rcpp.h>
#   using namespace Rcpp;
#
# prefix for each function
#
#   // [[Rcpp::export]]

# example: http://gallery.rcpp.org/articles/vector-minimum/

sourceCpp('findMin.cpp')  # min()
sourceCpp('findMinIdx.cpp')  # which.min()
