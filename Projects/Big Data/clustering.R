
PART I



graphics.off() ; rm(list = ls(all = TRUE)) ; cat("\014");

library(amap)
library(MASS)
library(klaR)
library(plyr)

#Set our working directory
setwd("C:\\Users\\USER\\Desktop")

# QUESTION 1 
# Read csv files: movies and ratings
movies <- read.csv("movies.csv", header=TRUE, sep=",")
ratings <- read.csv("ratings.csv", header=TRUE, sep=",")

#Question 2
# Initialize random number generator. We need this because we'll be be using the nstart
# parameter in the kmeans() function that randomly initializes the process
set.seed(20)

# Initialize a vector wr where we will store our metric. 
# In this example we will use the mean (i.e. avg) of withinss . Since we will execute K-means 19 times we will
# use a vector with dimension 20. The idea is that position i of vector will store the mean withinss of K-means 
# with i centers.
# NOTE: we will ignore wr[1] as we won't execute K-means with 1 center.
wr <-rep(0, 100)

# clustering for K=2,3,4 etc until 100 each time executing K-means.We start with 2 
#clusters (starting with K=1 does not make really sense)
for(i in 2:100) {
  
  # Cluster the data with i centers
  moviesCluster<-kmeans(movies[,3:22], centers=i, nstart=20, iter.max=20)
  
  #Clustering done. Now store our selected metric. 
  wr[i] <- mean(moviesCluster$withinss) 
}

# Now plot the mean withinss values.  Try to see where the elbow is! (elbow method)
plot(2:100, wr[2:100], type="b", xlab="Number of Clusters",
     ylab="Ratio betweenss / totss",
     main="Assessing the Optimal Number of Clusters with the Elbow Method",
     pch=20, cex=2)


# Cluster the data with 15 centers
moviesCluster<-kmeans(movies[,3:22], centers=15, nstart=20, iter.max=20)

#Intially lets map the Movies w.r.t the Number of Votes 
top = as.data.frame(table(ratings$movieId))
names(top) = c("movieId", "NumberofVotes")
head(top)


#Lets merge the New data set with the ratings dataset
top = merge(top, ratings, by = 'movieId')
#Letss sort our new dataset with decreasing No.-of-Users-Voted
top = top[order(top$NumberofVotes, decreasing = TRUE),]

top10 = head(top, n = 10)

#Top 10 Most rated movies ordered by descending Views
print(top10[c(1:3)])
top1 = transform(top, rating = as.numeric(rating))
#mean of rating evaluation for each movie
meanrating = aggregate( rating ~ movieId, data = top1,  mean )

##the first 15 movies with their mean rating score
head(meanrating,n=15)

#Question 5
#choose the user 198
user198<-subset(ratings,ratings$userId=='198')

###select user198's ratings of movies
user198result <- data.frame(user198$userId,user198$rating)

clusterId <- c(" clusterId")
user198result[ , clusterId] <-0

user198result$` clusterId`[ user198result$` clusterId`== 0 ]<-moviesCluster$cluster

