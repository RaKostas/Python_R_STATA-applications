import numpy as np
from sklearn.linear_model import LinearRegression
import pandas as pd
import matplotlib.pyplot as plt
import random
from tabulate import tabulate


crimedata = pd.read_csv('communities.data', header=None, sep=",")
crimedata.head()


# Slice the columns of interest

df = crimedata.iloc[:,[127,17,26,27,31,32,37,76,90,96]]
# Rename columns
df.columns = ['ViolentCrimesPerPop',
              'medIncome',
              'whitePerCap',
              'blackPerCap',
              'HispPerCap',
              'NumUnderPov',
              'PctUnemployed',
              'HousVacant',
              'MedRent',
              'NumStreet']
# Check dtypes
df.dtypes 

# Check for missing values
df.isna().sum()


print(crimedata)
print(df.dtypes)
print(df.isna() .sum())





# Prepare the variables


y = df.iloc[:,1]
x = df.iloc[:,1:]







# Define learning rate
alpha=0.9
# Define number of iterations
numIters= 200
# Define thetas
thetas = [0]*x.shape[1]


# # Batch Gradient Descent


# Define the Function that calculates  cost 
def Calculate_Cost(x,y,theta):
    m = len(y)
    prediction = x.dot(theta)
    cost = sum((prediction-y)**2)/(2*m)
    return cost



# Implementation of mini Batch Gradient Descent
def miniBatchGradientDescent(x,y,theta,alpha=0.9,numIters=200,numBatches=10):
    m = len(y)
    cost_history = []
    for i in range(numIters):# Start epoch loop
        #Get random indexes according to batch and observations 
        indexes = x.sample(round(m/numBatches)).index 
        x_batch = x.iloc[indexes,:]
        y_batch = y[indexes]
        #Update thetas
        theta = theta - alpha*(x_batch.T.dot(x_batch.dot(theta)-y_batch))/m
        #Calculate Cost and save it
        cost_history.append(Calculate_Cost(x_batch,y_batch,theta))
    return theta,cost_history
 



estimatedthetas, costs = miniBatchGradientDescent(x, y, thetas,alpha,numIters)

 


print ("Estimated_thetas")
print(estimatedthetas)







 

fig, ax = plt.subplots()
ax.plot(list(range(0,numIters)),costs)

ax.set(xlabel='Iterations (i)', ylabel='Cost',
       title='Cost per iteration.')
ax.grid()

fig.savefig("test.png")
plt.show()
