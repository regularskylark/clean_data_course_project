#install.packages("snakecase")
#install.packages("dplyr")
library(snakecase)
library(data.table)
library (dplyr)

# comment these lines out if wd already local or not run from source()
thisdir <- getSrcDirectory(function(x) {x})
setwd(thisdir)

# load, unzip data into data directory if needed 
dir.create(file.path(".", "data"), showWarnings = FALSE)
data_filename = "data/data.zip"
if (!file.exists(data_filename)){
  data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file( data_url, destfile=data_filename)
  unzip("data/data.zip", exdir = "./data")
}
data_dir <- "./data/UCI HAR Dataset/"

# load, combine train data
train_subjects <- read.table(file.path(data_dir, "train", "subject_train.txt"))
train_values <- read.table(file.path(data_dir, "train", "X_train.txt"))
train_activities <- read.table(file.path(data_dir, "train", "y_train.txt"))
train <- cbind(train_subjects, train_activities, train_values)

# load, combine test data
test_subjects <- read.table(file.path(data_dir, "train", "subject_train.txt"))
test_values <- read.table(file.path(data_dir, "train", "X_train.txt"))
test_activities <- read.table(file.path(data_dir, "train", "y_train.txt"))
test <- cbind(test_subjects, test_activities, test_values)

# 1. merge the training and the test sets to create one data set.
subject_col_index = 1
activity_col_index = 2
values_begin_col_index = 3
merged_set <- rbind(train, test)

# 2. extract only the measurements on the mean and standard deviation for each measurement.
features <- read.table(file.path(data_dir, "features.txt"), as.is=TRUE)
features_name_col <- features[,2]
features_extract_index <- grep(".*mean.*|.*std.*", features_name_col)
features_extract_values <- grep(".*mean.*|.*std.*", features_name_col, value=TRUE)
features_extract_col_indexes <- sapply(features_extract_index, function(x) {x+ncol(train_subjects)})
merged_set_extract <- merged_set[c(subject_col_index, activity_col_index, features_extract_col_indexes)]

# 3. use descriptive activity names to name the activities in the data set
activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"))
activity_label_list <- activity_labels[,2]
colnames(merged_set_extract) <- c("subject", "activity", features_extract_values)
merged_set_extract[,activity_col_index] = factor(merged_set_extract[,activity_col_index], labels=activity_label_list)

#colnames(activities) <- c("activity_id", "activity_name")

# 4. appropriate data set labels with descriptive variable names.

merged_set_extract_cols <- colnames(merged_set_extract)

# filter special characters
merged_set_extract_cols <- gsub("[-()]", "", merged_set_extract_cols)

# apply more descriptive names, apply snake_case - which I find much more readable than camelCase
merged_set_extract_cols <- gsub("BodyBody", "Body", merged_set_extract_cols)
merged_set_extract_cols <- gsub("mean", "Mean", merged_set_extract_cols)
merged_set_extract_cols <- gsub("std", "Standard_deviation", merged_set_extract_cols)
merged_set_extract_cols <- gsub("^f", "_frequencyDomain", merged_set_extract_cols, ignore.case=FALSE)
merged_set_extract_cols <- gsub("^t", "TimeDomain", merged_set_extract_cols)
merged_set_extract_cols <- gsub("Gyro", "Gyroscope", merged_set_extract_cols)
merged_set_extract_cols <- gsub("Acc", "Accelerometer", merged_set_extract_cols)
merged_set_extract_cols <- gsub("Mag", "Magnitude", merged_set_extract_cols)
merged_set_extract_cols <- gsub("Freq", "Frequency", merged_set_extract_cols, ignore.case=FALSE)
merged_set_extract_cols <- to_snake_case(merged_set_extract_cols, sep_out = "_")

colnames(merged_set_extract) <- merged_set_extract_cols


write.table(merged_set_extract, "tidy_data.txt", row.names=FALSE, quote=FALSE)

# 5. second independent tidy data set with the average of each variable for each activity and each subject.
merged_set_extract <- merged_set_extract %>% group_by(subject, activity) %>% summarise_all(mean)
write.table(merged_set_extract, "tidy_data_average.txt", row.names=FALSE, quote=FALSE)
