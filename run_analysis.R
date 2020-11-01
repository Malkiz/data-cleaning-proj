# Load raw data
X_test <- read.table('raw_data/test/X_test.txt', sep = "")
y_test <- read.table('raw_data/test/y_test.txt', sep = "")
X_train <- read.table('raw_data/train/X_train.txt', sep = "")
y_train <- read.table('raw_data/train/y_train.txt', sep = "")

# Merge the training and the test sets to create one data set.
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)

# get column names
features <- read.table('raw_data/features.txt', sep = "", col.names = c("index", "featureName"))
names(X) <- features$featureName

# Extract only the measurements on the mean and standard deviation for each measurement.
X <- X[, names(X)[grepl('(mean|std)\\(\\)$', names(X))]]

# Use descriptive activity names to name the activities in the data set
activity_labels <- read.table('raw_data/activity_labels.txt', sep = "", col.names = c("index", "activity"))
y$labels <- c(sapply(y, function(v) activity_labels$activity[v]))

# Merge the labels into the data set
X$Activity <- y[, "labels"]

# Appropriately label the data set with descriptive variable names.
names_temp <- names(X)
names_temp <- sub("^t", "Time", names_temp)
names_temp <- sub("^f", "Frequency", names_temp)
names_temp <- sub("Acc", "Acceleration", names_temp)
names_temp <- sub("Mag", "Magnitude", names_temp)
names_temp <- sub("-mean\\(\\)", "Mean", names_temp)
names_temp <- sub("-std\\(\\)", "StandardDeviation", names_temp)
names(X) <- names_temp

# Add the subject to the data set
subject_train <- read.table('raw_data/train/subject_train.txt', sep = "")
subject_test <- read.table('raw_data/test/subject_test.txt', sep = "")
subjects <- rbind(subject_train, subject_test)
X$Subject <- subjects[, 1]

# From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
mean_by_activity_and_subject <- X %>% group_by(Activity, Subject) %>% summarise(across(1:18, mean, na.rm= TRUE))

# save data sets to files
if (!dir.exists("result")) {
  dir.create("result")
}
write.csv(X, "result/dataset.csv")
write.csv(mean_by_activity_and_subject, "result/mean_by_activity_and_subject.csv")
