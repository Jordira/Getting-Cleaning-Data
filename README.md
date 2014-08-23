Getting-Cleaning-Data
=====================

#Objectives of the course project on week 3 and available data to be used:

## 1)Merges the training and the test sets to create one data set.

 (These are present as 9 txt files -one for each inertial signal- inside each subdirectory named test\Inertial Signals & train\Inertial Signals)

## 2)Extracts only the measurements on the mean and standard deviation for each measurement. 

(There are 128 columns that represent one single measurement at regular intervals. These 128 values on each row have to be averaged and compute the sd)

## 3)Uses descriptive activity names to name the activities in the data set 

(The activity names are represented by numbers on tables "test/y_test.txt" &"train/y_train.txt", that matches the rows of the 18 tables above with the activities.To know which number represents each name of activity, "activity_labels.txt" table is used.

## 4)Appropriately labels the data set with descriptive variable names. 

(The 9 variable names can be extracted from the txt files names, removing the last 9 characters from test datasets. 

## 5)Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

(As each subject can have several measurements for each activity, these measurements (both mean & sd) have to be averaged to have results only for unique combinations of subject-activity-summary, where subject (1:30), activity(1:6), summary("mean", "sd"). Total 30*6*2=360 rows


#This is the process used in the run_analysis.R script (as commented inside it):


a) Read subject tables for test&train datasets

b) Read activity levels to match levels&labels

c) Create a table with subjects&activities

d) Change activity level numbers by labels in both tables

e) Inspect resulting tables

f) Creating test&train lists of Inertial signals (each txt file represents one signal)

g) Renaming tables to include mean&sd for each signal, both in test&train datasets

h) Assuming same number of signals for test&train datasets (length(testinertial)), Loop to add 1 column for each signal (mean or sd is indicated in column "summary")

i) Read both test&train tables for each Inertial Signal [i] and compute mean & standard deviation

j) Colnames are given by the substring removing last 9 characters

k) Testing for good results. Number of rows must match with the sum of test&train datasets

l) Finding unique combinations of subject, activity and summary joining the three columns as one text column (using cbind&paste), with comma separator

m) Computing the mean of each variable (both mean&sd for each subject&activity). Use of reshape2-dcast function to average variables for each combination

n) Reconstructing the three columns of subject, activity & summary, and giving colnames again. Use comma separator and read.table to split again in 3 columns.

o) Saving the table with write.table() using row.names=FALSE
