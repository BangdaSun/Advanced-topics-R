###### Chapter 3 ######
# 
#   Reference: R for Geeks - tools, Dan Zhang 
#
### 3.1 memoise - cache management tool
#   memoise - define cache function, load the result of one function to local
#   forget - redefine cache function, remove the result of one function from local

# install.packages('memoise')
library(memoise)

# expriment - define a function makes CPU spend 1 sec
fun = memoise(function(x) {Sys.sleep(1); runif(1)})
system.time(print(fun()))
system.time(print(fun()))  # much less time

forget(fun)
system.time(print(fun()))

### 3.2 Rprof() - performance monitoring

# take one R file to run
system.time(source('rejection-sampling.R'))
system.time(source('rejection-sampling.R'))  # runtime almost same, no cache

# monitoring performance
file = 'rejection-sampling_rprof.out'
Rprof(file)                     # start monitoring   
source('rejection-sampling.R')  # running
Rprof(NULL)                     # end monitoring
summaryRprof(file)

# $by.self  
#   current function runtime, self.time is actual runtime
# $by.total
#   whole function runtime, self.time is actual time
# 
# in $by.self, we see: runif, eval, ifelse, f are time consuming
# 

### profr visualize performance
# install.packages('profr')
library(profr)
library(ggplot2)

p = parse_rprof(file)
plot(p)
ggplot(p)
