# Source of data for this project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library(data.table)
library(dplyr)

# 1. Merges the training and the test sets to create one data set.
##################################################################

activity_train <- read.table("train/y_train.txt",header = FALSE)
activity_test <- read.table("test/y_test.txt",header = FALSE)
activity <- rbind(activity_train, activity_test)    	#Merge training and test set

colnames(activity) <- "Activity"				#Assign field Name

subject_train <- read.table("train/subject_train.txt",header = FALSE)
subject_test <- read.table("test/subject_test.txt",header = FALSE)
subject <- rbind(subject_train,subject_test)      	#Merge training and test set

colnames(subject) <- "Subject"				#Assign field Name

features_train <- read.table("train/X_train.txt",header = FALSE)
features_test <- read.table("test/X_test.txt",header = FALSE)
features <- rbind(features_train,features_test)    	#Merge training and test set

featureNme <- read.table("features.txt",header = FALSE)
colnames(features) <- t(featureNme[2])			#Assign field Name

tidyData <- cbind(features,activity,subject)   		# Data set combining test and training data in 1 data set

# write.table(tidyData, "tidyData.txt",row.names = FALSE )	## tidayData output

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
###########################################################################################

reqdCol<- grep("-mean\\(\\)|-std\\(\\)", featureNme[, 2])   #get a listing of features with mean and sd
features <- features[, reqdCol]

tidyData <- cbind(features,activity,subject)   		#  Dataset with only mean and sd features col 


# 3. Uses descriptive activity names to name the activities in the data set.
###############################################################################

activityLbl <- read.table("activity_labels.txt",header = FALSE)
tidyData$Activity <- as.character(tidyData$Activity)
for (i in 1:6){ 
	tidyData$Activity[tidyData$Activity == i] <- as.character(activityLbl[i,2])
}


# 4. Appropriately labels the data set with descriptive activity names.
##############################################################################

#-- replace with descriptive col name
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData))
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData))
names(tidyData)<-gsub("^t", "Time", names(tidyData))
names(tidyData)<-gsub("^f", "Frequency", names(tidyData))
names(tidyData)<-gsub("tBody", "TimeBody", names(tidyData))
names(tidyData)<-gsub("-mean()", "Mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "STD", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("angle", "Angle", names(tidyData))
names(tidyData)<-gsub("gravity", "Gravity", names(tidyData))

#write.table(tidyData, "tidyData.txt",row.names = FALSE )	##  tidayData output

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
####################################################################################################################

tidyDataSubActAve <- aggregate(. ~Subject + Activity, tidyData, mean)
tidyDataSubActAve <- tidyDataSubActAve[order(tidyDataSubActAve$Subject,tidyDataSubActAve$Activity),]
#tidyDataSubActAve[,1:4]   	## Display data showing each subject, then by activity and the variable average

write.table(tidyDataAve , "tidyData_of_averages.txt", row.names = FALSE )    ##Final tidayData Subject Activity Average output


### ==== END OF PROJECT ================
