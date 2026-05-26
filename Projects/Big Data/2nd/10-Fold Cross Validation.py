from sklearn.linear_model import LinearRegression
from math import sqrt # We'll need sqrt()
import statistics # for mean()
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import KFold # import KFold
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
import pandas as pd


# Read the data
ffires = pd.read_csv("C:forestfires.csv",header=0, sep=",", engine='python')


ffires = ffires.sample(frac=1).reset_index(drop=True)


# We use the KFold object from sklearn and initialize it properly
kf = KFold(n_splits=10) 


print("\nLinear regression model: area = b1temp + b2wind + b3rain + b0\n")

# Create an empty array where we will store the calculated RMSE values
# so that we may be able to 
allRMSE = np.empty(shape=[0, 1])

# Just a variable to count at which tests we are
testNumber = 0

for train_index, test_index in kf.split(ffires):

 # Next test
 testNumber = 1
 

 trainingData = ffires.iloc[train_index,:]

 testData = ffires.iloc[test_index,:]


 lm = LinearRegression(normalize=False, fit_intercept=True)

 estimatedModel = lm.fit(trainingData.loc[:,['temp','wind','rain']],
                         trainingData.loc[:,['area']])

 
 print(">>>Iteration ", testNumber, sep='')
 print("\tEstimated coefficients:")
 print("\t\tb1=", estimatedModel.coef_[0][0] , sep='')
 print("\t\tb2=", estimatedModel.coef_[0][1] , sep='')
 print("\t\tb3=", estimatedModel.coef_[0][2] , sep='')
 print("\t\tb0=", estimatedModel.intercept_, sep='')
 
 
 # Now, use the estimated model to predict the value for area for

 predictedarea = estimatedModel.predict(testData.loc[:,['temp','wind','rain']])
 RMSE = sqrt(mean_squared_error(testData.loc[:,['area']], predictedarea))

 # Display the RMSE value
 print("\t\tModel RMSE=", RMSE, sep='')
 
 allRMSE = np.append(allRMSE, RMSE)



print("\n=======================================================")
print(" Final result: Mean RMSE of tests:", statistics.mean(allRMSE), sep='' )
print("=======================================================")



##############################################################################
print("Let's try when we have a restriction")
##############################################################################



ffires2 = pd.read_csv ("forestfires.csv",header=0, sep=",", engine='python')


ffires2 = ffires2.loc[ ffires2.loc[:,"area"] < 3.2 ] 
print(ffires.loc[ ffires.loc[:,"area"] < 3.2 ] )



ffires2 = ffires2.sample(frac=1).reset_index(drop=True)




# We use the KFold object from sklearn and initialize it properly
kf2 = KFold(n_splits=10) 


print("\nLinear regression model: area = b1temp + b2wind + b3rain + b0\n")

# Create an empty array where we will store the calculated RMSE values
# so that we may be able to 
allRMSE2 = np.empty(shape=[0, 1])

# Just a variable to count at which tests we are
testNumber2 = 0

for train_index, test_index in kf2.split(ffires2):

 # Next test
 testNumber2 = 1
 

 trainingData2 = ffires2.iloc[train_index,:]


 testData2 = ffires2.iloc[test_index,:]

 # The model we will estimate is: area = b1temp + b2wind + b3rain + b0
 lm2 = LinearRegression(normalize=False, fit_intercept=True)


 estimatedModel2 = lm2.fit(trainingData2.loc[:,['temp','wind','rain']],
                           trainingData2.loc[:,['area']])


 print(">>>Iteration ", testNumber2, sep='')
 print("\tEstimated coefficients:")
 print("\t\tb1=", estimatedModel.coef_[0][0] , sep='')
 print("\t\tb2=", estimatedModel.coef_[0][1] , sep='')
 print("\t\tb3=", estimatedModel.coef_[0][2] , sep='')
 print("\t\tb0=", estimatedModel.intercept_, sep='')
 
 
 predictedarea2 = estimatedModel2.predict(testData2.loc[:,['temp','wind','rain']])


 RMSE2 = sqrt(mean_squared_error(testData2.loc[:,['area']], predictedarea2))

 # Display the RMSE value
 print("\t\tModel RMSE=", RMSE2, sep='')

 allRMSE2 = np.append(allRMSE2, RMSE2)



print("\n=======================================================")
print(" Final result: Mean RMSE of tests:", statistics.mean(allRMSE2), sep='' )
print("=======================================================")


