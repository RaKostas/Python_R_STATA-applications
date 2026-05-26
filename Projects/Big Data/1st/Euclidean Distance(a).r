#euclideanDistance
euclideanDistance<-function(x,y) sqrt(sum((x-y)^2))

#euclideanDistance(d1,d2,d3,d4)

#D1
d1<-euclideanDistance(c(1:6),c(1:6))
print(d1)

#D2
d2<-euclideanDistance(c(-0.5, 1, 7.3, 7, 9.4, -8.2, 9, -6, -6.3),c(0.5, -1, -7.3, -7, -9.4, 8.2, -9, 6, 6.3))
print(d2)

#D3
d3<-euclideanDistance(c(-0.5, 1, 7.3, 7, 9.4, -8.2),c(1.25, 9.02, -7.3, -7, 5, 1.3))
print(d3)

#D4
d4<-euclideanDistance(c(0, 0, 0.2),c(0.2, 0.2, 0))
print(d4)
