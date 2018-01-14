#### Setting the working directory into 'UCI HAR Dataset directory' #####
setwd("E:/Coursera/Getting and Cleaning data course project/UCI HAR Dataset")
list.files()
list.dirs()

#### Getting Activity labels and Features ####
activity_labels <- read.table("./activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("./features.txt")
features[,2] <- as.character(features[,2])

#### Extracting data on mean and standard deviation ####
wanted_features <- grep(".*mean.*|.*std.*", features[,2])
wanted_features.names <- features[wanted_features,2]
wanted_features.names = gsub('-mean', 'Mean', wanted_features.names)
wanted_features.names = gsub('-std', 'Std', wanted_features.names)
wanted_features.names <- gsub('[-()]', '', wanted_features.names)


#### Loading the datasets ####
traindata <- read.table("./train/X_train.txt")[wanted_features]
trainActivities <- read.table("./train/Y_train.txt")
trainSubjects <- read.table("./train/subject_train.txt")
traindata <- cbind(trainSubjects, trainActivities, traindata)

testdata <- read.table("./test/X_test.txt")[wanted_features]
testActivities <- read.table("./test/Y_test.txt")
testSubjects <- read.table("./test/subject_test.txt")
testdata <- cbind(testSubjects, testActivities, testdata)

#### merging datasets and adding labels ####
allData <- rbind(traindata, testdata)
colnames(allData) <- c("subject", "activity", wanted_features.names)

#### changing activities & subjects into factor variables ####
allData$activity <- factor(allData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
allData$subject <- as.factor(allData$subject)

library(reshape2)
allData.melt <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melt, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)