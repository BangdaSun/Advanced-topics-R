#
#   Create a rectangular class (S4)
#

#   Constructor
rectangular = setClass(
  "rectangular", 
  representation(
    width = "numeric",
    length = "numeric"
  ),
  prototype = list(
    width = 0,
    length = 0
  )
)

#   Method: calculate area
#   be aware to set as generic function
setGeneric(
  name = "calcArea", 
  def  = function(object) {
    return(object@width * object@length)
  }
)

setMethod(
  f = "calcArea", 
  signature = "rectangular",
  definition = function(object) {
    return(object@width * object@length)
  }
)

#   Method: is.square
setGeneric(
  name = 'is.square',
  def  =  function(object) {
    return(object@width == object@length)
  }
)

setMethod(
  f = "is.square", 
  signature = "rectangular",
  definition = function(object) {
    return(object@width == object@length)
  }
)

#   Create an object of rectangular
rect1 = new("rectangular", width = 2, length = 3)

#   Get / set the attribute
slot(rect1, "width")
slot(rect1, "width") = 5

#   Test
rect1@width
calcArea(rect1)
is.square(rect1)
