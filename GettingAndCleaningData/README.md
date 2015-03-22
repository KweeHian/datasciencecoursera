# Getting and Cleaning Data Course Assignment
*********************************************

Background

Companies like FitBit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked are collected from the accelerometers from the Samsung Galaxy S smartphone.

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data is available at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The aim of the project is to clean and extract usable data from the above zip file. R script called run_analysis.R that does the following: 
- Merges the training and the test sets to create one data set. 
- Extracts only the measurements on the mean and standard deviation for each measurement. - Uses descriptive activity names to name the activities in the data set 
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Part 1 - Merge the training and the test sets to create one data set
-------
The respective data in training and test data sets corresponding to subject, activity and features are mergered. The results are stored in subject, activity and features. Final data set is produced from the merges to product 1 dataset (firstcut tidyData).

```
activity <- rbind(activity_train, activity_test)    	#Merge training and test set

subject <- rbind(subject_train,subject_test)      	#Merge training and test set

features <- rbind(features_train,features_test)    	#Merge training and test set

tidyData <- cbind(features,activity,subject)   		#Final Data set combining features, activity and subject in 1 data set
```

Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement
-------
Select out the required column with either mean or std from featureNames dataset. filter them out in orginal features dataset. Finally create 1 dataset with required col ( new tidyData is created)

```
reqdCol<- grep("-mean\\(\\)|-std\\(\\)", featureNme[, 2])   #get a listing of features with mean and sd
features <- features[, reqdCol]

tidyData <- cbind(features,activity,subject)   		# Final Data set with only mean and sd features col 
```

Part 3 - Uses descriptive activity names to name the activities in the data set
---------
The original activity field in tidyData is of numeric type. We need to change its type to character so that it can accept activity names. The activity names are taken from activityLbl. Loop through the tidyData and replace the activity code with activity name.


```
activityLbl <- read.table("activity_labels.txt",header = FALSE)
tidyData$Activity <- as.character(tidyData$Activity)
for (i in 1:6){ 
	tidyData$Activity[tidyData$Activity == i] <- as.character(activityLbl[i,2])
}
```

Part 4 - Appropriately labels the data set with descriptive variable names
--------
The following acronyms title are replaced with descriptive name using gsub();
- Character Acc can be replaced with Accelerometer
- Character Gyro can be replaced with Gyroscope
- Character BodyBody can be replaced with Body
- Character Mag can be replaced with Magnitude
- Character f can be replaced with Frequency
- Character t can be replaced with Time
- Character tBody can be replaced with TimeBody
- Character -mean() can be replaced with Mean
- Character -std() can be replaced with STD
- Character -freq() can be replaced with Frequency
- Character angle can be replaced with Angle
- Character gravity can be replaced with Gravity

```
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData)) .......
```

## Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Set Subject as a factor variable, then create tidyDataSubActAve as a data set with average for each activity and subject. 
Order the enties in tidyDataSubActAve and write it into data file "tidyData_of_averages.txt" containing the processed data.

```
tidyDataSubActAve <- aggregate(. ~Subject + Activity, tidyData, mean)
tidyDataSubActAve <- tidyDataSubActAve[order(tidyDataSubActAve$Subject,tidyDataSubActAve$Activity),]
write.table(tidyDataSubActAve  , "tidyData_of_averages.txt", row.names = FALSE )    ##Final tidayData Subject Activity Average output
```
