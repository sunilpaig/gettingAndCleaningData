#Dwonload the file if it does not exist
if(!file.exists("dataset.zip")){
  fileSource <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileSource,"dataset.zip")
}

#Unzip the file, if the file exists then overwrite
unzip("dataset.zip",overwrite = "TRUE")

#Read the activity lables and features
activity_labels<- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2]<-as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#Read the train datasets and name the columns
trainDataX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainDataY <- read.table("UCI HAR Dataset/train/y_train.txt")
subjectTrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(trainDataX)<-features[,2]
colnames(trainDataY)<-"activityType"
colnames(subjectTrain)<-"subjectID"

# Read the test datasets and name the columns
testDataX <- read.table("UCI HAR Dataset/test/X_test.txt")
testDataY <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(testDataX)<-features[,2]
colnames(testDataY)<-"activityType"
colnames(subjectTest)<-"subjectID"

#Merging the dataset
trainDataFinal<-cbind(trainDataX,trainDataY,subjectTrain)
testDataFinal<-cbind(testDataX,testDataY,subjectTest)
dataFinal<-rbind(trainDataFinal,testDataFinal)

#Selecting only the needed variables
featuresMeanStd<-grep(".*mean.*|.*std.*|activityType|subjectID", features[,2])
featuresMeanStd.names <- features[featuresMeanStd,2]
featuresMeanStd.names = gsub('-mean', 'Mean', featuresMeanStd.names)
featuresMeanStd.names = gsub('-std', 'Std', featuresMeanStd.names)
featuresMeanStd.names <- gsub('[-()]', '', featuresMeanStd.names)

#Final dataset with only the needed variables
dataFinal<-dataFinal[featuresMeanStd.names]

#Create a dataset from final dataset without the activity type
finalDataWOActivityType  <- dataFinal[,names(dataFinal) != 'activityType']

# Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData    <-aggregate(finalDataWOActivityType[,names(finalDataWOActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataWOActivityType$activityId,subjectId = finalDataWOActivityType$subjectId),mean)

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData    <-merge(tidyData,activityType,by='activityId',all.x=TRUE)

# Export the tidyData SET
write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t')





