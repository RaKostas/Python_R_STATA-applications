library(readxl)
library(lpSolveAPI)
library(ucminf)
library(Benchmarking)
library(productivity)
library (frontier)
library(sfa)
library(plm)
library(pastecs)
library(ggpubr)
library(lmtest)

industries <- read_excel("C:\\Users\\...\\industries.xls")

View(industries)

options(scipen = 999) # avoid scientific notation in R

stat.desc(industries) 


# TE under CRS with loop for each year 

datacrs<-data.frame()
datavrs<-data.frame()
datc<-data.frame()

for(i in 2005:2011){
  industriesdata<-industries[which(industries$Year== i),]
  x<-cbind(industriesdata$Capital,industriesdata$Labor, industriesdata$`Intermediate Inputs`,
           industriesdata$`Energy Consumption`)
  y<-industriesdata$GVA
  
  w<-dea(x,y, RTS="crs", ORIENTATION="in")
  datc<-data.frame(industriesdata$Country, industriesdata$Industry, i, w$eff)
  datacrs<-rbind(datacrs,datc)
}

# TE under VRS with loop for each year 

for(i in 2005:2011){
  industriesdata<-industries[which(industries$Year== i),]
  x<-cbind(industriesdata$Capital,industriesdata$Labor, industriesdata$`Intermediate Inputs`,
           industriesdata$`Energy Consumption`)
  y<-industriesdata$GVA
  
  w<-dea(x,y, RTS="vrs", ORIENTATION="in")
  datc<-data.frame(industriesdata$Country, industriesdata$Industry, i, w$eff)
  datavrs<-rbind(datavrs,datc)
}

effic<-merge(datacrs, datavrs, by=c("industriesdata.Country","industriesdata.Industry",
                                    "i") )
effic$SE<- effic$w.eff.x/effic$w.eff.y # scale efficiency

colnames(effic) <- c("Country", "Industry", "Year", "TE_CRS", "TE_VRS","Scaleff") # final dataframe        

View(effic)
summary(effic)

#SUM France
summary(effic[which(effic[,1]=='France' & effic[,2]=='Basic Metals'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Chemicals'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Coke'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Electrical Equipment'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Food'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Leather'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Machinery'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Manufacturing'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Other'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Pulp'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Rubber'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Textiles'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Transport'),])
summary(effic[which(effic[,1]=='France' & effic[,2]=='Wood'),])

#SUM Germany



summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Basic Metals'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Chemicals'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Coke'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Electrical Equipment'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Food'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Leather'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Machinery'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Manufacturing'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Other'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Pulp'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Rubber'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Textiles'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Transport'),])
summary(effic[which(effic[,1]=='Germany' & effic[,2]=='Wood'),])



#SUM Spain




summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Basic Metals'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Chemicals'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Coke'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Electrical Equipment'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Food'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Leather'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Machinery'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Manufacturing'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Other'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Pulp'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Rubber'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Textiles'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Transport'),])
summary(effic[which(effic[,1]=='Spain' & effic[,2]=='Wood'),])








# density plots 

d <- density(effic$TE_CRS) 
plot(d, xlim=c(0,1), xlab = "", lwd=2, col="lightpink4", main = "CRS") 

d <- density(effic$TE_VRS) 
plot(d, xlim=c(0,1), xlab = "", lwd=2, col="lightpink4", main = "VRS") 


d <- density(effic$Scaleff) 
plot(d, xlim=c(0,1), xlab = "", lwd=2, col="lightpink4", main = "Scale-Efficiency") 




rm(list=ls())
cat("\014") 


#####################################################################################
industries <- read_excel("C:\\Users\\...\\industries.xls")


# malmquist productivity France


data1 <- industries[which(industries$Country == "France" & industries$Year  >= 2000 & industries$Year <= 2010 & industries$Year <= 2010 & industries$Year != 2001 & industries$Year != 2002 & industries$Year != 2003 & industries$Year != 2004 & industries$Year != 2005 & industries$Year != 2006 & industries$Year != 2007 & industries$Year != 2008 & industries$Year != 2009),]

data1 <- data.frame( data1, c( "Industry", "Year" ))


