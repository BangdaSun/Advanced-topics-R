#
#   Create a rectangular class (S4)
#

#   Constructor
setClass("rectangular", representation(
           width = "numeric",
           length = "numeric"
         ))

#   Method: calculate area
#   be aware to set as generic function
calcArea = function(object) return(NULL)
setGeneric("calcArea")
setMethod("calcArea", "rectangular",
          function(object) {
            return(object@width * object@length)
          })

#   Method: is.square
is.square = function(object) return(NULL)
setGeneric("is.square")
setMethod("is.square", "rectangular",
          function(object) {
            return(object@width == object@length)
          })

#   Create an object of rectangular
rect1 = new("rectangular", width = 2, length = 3)

#   Get / set the attribute
slot(rect1, "width")
slot(rect1, "width") = 5

#   Test
rect1@width
calcArea(rect1)
is.square(rect1)
