## Getting and Cleaning Data Project: Tidy data

install.packages("dplyr")
install.packages("plyr")
library(plyr)
library(dplyr)

# read in features and activity tables; features table is for column names
features <- read.table("./UCI HAR Dataset/features.txt")
head(features)
dim(features)
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity
names(activity) <- c("activityid", "activity")

# read xtrain data, name the columns using features table
# Appropriately labels the data set with descriptive variable names
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
fname <- features[2]
names(xtrain) <- fname[1:561,]
head(xtrain)
str(xtrain)


# read label table ytrain and left join activity table to get activity lable
# --Uses descriptive activity names to name the activities in the data set
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
head(ytrain)
names(ytrain) <- "activityid"
ytrain2 <- left_join(ytrain, activity, by = "activityid")
head(ytrain2)

# read subject table
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subtrain) <- "subjectid"
head(subtrain)

# combine xtrain, ytrain and subtrain to get one single train dataset
train <- cbind(subtrain,ytrain2,xtrain)
head(train)
str(train)

# apply the above steps for test data set
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(xtest) <- fname[1:561,]
str(xtest)

ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(ytest) <- "activityid"

ytest2 <- left_join(ytest, activity, by = "activityid")
head(ytest2)

subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subtest) <- "subjectid"
head(subtest)

test <- cbind(subtest,ytest2,xtest)
str(test)

# combine train and test data sets
combine <- rbind(train,test)
head(combine)
str(combine)

# subset the columns to extract only the measurements 
# on the mean and standard deviation for each measurement.
meancol <-grep("mean()", names(combine), ignore.case=TRUE)
stdcol <-grep("std()", names(combine), ignore.case=TRUE) 
mycol <- c(1,3,meancol,stdcol)

mydata <- combine[,mycol]
head(mydata)
str(mydata)

# modify the column names appropriately
names1 <- sub(pattern="()",replacement="",x=names(mydata),fixed = TRUE)
names2 <- gsub("-",".",names1,)
names(mydata) <- names2


# creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
bysubact <- group_by(mydata, subjectid, activity)
str(bysubact)

tidydata <- summarise_each(bysubact,funs(mean), -c(subjectid, activity))
tidydata


# export the table and create a txt file
write.table(tidydata, file = "tidydata.txt", row.name=FALSE, col.names=TRUE)

# read the txt file into R to check the output
# tidydataread <- read.table("tidydata.txt", header = TRUE)
# head(tidydataread)
# str(tidydataread)
    