pr1<-malm(data=data1, id.var = "Industry", time.var = "Year", 
          x.vars=c("Capital", "Labor" ,"Intermediate.Inputs", "Energy.Consumption"), 
          y.vars=c("GVA"), 
          orientation =  "in",tech.reg = TRUE, rts ="vrs")

malmFrance<- data.frame(pr1$Changes$Industry, pr1$Changes$Year.0, pr1$Changes$Year.1, pr1$Changes$malmquist,
                        pr1$Changes$effch, pr1$Changes$tech)

summary(malmFrance$pr1.Changes.malmquist)
summary(malmFrance$pr1.Changes.effch)
summary(malmFrance$pr1.Changes.tech)
summary(malmFrance$pr1.Changes.inp.scalech)

par(mfrow=c(2,2))
hist(malmFrance$pr1.Changes.malmquist, xlab = "", main = "Malmquist index France", col = "lightpink4")
hist(malmFrance$pr1.Changes.effch, xlab = "", main = "Efficiency change",col = "lightpink4")
hist(malmFrance$pr1.Changes.tech, xlab = "", main = "Technical change",col = "lightpink4")


# malmquist productivity Germany

data2 <- industries[which(industries$Country == "Germany" & industries$Year  >= 2000 & industries$Year <= 2010 & industries$Year <= 2010 & industries$Year != 2001 & industries$Year != 2002 & industries$Year != 2003 & industries$Year != 2004 & industries$Year != 2005 & industries$Year != 2006 & industries$Year != 2007 & industries$Year != 2008 & industries$Year != 2009),]

data2 <- data.frame( data2, c( "Industry", "Year" ))


pr2<-malm(data=data2, id.var = "Industry", time.var = "Year", 
          x.vars=c("Capital", "Labor" ,"Intermediate.Inputs", "Energy.Consumption"), 
          y.vars=c("GVA"), 
          orientation =  "in",tech.reg = TRUE, rts ="vrs")

malmGermany<- data.frame(pr2$Changes$Industry, pr2$Changes$Year.0, pr2$Changes$Year.1, pr2$Changes$malmquist,
                         pr2$Changes$effch, pr2$Changes$tech)


summary(malmGermany$pr2.Changes.malmquist)
summary(malmGermany$pr2.Changes.effch)
summary(malmGermany$pr2.Changes.tech)
summary(malmGermany$pr2.Changes.inp.scalech)

par(mfrow=c(2,2))
hist(malmGermany$pr2.Changes.malmquist, xlab = "", main = "Malmquist index Germany", col = "lightpink4")
hist(malmGermany$pr2.Changes.effch, xlab = "", main = "Efficiency change",col = "lightpink4")
hist(malmGermany$pr2.Changes.tech, xlab = "", main = "Technical change",col = "lightpink4")


# malmquist productivity Spain

data3 <- industries[which(industries$Country == "Spain" & industries$Year  >= 2000 & industries$Year <= 2010 & industries$Year <= 2010 & industries$Year != 2001 & industries$Year != 2002 & industries$Year != 2003 & industries$Year != 2004 & industries$Year != 2005 & industries$Year != 2006 & industries$Year != 2007 & industries$Year != 2008 & industries$Year != 2009),]

data3 <- data.frame( data3, c( "Industry", "Year" ))


pr3<-malm(data=data3, id.var = "Industry", time.var = "Year", 
          x.vars=c("Capital", "Labor" ,"Intermediate.Inputs", "Energy.Consumption"), 
          y.vars=c("GVA"), 
          orientation =  "in",tech.reg = TRUE, rts ="vrs")

malmSpain<- data.frame(pr3$Changes$Industry, pr3$Changes$Year.0, pr3$Changes$Year.1, pr3$Changes$malmquist,
                       pr3$Changes$effch, pr3$Changes$tech)


summary(malmSpain$pr3.Changes.malmquist)
summary(malmSpain$pr3.Changes.effch)
summary(malmSpain$pr3.Changes.tech)
summary(malmSpain$pr3.Changes.inp.scalech)

par(mfrow=c(2,2))
hist(malmSpain$pr3.Changes.malmquist, xlab = "", main = "Malmquist index Spain", col = "lightpink4")
hist(malmSpain$pr3.Changes.effch, xlab = "", main = "Efficiency change",col = "lightpink4")
hist(malmSpain$pr3.Changes.tech, xlab = "", main = "Technical change",col = "lightpink4")


