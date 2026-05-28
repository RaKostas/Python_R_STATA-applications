library(dplyr)
library(readxl)
library(Benchmarking)
#Setup our environment. Where is our data
setwd("C:\\Users\\...)
data<-read_excel("DEA_Project.xlsx")
energy<-data[,4]
labor<-data[,5]
GFCF<-data[,6]
x<-cbind(energy,labor,GFCF)


gdp<-data[,3]
y<-as.matrix(gdp)
TEvrs<-dea(x,y,RTS="vrs",ORIENTATION = "in")
TEcrs<-dea(x,y,RTS="crs",ORIENTATION = "in")
VRS<-TEvrs$eff
VRS<-as.matrix(VRS) 
CRS<-TEcrs$eff
CRS<-as.matrix(CRS)
SE<-CRS/VRS
summary(TEvrs)
summary(TEcrs)
summary(SE)
countries<-data[,2]
countriesname<-data[,1]
TABLE1<-cbind(countriesname,countries,VRS,CRS,SE)
hist1 <- hist(SE, col="darksalmon", xlab="Scale Efficiency", main="Histogram")
peers(TEvrs)
peers(TEcrs)
