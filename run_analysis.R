#### Getting and Cleaning course week4- project assignment
#### Deepak Singh
####

#### Set working directory
getwd()
setwd("./Coursera- Data Science Specilization/Getting and Cleaning Data/")


#### include required library
library(dplyr)
library(reshape2)


### download data from the website and unzip it
f_name <- "getdata_dataset.zip"

if (!file.exists(f_name)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileUrl, f_name, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(f_name) 
}


### Load activity labels and  features into data frame variables
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")


### Extract variables with names mean and standard deviation
featuresRequired <- grep("-mean|-std", features$V2)
featuresRequiredNames <- gsub("-|\\(|\\)", "", gsub("-std", "-Std", gsub("-mean", "-Mean", grep("-mean|-std", features$V2, value = TRUE))))


### Extract training datasets  
training <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresRequired]
trainingDT <- tbl_df(training)
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, trainingDT)


### Extract test datasets  

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresRequired]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

### Now merge two datasets viz. training dataframe and test dataframe 
all_Data <- rbind(train, test)
colnames(all_Data) <- c("subject", "activity", featuresRequiredNames)

### turn activities & subjects into factors
all_Data$activity <- factor(all_Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
all_Data$subject <- as.factor(all_Data$subject)

### USing library reshape2 to leverage melt and dacast
all_Data.melted <- melt(all_Data, id = c("subject", "activity"))
all_Data.mean <- dcast(all_Data.melted, subject + activity ~ variable, mean)

### write output data in tidy.txt file
write.table(all_Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)


### All done...
