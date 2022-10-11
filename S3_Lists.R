#---------------Load packages---------------
#install.packages("tidyverse")
#install.packages("ggolot2")
#install.packages("hablar")
library(ggplot2)
library(dplyr)
library(hablar)
library(magrittr)
library(stringr)

#Deliverable: A list with the following components:  
#Character: Machine name
#Vector: (min,mean, max) utilization for the month excluding unknown hours
#Logical: Has utilization ever fallen below 90% (TRUE/FALSE)
#Vector: All hours where utilization is unknown (NA's)
#Data frame: For this machine
#Plot: For all machines   

#---------------Read in data---------------
coal <- read.csv("P3_Machine_Utilization.csv")
str(coal)
head(coal,10)

#Derive utilization and add column
coal$Utilization <- 1 - coal$Percent.Idle

#---------------Handling date-times in R---------------
coal$PosixTime <- as.POSIXct(coal$Timestamp, format="%d/%m/%Y %H:%M")
coal$Timestamp <- NULL

#---------------Rearrange data in a df---------------
coal <- coal[,c(4,1,2,3)]

#---------------What is a list?---------------
#Can contain a mix of different types of elements
#Useful for storage

RL1 <- coal[coal$Machine == "RL1",]
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

#---------------Construct list---------------
#Character: Machine name
#Vector: (min,mean, max) utilization for the month excluding unknown hours
#Logical: Has utilization ever fallen below 90% (TRUE/FALSE)

coal_stats_rl1 <- c(min(RL1$Utilization, na.rm=TRUE),
                    mean(RL1$Utilization, na.rm=TRUE),
                    max(RL1$Utilization, na.rm=TRUE))

util_under_90_flag <- length(which(RL1$Utilization < .90)) > 0
list_rl1 <- list("RL1", coal_stats_rl1, util_under_90_flag)

#---------------Name components of a list---------------
#This:
names(list_rl1) <- c("Machine", "Stats", "LowThreshold")
#Or this:
list_rl1 <- list(Machine="RL1", Stats=coal_stats_rl1, LowThreshold=util_under_90_flag)

#---------------Extract components of a list---------------
#There are three ways:
#[] - this method will always return a list
#[[]] - this method will always return the actual object
#$ - same as [[]]

list_rl1

list_rl1[1] #[1] "RL1"
typeof(list_rl1[1]) #List

list_rl1[[1]] #[1] "RL1"
typeof(list_rl1[[1]]) #[1] "character"

list_rl1$Machine #[1] "RL1"
typeof(list_rl1$Machine) #[1] "character"

list_rl1[2] #[1] 0.8492262 0.9516976 0.9950000
typeof(list_rl1[2]) #[1] "list"

list_rl1[[2]] #[1] 0.8492262 0.9516976 0.9950000
typeof(list_rl1[[2]]) #[1] "double"

list_rl1$Stats #[1] 0.8492262 0.9516976 0.9950000
typeof(list_rl1$Stats) #[1] "double"

list_rl1$Stats[3]

#---------------Adding and deleting components---------------
#One way:
list_rl1[4] <- "New"
#Another way:
#Vector: All hours where utilization is NA
list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization), "PosixTime"]

#---------------Remove a component---------------
list_rl1[6:10] <- NULL 

#---------------Add data frame for this machine---------------
list_rl1$Data <- RL1
summary(list_rl1)

#---------------Subsetting a list---------------
list_rl1[1:3]
list_rl1[c(1,2)]
list_rl1[c("Machine", "Stats")]
list_rl1[[2]][2] #Double square brackets are NOT for subsetting. They just access a single component of a list.

#---------------Building a timeseries plot---------------
q <- ggplot(data=coal)
myplot <- q + geom_line(aes(x=PosixTime, y=Utilization,
                  color=Machine)) +
  facet_grid(Machine~.) +
  geom_hline(yintercept=0.90, color="Gray", size=1.2, linetype=3)

#Add to list:
list_rl1$Plot <- myplot
list_rl1




