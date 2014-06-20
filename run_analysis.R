

# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following. 
# 
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for 
#       each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
#   5. Creates a second, independent tidy data set with the average of each 
#       variable for each activity and each subject. 



# Read data
# ---------

# Subjects - training
subjects.train <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                             col.names="subject")

# Subjects- testing
subjects.test <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                            col.names="subject")

# Features names
feature.labels <- read.table("./UCI HAR Dataset/features.txt")

# Training set with descriptive variable names
X.train <- read.table("./UCI HAR Dataset/train/X_train.txt",
                      col.names=as.character(feature.labels[,2]))

# Testing test with descritive variable names
X.test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                     col.names=as.character(feature.labels[,2]))

# Training labels with descriptive variable names
y.train <- read.table("./UCI HAR Dataset/train/y_train.txt",
                      col.names="activity")

# Testing labels with descriptive variable name
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt",
                     col.names="activity")

# Data merge
# ----------

# train <- cbind(as.factor(rep("train",nrow(X.train))),
#                X.train,subjects.train,y.train)
# names(train)[1] <- "type"
# 
# test <- cbind(as.factor(rep("test",nrow(X.test))),
#             X.test,subjects.test,y.test)
# names(test)[1] <- "type"
train <- cbind(X.train,subjects.train,y.train)
test  <- cbind(X.test,subjects.test,y.test)

data <- rbind(train,test)

# Remove variables not needed any more
rm("X.test","X.train","feature.labels","subjects.test","subjects.train",
   "test","train","y.test","y.train")


# Descriptive activity names
# --------------------------
# read activities 
activity.lab <- read.table("./UCI HAR Dataset/activity_labels.txt",
                              col.names=c("label","name"))

# Assign names
data$activity <- unlist(lapply(data$activity, 
                           function(a) activity.lab[a==activity.lab[,1],2]))


# Extracts the measurements on the mean and standard deviation for each measurement 
# ---------------------------------------------------------------------------------
k.mean <- grep("mean",names(data))
k.std  <- grep("std", names(data))
data <- data[,c(k.mean,k.std,562,563)]


# Second tidy set with the average of each variable for each activity and each subject
# ------------------------------------------------------------------------------------
data.means <- aggregate(data[,1:79],
                                by=list(data$subject, data$activity),
                                mean)
names(data.means)[1] <- "subject"
names(data.means)[2] <- "activiy"

# The tidy data set is saved here
write.table(data.means,file="tidy_data_set.txt",col.names=TRUE)

# Remove variables not needed any more
rm("activity.lab","k.mean","k.std")
