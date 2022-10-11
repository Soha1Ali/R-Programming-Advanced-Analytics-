#---------------http://r-tutorials.com/r-exercises-apply-family-functions/---------------

mymatrix <- matrix(data=c(6,34,923,5,0, 112:116, 5,9,34,76,2, 545:549), nrow=5, ncol=4, byrow=FALSE)                  

#Get the mean of each row
apply(mymatrix, 1, mean)

#Sort the columns in ascending order
apply(mymatrix, 2, sort)

#Use three ‘apply’ family functions to... 
#...get the minimum values of each column of the ‘mtcars’ dataset
as.list(mtcars) #True
a <- apply(mtcars, 2, min)
l <- lapply(mtcars, min)
s <- sapply(mtcars, min)

is.vector(mtcars[[1]]) #True
is.vector(weather[[1]]) #False

#Put the three outputs ‘l’, ‘s’, ‘m’ in the list ‘listobjects’
listobjects <- list(a, l, s)

#Use a suitable ‘apply’ function to get the class of each of the three list elements in ‘listobjects'

#---------------https://www.stat.cmu.edu/~ryantibs/statcomp/lectures/apply.html---------------

state <- state.x77

str(state)
summary(state)

#Get minimum entry for each column
colnames(state)
is.matrix(state) #True
apply(state, 2, min)
apply(state, 2, summary)



