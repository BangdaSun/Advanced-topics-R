####################
### Memory usage ###
####################

library('pryr')
library('devtools')
#devtools::install_github('hadley/lineprof')


### 1. Object size

pryr::object_size(1:10)
pryr::object_size(1:1000)
pryr::object_size(1:100000)  # 400 kB
pryr::object_size(1:1000000) # 4MB

# pryr::object_size is better than built-in object.size() because it accounts for
# shared elements within an object and includes the size of environments

# empty vector would not be zero-memory-used, and memory usage is not proportional to length
sizes <- sapply(0:50, function(n) object_size(seq_len(n)))
plot(0:50, sizes, xlab = "Length", ylab = "Size (bytes)", type = "s")

# every length 0 vector occupies 40 bytes of the memory:
#   object metedata (4 bytes), two pointers <- -> (16 bytes), pointer to attributes (8 bytes)
#   length of vector (4 bytes), true length of vector (4 bytes)

# why memory size grow irregularly?
# we need to know how R requests memory from the operating system
# requesting memory is a relative expensive operation,
# every time a small vector is created would slow R down considerably;
# and R asks for a big block of memory and then manages that block itself
# this block is called the small vector pool and is used for vectors less than 128 bytes long

# beyond 128 bytes, R will ask for memory in multiples of 8 bytes. This ensures good alignment

plot(0:50, sizes - 40, xlab = "Length", 
  ylab = "Bytes excluding overhead", type = "n")
abline(h = 0, col = "grey80")
abline(h = c(8, 16, 32, 48, 64, 128), col = "grey80")
abline(a = 0, b = 4, col = "grey90", lwd = 4)
lines(sizes - 40, type = "s")

# components can be shared across multiple objects
x <- 1e6
object_size(x)
y <- list(x, x, x)
object_size(y) # exactly same with x
object_size(x, y) # still same

