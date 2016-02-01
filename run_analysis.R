
##1. Merges the training and the test sets to create one data set.

#We first read all the data into tables
x_train<-read.table("X_train.txt")
x_test<-read.table("X_test.txt")
subject_test<-read.table("subject_test.txt")
subject_train<-read.table("subject_train.txt")
y_test<-read.table("y_test.txt")
y_train<-read.table("y_train.txt")

#We merge the labels and the data sets
test<-cbind(subject_test,y_test,x_test)
train<-cbind(subject_train,y_train,x_train)
alldataset<-rbind(test,train)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

#We read the information from the variable names from features.txt
features<-read.table("features.txt")

#Get only the variable names with mean() or std() in its name and subset these columns
MeanStd <- grep("-(mean|std)\\(\\)", features[, 2]) 
MeanStdDataSet <- alldataset[, MeanStd]
names(MeanStdDataSet)<-features[MeanStd,2] ##change column names


##3. Uses descriptive activity names to name the activities in the data set
#Activities are stored in the file activity_labels.txt
activity_labels<-read.table("activity_labels.txt")
MeanStdDataSet[,1]<-activity_labels[MeanStdDataSet[,1],2]

##4. Appropriately labels the data set with descriptive variable names.

# To be more descriptive, change t to Time, f to Frequency, mean() to Mean and std() to StandardDeviation
# Remove extra dashes and naming errors from original feature names
names(MeanStdDataSet) <- gsub("^t", "Time", names(MeanStdDataSet))
names(MeanStdDataSet) <- gsub("^f", "Frequency", names(MeanStdDataSet))
names(MeanStdDataSet) <- gsub("-mean\\(\\)", "Mean", names(MeanStdDataSet))
names(MeanStdDataSet) <- gsub("-std\\(\\)", "StandardDeviation", names(MeanStdDataSet))
names(MeanStdDataSet) <- gsub("-", "", names(MeanStdDataSet))
names(MeanStdDataSet) <- gsub("BodyBody", "Body", names(MeanStdDataSet))

# Add subjects with tidier names
subject_train <- read.table("subject_train.txt")
subject_test  <- read.table("subject_test.txt")
subjects <- rbind(subject_train, subject_test)[, 1]

TidyDataSet <- cbind(Subject = subjects,MeanStdDataSet)

## Write file
write.table(TidyDataSet, "TidyDataSet.txt", row.names = FALSE)
