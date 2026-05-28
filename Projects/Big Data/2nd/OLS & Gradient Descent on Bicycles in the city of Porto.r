Dataday<-read.csv("day.csv", sep=",", header=T)
Dataday<-na.omit(Dataday)
str(Dataday)
Dataday[,"dteday"] <- as.numeric(Dataday[,"dteday"])

#i) Estimation of the multiple linear regression model
#cnt= β1weathersit+β2temp+β3hum+β4windspeed+β0
# Transform the numeric variable weathersit  into factors
Dataday$weathersit=as.factor(Dataday$weathersit)

linear.regression.model <-  linear.regression.model<-lm(cnt ~ as.factor(weathersit)+temp+hum+windspeed, data=Dataday)
# Show results
summary(linear.regression.model)
#Show/print estimated coefficients only
print( linear.regression.model$coefficients )



#ii)Gradient Descent 

# calculateCost

calculateCost<-function(X, y, theta){
  
  m <- length(y)
  return( sum((X%*%theta- y)^2) / (2*m) )
} # calculateCost
# gradientDescent

gradientDescent<-function(X, y, theta, alpha=0.01, numIters=90){
  
  m <- length(y)
  
  
  costHistory <- rep(0, numIters)
  
  
  for(i in 1:numIters){
    
    
    
    
    theta <- theta - alpha*(1/m)*(t(X)%*%(X%*%theta - y))
    
    
    costHistory[i]  <- calculateCost(X, y, theta)
    
  } 
  
  
  
  gdResults<-list("coefficients"=theta, "costs"=costHistory)
  return(gdResults)
} # gradientDescent
Dataday<-read.csv("day.csv", sep=",", header=T)



# Number of observations
numObs<-nrow(Dataday)

# Dependent variable
dependentvariable<-Dataday$cnt

# Independent variables
indVariables<- cbind( rep(1, numObs), Dataday[, 9], Dataday[, 10],Dataday[,12],Dataday[,13])

# Learning rate α
alpha=0.001

# Number of iterations
numIterations=15000

initialThetas<-rep(runif(1),5) 
gdOutput<-gradientDescent(indVariables, dependentvariable, initialThetas,alpha,numIterations)

print(gdOutput$coefficients)

#plot
plot(gdOutput$costs, xlab="Iterations", ylab="J(θ)" )

