Course Project for Getting and Cleaning Data Course
================================================

## Introduction

For this project, the dataset I worked with is the ***Human Activity Recognition Using Smartphones Data Set  from the given*** from the UCI Machine Learning Repository. 

Included in this repository are **4** files:

- `README.md` - this file providing the overview of the project and files included in this repository

- `Codebook.md` - describes all of the variables

- `run_analysis.R` - script that downloads the provided data, processed it, and outputs the clean dataset

- `UCI HAR Tidy Averages Dataset.txt` - final tidy dataset with the average values of each variable for each activity and each subject

    

## Transformations/Processing

The processing performed on the data is executed by the **`run_analysis.R`** script in this repository, and it can be divided to roughly 6 parts:

**1. Download/Unzip/Load Data**

The code checks for whether the unzip data directory already exists in the working directory. If not,  the file is downloaded from the provided link and subsequently unzipped. Next, load all of the relevant data from both the **`train`** and **`test`** folders (observations, subject mapping, and activity mapping), as well as the activity and variable labels from `activity_labels.txt` and `features.txt` files respectively.

**2. Merge `train` And `test` Subject and Activity Data**

The subject and activity data are combined into separate columns first by row binding the corresponding files (`subject_train.txt`, `subject_test.txt`, `y_train.txt`, and `y_test.txt`) from the `train` and `test` folders, and then column binding the two columns. The result is a 10299 by 2 data frame containing 1 column for subject and 1 column for activity. 

**3. Replace `activity` Data and Subsetting `mean` and `std` Data**

The numeric values (1 to 6) in `activity` column are replaced with corresponding text descriptions (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) from the mapping provided by the `activity_labels.txt` file.

The `train` and `test` observation data are combined to create a 10299 by 561 dataframe. The `grep` function is then used to find the column indices of any variable that contains "mean" or "std" (standard deviation) data. 79 variables are found. The subset of data for these 79 variables is then column bound with the subject and activity dataframe to create a 10299 by 81 dataframe.

**4. Correct Variable Names**

The existing column names for the 81 variables are taken as they are, and the following adjustments are made in order to make the variable names more precise and descriptive:

- "^f" (letter "f" at the beginning) --> "freq" which indicates frequency domain values

- "^t" (letter "t" at the beginning) --> "time" which indicates time domain values
 
- "Acc" --> "Acceleration"

- "-mean()" --> "Mean"

- "-meanFreq()" --> "MeanFreq"

- "-std()" --> "Std" which means standard deviation

- "Gyro" --> "Gyroscope"

- "Mag" --> "Magnitude"

- "BodyBody" --> "Body"

The adjusted values are then assigned back to the processed data frame as column names.

**5. Create New Dataset with Averages of Each Variable/Activity/Subject**

The `aggregate` function is used to summarize the data by taking the mean of the other variables grouped by activity and then subject, such that each subject will have 6 rows of data averages for each of the 6  correponding activities. With 30 subjects, this ultimately creates a 180 by 81 dataframe.

**6. Output the New Dataset**

The `write.table` function is used to save the resultant 180 by 81 dataframe to a text file titled `UCI HAR Tidy Averages Dataset.txt`.

## Final Output

The final output file, `Final Tidy Dataset.txt`, contains the averages for the means and standard deviation of all measurements for each subject and activity pair along with the variable names. The detailed explanation of each of the 81 variables can be found in the [`CodeBook.md`](https://github.com/briansun92/CourseProjectforGettingandCleaning/blob/master/CodeBook.md) file. 
