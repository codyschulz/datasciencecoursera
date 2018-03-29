#######################################
# Course 3: Getting and Cleaning Data #
#######################################

##### Initials #####

### Remove scientific notation
options(scipen=999)

### Clear memory
rm(list=ls())

### Set working directory
setwd("C:/Users/Cody/Google Drive/Data Science/datasciencecoursera/course_3/assignment")

### Open packages
libs <- c("dplyr", "readr", "gsubfn")
lapply(libs, require, character.only = TRUE)

##### Open and analyze #####

##### Open

### Open activity_labels
activity_labels <- read_delim(
  "in/UCI HAR Dataset/activity_labels.txt",
  delim = " ",
  col_names = FALSE
)

### Open subject_test
subj_test <- read_delim(
  "in/UCI HAR Dataset/test/subject_test.txt",
  delim = " ",
  col_names = FALSE
)

### Open subject_train
subj_train <- read_delim(
  "in/UCI HAR Dataset/train/subject_train.txt",
  delim = " ",
  col_names = FALSE
)

### Open features
features <- read_delim(
  "in/UCI HAR Dataset/features.txt",
  delim = " ",
  col_names = FALSE
)

### Open y_test
y_test <- read_delim(
  "in/UCI HAR Dataset/test/y_test.txt",
  delim = " ",
  col_names = FALSE
)

### Open y_train
y_train <- read_delim(
  "in/UCI HAR Dataset/train/y_train.txt",
  delim = " ",
  col_names = FALSE
)

### Open test
test <- read_fwf("in/UCI HAR Dataset/test/X_test.txt",
                 col_positions = fwf_widths(rep(16, 561)))


### Open train
train <- read_fwf("in/UCI HAR Dataset/train/X_train.txt",
                  col_positions = fwf_widths(rep(16, 561)))


##### Add activity, subject, and variable labels

### Label columns
colnames(subj_test) <- "subjectid"
colnames(subj_train) <- "subjectid"
colnames(y_test) <- "activitynum"
colnames(y_train) <- "activitynum"

### Modify variable labels to be lowercase and without spaces or underscores
features$X2 <- gsubfn(
  "\\(\\)|\\-|,",
  list(
    "()" = "",
    "-" = "_",
    "," = "_"
  ),
  tolower(features$X2)
)

### Add variable labels
colnames(test) <- features$X2
colnames(train) <- features$X2


### Add subject and activity labels
test1 <- cbind(y_test, subj_test, test)
train1 <- cbind(y_train, subj_train, train)

##### Merge testing and training data

tt <- rbind(train1, test1)

##### Keep only columns concerned with mean and standard deviation

tt1 <- tt[,grepl("activitynum|subjectid|_mean_|std", colnames(tt))]

##### Merge activity and reorder

colnames(activity_labels) <- c("activitynum", "activity")

tt2 <- merge(tt1, activity_labels, by = "activitynum")

tt3 <- tt2 %>%
  select(activity, activitynum, subjectid, everything())

##### Create a new dataset that summarizes variables
tt4 <- tt3 %>%
  group_by(activity, activitynum, subjectid) %>%
  summarize_all(funs(mean))

##### Save
write.table(tt4, file = "out/accelerometer_data_summarized.txt", row.names = FALSE)
