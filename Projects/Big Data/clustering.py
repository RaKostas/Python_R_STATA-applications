

2.1



#  KMeans clustering          #




# Import some required libraries
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from sklearn import preprocessing # That's for MinMax normalization
from sklearn.cluster import KMeans
from kmodes.kmodes import KModes

####QUESTION 1
#Read csv file
#The dataset  Movies is  a csv file which
#contains the titles of 9125 movies 
#along with the categories to which each belongs film.

movies = pd.read_csv("C:\\Users\\USER\\Desktop\\movies.csv")
print(movies.head())
ratings = pd.read_csv("C:\\Users\\USER\\Desktop\\ratings.csv")
print(ratings.head())
print('The dataset contains: ', len(ratings), ' ratings of ', len(movies), ' movies.')



####QUESTION 2
###We use the library kmodes to execute kmeans algorithm cause our data
#consists of categorical variables so

##Euclidean distance can't be applied in this case.
#Before executing the K-means algorithm, we have to normalize the variables that
#will be used for clustering since K-means uses Euclidean distance which is
#sensible to big values. We use min-max normalization.

#MinMax normalization of all variables has been done. We can now execute
#the KModes algorithm in an attempt to cluster the different movies.
#However, since we don't know the most appropriate value for k, we use
#the Elbow method:this means that we execute the KModes algorithm for different
#values of k and calculate the objective function SSE. Afterwards we plot the
#SSE in relation to k (number of clusters) and select that value of k where
#the elbow appears in the plot.
maxNumberOfClusters = 100

# Here we store the value of the objective function after each
# KMeans executuin
sse = []

print("Executing KMeans for k=2 up to",maxNumberOfClusters )
# Ok, enough with words. Start the clustering process for
# all the values of k. During each iteration, we
# calculate the objective function and store the value in the above list.
for k in range(2, maxNumberOfClusters+1):
    print("\t>>> Executing KMeans with k=",k, "clusters.....", end="")
    km = KModes(n_clusters=k, init='Huang', max_iter=500, n_init=10, random_state=0)
    # .fit() method actually does the kmeans clustering of wineData 
    km.fit(movies)
    # .inertia_ contains the value of the objective function which is the sum of squared distances
    # across all clusters (SSE). Add the sum of squared distances into the list, so that
    # we can later diplay it
    sse.append(km.cost_)
    print("Done.")
    

# Done. We have executed the KMeans for different values of k. Lets see which value of k is
# an appropriate one.
# Now we plot here the sum of squared errors that we got with regards to k in order
# to identify the elbow. Around that area where the elbow is, is a sweet value of k.
print("Displaying plot to apply the Elbow method")
plt.plot(range(2, maxNumberOfClusters+1), sse)
#y = np.array([i for i in range(2,maxNumberOfClusters+1,1)])
#plt.plot(y,cost)
plt.title('Elbow Method')
plt.xlabel('Number of clusters')
plt.ylabel('SSE')
plt.show()


#
# Looks like 15 is an ok value.
# NOTE: this value has been determined by executing the previous elbow method
# with maxNumberOfClusters = 100.
#
# Execute KMeans again with k=15 to get the final clusters.
#
print("Executing KMeans with k=100 (100 clusters) to get FINAL clustering of the data...", end="")
km = KModes(n_clusters=15, init='Huang', max_iter=500, n_init=10, random_state=0)
clusters = km.fit(movies)
print("Done")

# Now, variable clusters contains the information which cluster each observation belongs to.
# Clusters are numbered using sequential integer values (starting from 0) that function
# as IDs of the clusters.
# In our case clusters  will be numbered from 0 up to 15 (since we set k=15)
# which -as mentioned- functions as an ID of the cluster.
# In particular, clusters.labels_ contain the ID of the cluster each observation (row) in
# DataFrame wineData belongs to. Hence, the first value in clusters.labels_ contains the cluster in
# which the first row of wineData belongs, second value in clusters.labels_ contains the cluster
# in which the second row of wineData belongs etc.

# Take a look at the cluster IDs
print("Displaying cluster IDs...")
print(clusters.labels_)

print("Appending \"cluster\" variable to DataFrame wineData.....", end="")
# In order to get a better view of the cluster each data item was placed,
# we create a new variable called Cluster in our DataFrame wineData and assign
# to that new variable the results of KMeans.
# This allows us to e.g. filter the data based on the cluster they belong to
# using slicing operators.
movies["ClusterId"] = clusters.labels_
print("Done")

# Next we display a trivial user interface that lets you enter
# a cluster ID and it displays the data in wineData belonging to that cluster.
desiredCluster=0
while desiredCluster >= 0:

      ans = input(">>>Give cluster ID (enter negative value to quit):")
      if ans == "":
         continue
        
      desiredCluster = int(ans)
      if desiredCluster >= 0:
         print("...All data belonging to cluster:", desiredCluster)
         print( movies[ movies["ClusterId"] == desiredCluster ] )
      else:
          print("...ByeBye!")


