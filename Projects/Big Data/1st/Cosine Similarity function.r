library(SnowballC)
library(lsa)

#theta= the angle of vectors x,y
#x*y= ||x||*||y||*cos(theta)

#Cosine Similarity
cosinesimilarity<-function(x,y) cosine(x,y)

#CosSimA
x<-c(9.32,-8.3,0.2)
y<-c(-5.3, 8.2, 7)
CosSimA<-cosinesimilarity(x,y)
print(CosSimA)

#CosSimB
x<-c(6.5, 1.3, 0.3, 16, 2.4, -5.2, 2, -6, -6.3)
y<-c(0.5, -1, -7.3, -7, -9.4, 8.2, -9, 6, 6.3)
CosSimB<-cosinesimilarity(x,y)
print(CosSimB)

#CosSimC
x<-c(-0.5, 1, 7.3, 7, 9.4, -8.2)
y<-c(1.25, 9.02, -7.3, -7, 15, 12.3)
CosSimC<-cosinesimilarity(x,y)
print(CosSimC)

#CosSimD
x<-c(2, 8, 5.2)
y<-c(2, 8, 5.2)
CosSimD<-cosinesimilarity(x,y)
print(CosSimD)

