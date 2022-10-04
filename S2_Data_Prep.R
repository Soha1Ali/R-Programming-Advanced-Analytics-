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
#getwd()
#setwd()
fin <- read.csv("Future_500_data.csv")

#-------- Explore dataset --------
nrow(fin)
ncol(fin)
head(fin)
tail(fin)
str(fin)
summary(fin)

#--------The factor variable trap--------
#To convert a factor into numeric, you have to first convert it into a character

#Character
x <- c("12", "13", "14", "12", "12")
str(x)
y <- as.numeric(as.character(x))
str(y)

#--------sub() and gsub()--------
#Used to find and replace first and all matches respectively
fin$Expenses <- gsub("Dollars", "", fin$Expenses)
fin$Expenses <- gsub(",", "", fin$Expenses)
fin$Expenses <- gsub(" ", "", fin$Expenses)
fin$Revenue <- gsub(",", "", fin$Revenue)
fin$Revenue <- gsub("\\$", "", fin$Revenue)
fin$Growth <- gsub("%", "", fin$Growth)

#--------Correct object types--------
fin <- fin %>%
  convert(fct(ID),
          num(Revenue, Expenses))

str(fin)

adsf 

