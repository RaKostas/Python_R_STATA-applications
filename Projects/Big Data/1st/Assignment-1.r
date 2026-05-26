library(MASS)

#View the first six rows
head(Cars93)

#Descriptive Statistics
summary(Cars93)
Data<-Cars93
pcaData<-Cars93
head(pcaData)
pcaData<-Cars93[-c(57),c(4:8,11:15,17:25)]
pcaData$Cylinders<-as.numeric(pcaData$Cylinders)

#View the new data "pcaData"
#View(pcaData)

# Do variables have any (at least 1) missing (na) value? 
if (any(is.na(pcaData[,"Min.Price"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Price"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")


if (any(is.na(pcaData[,"Max.Price"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"MPG.city"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"MPG.highway"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"EngineSize"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Horsepower"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"RPM"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Rev.per.mile"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Fuel.tank.capacity"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Passengers"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Length"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Wheelbase"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Width"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Turn.circle"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")
if (any(is.na(pcaData[,"Rear.seat.room"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Luggage.room"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Weight"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

if (any(is.na(pcaData[,"Cylinders"]))) {
  sprintf("has NA values")
} else
  sprintf("It's ok! ")

#Replace NA values with the means of the variables
pcaData$Rear.seat.room[which(is.na(pcaData$Rear.seat.room))]<-27.83
pcaData$Luggage.room[which(is.na(pcaData$Luggage.room))]<-13.89

#PCA run
principalComponents<-princomp(pcaData, cor=FALSE, score=TRUE)

#eigenvectors
eigenvectors<-principalComponents$loadings
print(eigenvectors)

#eigenvalues
eigenvalues<-principalComponents$sdev^2
print(eigenvalues)

#covariance matrix

cov(pcaData)



summary(principalComponents)
plot(principalComponents)

eigenvalues[1]/sum(eigenvalues)
sum(eigenvalues[1:2])/sum(eigenvalues)
