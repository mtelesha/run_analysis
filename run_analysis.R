# Getting and Cleaning Data Course Project
# run_analysis.R
### learned
# setwd is BAD PRACTICE 
# I will never use setwd() in any of my scripts ever again BUT will use RStudio or
# projecttemplate library from now on
# Will use relative paths sourced to this scripts location


# Libraries
library(DataCombine) # for FindReplace of Activities
library(reshape2) # to melt and cat to make tidy data
library(stringr) 

# data set obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# download the file
# set the url for the zip file for the project if not present
# Should only have to download and unzip once
if(!file.exists("./data/harusds.zip")) url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download the file as harusds.zip in data folder
if(!file.exists("./data/harusds.zip")) download.file(url, destfile = "./data/harusds.zip")
# unzip the harusds.zip file
if(!file.exists("./data/README.txt")) unzip("./data/harusds.zip")

# -----------------------------------------------
# 1 - Merge the training and testing data set
# load the test and train files 

x_test  <- read.table("./data/test/X_test.txt", header = FALSE,
                      strip.white = TRUE, stringsAsFactors = FALSE)
x_train <- read.table("./data/train/X_train.txt", header = FALSE,
                      strip.white = TRUE, stringsAsFactors = FALSE)


# merge x and y into test data.frame
# bidn the rows
features_df   <- rbind(x_test, x_train) 


# load the features.txt and activitities_labels.txt for column names for features
# using colClasses I only read in the second column
feat_colnames <- read.table("./data/features.txt", 
                            colClasses = c(rep("NULL", 1), rep("character", 1)),
                            header = FALSE, stringsAsFactors = FALSE)
colnames(features_df) <- feat_colnames$V2 # name the columns accordingly
# load the activities (y) data
y_test  <- read.table("./data/test/y_test.txt",
                      strip.white = TRUE, stringsAsFactors = FALSE)
y_train <- read.table("./data/train/y_train.txt",
                      strip.white = TRUE, stringsAsFactors = FALSE)
# make y into activities data frame
activity_df <- rbind(y_test, y_train)
colnames(activity_df) <- "activity"

# combine the activity dataframe with the features data frame
data <- cbind(features_df, activity_df)


# -----------------------------------------------
# 2 - Extract only the measurements on the mean and stnadard deviation for each measurement
# create mean and std subset and combine them for a data file with activity
data_mean <- data[, grep("mean\\(\\)", colnames(data))]
data_std  <- data[, grep("std\\(\\)" , colnames(data))]
# combine for data data frame
data <- cbind(data_mean, data_std)
# readd activity
data <- cbind(data, activity_df)

# -----------------------------------------------
# 3 - Uses descriptive activity names to name the activities in the data set
###
# name the column head the file name y = actitivities

# load the activities labels
activites_labels <- read.table("./data/activity_labels.txt",
                               stringsAsFactors = TRUE) # load file
# add the column names of the data frame to replace
colnames(activites_labels) <- c("fromCol", "toCol")
# need the intinger to be changed to charecter for FindReplace
activites_labels$fromCol <- as.character(activites_labels$fromCol)
data$activity <- as.character(data$activity)
# Now replace the number activities to Human Readable strings
data <- suppressWarnings(FindReplace(data = data,  Var = "activity",
                    replaceData = activites_labels,
                    from = "fromCol", to = "toCol"))
# add the subjects to data
subjects_test <- read.table("./data/test/subject_test.txt", stringsAsFactors = FALSE)
subjects_train <- read.table("./data/train/subject_train.txt", stringsAsFactors = FALSE)
# combind rows to test and train subejcts
subjects_df <- rbind(subjects_test, subjects_train) 
colnames(subjects_df) <- "subject"
# comdind columns with data
data <- cbind(data, subjects_df)

# cleanup enviroment
suppressWarnings(rm(activites_labels, activity_df, data_mean, data_std,
                    feat_colnames, features_df, subjects_df, subjects_test,
                    subjects_train, x_test, x_train, y_test, y_train))

# -----------------------------------------------
# 4 - Appropriately label the data set with descriptive variable names
###

# use base R sub 

new_c_names <- colnames(data)
new_c_names <- sub("fBodyAcc","Frequency_Body_Acceleration",new_c_names[])
new_c_names <- sub("fGravityAcc","Frequency_Gravity_Acceleration",new_c_names[])
new_c_names <- sub("fBodyGyro","Frequency_Body_Gyroscope",new_c_names[])
new_c_names <- sub("fGravityGyro","Frequency_Gravity_Gyroscope",new_c_names[])
new_c_names <- sub("fBodyBodyAcc","Frequency_Body_Acceleration",new_c_names[])
new_c_names <- sub("fBodyBodyGyro","Frequency_Body_Gyroscope",new_c_names[])
new_c_names <- sub("tBodyGyro","Time_Body_Gyroscope",new_c_names[])
new_c_names <- sub("tGravityGyro","Time_Gravity_Gyroscope",new_c_names[])
new_c_names <- sub("tGravityAccMags","Time_Gravity_Mags",new_c_names[])
new_c_names <- sub("tBodyAccMag","Time_Body_Mags_",new_c_names[])
new_c_names <- sub("tBodyAccJerkMag","Time_Body_Acceleration_Jerk_Mags_",new_c_names[])
new_c_names <- sub("tGravityAcc","Time_Gravity_Acceleration",new_c_names[])
new_c_names <- sub("tBodyAcc","Time_Body_Acceleration",new_c_names[])
new_c_names <- sub("tBodyAccJerk","Time_Body_Acceleration_Jerk",new_c_names[])
new_c_names <- sub("-mean\\(\\)","_mean",new_c_names[])
new_c_names <- sub("-std\\(\\)","_std_deviation",new_c_names[])
new_c_names <- sub("-std","_std_deviation",new_c_names[])
new_c_names <- sub("-X","",new_c_names[])
new_c_names <- sub("-Y","",new_c_names[])
new_c_names <- sub("-Z","",new_c_names[])

# use the Human Readable Coloumn names
colnames(data) <- new_c_names
# cleanup
rm(new_c_names)
# -----------------------------------------------
# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# melting the data frame
data_mean <- melt(data, id.var = c("activity", "subject"))
# casting tidy data
tiddy_data <- dcast(data_mean, activity + subject ~ variable, mean)

# write out cleaned up data
write.csv(tiddy_data, "tiddy_data.csv")