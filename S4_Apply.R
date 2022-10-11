#---------------Load packages---------------
#install.packages("tidyverse")
#install.packages("ggolot2")
#install.packages("hablar")
library(ggplot2)
library(dplyr)
library(hablar)
library(magrittr)
library(stringr)

#---------------Read in data---------------
setwd("./Weather Data") #The dot = current directory
chicago <- as.matrix(read.csv("Chicago-C.csv", row.names=1)) #row.name=1 makes first column into row names
houston <- as.matrix(read.csv("Houston-C.csv", row.names=1))
newyork <- as.matrix(read.csv("NewYork-C.csv", row.names=1))
sanfrancisco <- as.matrix(read.csv("SanFrancisco-C.csv", row.names=1))

weather <- list(chicago=chicago, houston=houston, newyork=newyork, sanfrancisco=sanfrancisco)

#---------------What is the apply family of functions?---------------
is.vector(apply(chicago, 1, mean)) #Average of each row, is vector
is.vector(apply(weather[["chicago"]], 1, mean)) #Same as above, is vector
is.vector(apply(weather$chicago, 1, mean)) #Same as above, is vector

apply(chicago, 2, mean) #Average of each column
apply(chicago, 1, max)
apply(chicago, 1, min)

#---------------Recreating the apply function with loops---------------
#Via for loop
chicago
r <- seq(length(chicago[,1]))
output <- NULL

for (i in r) {
  output[i] <- mean(chicago[i,])
}

names(output) <- rownames(chicago)
output

#Via for apply
apply(chicago, 1, mean)

#---------------Using lapply---------------
#lapply gives output in lists
#You don't specify rows and columns
#t() function means transpose (turn cols in to rows)
#Example 1:
#Long way
list(t(weather$chicago), t(weather$newyork),t(weather$houston), t(weather$sanfrancisco))
#lapply way
lapply(weather, t)

#Example 2:
#Long way
rbind(chicago, new.row=1:12)
rbind(houston, new.row=1:12)
rbind(newyork, new.row=1:12)
rbind(sanfrancisco, new.row=1:12)

#lapply way
lapply(weather, rbind, new.row=1:12)

#Example 3:
#Long way
rowMeans(chicago)
rowMeans(houston)
rowMeans(newyork)
rowMeans(sanfrancisco)

#lapply way
lapply(weather, rowMeans)

#rowMeans
#colMeans
#rowSums
#colSums

#---------------Combine lapply with []---------------
#Long way to get weather for Jan in each element
weather[[1]][1,1] #0
weather[[2]][1,1] #17.2
weather[[3]][1,1] #3.8
weather[[4]][1,1] #13.8

#lapply way
lapply(weather, "[", 1, 1)

#lapply way to get first row of each element
lapply(weather, "[", 1, ) 

#lapply to get just March values
lapply(weather, "[", , 3) #This
lapply(weather, "[", , "Mar") #Or this

#---------------Adding your own functions---------------
lapply(weather, function(x) x[1,]) #Get first row of each element
lapply(weather, function(x) x[1,]-x[2,]) #Get difference between high and low temp
lapply(weather, function(x) round((x[1,]-x[2,])/x[2,],2)) #Difference between low and high ave over the years

#Practice 1: Ave precipitation per days that it rained in each city (ave over each month)
#Long way for chicago
weather[[1]][3,] / weather[[1]][4,]

#lapply way for each
lapply(weather, function(z) round(z[3,]/z[4,],2))

#---------------Using sapply---------------
#Like lapply but returns a vector or matrix when poss.

#Average high temp for July using lapply:
lapply(weather, "[", 1, 7) #This
lapply(weather, "[", "AvgHigh_C", "Jul") #Or this
typeof(lapply(weather, "[", "AvgHigh_C", "Jul")) #This is a list

#Average high temp for July using sapply:
sapply(weather, "[", 1, 7)
is.vector(sapply(weather, "[", 1, 7)) #This is a numeric vector 

#Average high temp for 4th quarter:
lapply(weather, "[", 1, 10:12) #Output is a list
sapply(weather, "[", 1, 10:12) #Output is a matrix

#Row means:
lapply(weather, rowMeans) #Output is a list
sapply(weather, rowMeans) #Output is a matrix

#Difference between low and high ave over the years
lapply(weather, function(x) round((x[1,]-x[2,])/x[2,],2))
sapply(weather, function(x) round((x[1,]-x[2,])/x[2,],2))

#---------------Nesting apply functions--------------
#Get row maximums for chicago:
apply(chicago, 1, max)

#Get row maximums for every matrix in weather list:
lapply(weather, apply, 1, max) #This (preferred)
lapply(weather, function(x) apply(x, 1, max)) #Or this

#Tidier:
sapply(weather, apply, 1, max) 

#---------------which.max() and which.min()--------------
#which(max) will tell you the name of the values that are max, not just the numbers
which.max(chicago[1,])
names(which.max(chicago[1,]))
apply(chicago, 1, function(x) names(which.max(x)))
lapply(weather, function(y) apply(y, 1, function(x) names(which.max(x))))
sapply(weather, function(y) apply(y, 1, function(x) names(which.max(x))))

#---------------Practice--------------
weather #list
chicago #matrix

#apply
apply(chicago, 1, mean)
is.vector(apply(chicago, 1, mean)) #T
is.matrix(apply(chicago, 1, mean)) #F

#lapply
weather
is.list(lapply(weather, rowMeans)) #T
is.list(lapply(weather, "[", 1, )) #T
lapply(weather, function(x) x[1,]/3) 

chicago[1,]

#sapply
is.matrix(sapply(weather, rowMeans)) #T
is.matrix(sapply(weather, "[", 1, )) #T
sapply(weather, function(x) x[1,]/3) 

#---------------Practice with state.x77 dataset--------------
is.matrix(state.x77) #T
state <- state.x77
str(state)
?state.x77

#apply
apply(state, 2, max)
apply(state, 2, min)




