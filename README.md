---
title: "Description of run_analysis.R"
author: "Pablo Garcia-Alfageme"
date: "16/12/2014"
output: html_document
---

*Load the required packages


```r
library(dplyr)
library(tidyr)
```

*Load the training and the test datasets and merge them


```r
trainData=read.table("./UCI HAR Dataset/train/X_train.txt")
testData=read.table("./UCI HAR Dataset/test/X_test.txt")
data=rbind(trainData,testData)
```

*Load the features file and use it for the columnanes of the data. 


```r
features=read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)[,2]
colnames(data)=features
filteredFeatures=c(grep("mean()",colnames(data),fixed=TRUE),grep("std()",colnames(data),fixed=TRUE))
data=data[,filteredFeatures]
colnames(data)=gsub("mean\\()","Mean",colnames(data))
colnames(data)=gsub("std\\()","Std",colnames(data))
colnames(data)=gsub("-","",colnames(data))
```

*Filter the data, extracting just the measures of the mean and the standard deviation for each measurement.


```r
filteredFeatures=c(grep("mean()",colnames(data),fixed=TRUE),grep("std()",colnames(data),fixed=TRUE))
data=data[,filteredFeatures]
colnames(data)=gsub("mean\\()","Mean",colnames(data))
colnames(data)=gsub("std\\()","Std",colnames(data))
colnames(data)=gsub("-","",colnames(data))
```

*Tidy the column names, taking out () and -

```r
colnames(data)=gsub("mean\\()","Mean",colnames(data))
colnames(data)=gsub("std\\()","Std",colnames(data))
colnames(data)=gsub("-","",colnames(data))
```

*Load the training and the test activity files, merge them as a factor variable, with its description names as the levels and add it to the main data set as a variable called activity

```r
trainY=read.table("./UCI HAR Dataset/train/y_train.txt")[,1]
testY=read.table("./UCI HAR Dataset/test/y_test.txt")[,1]
Y=as.factor(c(trainY,testY))
activityLevels=read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)[,2]
levels(Y)=activityLevels
data$activity=Y
```

*Load the training and the test subject files, merge them as a factor variable and add it to the main data set as a variable called subject**

```r
trainSubject=read.table("./UCI HAR Dataset/train/subject_train.txt")[,1]
testSubject=read.table("./UCI HAR Dataset/test/subject_test.txt")[,1]
subject=as.factor(c(trainSubject,testSubject))
data$subject=subject
```

*Create an independent dataset gathering all the measurements in one variable called measure and its values in a variable called value, group this dataset by measure, activity, and subject and summarize it with the average of each variable for each activity and each subject.


```r
data2=data%>%
  gather(measure,value,-c(activity,subject))%>%
  group_by(measure,activity,subject)%>%
  summarize(avg=mean(value))

write.table(data2,file="tidydata.txt",row.names=FALSE)
```
