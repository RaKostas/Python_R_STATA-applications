import numpy as np
import pandas as pd
import numpy as np
import random
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from tabulate import tabulate



crimedata = pd.read_csv('communities.data', header=None, sep=",")
crimedata.head()
# Columns of interest:
df = crimedata.iloc[:,[127,17,26,27,31,32,37,76,90,95]]
#rename colums
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

print(df)

# check dtypes
df.dtypes 
print(df.dtypes)
# check for missing values
df.isna().sum()
print(df.isna() .sum())







# define dependent and independent variables
dependent= df.loc[:,['ViolentCrimesPerPop']]


 

independent=df.loc[:,['medIncome',
              'whitePerCap',
              'blackPerCap',
              'HispPerCap',
              'NumUnderPov',
              'PctUnemployed',
              'HousVacant',
              'MedRent',
              'NumStreet']]


 
#OLS

lm = LinearRegression(normalize=False, fit_intercept=True)
estimatedModel = lm.fit(independent, dependent)

 
#Show Coefficients
print("Coefficients:")
print(tabulate (estimatedModel.coef_))

 


print("\t-Intercept:", estimatedModel.intercept_)

 

print("You may also display the R-squared (the proportion of variance explained):")
#R^2
Rsquared = lm.score(independent, dependent)

 

print("R-squared:", Rsquared)






###################################################################################

# Bacth Gradient Descent



#  preparetion of the data
#  X -> matrix of independent variables values, with the first column all ones (1)
#  y -> Vector of values of dependent variable
#  alpha -> the learning rate
#  numIterations -> How many iterations to do.


# Get the dependent variable - ViolentCrimesPerPop at column 1 - as a matrix
dependent =  np.array(crimedata.loc[:,[127]])

# Prepare the matrix of the values of the independent variables.

independent =  np.array(crimedata.loc[:,[17,26,27,31,32,37,76,90,95]])

# Create a new column with 1994 ones in it (1994 beacuase we have 1994 observation in the training set)
onesColumn = np.ones( (1994,1) )

# Now add the column with ones to the matrix of independent variables values

independentVars = np.hstack((onesColumn, independent))

# Get random thetas
thetas = np.random.rand(independentVars.shape[1],1)

# Assign learning rate alpha.
alpha=0.01

# How many iterations to do?
numIterations = 100



def calculateCost(x, y, theta, m):    
    cost = np.sum( (np.dot(x, theta) - y) ** 2) / (2 * m)
    return(cost)
    


def batchGradientDescent(x, y, theta, alpha, m, numIterations):
    calculatedCosts = []
    for i in range(0, numIterations):
        cost = calculateCost(x, y, theta, m)
        calculatedCosts.append(cost)
        theta = theta - alpha * (np.dot(x.transpose(), (np.dot(x, theta) - y)) / m)
        print("===== Iteration (%d) ======" % i)
        print(theta)        
        
    return theta, calculatedCosts




# Now execute the gradient descent algorithm
# Store the result in appropariate variables.
estimatedThetas, costs = batchGradientDescent(independentVars, dependent, thetas, alpha, 1994, numIterations)

# Print the estimated coefficients/thetas
print(">>> Estimated thetas")
print(estimatedThetas)

fig, ax = plt.subplots()
ax.plot(list(range(0,numIterations)),costs)

ax.set(xlabel='Iterations (i)', ylabel='Cost',
       title='Cost per iteration.')
ax.grid()

fig.savefig("test.png")
plt.show()


