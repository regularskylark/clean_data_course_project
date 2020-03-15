# Code book for clean_data_course_project

This code book relates to the `tidy_data.txt` and `tidy_data_average.txt` files of this repository. The `tidy_data.txt` file is not added to this repo due to its' size, but it can be reproduced by running `run_analysis.R`.

See the `README.md` file for more information on this data set.

The source data is located at [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). Source data is stored in the `/data` folder once downloaded by `run_analysis.R`.

## Data

The `tidy_data.txt` and `tidy_data_average.txt` files are text files, with space-separated values.

## Variables

Each `tidy_data.txt` row contains individual signal measurements for a specified subject and activity.
Each `tidy_data_average.txt` row contains averaged signal measurements for a specified subject and activity.

For more information relating to the measurement units (these are already human readable in the variable names), and any other relevant information, consult the original dataset README files. 

## Transformations

The below transformations were applied to the source data:

1. Training and test data sets were merged to create one data set.
2. Measurements on the mean and standard deviation were filtered, discarding other measurements.
3. Activity indentifier indexes were replaced with human-readable descriptors in the dataset.
4. Variable names were modified to be more human readable and set in snake_case.
5. From the data set in step 4, a second, independent tidy data set with the average of each variable for each activity and each subject was created this is output as `tidy_data_average.txt`. The non-averaged dataset is retained and output as `tidy_data.txt`.