#Question 4
data = pd.merge(ratings, movies, on='movieId') 
print(data.head())

# Calculate mean rating of all movies 
data.groupby('title')['rating'].mean().sort_values(ascending=False).head()
print(data)

# Calculate count rating of all movies 
data.groupby('title')['rating'].count().sort_values(ascending=False).head() 
print(data)
# creating dataframe with 'rating' count values 
values = pd.DataFrame(data.groupby('title')['rating'].mean())
values.columns = ['mean of ratings']
print(values) 
values['num of ratings'] = pd.DataFrame(data.groupby('title')['rating'].count()) 
print(values)
data = pd.merge(values, data, on='title') 
print(data.head())

###QUESTION 5

User=0
while User >= 0:
        a = input(">>>Give the userID (enter negative value to quit):")
        if a == "":
         continue
        
        User = int(a)
        if User >= 0:
            print('\nGet', User ,'from the dataset:')
            feedback=pd.DataFrame(data.loc[ data.loc[:,"userId"] == User, ("userId","rating",'ClusterId') ])
            print(feedback)

        #Question 6
            mean_ratings=pd.DataFrame(feedback.groupby('ClusterId')['rating'].mean())
            user_mean_ratings = pd.merge(mean_ratings, feedback, on='ClusterId')
            user_mean_ratings.columns = ['ClusterId', 'mean_ratings_of_class','userId','rating']
            print(user_mean_ratings)

        #Question 7
            above35=user_mean_ratings.loc[user_mean_ratings.loc[:,"mean_ratings_of_class"] >= 3.5]
            print(above35)
        #Question 8
            if  all(above35.mean_ratings_of_class < 3.5):
                print("Sorry, no recommendations for you!")
            else:
                print("Recommendation for you!")
        #Question 9
                

        else:
          print("...ByeBye!")


2.2

# Import the required modules
import pandas as pd
import numpy as np
from sklearn.cluster import AgglomerativeClustering
from sklearn import preprocessing
from sklearn.preprocessing import MinMaxScaler

# Read csv file
# The dataset  europe is  a csv file 
europe = pd.read_csv("C:\\Users\\USER\\Desktop\\europe.csv", sep=",", header=0, quotechar="\"")


#check the data
print(europe.head() )

#Attributes/Variables have different scales.
#we will be using Euclidean distance in the distance matrix, this may
#introduce bias. Hence, try to normalize each value of attribute to
#a scale from 0 to 1

#We will use min-max normalization.
#Define the function norm that will normalize a value using the min-max 'GDP',
#'Inflation','Life.expect','Military','Pop.growth','Unemployment'
#from sklearn.preprocessing import MinMaxScaler
#This will normalize every attribute in our dataset.
numeric = ['GDP','Inflation','Life.expect','Military','Pop.growth','Unemployment']
categorical = ['Country','Area']
scaler = preprocessing.MinMaxScaler()
X_numeric_std = pd.DataFrame(data=scaler.fit_transform(europe[numeric]),
                             columns=numeric)
europe_std = pd.merge(europe[categorical],X_numeric_std,  left_index=True,
                      right_index=True)
print(europe_std.head())

#After the normalization we can continue 

#We will use the Python function AgglomerativeClustering() to calculate the entire
#distance matrix based on the Euclidean distance. To tell Python to take into consideration
#all attributes except the first and the second.
#The AgglomerativeClustering() function executes hierarchical clustering.
#AgglomerativeClustering() takes a shitload of arguments, but the important ones
#are two: 1) the distance matrix  and 2) the distance 
#measure for clusters. First argument of AgglomerativeClustering() is the distanceMatrix
#that has been. If no argument for the distance measure of clusters is given 
#(parameter method), the "Complete Linkage" measure is assumed. 
#Here we use the complete linkage by explicitly specifying it.

#AgglomerativeClustering=AgglomerativeClustering(n_clusters=2, affinity='euclidean', memory=None,
#                                                     connectivity=None,
#                                                     compute_full_tree='auto',
#                                                     linkage='complete', distance_threshold=None)
clustering = AgglomerativeClustering().fit(europe_std.iloc[:,2:8])
###clusters of the dataset
print(clustering)
AgglomerativeClustering()
print(clustering.labels_)


from matplotlib import pyplot as plt
from scipy.cluster.hierarchy import dendrogram

#Another fuction for hierarcical clustering is the Python function
#hierarchy.linkage to calculate the entire distance matrix based on the
#Euclidean distance and the distance measure of clusters is given 
#(parameter method), the "Complete Linkage".
    
from scipy.cluster import hierarchy

Z = hierarchy.linkage(europe_std.iloc[:,2:8], 'complete')
print(Z)
###cluster the dataset by an index presenting country as label
europe= europe.set_index('Country')
del europe_std.index.name
europe
 
# Plot with Custom leaves(dendrogram)
hierarchy.dendrogram(Z, leaf_rotation=90, leaf_font_size=8, labels=europe.index)
plt.show()






