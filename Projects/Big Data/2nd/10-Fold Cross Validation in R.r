

# k-Fold Cross Validation
# Returns the Root Mean Squared Prediction Error
calculateRMSE<-function(predictedValues, actualValues){
  err<- sqrt( mean((actualValues - predictedValues)^2)  )
  return( err )
}

# The function returns the average of the mean squared error
kFoldCrossValidation<-function(data, frml, k){
  # Random shuffle of observations in the dataset
  dataset<-data[sample(nrow(data)),]
  # Create k folds of approximately equal size
  folds <- cut(seq(1,nrow(dataset)), breaks=k, labels=FALSE)
   # Vector to store RMSE values
  RMSE<-vector()
  # The process stops when all folds have been used as test sets
  for(i in 1:k){

    # Define the test set for the current iteration
    testIndexes <- which(folds==i,arr.ind=TRUE)
    # Define test dataset
    testData <- dataset[testIndexes, ]
    # Define training dataset (everything except the test set)
    trainData <- dataset[-testIndexes, ]
    # Estimate regression model coefficients using training data
    candidate.linear.model<-lm( frml, data = trainData)
    # Predict dependent variable values for the test set
    predicted<-predict(candidate.linear.model, testData)
    # Calculate RMSE error
    error<-calculateRMSE(predicted, testData[, "area"])
    # Store error value
    RMSE<-c(RMSE, error)
  }
  
  # Return the average error across all folds
  return( mean(RMSE) )
}

#ii)

# Dataset with geographical and meteorological data for forest fires in Portugal
forestfires<-read.csv("forestfires.csv", sep=",", header=T,stringsAsFactors = F, quote = "\"")


# Check for missing values and remove rows that contain any missing value
forestfires<-na.omit(forestfires)


# Candidate models to evaluate the prediction of burned area
# based on weather conditions using 10-fold cross-validation
# area = β1*temp + β2*wind + β3*rain + β0

# Regression models stored as strings and converted to R formulas
predictionModels<-vector()
predictionModels[1]<-"area ~ temp+wind+rain"
forestfires2<-forestfires[which(forestfires$area<3.2),]
forestfires2<-na.omit(forestfires2)
predictionModels[2]<-"area ~ temp+wind+rain"

# After each cross-validation, the average RMSE of each model is stored

modelMeanRMSE<-vector()
modelMeanRMSE2<-vector()
# Perform 10-fold cross-validation for each candidate model
for (k in 1:length(predictionModels[1])){
  # Δισταυρωμένη επικύρωση 10-πτυχών για το γραμμικό μοντέλο παλινδρόμησης k
  modelErr<-kFoldCrossValidation(forestfires,as.formula(predictionModels[k]), 10)
  # Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE<-c(modelMeanRMSE, modelErr)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr ) )
}

for (k in 1:length(predictionModels[2])){

  # 10-fold cross-validation for linear regression model k
  modelErr2<-kFoldCrossValidation(forestfires2, as.formula(predictionModels[k]), 10)

  # Store average error
  modelMeanRMSE2<-c(modelMeanRMSE2, modelErr2)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr2 ) )
}

# Combine RMSE of both models
all<-c(modelMeanRMSE,modelMeanRMSE2)

# Which model had the lowest RMSE?
bestModelIndex<-which( modelMeanRMSE == min(modelMeanRMSE) )

# Display the model with the lowest RMSE (highest accuracy)
print( sprintf("Model with best accuracy was: [%s] error: [%f]", predictionModels[bestModelIndex], all[bestModelIndex]) )

# Regression models evaluated using RMSE with OLS,
# where coefficients are estimated using the entire dataset as training data
final.linear.model<-lm( as.formula(predictionModels[bestModelIndex]), data=forestfires )
final.linear.model
final.linear.model<-lm( as.formula(predictionModels[bestModelIndex]), data=forestfires2 )
final.linear.model
