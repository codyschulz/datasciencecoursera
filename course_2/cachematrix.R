#### makeCacheMatrix creates a list of functions that

## Set the value of the matrix

## Get the value of the matrix

## Set the value of the solved matrix

## Get the value of the solved matrix

makeCacheMatrix <- function(x = matrix()) {
  
  # Set s equal to NULL
  s <- NULL
  
  # Create a function set whose input is y
  set <- function(y) {
    
    # Set x from the parent environment (makeCacheMatrix()) equal to the value of y
    x <<- y
    
    # Set the value of s from the parent environment (makeCacheMatrix()) equal to NULL
    s <<- NULL
  }
  
  # Create a function get that retrieves x from the parent environment (makeCacheMatrix())
  get <- function() x
  
  # Create a function setsolved whose input is solved that sets the value of s from
  # the parent environment (makeCacheMatrix)  equal to solved
  setsolved <- function(solved) s <<- solved
  
  # Create a function getsolved that retrieves s from the parent environment (makeCacheMatrix())
  getsolved <- function() s
  
  # Create a list containing the previous four functions and name them as well (so you can use the $ symbol)
  
  # NOTE: cacheSolve will only work with objects of type makecacheMatrix. You need to run cacheSolve to
  # solve any matrices
  list(
    set = set,
    get = get,
    setsolved = setsolved,
    getsolved = getsolved
  )
  
}

#### cachesolve

### First checks to see if the matrix has already been solved

### If so, it gets the solved matrix from the cache and skips the computation

### Otherwise, it

## Solves the matrix

## Sets the value of the solved matrix in the cache via the setsolved function

# Note: x must be an object of type makeCacheMatrix


cacheSolve <- function(x, ...) {
  
  # Create an object s which is the output of running getsolved() from x (a makeCacheMatrix() object)
  # Note: getsolved() doesn't actually solve the matrix, it just retrieves s, so it's not performing any
  # costly computations
  s <- x$getsolved()
  
  # Checks to see if s's value has already been set to a non-null value
  if(!is.null(s)) {
    
    # If s isn't null, send a message that the function is retrieving s from the cache
    message("getting cached data")
    
    # Return the value of s retrieved from the cache
    return(s)
  }
  
  # If s's value has not already been set to a non-null value:
  
  # Create an object data which is the output of running get from x (a makeCacheMatrix object)
  data <- x$get()
  
  # Create an object s which is the solution to the matrix data (this is the actual expensive computation, only done if the mean
  # doesn't already exist)
  s <- solve(data, ...)
  
  # Run the setsolved function on s from x (a makeCacheMatrix object)
  x$setsolved(s)
  
  # Return the value of s
  s
  
}

##### Test

### Create a test matrix
test_matrix <- matrix(c(2, 3, 2, 2), nrow = 2)

### Turn it into a makeCacheMatrix object
made_matrix <- makeCacheMatrix(test_matrix)

### Retrieve the solved matrix
cacheSolve(made_matrix)
