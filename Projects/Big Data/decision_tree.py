import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn import preprocessing
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix, classification_report
from sklearn import tree

data = pd.read_csv('agaricus-lepiota.data')
data.head()
# We follow the same procedure in Python as well,but first we have to do one-hot encoding for our categorical variables
# Do the  One-Hot encoding of all categorical variables.

print("\n\nPreprocessing dataset\n")

# First, get a list of the names of variables in our dataset that are categorical.
# We to this using the .select_dtypes().columns method giving as argument [object].
# The value [object] is the way a DataFrame in Python signifies that a variable is categorical.
categoricalVariables = data.select_dtypes([object]).columns

# Now variable categoricalVariables has the list of names of variables in the DataFrame
# bankData that have categorical variables. We iterate over these variables and
# do a One-hot encoding of each of these during each iteration.
# CAVEAT: We only avoid the class attribute! The class attribute, that takes binary values 'edible', 'poisonous'
# will not be One-hot encoded. We use a different way to encode the class attribute to 0 and 1.
for var in categoricalVariables:

    print("\tOne-Hot-Encoding variable ", var, " .....", sep="", end="")
    # Is this variable our class attribute? If so, DO NOT One-hot encode it i.e. ignore it
    if var == "p":
        print("Ignored")  # yes it is the class attribute. Ignore it for now,
        # as we will handle it differently
        continue  # don't execute the code below. Go on to next attribute

    # If we reach this point during the for-loop, the variable var IS NOT the class attribute
    # and catefffgorical. Hence, One-hot encode it.

    # First, make the variable we are going to One-hot encode explicitly categorical
    data[var] = pd.Categorical(data[var])
    # Now, this does the actual work of One-hot encoding of variable var.
    # varDummies will be a pandas DataFrame with new variables, one for each
    # possible value of variable var and the proper value for each of these variables
    # for the respective entry in the original dataset.
    varDummies = pd.get_dummies(data[var], prefix=var)
    # One-hot encoding of variable done.
    # Now, add the new variables to our original dataset.
    data = pd.concat([data, varDummies], axis=1)
    # And remove the original variable from our dataset. We don't need it anymore
    # since we have One-hot encoded it and added the new variables to the DataFrame.
    data = data.drop([var], axis=1)
    print("Done")
    # Finished. Go to next categorical variable in our dataset and do the same.

# If we reach this point, all categorical variables have been One-hot encoded. We print out
# the variables of the DataFrame just to get a look at how many new variables were added


print("\n\tVariables of DataFrame bankData after One-hot encoding:")
print("\t", data.columns)

# We left out the class attribute during One-hot encoding.
# Since the class attribute (attribute/variable y in our dataset) already takes two values ('edible', 'poisonous') and hence is in
# essence already a binary variable, we just do different encoding of these values: we will transform the value 'edible' to the number 0
# and the value 'poisonous' to the value 1.
# We do this encoding and add a new column to the end of DataFrame Data  named newP, containing these new values of 0 and 1.
# Once we have done this, the original column/variable p is not needed anymore and can be dropped.

data['newP'] = (data['p'].map({'e': 0, 'p': 1}))

# Drop the column P. Not needed anymore since we have added the column newP
data = data.drop(['p'], axis=1)
print("\n\nPreprocessing done.")

#Ok, now that we are done with One-Hot-Encoding let's split our data set to train and test!
#First, split X and Y
features = data.iloc[:,:-1]
classVariable = data['newP']
#Followed by the split!
X_train,X_test,Y_train,Y_test = train_test_split(features, classVariable, test_size=0.2, random_state = 100)

#Great, now let's create the model and fit our data
print("\nTraining the model (decision tree)......", sep='', end='')

# We use entropy as our impurity measure and there set the argument criterion="entropy".
# We could also use the gini measure and in this case we would specify the argument criterion="gini"
model = DecisionTreeClassifier(criterion="entropy")
# Train now the model. The next line will create the Decision Tree using the entropy measure
# with which we are able to predict the value of the class variable newP.
model_fit = model.fit(X_train, Y_train)
print("done.")

#Model is done training, let's predict
print("\nUsing testing set to predict class attribute......", sep='', end='')
predictions = model.predict(X_test)
print("done.")

# Calculate Confusion Matrix and print it!
print("\nCalculating confusion matrix on the testing set......", sep='', end='')
cm = confusion_matrix(Y_test, predictions)
# We just tranform the confusion matrix into a DataFrame in order to make
# its display much more convenient i.e. it's done for purely esthetic reasons.
cm = pd.DataFrame(cm)
print("done.")
# Print/show the confusion matrix
print("Confusion matrix:")
print(cm)

