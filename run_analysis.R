library(plyr)
library(data.table)
path <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(path)

## 1. Merges the training and the test sets to create one data set.

x_train = read.table('./train/x_train.txt',header=FALSE)
y_train = read.table('./train/y_train.txt',header=FALSE)
x <- rbind(x_train, x_test) # <-- merge train and test datasets


x_test = read.table('./test/x_test.txt',header=FALSE)
y_test = read.table('./test/y_test.txt',header=FALSE)
y <- rbind(y_train, y_test) # <-- merge train and test datasets

subject_train = read.table('./train/subject_train.txt',header=FALSE)
subject_test = read.table('./test/subject_test.txt',header=FALSE)
subject <- rbind(subject_train, subject_test) # <-- merge train and test subject datasets

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

x_mstd <- x[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(x_mstd) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 

## 3. Uses descriptive activity names to name the activities in the data set

y[, 1] <- read.table("activity_labels.txt")[y[, 1], 2]
names(y) <- "Activity"

## 4. Appropriately labels the data set with descriptive variable names.

names(subject) <- "Subject"
DS1 <- cbind(x_mstd, y, subject)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

DS2<-aggregate(. ~Subject + Activity, DS1, mean)
DS2<-DS2[order(DS2$Subject,DS2$Activity),]
write.table(DS2, file = "Tidy_DS2.txt",row.name=FALSE)

