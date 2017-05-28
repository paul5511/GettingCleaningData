
# Read in the test data
x_test <- read.table("./UCI HAR Dataset-2/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset-2/test/Y_test.txt")
subjet_test <- read.table("./UCI HAR Dataset-2/test/subject_test.txt")

# Read in the training data
x_train <- read.table("./UCI HAR Dataset-2/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset-2/train/Y_train.txt")
subjet_train <- read.table("./UCI HAR Dataset-2/train/subject_train.txt")

# And the data description

data_desc <- read.table("./UCI HAR Dataset-2/features.txt")
activities <- read.table("./UCI HAR Dataset-2/activity_labels.txt")

# Merge trainng and test datasets

x_merged <- rbind(x_test, x_train)
y_merged <- rbind(y_test, y_train)
subject_merged <- rbind(subjet_test, subjet_train)

# Extract only the measurements on the mean and standard deviation for each measurement.
# Now we need to find the data descriptions that contain "mean" or "std"

matchingDescriptions <- data_desc[grep("-mean\\(\\)|-std\\(\\)", data_desc[,2]),]

# The row numbers in matchingDescriptions now correspond to the column numbers of the descriptions
# we want to extract. So get all the rows and just those columns from the merged x dataset.
x_merged <- x_merged[,matchingDescriptions[,1]]


colnames(y_merged) <- "activityNumber"
y_merged <- merge(y_merged, activities, by.x = "activityNumber", by.y = "V1")
colnames(y_merged) <- c("activityNumber", "activityDesc")

# Name the columns
colnames(x_merged) <- matchingDescriptions[,2]

# Bolt on the activity description
x_merged$activityDesc <- y_merged$activityDesc


#5
colnames(subject_merged) <- "subject"
total <- x_merged
# Bolt on the subject number to the merged data set
total$subject <- subject_merged$subject

# Group by activity and subject then calculate the mean of the varialbes for each group
meanByActivityAndSubject <- total %>% group_by(activityDesc, subject) %>% summarise_each(funs(mean))

write.table(meanByActivityAndSubject, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
