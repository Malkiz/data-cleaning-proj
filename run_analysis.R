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
y <- y[, "labels"]

# Appropriately label the data set with descriptive variable names.

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.