setwd("C:\\Users\\user\\Desktop")

## Διασταυρωμένη Επικύρωση k-Πτυχών
# Συνάρτηση που υπολογίζει και επιστρέφει το Μέσο Τετραγωνικό Σφάλμα (Root Mean Squared Error 
# - RMSE) 
# predictedValues: διάνυσμα με τιμές της εξαρτημένης μεταβλητής που προβλέπει το μοντέλο 
#                  παλινδρόμησης
# actualValues: διάνυσμα με τις πραγματικές τιμές της εξαρτημένης με-ταβλητής
# Επιστρέφει το Μέσο Τετραγωνικό Σφάλμα πρόβλεψης
calculateRMSE<-function(predictedValues, actualValues){
  err<- sqrt( mean((actualValues - predictedValues)^2)  )
  return( err )
}


# Συνάρτηση που υλοποιεί τον αλγόριθμο της διασταρωμένης επικύρωσης k-πτυχών.
# Η συνάρτηση κάνει χρήση του μέσου τετραγωνικού σφάλματος (RMSE) ως μετρική σφάλματος.
# Παράμετροι συνάρτησης:
# data: το σύνολο δεδομένων που θα χωριστεί σε τμήματα ελέγχουν κα εκπαίδευσης
# frml: το γραμμικό μοντέλο παλινδρόμησης που θα αξιολογηθεί η ακρί-βεια πρόβλεψής του
# k: η τιμή k της διασταυρωμένης επικύρωσης k-πτυχών που δηλώνει σε πόσα τμήματα θα διαχωριστεί
#    το αρχικό σύνολο δεδομένων
# Επιστρεφόμενη τιμή:
# Η συνάρτηση επιστρέφει τον μέσο όρο του μέσου τετραγωνικού σφάλματος
kFoldCrossValidation<-function(data, frml, k){
  # Τυχαία αναφιάταξη των παρατηρήσεων του συνόλου δεδομένων
  dataset<-data[sample(nrow(data)),]
  #Δημιουργία k σε πλήθος τμημάτων του συνόλου δεδομένων με περίπου ίσο πλήθος 
  # παρατηρήσεων σε κάθε τμήμα.
  folds <- cut(seq(1,nrow(dataset)), breaks=k, labels=FALSE)
  # Διάνυσμα όπου αποθηκεύεται το Μέσο Τε
  RMSE<-vector()
  # Επαναλαηπτική διαδικασία όπου κάθε ένα από τα k τμήματα θα χρησι-μοποιηθεί διαδοχικά
  # ως σύνολο ελέγχου για το μοντέλο παλινδρόμησης και όλα τα υπόλοιπα ως σύνολο εκπαίδευσης. 
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

#i)
# Dataset με γεωγραφικά και μετεωρολογικά σοιχεια για πυρκαγιές που εκδηλώθηκαν στην Πορτογαλία
forestfires<-read.csv("forestfires.csv", sep=",", header=T,stringsAsFactors = F, quote = "\"")


# Έλεγχος για δεδομένα που λείπουν (missing values) και αφαίρεση ολόκληρης γραμμής
# σε περίπτωση που μια τουλάχιστον μεταβλητή έχει missing value
forestfires<-na.omit(forestfires)


# Το  υποψήφιο μοντέλο των οποίων θα αξιολογηθεί η ικανότητα πρόβλεψης της 
#επιφάνειας που θα καεί βάσει των μετεωρολογικών συνθηκών που επικρατούν με τη μέθοδο της 
#διασταυρωτικής επικύρωσης 10-φορές. 
#area=β1temp +β2wind+β3rain +βο
# Το μοντέλο παλινδρόμησης αποθηκεύεται στο διάνυσμα ως συμβολοσειρά και θα μετατραπεί
# σε τύπο (formula) της R
predictionModels<-vector()
predictionModels[1]<-"area ~ temp+wind+rain"
modelMeanRMSE<-vector()
for (k in 1:length(predictionModels[1])){
  # Δισταυρωμένη επικύρωση 10-πτυχών για το γραμμικό μοντέλο παλινδρόμησης k
  modelErr<-kFoldCrossValidation(forestfires,as.formula(predictionModels[k]), 10)
  # Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE<-c(modelMeanRMSE, modelErr)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr ) )
}


# To μοντέλο παλινδρόμηνσης με το μέσο τετραγωνικό σφάλμα χρησιμοποιώντας την μέθοδο OLS,όπου
#εκτιμώνται οι συντελεστές του λαμβάνοντας υπόψη ολόκληρο το σύνολο δεδομένων ως σύνολο εκπαίδευσης
linear.model<-lm( as.formula(predictionModels[k]), data=forestfires )
linear.model

#ii)
#Τιμή της μεταβλητής area μικρότερη από 3.2 εκτάρια
forestfires2<-forestfires[which(forestfires$area<3.2),]
forestfires2<-na.omit(forestfires2)
predictionModels[2]<-"area ~ temp+wind+rain"
modelMeanRMSE2<-vector()
for (k in 1:length(predictionModels[2])){
  # Δισταυρωμένη επικύρωση 10-πτυχών για το γραμμικό μοντέλο παλιν-δρόμησης k
  modelErr2<-kFoldCrossValidation(forestfires2, as.formula(predictionModels[k]), 10)
  #Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE2<-c(modelMeanRMSE2, modelErr2)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr2 ) )
}
#To δεύτερο μοντέλο παλινδρόμηνσης με το μέσο τετραγωνικό σφάλμα χρησιμοποιώντας την μέθοδο OLS,όπου
#εκτιμώνται οι συντελεστές του λαμβάνοντας υπόψη ολόκληρο το σύνολο δεδομένων ως σύνολο εκπαίδευσης
linear.model2<-lm( as.formula(predictionModels[k]), data=forestfires2 )
linear.model2
