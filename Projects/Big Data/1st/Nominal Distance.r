# Nominal Distance function

nominalDistance<-function(x,y){
  i=0
  w=0
  z=0
  for (d in x){
    i=i+1
    if (d==y[i]) {
      w=0
    } else {
      w=1 
    }
    z=z+w
  }
  return(z)}

# Nominal Distance A
x<-c("Green","Potato","Ford")
y<-c("Tyrian purple","Pasta","Opel")
nominalDistanceA=nominalDistance(x,y)
print(nominalDistanceA)

# Nominal Distance B
x<-c("Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay")
y<-c("Eagle", "Ronaldo", "Real madrid", "Prussian blue", "Michael Bay")
nominalDistanceB=nominalDistance(x,y)
print(nominalDistanceB)

# Nominal Distance C
x<-c("Werner Herzog", "Aquirre, the wrath of God", "Audi", "Spanish red")
y<-c("Martin Scorsese", "Taxi driver", "Toyota", "Spanish red")
nominalDistanceC=nominalDistance(x,y)
print(nominalDistanceC)

