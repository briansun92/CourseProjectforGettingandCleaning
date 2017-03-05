# check if data directory exists, if not download file and unzip
if(!file.exists("./UCI HAR Dataset")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  destfile = "./UCI HAR Dataset.zip", 
                  method = "curl")
    unzip("UCI HAR Dataset.zip")
}

# load in the activity labels range 1-6
actlabel <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                       col.names = c("labid", "labtype"))

# load in feature/variable names range 1-561
colname <- read.table("./UCI HAR Dataset/features.txt", check.names = FALSE)

# load in the test and train subject and activity label datasets
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
testlab <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "labid")
trainlab <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "labid")

# load in train dataset
train <- read.table("./UCI HAR Dataset/train/X_train.txt",
                   # colClasses = rep("numeric", 561),
                    col.names = colname[[2]], check.names = FALSE)

# load in test dataset
test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                   # colClasses = rep("numeric", 561),
                   col.names = colname[[2]], check.names = FALSE)

# put train and test subject data as a column, activity data as a column, and combine them
sub<-rbind(trainsubject, testsubject)  # combine column for subject number
lab<-rbind(trainlab, testlab)  # combine column for labid
sl <- cbind(sub,lab)   # combine sub and lab 

# replace labid column with corresponding text labels from the activity label dataframe
sl$labid <- actlabel[match(sl$labid, actlabel[[1]]), 2]

# find all column/variable that contain "mean" or "std"
ms <- grep("mean|std", colname[[2]])

# combine train/test datasets, subset to mean/std variables, combine w/ subject/activity columns
alldata <- cbind(sl, 
                 rbind(train, test)[,ms]) # combine train/test data set and subset

# get names of all variables 
varname <- names(alldata)

# abbreviated strings in varName
abbr <- c("^f", "^t", "Acc", "-mean\\(\\)", "-meanFreq\\(\\)", "-std\\(\\)", "Gyro", "Mag", "BodyBody")

# corrected strings 
corrected <- c("freq", "time", "Acceleration", "Mean", "MeanFreq", "Std", "Gyroscope", "Magnitude", 
               "Body")

# replace each abbreviated string with the corrected one
for(i in seq_along(abbr)){
    varname <- sub(abbr[i], corrected[i], varname)
}

# replace column names of allData with corrected version
names(alldata) <- varname

# create independent data set with average for each variable/activity/subject
newdata <- aggregate(alldata[, 3:length(alldata)], 
                     list(labid = alldata$labid, subject = alldata$subject), 
                     mean)

# write newData to output file
write.table(newdata, file = "Final Tidy DataSet.txt", row.name = FALSE)