#Set library
require(dplyr)

#Download Data & Unzip
fileUrl<-("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
download.file(fileUrl,destfile="activity.zip")
unzip("activity.zip")

#Load into R the trianing set and the testing set and the labels code
Y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
Y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
labels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")
subjects_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
subjects_train<-read.table("UCI HAR Dataset/train/subject_train.txt")

#1. Merge train and set tables
X_data<-rbind(X_train,X_test)
Y_data<-rbind(Y_train,Y_test)

#2. extract only measurements on the mean and st dev for each measurement
extract_indices<-c(grep("mean\\(\\)",features[,2]),grep("std\\(\\)",features[,2]))
extract_indices<-sort(extract_indices)
X_data<-X_data[,extract_indices]

#3. Use descriptive names to names the activities
Y_data[,1]<-factor(Y_data[,1],labels=labels[,2])

#4. Labels the variables with decriptive names
colnames(X_data)<-features[extract_indices,2]

#5. Creates a second data set with average of each variable for each activity and each subject
# Merge subjects, activities and measures
subjects<-rbind(subjects_train,subjects_test)
Data<-cbind(subjects,Y_data,X_data)
colnames(Data)<-c('subjects','activities',colnames(Data)[3:68])

#Get the average by activities and by subject
Data<-group_by(Data,subjects,activities)
Export<-summarize_each(Data,funs(mean))

#export to ASCII file
write.table(Export,file='tidy_data.txt',row.names=FALSE)