rm(list=ls())
cat("\014") 


######################################################################################## 

options(scipen = 999) # avoid scientific notation in R

industries <- read_excel("C:\\Users\\......\\industries.xls")

# with time-invariant efficiencies -> industry effects

# SFA -> France


data1<-industries[which(industries$Country == "France"),]

data1 <- pdata.frame( data1, c( "Industry", "Year" ) )

cobbFR <- sfa( log(GVA) ~ log(Capital) + log(Labor) +
                 log(`Intermediate Inputs`) +
                 log(`Energy Consumption`), data = data1)


summary(cobbFR, extraPar = TRUE)


tranlogFR <- sfa(log(GVA)~ log(Capital)+log(Labor)+log(`Intermediate Inputs`)+log(`Energy Consumption`)+
                   +I(0.5*log(Capital)^2)+I(0.5*log(Labor)^2)+I(0.5*log(`Intermediate Inputs`)^2)+I(0.5*log(`Energy Consumption`)^2)+
                   I(log(Capital)*log(Labor))+I(log(Capital)*log(`Intermediate Inputs`))+
                   I(log(Capital)*log(`Energy Consumption`))+
                   I(log(Labor)*log(`Intermediate Inputs`))+I(log(Labor)*log(`Energy Consumption`))+
                   +I(log(`Intermediate Inputs`)*log(`Energy Consumption`)),  data=data1)

summary(tranlogFR,extraPar = TRUE)


logLik(cobbFR)
logLik(tranlogFR) # translog model is better

data1$efficiencies <- eff( tranlogFR, asInData = TRUE) #  extract the efficiencies

d<-density(data1$efficiencies)

plot(d, main="Efficiencies of of industries in France", xlab = "", lwd=2, cex.main=1, 
     col="lightpink4")



#SUM France
summary(data1[which(data1[,2]=='France' & data1[,1]=='Basic Metals'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Chemicals'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Coke'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Electrical Equipment'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Food'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Leather'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Machinery'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Manufacturing'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Other'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Pulp'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Rubber'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Textiles'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Transport'),])
summary(data1[which(data1[,2]=='France' & data1[,1]=='Wood'),])





# SFA -> Germany 

data2<-industries[which(industries$Country == "Germany"),]

data2 <- pdata.frame( data2, c( "Industry", "Year" ) )

cobbGE <- sfa( log(GVA) ~ log(Capital) + log(Labor) +
                 log(`Intermediate Inputs`) +
                 log(`Energy Consumption`), data = data2)


summary(cobbGE,extraPar = TRUE)


tranlogGE <- sfa(log(GVA)~ log(Capital)+log(Labor)+log(`Intermediate Inputs`)+log(`Energy Consumption`)+
                   +I(0.5*log(Capital)^2)+I(0.5*log(Labor)^2)+I(0.5*log(`Intermediate Inputs`)^2)+I(0.5*log(`Energy Consumption`)^2)+
                   I(log(Capital)*log(Labor))+I(log(Capital)*log(`Intermediate Inputs`))+
                   I(log(Capital)*log(`Energy Consumption`))+
                   I(log(Labor)*log(`Intermediate Inputs`))+I(log(Labor)*log(`Energy Consumption`))+
                   +I(log(`Intermediate Inputs`)*log(`Energy Consumption`)),  data=data2, method = "CG")

summary(tranlogGE,extraPar = TRUE)

logLik(cobbGE)
logLik(tranlogGE) # translog model is better


data2$efficiencies <- eff( tranlogGE, asInData = TRUE) #  extract the efficiencies


d<-density(data2$efficiencies)

plot(d, main="Efficiencies of industries in Germany", xlab = "", lwd=2, cex.main=1, 
     col="lightpink4")





#SUM Germany



summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Basic Metals'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Chemicals'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Coke'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Electrical Equipment'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Food'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Leather'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Machinery'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Manufacturing'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Other'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Pulp'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Rubber'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Textiles'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Transport'),])
summary(data2[which(data2[,2]=='Germany' & data2[,1]=='Wood'),])





