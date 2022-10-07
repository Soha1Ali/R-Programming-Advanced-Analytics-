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
#fin <- read.csv("Future_500_data.csv")
fin_original <- read.csv("Future_500_data.csv", na.strings=c(""))
View(fin_original)
fin <- read.csv("Future_500_data.csv", na.strings=c(""))

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
          int(Revenue, Expenses),
          num(Employees, Growth))

typeof(fin$Industry)

fin$Employees <- as.numeric(unlist(fin$Employees))
#typeof(fin$Employees)

fin$Growth <- as.numeric(as.character(fin$Growth))
#typeof(fin$Growth)

str(fin)

#--------Dealing with missing data--------
#----Locating missing data----
#1. Update import to fin <- read.csv("Future_500_data.csv", na.strings=c(""))
#2. Use the complete.cases() function to locate all complete row. Use ! to find incomplete rows
fin[!complete.cases(fin),]
head(fin, 6)

#----Filtering data when NAs are present----
#If you just do this, you'll get a bunch of NAs in addition to the row you're actually after
fin[fin$Revenue == 9746272,]

#So you have to tell R to only look for TRUE, not TRUE and NA. Do this using which()
fin[which(fin$Revenue == 9746272),]

#----Using is.na() funtion to find NAs in just one column----
fin[is.na(fin$Expenses), ]
fin[is.na(fin$State), ]
fin[is.na(fin$Revenue), ]

#--------Removing records--------
fin_backup <- fin
fin[!complete.cases(fin$Industry),]
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),] #Opposite of above action
fin <- fin[!is.na(fin$Industry),] #Reassign fin to subset that excludes NAs in the industry column

#--------Resetting the dataframe index--------
rownames(fin) <- NULL
View(fin)

#--------Replacing missing data: factual analysis method--------
fin[!complete.cases(fin),] #All incomplete rows in df
fin[is.na(fin$State),] #All NAs in the state column

#Replace New York NAs in state column with NY and same for San Francisco with CA
fin[is.na(fin$State) & fin$City == "New York", "State"] <- "NY"
fin[is.na(fin$State) & fin$City == "San Francisco", "State"] <- "CA"

#--------Replacing missing data: median imputation method (part 1)--------

#1. Find median of missing 'employee' column values. To make the estimation better, we're only looking at companies in the same industry. 
fin[!complete.cases(fin),] #Rows 3 and 332 have missing 'employees' values
fin[is.na(fin$Employees),] #All NAs in the employees column

#1.5 The median function returns an error for both lines covered in the course. 
#median(fin[,"Employees"], na.rm=TRUE) #Error: need numeric data
#median(fin[fin$Industry == "Retail","Employees"], na.rm=TRUE) #Error: need numeric data

#1.51 Check object types. For some reason the first one is a list, not a double. I think that's the issue. 
typeof(fin[,"Employees"]) #List
typeof(fin$Employees) #Double

median(fin$Employees, na.rm=TRUE) #The median function works here. 
#median(fin[,"Employees"],na.rm=TRUE) #But not here.

#1.52 Looked up how to convert lists to an integer object. Use as.numeric(unlist(x))
median(as.numeric(unlist(fin[,"Employees"])), na.rm=TRUE) #56
median(as.numeric(unlist(fin[fin$Industry == "Retail","Employees"])), na.rm=TRUE) #28
median(as.numeric(unlist(fin[fin$Industry == "Financial Services","Employees"])), na.rm=TRUE) #80

#2. Replace NA value with median

#2.5 Make sure to save median value in its own variable 
med_empl_retail <- median(as.numeric(unlist(fin[fin$Industry == "Retail","Employees"])), na.rm=TRUE) #28
med_empl_finserv <- median(as.numeric(unlist(fin[fin$Industry == "Financial Services","Employees"])), na.rm=TRUE) #80

#2.51 Replace value
fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- med_empl_retail
fin[is.na(fin$Employees) & fin$Industry == "Financial Services", "Employees"] <- med_empl_finserv

#2.52 Check
fin[3,]
fin[330,]

#--------Replacing missing data: median imputation method (part 2)--------
fin[!complete.cases(fin),] #Fill in median for growth NA 
fin[is.na(fin$Growth),] #NAs in growth column (row 8)

#1. Find the median of growth in the construction industry
median(as.numeric(unlist(fin[fin$Industry == "Construction","Growth"])), na.rm=TRUE) #10

#2. Replace NA value with median
med_growth_const <- median(as.numeric(unlist(fin[fin$Industry == "Construction","Growth"])), na.rm=TRUE) #10
fin[is.na(fin$Growth) & fin$Industry == "Construction", "Growth"] <- med_growth_const

#2.5 Check
fin[8,]

#--------Replacing missing data: median imputation method (part 3)--------
fin[is.na(fin$Expenses),] #Fill in median for expenses (rows 8 & 44) by industry

#1. Find the median expenses for each industry
#Construction
typeof(fin[fin$Expenses == "Construction","Expenses"]) #List
median(as.numeric(unlist(fin[fin$Industry == "Construction","Expenses"])), na.rm=TRUE) #4506976

#2. Replace NA value with median
#Construction
med_rev_const <- median(as.numeric(unlist(fin[fin$Industry == "Construction","Expenses"])), na.rm=TRUE) #4506976
med_rev_const <- as.integer(med_rev_const)
typeof(med_rev_const)
fin[is.na(fin$Expenses) & fin$Industry == "Construction", "Expenses"] <- med_rev_const

#2.5 Check
fin[c(8,42),]

#--------Manually enter missing data--------
fin[is.na(fin$Profit) & is.na(fin$Revenue), "Profit"] <- 4548083
fin[c(8, 42),]

#--------Replacing missing data: deriving values method--------
fin[is.na(fin$Revenue), "Revenue"] <- fin[is.na(fin$Revenue), "Expenses"] + fin[is.na(fin$Revenue), "Profit"] 
fin[c(8,42),]

fin[is.na(fin$Expenses), "Expenses"] <- fin[fin$Name == "Ganzlax", "Revenue"] - fin[fin$Name == "Ganzlax", "Profit"]
fin[c(15),]



