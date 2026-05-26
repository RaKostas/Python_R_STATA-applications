# read  data into a dataframe
data = read.csv('communities.csv')


head(data)
colnames(data)

#slice dataset so that contains  only those variables that are interested us
df = data[,c(18,27,28,32,33,38,77,91,97,128)]
#Rename  Columns accordingly
Column_Names = c("medIncome","whitePerCap","blackPerCap","HispPerCap",
                 "NumUnderPov","PctUnemployed","HousVacant","MedRent","NumStreet","ViolentCrimesPerPop")

colnames(df) = Column_Names

summary(df)
# Check for missing values
any(is.na(df))



#-----------------------------------------------------------------------------
#Mini Batch Gradient Descent
#-----------------------------------------------------------------------------

#Define the Cost Function:
calculateCost<-function(X, y, theta){

  m <- length(y)
  return( sum((X%*%theta- y)^2) / (2*m) )
}

#Define mini-Batch Gradient Descent function and batch_size

MinibatchGradientDescent<-function(x,y, theta, alpha=0.01, numIters=90,batch_size=5){
  m <- length(y)
  #Save the History of Cost Function here, to check validity of alpha,and if cost reduces with each epoch
  costHistory <- rep(0, numIters)
  #Start of iterations
  for(i in 1:numIters){ 
   # Choose random indexes
    indexes = sample(1:m, floor(m/batch_size), replace = FALSE)    x_b = x[indexes,]
    y_b =y[indexes]

    #Update Thetas
    theta <- theta - alpha*(1/m)*(t(x_b)%*%(x_b%*%theta - y_b))
    #Calculate Cost
    costHistory[i] = calculateCost(x,y,theta)
  }#end inner loop
  #Iterations are over,save the results with the coefficients (theta) and cost history of J (costHistory) 
  gdResults<-list("coefficients"=theta, "costs"=costHistory)
  return(gdResults) 
}



# shuffle  data
df = df[sample(nrow(df)),]
# Define matrix
x = cbind(rep(1,nrow(df)),df$medIncome,df$whitePerCap,df$blackPerCap,df$HispPerCap,df$NumUnderPov,df$PctUnemployed,df$HousVacant,df$MedRent,df$NumStreet)
y = df$ViolentCrimesPerPop
# Define thetas
thetas_ = runif(ncol(x))

#call Gradient Descent
gd = MinibatchGradientDescent(x,y,thetas_,alpha=0.9,numIters=200,batch_size=10)
coefs_mbgd = gd$coefficients
costs_mbgd = gd$costs
plot(costs_mbgd)
coeffs = data.frame(coefs_mbgd)

print(coeffs)
