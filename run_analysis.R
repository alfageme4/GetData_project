library(dplyr)
library(data.table)
library(tidyr)
trainData=read.table("./UCI HAR Dataset/train/X_train.txt")
testData=read.table("./UCI HAR Dataset/test/X_test.txt")
data=rbind(trainData,testData)
features=read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)[,2]
setnames(data,features)
filteredFeatures=c(grep("mean()",colnames(data),fixed=TRUE),grep("std()",colnames(data),fixed=TRUE))
data=data[,filteredFeatures]
colnames(data)=gsub("mean\\()","Mean",colnames(data))
colnames(data)=gsub("std\\()","Std",colnames(data))
colnames(data)=gsub("-","",colnames(data))

trainY=read.table("./UCI HAR Dataset/train/y_train.txt")[,1]
testY=read.table("./UCI HAR Dataset/test/y_test.txt")[,1]
Y=as.factor(c(trainY,testY))
activityLevels=read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)[,2]
levels(Y)=activityLevels
data$activity=Y

trainSubject=read.table("./UCI HAR Dataset/train/subject_train.txt")[,1]
testSubject=read.table("./UCI HAR Dataset/test/subject_test.txt")[,1]
subject=as.factor(c(trainSubject,testSubject))
data$subject=subject

data2=data%>%
  gather(measure,value,-c(activity,subject))%>%
  group_by(measure,activity,subject)%>%
  summarize(avg=mean(value))

write.table(data2,file="tidydata.txt",row.names=FALSE)
 
