setwd("C:\\Users\\user\\Desktop")
# Διασταυρωμένη Επικύρωση k-Πτυχών
# Επιστρέφει το Μέσο Τετραγωνικό Σφάλμα πρόβλεψης
calculateRMSE<-function(predictedValues, actualValues){
  err<- sqrt( mean((actualValues - predictedValues)^2)  )
  return( err )
}

# Η συνάρτηση επιστρέφει τον μέσο όρο του μέσου τετραγωνικού σφάλματος
kFoldCrossValidation<-function(data, frml, k){
  # Τυχαία αναφιάταξη των παρατηρήσεων του συνόλου δεδομένων
  dataset<-data[sample(nrow(data)),]
  #Δημιουργία k σε πλήθος τμημάτων του συνόλου δεδομένων με περίπου ίσο πλήθος 
  # παρατηρήσεων σε κάθε τμήμα.
  folds <- cut(seq(1,nrow(dataset)), breaks=k, labels=FALSE)
  # Διάνυσμα όπου αποθηκεύεται το Μέσο Τε
  RMSE<-vector()
  # Η διαδικασία θα τερματίσει εάν όλα τα τμήματα έχουν χρησιμοποιηθεί ως σύνολο σλέγχου.
  for(i in 1:k){
    # Καθορισμός του τμήματος ελέγχου για την τρέχουσα επανάληψη 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    # Καθορισμός συνόλου ελέγχου μοντέλου
    testData <- dataset[testIndexes, ]
    # Καθορισμός συνόλου εκπαίδευσης μοντέλου, που θα είναι όλα τα υπόλοιπα
    # πλην των δεδομένων που χρησιμοποιηθούν για έλεγχο
    trainData <- dataset[-testIndexes, ]
    # Εκτίμηση συντελεστών του μοντέλου παλινδρόμησης χρησιμοποιώντας το σύνολο εκπαίδευσης
    candidate.linear.model<-lm( frml, data = trainData)
    # Υπολογισμός των τιμών της εξαρτημένης μεταβλητής που προβλέπει το μοντέλο 
    # για τις τιμές του τρέχοντος συνόλου ελέγχου 
    predicted<-predict(candidate.linear.model, testData)
    # Υπολογισμός σφάλματος RMSE
    error<-calculateRMSE(predicted, testData[, "area"])
    # Αποθήκευση τιμής σφάλματος
    RMSE<-c(RMSE, error)
  }
  
  # Επιστροφή μέσης τιμής των σφαλμάτων που προέκυψαν απ'όλα τα τμήμα-τα ελέγχου
  return( mean(RMSE) )
}
#ii)
# Dataset με γεωγραφικά και μετεωρολογικά σοιχεια για πυρκαγιές που εκδηλώθηκαν στην Πορτογαλία
forestfires<-read.csv("forestfires.csv", sep=",", header=T,stringsAsFactors = F, quote = "\"")


# Έλεγχος για δεδομένα που λείπουν (missing values) και αφαίρεση ολόκληρης γραμμής
# σε περίπτωση που μια τουλάχιστον μεταβλητή έχει missing value
forestfires<-na.omit(forestfires)

# Τα  υποψήφια μοντέλα των οποίων θα αξιολογηθεί η ικανότητα πρόβλεψης της 
#επιφάνειας που θα καεί βάσει των μετεωρολογικών συνθηκών που επικρατούν με τη μέθοδο της 
#διασταυρωτικής επικύρωσης 10-φορές. 
#area=β1temp +β2wind+β3rain +βο
# Τα μοντέλα παλινδρόμησης αποθηκεύονται στο διάνυσμα ως συμβολοσειρά και θα μετατραπούν
# σε τύπο (formula) της R
predictionModels<-vector()
predictionModels[1]<-"area ~ temp+wind+rain"
forestfires2<-forestfires[which(forestfires$area<3.2),]
forestfires2<-na.omit(forestfires2)
predictionModels[2]<-"area ~ temp+wind+rain"
# Μετά από κάθε διασταυρωμένη επικύρωση, ο μέσος όρος του μέσου τετραγωνικού 
# σφάλματος κάθε μοντέλου θα αποθηκευτεί σε διάνυσμα.
modelMeanRMSE<-vector()
modelMeanRMSE2<-vector()
#Διασταυρωμένη επικύρωση 10-φορές για κάθε ένα από τα 
# δύο υποψήφια μοντέλα.
for (k in 1:length(predictionModels[1])){
  # Δισταυρωμένη επικύρωση 10-πτυχών για το γραμμικό μοντέλο παλινδρόμησης k
  modelErr<-kFoldCrossValidation(forestfires,as.formula(predictionModels[k]), 10)
  # Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE<-c(modelMeanRMSE, modelErr)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr ) )
}

for (k in 1:length(predictionModels[2])){
  # Δισταυρωμένη επικύρωση 10-πτυχών για το γραμμικό μοντέλο παλινδρόμησης k
  modelErr2<-kFoldCrossValidation(forestfires2, as.formula(predictionModels[k]), 10)
  #Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE2<-c(modelMeanRMSE2, modelErr2)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr2 ) )
}
#μέσο τετραγωνικό σφάλμα των δυο μοντέλων
all<-c(modelMeanRMSE,modelMeanRMSE2)
# Ποιο μοντέλο είχε το χαμηλότερο μέσο τετραγωνικό σφλάμα;
bestModelIndex<-which( modelMeanRMSE == min(modelMeanRMSE) )
# Εμφάνιση μοντέλου με το μικρότερο μέσο τετραγωνικό σφάμα δηλαδή τη μεγαλύτερη ακρίβεια
print( sprintf("Model with best accuracy was: [%s] error: [%f]", predictionModels[bestModelIndex], all[bestModelIndex]) )
# Tα μοντέλα παλινδρόμηνσης με το  μέσο τετραγωνικό σφάλμα χρησιμοποιώντας την μέθοδο OLS,όπου
#εκτιμώνται οι συντελεστές του λαμβάνοντας υπόψη ολόκληρο το σύνολο δεδομένων ως σύνολο εκπαίδευσης
final.linear.model<-lm( as.formula(predictionModels[bestModelIndex]), data=forestfires )
final.linear.model
final.linear.model<-lm( as.formula(predictionModels[bestModelIndex]), data=forestfires2 )
final.linear.model
