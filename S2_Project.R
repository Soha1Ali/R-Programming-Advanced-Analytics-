#---------------Load packages---------------
#install.packages("tidyverse")
#install.packages("ggolot2")
#install.packages("hablar")
library(ggplot2)
library(dplyr)
library(hablar)
library(magrittr)
library(stringr)

#---------------Cleaned df for visualizations---------------
fin.1 <- fin

#Q1: A scatterplot classified by industry showing revenue, expenses, & profit

#1. Change object type of industry column
typeof(fin.1$Industry) #Character
fin.1$Industry <- as.factor(fin.1$Industry) 
str(fin.1$Industry) #Factor with 7 levels
levels(fin.1$Industry) #"Construction" "Financial Services" "Government Services" "Health" "IT Services" "Retail" "Software"   

#1.5 Change number notation
fin.1$Revenue <- round(fin.1$Revenue / 1e6, 1)
fin.1$Profit <- round(fin.1$Profit / 1e6, 1)
fin.1$Expenses <- round(fin.1$Expenses / 1e6, 1)

#2. Create base
fin.2 <- ggplot(data=fin.1)

#3. Define geometries
fin.2 + geom_point(aes(x=Revenue, 
                       y=Expenses,
                       color=Industry,
                       size=Profit))

#Q2: A scatterplot that includes industry trends for the expenses~revenue relationship
fin.2 + geom_point(aes(x= Revenue, 
                       y=Profit,
                       color=Industry, 
                       size=Expenses),
                   alpha=.5)

fin.3 <- ggplot(data=fin.1, aes(x=Revenue, 
                               y=Expenses,
                               color=Industry))

fin.3 + geom_point() + 
  geom_smooth(fill=NA, size=1.2)

#Q3: Box plots showing growth by industry
fin.4 <- ggplot(data=fin.1, aes(x=Industry, y=Growth,
                color=Industry))

fin.4 + geom_jitter() + geom_boxplot(alpha=.5, outlier.colour=NA)



