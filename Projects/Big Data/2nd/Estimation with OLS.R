
communitiesdata<-read.csv("communities.csv ", sep=",", header=F)



#create data frame for the estimated variables 
ViolentCrimesPerPop<-communitiesdata[,128]
medIncome<-communitiesdata[,18]
whitePerCap<-communitiesdata[,27]
blackPerCap<-communitiesdata[,28]
HispPerCap<-communitiesdata[,32]
NumUnderPov<-communitiesdata[,33]
PctUnemployed<-communitiesdata[,38]
HoursVacant<-communitiesdata[,77]
MedRent<-communitiesdata[,91]
NumStreet<-communitiesdata[,96]
Table1<-cbind(ViolentCrimesPerPop,medIncome,whitePerCap,blackPerCap,HispPerCap,NumUnderPov,PctUnemployed,HoursVacant,MedRent,NumStreet)
Table1<-as.data.frame(Table1)
#check for missing values
any(is.na(Table1))



# Estimation of the multiple linear regression model
#ViolentCrimesPerPop=β1medIncome+β2whitePerCap+β3blackPerCap+β4HispPerCap+β5NumUnderPov+β6PctUnemployed+β7HoursVacant+β8MedRent+β9NumStreet+β0
linear.regression.model <-  linear.regression.model<-lm(ViolentCrimesPerPop ~ medIncome+whitePerCap+blackPerCap+HispPerCap+NumUnderPov+PctUnemployed+HoursVacant+MedRent+NumStreet, data=Table1)
#Show/print estimated coefficients only
print( linear.regression.model$coefficients )
# Show results
summary(linear.regression.model)

