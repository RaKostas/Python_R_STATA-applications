import pandas as pd
import numpy as np

# Download and print Dataset
url = "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"
df = pd.DataFrame(pd.read_csv(url,sep=";"))
df.head()


# Get feature names 
featureLabels=[col for col in df.columns]
# except quality
featureLabels=featureLabels[0:11]

# Standardize Data
from sklearn.preprocessing import StandardScaler
# Feature
x = df.loc[:, featureLabels].values
# Target
y = df.loc[:,['quality']].values
# Standard scale data
x = StandardScaler().fit_transform(x)


# PCA
from sklearn.decomposition import PCA
n_components=11
pca = PCA(n_components)
principalComponents = pca.fit_transform(x)
principalDf = pd.DataFrame(data = principalComponents
             , columns = [str(x+1) for x in list(range(n_components))])

# Results
# Results.
print('Oi 11 idiotimes apo tin PCA einai:')
print(pca.singular_values_) # Eigenvalues - Erwtima 1
print('Ta 11 idiodianysmata apo tin PCA einai:')
print(pca.components_)# Eigenvectors) - Erwtima 2
print('Ta ratio pou antistoixei stin kathe idiotimi einai:')
print(pca.explained_variance_ratio_) # Explained_variance_ratio - Erwtima 3



#Euclidean Distance
def euclideanDistance(x,y):   
    return np.sqrt(np.sum((x-y)**2))

#D1,D2,D3,D4

#D1
d1=euclideanDistance(np.array([1,2,3,4,5,6]),np.array([1,2,3,4,5,6]))
print(d1)

#D2
d2=euclideanDistance(np.array([-0.5,1,7.3,7,9.4,-8.2,9,-6,-6.3]),np.array([0.5,-1,-7.3,-7,-9.4,8.2,-9,6,6.3]))
print(d2)

#D3
d3=euclideanDistance(np.array([-0.5,1,7.3,7,9.4,-8.2]),np.array([1.25,9.02,-7.3,-7,5,1.3]))
print(d3)

#D4
d4=euclideanDistance(np.array([0,0,0.2]),np.array([0.2,0.2,0]))
print(d4)





#Euclidean Distance
def euclideanDistance(x,y):   
    return np.sqrt(np.sum((x-y)**2))

#user1,user2,user3,user4,user5

user1=np.array([25000,14,7])
user2=np.array([42000,17,9])
user3=np.array([55000,22,5])
user4=np.array([27000,13,11])
user5=np.array([58000,21,13])

#Duser1user5
Duser1user5=euclideanDistance(user1,user5)
print(Duser1user5)

#Duser2user5
Duser2user5=euclideanDistance(user2,user5)
print(Duser2user5)

#Duser3user5
Duser3user5=euclideanDistance(user3,user5)
print(Duser3user5)

#Duser4user5
Duser4user5=euclideanDistance(user4,user5)
print(Duser4user5)





#Cosine Similarity function
def cosinesimilarity(x,y):
    return(np.dot(x,y)/(np.sqrt(np.dot(x,x))* np.sqrt(np.dot(y,y))))

#cosSimA
x=([9.32,-8.3,0.2])
y=([-5.3,8.2,7])
cosSimA=cosinesimilarity(x,y)
print(cosSimA)

#cosSimB
x=([6.5, 1.3, 0.3, 16, 2.4, -5.2, 2, -6, -6.3])
y=([0.5, -1, -7.3, -7, -9.4, 8.2, -9, 6, 6.3])
cosSimB=cosinesimilarity(x,y)
print(cosSimB)

#cosSimC
x=([-0.5, 1, 7.3, 7, 9.4, -8.2])
y=([1.25, 9.02, -7.3, -7, 15, 12.3])
cosSimC=cosinesimilarity(x,y)
print(cosSimC)

#cosSimD
x=([2, 8, 5.2])
y=([2, 8, 5.2])
cosSimD=cosinesimilarity(x,y)
print(cosSimD)




#Nominal Distance Function
def nominaldistance(v1,v2):
    l=len(v1)
    w = np.zeros((l), dtype=np.int)
    for i in range(len(v1)):
        x = v1[i]
        y = v2[i]
        if x==y :
           w[i] = 0
        else:
           w[i] = 1
    z=np.sum(w)
    return z


#Nominal Distance A
x= ["Green","Potato","Ford"]
y= ["Tyrian purple","Pasta","Opel"]
nominaldistanceA=nominaldistance(x,y)
print(nominaldistanceA)

#Nominal Distance B
x= ["Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay"]
y= ["Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay"]
nominaldistanceB=nominaldistance(x,y)
print(nominaldistanceB)

#Nominal Distance C
x= ["Werner Herzog", "Aquirre, the wrath of God", "Audi", "Spanish red"]
y= ["Martin Scorsese", "Taxi driver", "Toyota", "Spanish red"]
nominaldistanceC=nominaldistance(x,y)
print(nominaldistanceC)

