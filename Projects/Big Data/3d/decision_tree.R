graphics.off() ; rm(list = ls(all = TRUE)) ; cat("\014");

setwd("C:\\Users\\USER\\Desktop")


library(rpart)
library(rpart.plot)
library(tree)
library(ggplot2)
library(e1071)
library(stringr)
library(rattle)

data = read.csv("agaricus-lepiota.data")
head(data)

#Our class variable is p:first column , e = edible / p = poisonous
unique(data$p)

#Now, we create the TRAINING and TESTING dataset
#initialize random number generator. Note: if you keep 2, the same 
#records will always be selected
set.seed(2)


##Create training set. We'll use 80% of the observations as the training 
#set which will be used to build the Decision tree.
train = sample(1:nrow(data),0.8*nrow(data))
#The rest will be our testing data.
test = -train
#Create the actual dataset
training_data = data[train,]
testing_data = data[-train,]
#Check for missing values
table(data$e.1)  #we observe 2480 have "?"

#Create the decision tree using the training data.
tree_model<-rpart(p~., method="class", data=training_data, 
                  na.action=na.rpart)

fancyRpartPlot(tree_model, main = "Poisonous or edible mushroom", cex=1 ,tweak=1)

head(testing_data)
tree_predict = predict(fit,testing_data,type="class")
#Prediction done. Now tree_predict is a one dimensional data structure
#(separate from testing dataset) that holds one value ?Yes?/?No? for 
#each record in testing set. I.e. the first value in tree_predict 
#corresponds to the first record in testing set.


#Now, try to evaluate how well our testing data was classified by 
#calculating the Confusion Matrix.
testingDataConfusionTable = table(tree_predict, testing_data$p)
print(testingDataConfusionTable)

#Calculate accuracy
accuracy = (sum(diag(testingDataConfusionTable))/sum(testingDataConfusionTable))
# Calculate Error rate
error_rate = 1-accuracy

#Print the result out nicely. We loooooooooove nice and clear responses.
#Note: As a rule of thumb, accuracy  >=70% means our model is nice! 
#If accuracy is lower, this might be due to the improperly selected 
#training set. Hence re-run the entire sequence again until you find a 
#disired accuracy. You can automate this by adding all the above steps 
#in a loop and find the best model.
sprintf('The Decision tree accuracy rate is %f and the error rate is %f',accuracy,error_rate)

#Entropy Gain
#We calculate entropy gain by hand for  habitat(u) of the first 30 observations
data2 = data[1:30,]
head(data2)

#Entropy Entire
#we have two classes(poisonous and edible)
Entropy_entire = - (22/30)*log2(22/30)  - (8/30)*log2(8/30)
Entropy_entire

# check how many unique values we have(splits) for a habitat split
unique(data2$u)
# we have 4 , "g","m","u" and "d" 

#Entropy split for the value "g" of habitat(u)
#fist is whether the mushroom is edible - the mushroom is poisonous
Entropy_1 = - (7/11)*log2(7/11) - (4/11)*log2(4/11)
Entropy_1

#Entropy split for the value "m" of habitat(u)
#fist is whether the mushroom is edible - the mushroom is poisonous
Entropy_2 = - (12/12)*log2(12/12) - 0
Entropy_2 

#Entropy split for the value "u" of habitat(u)
#fist is whether the mushroom is edible - the mushroom is poisonous
Entropy_3 = - (2/6)*log2(2/6) - (4/6)*log2(4/6)
Entropy_3 

#Entropy split for the value "d" of habitat(u)
#fist is whether the mushroom is edible - the mushroom is poisonous
Entropy_4 = - (1/1)*log2(1/1) - 0
Entropy_4 


#Entropy split
Entropy_split<- 11/30*Entropy_1 + 12/30*Entropy_2 + 6/30*Entropy_3 + 1/30*Entropy_4
Entropy_split

#Entropy_gain
Entropy_gain = Entropy_entire - Entropy_split
Entropy_gain


sprintf("Entropy split is %f and the Entropy gain on habitat is : %f",Entropy_split,Entropy_gain)
