###Codebook
For the Coursera Class Getting and Cleaning Data Project.

Dataset is from [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://)

### Tiddy Dataset
[Tiddy_Data]() is from the run_anaylsis.R script

### Data for the project
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Data contains Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

### run_analysis.R
*all pathing is **relative links**. Working directory is the source of this script.
Do not add or use setwd() in any R scripts - http://stackoverflow.com/questions/13770304/risks-of-using-setwd-in-a-script*

Suggestions for pathing - http://www.r-bloggers.com/r’s-working-directory/

######*Libraries used:*
**stringr** - Used to subset the feature labels to only include mean() and std() functions. Was not possible with base R grep to get a correct subset.
**reshape2r** - used to melt (long format data frame) and dcast by mean (wide format data frame)
**DataCombind** - used for replacing the actitivites numbers into the actual activities descriptors from the file activities_lables.txt. I used this since I did not need to enter any data but automatically use the data set supllied files with the activities.

#### download the dataset in zip
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#### data frames
1. First txt files were read table the train and test files x (features) and y(activities) data files
1. Use the activities labels to sub numbers to human readable format
1. Combinded the train and test files together by rows features and activities
3. After the activities labels were replaced I merged the data frames by rows
4. Gathered the correct column names from the features.txt. Keeping only the std() and mean()
5. COmbind the second data frame with subject (persons of the study) with the activitiies
5. Give the data frame desciptive names for columns names
6. Melted the data frames into long format and re dcast to bring the data into all means of subject to activity combonations
6. Created the tidy_data.csv which is the average of each column for each subject/activity names

#### saved the tiddy data in CSV format
This is the final outcome of the run_anaylsis.R script which could further be used for further analysis.