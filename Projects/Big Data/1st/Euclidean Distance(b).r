#Euclidean Distance
euclideanDistance<-function(x,y) sqrt(sum((x-y)^2))

#user1,user2,user3,user4

user1=c(25000,14,7)
user2=c(42000,17,9)
user3=c(55000,22,5)
user4=c(27000,13,11)
user5=c(58000,21,13)

#Duser1user3
Duser1user3<-euclideanDistance(user1,user3)
print(Duser1user3)

#Duser2user3
Duser2user3<-euclideanDistance(user2,user3)
print(Duser2user3)

#Duser4user3
Duser4user3<-euclideanDistance(user4,user3)
print(Duser4user3)

#Duser5user3
Duser5user3<-euclideanDistance(user5,user3)
print(Duser5user3)


