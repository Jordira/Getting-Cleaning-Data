##Set working directory (change appropriately if needed)

setwd("C:/Users/Jordi/Desktop/Getting_Cleaning_Data/Course_project/UCI HAR Dataset")

## 1)Merges the training and the test sets to create one data set.
## 2)Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3)Uses descriptive activity names to name the activities in the data set
## 4)Appropriately labels the data set with descriptive variable names. 



activitylabels<-read.table("activity_labels.txt",header=FALSE)

##Read subject tables for test&train datasets

testsubject<-read.table("test/subject_test.txt",header=FALSE)
trainsubject<-read.table("train/subject_train.txt",header=FALSE)

##Read activity levels to match levels&labels

activitytestlevels<-read.table("test/y_test.txt",header=FALSE)
activitytrainlevels<-read.table("train/y_train.txt",header=FALSE)

##Create a table with subjects&activities

testsubject<-cbind(testsubject,activitytestlevels)
trainsubject<-cbind(trainsubject,activitytrainlevels)

colnames(testsubject)<-c("subject","activity")
colnames(trainsubject)<-c("subject","activity")

##Change activity level numbers by labels in both tables

testsubject$activity <- factor(testsubject$activity,
                    levels = activitylabels[,1],
                    labels = activitylabels[,2])

trainsubject$activity <- factor(trainsubject$activity,
                         levels = activitylabels[,1],
                         labels = activitylabels[,2])

##testsubject$summarytype <- factor(testsubject$summarytype,
##                           levels = c(1,2),
##                           labels = c("mean","sd"))

##trainsubject$summarytype <- factor(trainsubject$summarytype,
##                            levels = c(1,2),
##                            labels = c("mean","sd"))


##Inspect resulting tables

head(testsubject)
head(trainsubject)

##Creating test&train lists of Inertial signals (each txt file represents one signal)

dirtest<-"test/Inertial Signals"

dirtrain<-"train/Inertial Signals"

testinertial<-dir(dirtest)

traininertial<-dir(dirtrain)

##Renaming tables to include mean&sd for each signal, both in test&train datasets

feature_mean_test<-cbind(testsubject,summary="mean")
feature_mean_train<-cbind(trainsubject,summary="mean")
feature_sd_test<-cbind(testsubject,summary="sd")
feature_sd_train<-cbind(trainsubject,summary="sd")

feature_mean_sd<-rbind(feature_mean_test,feature_mean_train,feature_sd_test,feature_sd_train)
head(feature_mean_sd)
tail(feature_mean_sd)
nrow(feature_mean_sd)

##Assuming same number of signals for test&train datasets (length(testinertial)), 
##Loop to add 1 column for each signal (mean or sd is indicated in column "summary")

for (i in 1:length(testinertial)){

##Read both test&train tables for each Inertial Signal [i] 
##and compute mean & standard deviation
  
table_test<-read.table(paste(dirtest,'/',testinertial[i],sep=""),header=FALSE)
table_train<-read.table(paste(dirtrain,'/',traininertial[i],sep=""),header=FALSE)                      
 
  
  feature_mean_i<-rbind(data.frame(v=rowMeans(table_test)),data.frame(v=rowMeans(table_train)))  
  feature_sd_i<-rbind(data.frame(v=apply(table_test, 1, sd)),data.frame(v=apply(table_train, 1, sd)))  
  feature_mean_sd_i<-rbind(feature_mean_i,feature_sd_i)



feature_mean_sd<-cbind(feature_mean_sd,feature_mean_sd_i)

##Colnames are given by the substring removing last 9 characters

colnames(feature_mean_sd)[i+3]<-substr(testinertial[i],1,nchar(testinertial[i])-9) 


}


##Testing for good results

head(feature_mean_sd)
tail(feature_mean_sd)
nrow(feature_mean_sd)
2*(nrow(table_test)+nrow(table_train))

## 5)Creates a second, independent tidy data set with the average of each variable
##   for each activity and each subject.

(tapply(feature_mean_sd[,4],feature_mean_sd[,1:3], mean))


library(reshape2)
moltentable<-(melt(feature_mean_sd, id=c("subject","activity","summary")))

##Finding unique combinations of subject, activity and summary joining the three columns as text

moltentable2<-cbind(moltentable,subactsum=paste(moltentable$subject,moltentable$activity,moltentable$summary, sep=","))

##Computing the mean of each variable (both mean&sd for each subject&activity)

moltentable3<-dcast(moltentable2,subactsum~variable,mean)

##Reconstructing the three columns of subject, activity & summary, and giving colnames again

moltentable4<-cbind(read.table(text = as.character(moltentable3$subactsum), sep = ","),moltentable3[,-1])
colnames(moltentable4)[1:3]<-c("subject","activity","summary")

##Saving the table with write.table() using row.names=FALSE

write.table(moltentable4,file="moltentable.txt",row.names=FALSE,col.names=TRUE)