#Let's now calculate accuracy and error and print them:
# Next, based on the values in the confusion matrix, the accuracy
# of the model will be calculated using the formula:
# accuracy pct = (total number of correctly identified classes) / (total number of data in testing set)
result=model.score(X_test, Y_test)
# Show the accuracy of the model.
# A rule of thumb: if the accuracy is > 70% the model can be considered useful.
print ("\nModel's predictive accuracy is: %.2f%%" % (accuracy_score(Y_test,predictions)*100))

#Now we have to visualize the tree for the last part of the exercise:
fig = plt.figure(figsize=(25,20))
_ = tree.plot_tree(model, feature_names=data.columns, filled=True)
print(_)
print("---------------------------------Second Exercise / Manual Entropy Gain Calculation----------------------------------")
#Same as with R, entropy gain for habitat (first 30 observations), first keep only the observations we are interested in
data2 = data.iloc[:30,:]
data2.tail()

#Last Row is Edible = 0 / Poisonous = 1,let's see how much of each
data2.newP.value_counts()
#We already knew that, but let's move on.First of all create Entropy Calculation function(for 2 classes):
def Entropy(p1,p2):
    #Import math for math.log2(x) calculation
    import math
    if p1==0 or p2==0:
        return 0
    else:
        return (-p1*(math.log2(p1))-p2*(math.log2(p2)))
#Step 1: Calculate Entropy for root node(parent)
#Below we show different ways to get our results of probabilities
pp_e = data2.newP.value_counts()[0]/data2.newP.count()
pp_p = data2.newP.sum()/len(data2)
Entropy_root = Entropy(pp_e,pp_p)

#We got the root Entropy, let's find split entropy and sum multiply with weights to find Entropy Gain!
print(data2.iloc[:,110:117].sum())
print('We can see that only u,g,m,u have values so we will split them and calculate the Entropy for each node accordingly')

#Step 2: Split the nodes and Calculate Node Entropy for each one
split_d = data2.query("u_d ==1")
split_g = data2.query("u_g ==1")
split_m = data2.query("u_m ==1")
split_u = data2.query("u_u ==1")

#Find probabilities for edible, poisonous(0=edible,1=poisonous) for each

#d
pd_e = split_d['newP'].sum()/len(split_d)
pd_p = 1 - pd_e
#g
pg_e = split_g['newP'].sum()/len(split_g)
pg_p = 1 - pg_e
#m
pm_e = split_m['newP'].sum()/len(split_m)
pm_p = 1 - pm_e
#u
pu_e = split_u['newP'].sum()/len(split_u)
pu_p = 1 - pu_e

#Find Entropy for each split node

#d
Entropy_d = Entropy(pd_e,pd_p)
#g
Entropy_g = Entropy(pg_e,pg_p)
#m
Entropy_m = Entropy(pm_e,pm_p)
#u
Entropy_u = Entropy(pu_e,pu_p)

#Calculate Entropy for split as weighted Entropy of split nodes!

Entropy_split = Entropy_d * len(split_d)/len(data2) + Entropy_g * len(split_g)/len(data2) + Entropy_m * len(split_m)/len(data2) +Entropy_u * len(split_u)/len(data2)

#Last part, find Entropy Gain:

Entropy_gain = Entropy_root - Entropy_split

print(f' Root Entropy is {Entropy_root} \n Split Entropy is {Entropy_split}  \n Entropy Gain is {Entropy_gain}')
print('\n')
print('-----------------------End of Second Task : Manual Calculation of Entropy Gain on Habitat Split------------------------')

print('\n Beginning of Third Task(Python Only) Naive Bayes on mushrooms Data Set')
#For this task , the logic is the same as previous Decision Tree model, we just have to import Naive Bayes model first
#Since we have already preprocessed our data and they only contain 2 values (0/1) we are going to use BernoulliNB, let's import
from sklearn.naive_bayes import BernoulliNB

#Ok, all set, let's create , fit , predict and find our model's accuracy, we are going to use the split we made earlier
model_nb = BernoulliNB()
model_nb.fit(X_train,Y_train)
predictions_nb = model_nb.predict(X_test)
#Let's create our confusion matrix and print it
cm_nb = confusion_matrix(Y_test,predictions_nb)
cm_nb = pd.DataFrame(cm_nb)
print(f"Confusion Matrix for Naive Bayes model is : \n {cm_nb}")
#Find accuracy and error and print the results!
accuracy_nb = model_nb.score(X_test,Y_test)
print(f"The accuracy of our Naive Bayes model is : {accuracy_nb}")











