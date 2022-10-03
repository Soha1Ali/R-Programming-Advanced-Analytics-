#---------------Load packages---------------
#install.packages("tidyverse")
#install.packages("ggolot2")
#install.packages("hablar")
library(ggplot2)
library(dplyr)
library(hablar)
library(magrittr)

#---------------Read in data---------------
getwd()
setwd()
fin <- read.csv("Future_500_data.csv")

#-------- Explore dataset --------
nrow(fin)
ncol(fin)
head(fin)
tail(fin)
str(fin)
summary(fin)

#--------Correct object types--------
fin <- fin %>%
  convert(fct(ID))

#--------The factor variable trap--------
#To convert a factor into numberics, you have to first convert it into a charachter

#WRONG
x <- c("12", "13", "5", "6", "7")
typeof(x)
y <- as.numeric(x)
typeof(z)

a <- as.numeric(a)
a

x <- factor(c("12", "13", "5", "6", "7"))


#RIGHT
b <- as.numeric(as.character(a))
b




