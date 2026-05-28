getwd(); graphics.off() ; rm(list = ls(all = TRUE)) ; cat("\014");
#Includes functions for apriori algorithm
library(arules)
library(readxl)
library(bitops)
library(RCurl)

#Setup our environment. Where is our data
setwd("C:\\Users\\...)




#First read the data. Note the dataset HAS NO headers, hence set header to FALSE. 
#We well add headers later. NOTE: Change your path to data appropriately!
FertilityDataSet = read.csv("fertility_Diagnosis .csv", header=FALSE)


#Add headers to data. Makes working with dataset easier
colnames(FertilityDataSet) <- c("season", "age", "childish-disease", 
                                "trauma", "surgical-intervention", "fevers", 
                                "alcoholic", "smoking", "sitting", "output")

#Take a quick look at the data. Is everything ok?
head(FertilityDataSet)

#Now we are ready to execute the apriori algorithm for finding association rules


#Execute now the apriori algorithm without any parameter for support or confidence. 
#This means that no minsup and minconf is provided and 
#that all possible rules will be generated
FertilityDataSet<-FertilityDataSet[,c(-2,-9)]
FertilityDataSet$season <- as.factor(FertilityDataSet$season )
FertilityDataSet$`childish-disease` <- as.factor(FertilityDataSet$`childish-disease` )
FertilityDataSet$`trauma` <- as.factor(FertilityDataSet$`trauma` )
FertilityDataSet$`surgical-intervention` <- as.factor(FertilityDataSet$`surgical-intervention` )
FertilityDataSet$`fevers` <- as.factor(FertilityDataSet$`fevers` )
FertilityDataSet$`alcoholic` <- as.factor(FertilityDataSet$`alcoholic` )
FertilityDataSet$`smoking` <- as.factor(FertilityDataSet$`smoking` )

#Data <- discretizeDF(Data, default = list(method = "interval", breaks = 2, 
#labels = c("yes", "no")))
rules <- apriori(FertilityDataSet)

#Variable rules has all the rules. Can we see the rules now?
#Yes, but this may take a huge amount of time due to the number
#of rules
#CAVEAT LECTOR: DO THIS ONLY IF YOU HAVE NOTHING BETTER TO DO
#
# *** YOU HAVE BEEN WARNED *** 

inspect(rules)

#Lets execute apriori with the following parameters: minimum support 20% (supp=0.2), 
#minimum confidence=1), on the LHS we need at least 2 items (minlen=2) and on the
# right-hand-side (rhs) only the Diagnosis=altered should appear.
rules1 <- apriori(FertilityDataSet, parameter = list(minlen=2, supp=0.02, conf=1),
                  appearance = list(rhs=c("output=O"), default="lhs"))



#Lets see the rules. Should not be that much. 
# For each rule, it's support, confidence and lift are displayed.
inspect(rules1)
rules_lift <- sort (rules1, by="lift", decreasing=TRUE)
inspect(rules_lift) 
rules2 <- rules_lift[!is.redundant(rules_lift)]
inspect(rules2)