#Question 6
###create a dataframe-team with cluster 1
cluster1<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 1 ])
rating1 <- c(" rating1")
cluster1[,rating1]<-0
###add ratings that only belongs to cluster 1 for user198
cluster1$` rating1`[ cluster1$` rating1`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 1 for user198
mean(cluster1$` rating1`)


###create a dataframe-team with cluster 2
cluster2<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 2 ])
rating2 <- c(" rating2")
cluster2[,rating2]<-0
###add ratings that only belongs to cluster 2 for user198
cluster2$` rating2`[ cluster2$` rating2`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 2 for user198
mean(cluster2$` rating2`)

###create a dataframe-team with cluster 3
cluster3<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 3 ])
rating3 <- c(" rating3")
cluster3[,rating3]<-0
###add ratings that only belongs to cluster 3 for user198
cluster3$` rating3`[ cluster3$` rating3`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 3 for user198
mean(cluster3$` rating3`)

###create a dataframe-team with cluster 4
cluster4<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 4 ])
rating4 <- c(" rating4")
cluster4[,rating4]<-0
###add ratings that only belongs to cluster 4 for user198
cluster4$` rating4`[ cluster4$` rating4`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 4 for user198
mean(cluster4$` rating4`)

###create a dataframe-team with cluster 5
cluster5<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 5 ])
rating5 <- c(" rating5")
cluster5[,rating5]<-0
###add ratings that only belongs to cluster 5 for user198
cluster5$` rating5`[ cluster5$` rating5`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 5 for user198
mean(cluster5$` rating5`)

###create a dataframe-team with cluster 6
cluster6<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 6 ])
rating6 <- c(" rating6")
cluster6[,rating6]<-0
###add ratings that only belongs to cluster 6 for user198
cluster6$` rating6`[ cluster6$` rating6`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 6 for user198
mean(cluster6$` rating6`)

###create a dataframe-team with cluster 7
cluster7<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 7 ])
rating7 <- c(" rating7")
cluster7[,rating7]<-0
###add ratings that only belongs to cluster 7 for user198
cluster7$` rating7`[ cluster7$` rating7`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 7 for user198
mean(cluster7$` rating7`)

###create a dataframe-team with cluster 8
cluster8<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 8 ])
rating8 <- c(" rating8")
cluster8[,rating8]<-0
###add ratings that only belongs to cluster 8 for user198
cluster8$` rating8`[ cluster8$` rating8`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 8 for user198
mean(cluster8$` rating8`)

###create a dataframe-team with cluster 9
cluster9<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 9 ])
rating9 <- c(" rating9")
cluster9[,rating9]<-0
###add ratings that only belongs to cluster 9 for user198
cluster9$` rating9`[ cluster9$` rating9`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 8 for user198
mean(cluster9$` rating9`)


###create a dataframe-team with cluster 10
cluster10<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 10 ])
rating10 <- c(" rating10")
cluster10[,rating10]<-0
###add ratings that only belongs to cluster 10 for user198
cluster10$` rating10`[ cluster10$` rating10`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 10 for user198
mean(cluster10$` rating10`)

###create a dataframe-team with cluster 11
cluster11<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 11 ])
rating11 <- c(" rating11")
cluster11[,rating11]<-0
###add ratings that only belongs to cluster 11 for user198
cluster11$` rating11`[ cluster11$` rating11`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 11 for user198
mean(cluster11$` rating11`)

###create a dataframe-team with cluster 12
cluster12<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 12 ])
rating12 <- c(" rating12")
cluster12[,rating12]<-0
###add ratings that only belongs to cluster 12 for user198
cluster12$` rating12`[ cluster12$` rating12`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 12 for user198
mean(cluster12$` rating12`)

###create a dataframe-team with cluster 13
cluster13<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 13 ])
rating13 <- c(" rating13")
cluster13[,rating13]<-0
###add ratings that only belongs to cluster 13 for user198
cluster13$` rating13`[ cluster13$` rating13`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 13 for user198
mean(cluster13$` rating13`)

###create a dataframe-team with cluster 14
cluster14<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 14 ])
rating14 <- c(" rating14")
cluster14[,rating14]<-0
###add ratings that only belongs to cluster 14 for user198
cluster14$` rating14`[ cluster14$` rating14`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 14 for user198
mean(cluster14$` rating14`)

###create a dataframe-team with cluster 15
cluster15<-data.frame(user198result$` clusterId`[ user198result$` clusterId`== 15 ])
rating15 <- c(" rating15")
cluster15[,rating15]<-0
###add ratings that only belongs to cluster 15 for user198
cluster15$` rating15`[ cluster15$` rating15`== 0 ] <- user198result$user198.rating
##mean of the ratings only in cluster 15 for user198
mean(cluster15$` rating15`)

#Question 7 - Question 8


#mean of cluster 1 for user198
if(mean(cluster1$` rating1`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 2 for user198
if(mean(cluster2$` rating2`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 3 for user198
if(mean(cluster3$` rating3`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 4 for user198
if(mean(cluster4$` rating4`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 5 for user198
if(mean(cluster5$` rating5`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 6 for user198
if(mean(cluster6$` rating6`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 7 for user198
if(mean(cluster7$` rating7`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 8 for user198
if(mean(cluster8$` rating8`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 9 for user198
if(mean(cluster9$` rating9`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 10 for user198
if(mean(cluster10$` rating10`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 11 for user198
if(mean(cluster11$` rating11`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 12 for user198
if(mean(cluster12$` rating12`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 13 for user198
if(mean(cluster13$` rating13`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 14 for user198
if(mean(cluster14$` rating14`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#mean of cluster 15 for user198
if(mean(cluster15$` rating15`)<3.5){
  print("Sorry, no recommendations for
        you!")
} else {
  print("There are recommendations for you!")
}

#Question 9
#max ratings in cluster 1...15 for user198 except 3 & 5
max(cluster1$` rating1`)
max(cluster2$` rating2`)
max(cluster4$` rating4`)
max(cluster6$` rating6`)
max(cluster7$` rating7`)
max(cluster8$` rating8`)
max(cluster9$` rating9`)
max(cluster10$` rating10`)
max(cluster11$` rating11`)
max(cluster12$` rating12`)
max(cluster13$` rating13`)
max(cluster14$` rating14`)
max(cluster15$` rating15`)


###all movies belongs in cluster 1 for all the users
movieall1<-subset(ratings, moviesCluster$cluster==1 & ratings$rating==5 )
###all movies belongs in cluster 2 for all the users
movieall2<-subset(ratings, moviesCluster$cluster==2 & ratings$rating==5 )
###all movies belongs in cluster 4 for all the users
movieall4<-subset(ratings, moviesCluster$cluster==4 & ratings$rating==5 )
###all movies belongs in cluster 6 for all the users
movieall6<-subset(ratings, moviesCluster$cluster==6 & ratings$rating==5 )
###all movies belongs in cluster 7 for all the users
movieall7<-subset(ratings, moviesCluster$cluster==7 & ratings$rating==5 )
###all movies belongs in cluster 8 for all the users
movieall8<-subset(ratings, moviesCluster$cluster==8 & ratings$rating==5 )
###all movies belongs in cluster 9 for all the users
movieall9<-subset(ratings, moviesCluster$cluster==9 & ratings$rating==5 )
###all movies belongs in cluster 10 for all the users
movieall10<-subset(ratings, moviesCluster$cluster==10 & ratings$rating==5 )
###all movies belongs in cluster 11 for all the users
movieall11<-subset(ratings, moviesCluster$cluster==11 & ratings$rating==5 )
###all movies belongs in cluster 12 for all the users
movieall12<-subset(ratings, moviesCluster$cluster==12 & ratings$rating==5 )
###all movies belongs in cluster 13 for all the users
movieall13<-subset(ratings, moviesCluster$cluster==13 & ratings$rating==5 )
###all movies belongs in cluster 14 for all the users
movieall14<-subset(ratings, moviesCluster$cluster==14 & ratings$rating==5 )
###all movies belongs in cluster 15 for all the users
movieall15<-subset(ratings, moviesCluster$cluster==15 & ratings$rating==5 )
### movies that 198 user have seen and belongs in both 2 and 12 clusters
df<-subset(ratings, ratings$userId==198 & ratings$rating==5)

##substact from the whole movies of cluster 1 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 1
best1cluster<-movieall1[!movieall1$movieId %in% df$movieId,]

##substact from the whole movies of cluster 2 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 2
best2cluster<-movieall2[!movieall2$movieId %in% df$movieId,]

##substact from the whole movies of cluster 4 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 4
best4cluster<-movieall4[!movieall4$movieId %in% df$movieId,]

##substact from the whole movies of cluster 6 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 6
best6cluster<-movieall6[!movieall6$movieId %in% df$movieId,]

##substact from the whole movies of cluster 7 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 7
best7cluster<-movieall7[!movieall7$movieId %in% df$movieId,]

##substact from the whole movies of cluster 8 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 1
best8cluster<-movieall8[!movieall8$movieId %in% df$movieId,]

##substact from the whole movies of cluster 9 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 9
best9cluster<-movieall9[!movieall9$movieId %in% df$movieId,]

##substact from the whole movies of cluster 10 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 10
best10cluster<-movieall10[!movieall10$movieId %in% df$movieId,]

##substact from the whole movies of cluster 11 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 11
best11cluster<-movieall11[!movieall11$movieId %in% df$movieId,]

##substact from the whole movies of cluster 12 those user 198 have seen
df$movieId  #user seen 198 
##extract those movies(36,858...) from the whole cluster 12
best12cluster<-movieall12[!movieall12$movieId %in% df$movieId,]

##substact from the whole movies of cluster 13 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 13
best13cluster<-movieall13[!movieall13$movieId %in% df$movieId,]

##substact from the whole movies of cluster 14 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 14
best14cluster<-movieall14[!movieall14$movieId %in% df$movieId,]

##substact from the whole movies of cluster 15 those user 198 have seen
df$movieId #user seen 198 
##extract those movies(36,858...) from the whole cluster 15
best15cluster<-movieall15[!movieall15$movieId %in% df$movieId,]



###recommendation of movies on the whole cluster 1,2,...,15 that user198 didn't 
###evaluate so he hasn't seen them.(same cluster means same choice of films).
###select 2 movies from the two clusters randomly wtih rating=5.
film1cluster1<-subset(movies, movies$movieId==592)
film2cluster1<-subset(movies, movies$movieId==1257)

film1cluster2<-subset(movies, movies$movieId==141)
film2cluster2<-subset(movies, movies$movieId==480)

film1cluster4<-subset(movies, movies$movieId==222)
film2cluster4<-subset(movies, movies$movieId==585)

film1cluster6<-subset(movies, movies$movieId==150)
film2cluster6<-subset(movies, movies$movieId==589)

film1cluster7<-subset(movies, movies$movieId==265)
film2cluster7<-subset(movies, movies$movieId==2959)

film1cluster8<-subset(movies, movies$movieId==1214)
film2cluster8<-subset(movies, movies$movieId==1219)

film1cluster9<-subset(movies, movies$movieId==1197)
film2cluster9<-subset(movies, movies$movieId==616)

film1cluster10<-subset(movies, movies$movieId==318)
film2cluster10<-subset(movies, movies$movieId==1032)

film1cluster11<-subset(movies, movies$movieId==39)
film2cluster11<-subset(movies, movies$movieId==551)

film1cluster12<-subset(movies, movies$movieId==17)
film2cluster12<-subset(movies, movies$movieId==266)

film1cluster13<-subset(movies, movies$movieId==1225)
film2cluster13<-subset(movies, movies$movieId==2918)

film1cluster14<-subset(movies, movies$movieId==7153)
film2cluster14<-subset(movies, movies$movieId==527)

film1cluster15<-subset(movies, movies$movieId==34)
film2cluster15<-subset(movies, movies$movieId==2194)

###data frame of those films with rating=5 for user198 from all clusters
recommendations<-data.frame(film1cluster1$title,film2cluster1$title,
                            film1cluster2$title,film2cluster2$title,
                            film1cluster4$title,film2cluster4$title,
                            film1cluster6$title,film2cluster6$title,
                            film1cluster7$title,film2cluster7$title,
                            film1cluster8$title,film2cluster8$title,
                            film1cluster9$title,film2cluster9$title,
                            film1cluster10$title,film2cluster10$title,
                            film1cluster11$title,film2cluster11$title,
                            film1cluster12$title,film2cluster12$title,
                            film1cluster13$title,film2cluster13$title,
                            film1cluster14$title,film2cluster14$title,
                            film1cluster15$title,film2cluster15$title)

###recommendation for user198
print("You may also like the following movies:")
film1cluster1$title
film2cluster1$title
film1cluster2$title
film2cluster2$title
film1cluster4$title
film2cluster4$title
film1cluster6$title
film2cluster6$title
film1cluster7$title
film2cluster7$title
film1cluster8$title
film2cluster8$title
film1cluster9$title
film2cluster9$title
film1cluster10$title
film2cluster10$title
film1cluster11$title
film2cluster11$title
film1cluster12$title
film2cluster12$title
film1cluster13$title
film2cluster13$title
film1cluster14$title
film2cluster14$title
film1cluster15$title
film2cluster15$title



















PART II






getwd(); graphics.off() ; rm(list = ls(all = TRUE)) ; cat("\014");


library(amap)
library(MASS)
library(klaR)
library(plyr)


#Set our working directory
setwd("C:\\Users\\USER\\Desktop\\3hErgasia2020-2021\\thema 3o")

# Read csv file
europe<-read.csv("europe.csv", sep=",", header=T)

summary(europe)
head(europe)

# Attributes/Variables have different scales.
# we will be using Euclidean distance in the distance matrix, this may
# introduce bias. Hence, try to normalize each value of attribute to
# a scale from 0 to 1.We will use min-max normalization.
#Define the function norm that will normalize a value using the min-max.
norm <- function(x){ return( (x-min(x)) / (max(x)-min(x)) ) }


# Pass now each attribute of the dataset through the norm function
europe[,"GDP"] <-norm(europe$GDP)
europe[,"Inflation"] <-norm(europe$Inflation)
europe[,"Life.expect"] <-norm(europe$Life.expect)
europe[,"Military"] <-norm(europe$Military)
europe[,"Pop.growth"] <-norm(europe$Pop.growth)
europe[,"Unemployment"] <-norm(europe$Unemployment)

summary(europe)
head(europe)


# Now, calculate first the initial distance matrix for all data points,
# but remove attribute Name, which is the first attribute. 
# Use the R function dist() to calculate the entire distance matrix based on the Euclidean
# distance. 

distanceMatrix <- dist(europe[,3:8])


# Agglomerate hierarchical clustering using the hclust function
# The hclust() function executes hierarchical clustering.
# hclust() takes a shitload of arguments, but the important ones
# are two: 1) the distance matrix that we already computed above and 2) the distance measure for clusters
# First argument of hclust is the distance Matrix that has been calculated previously. 
# If no argument for the distance measure of clusters is given (parameter method), 
# the "Complete Linkage" measure is assumed (i.e. it's the default). Here we use the complete linkage by
# explicitly specifying it.

europeHClustering <-hclust(distanceMatrix, method="complete")

# Hierarchical clustering finished. Plot the dendrogram using the
# plot() function. Second parameter labels= tells R to display labels
# (in our case the Country) on the horizontal axis.
plot(europeHClustering, labels=europe$Country)


# You can also get more fancy and add rectangles identifying more clearly
# the clusters like the following.
#
# Argument 8 tells rect.hclust() how many clusters to wrap in rectangles (parameter k) or
# equivalently at which height of the dendrogram (parameter h) to indicate clusters.
# Parameter simply controls the border color 
# Here we draw lines around 4 clusters (k=4) with blue color (border=12)
rect.hclust(europeHClustering, k=4, border=12)









