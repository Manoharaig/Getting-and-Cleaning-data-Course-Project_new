
library(data.table)
library(reshape2)
library(dplyr)
library(plyr)

# setting out the working directory

    path <- file.path( getwd(),"data","cloufront","UCI HAR Dataset")

# Step1: Read and merging all the data separately by data, label and subject.

    test_data <-  read.table(file.path(path,"test","X_test.txt"),header = FALSE, sep = "")
    train_data <-  read.table(file.path(path,"train","X_train.txt"),header = FALSE, sep = "")
    
    test_label <-  read.table(file.path(path,"test","y_test.txt"),header = FALSE, sep = "", col.names = "label")
    train_label <-  read.table(file.path(path,"train","y_train.txt"),header = FALSE, sep = "", col.names = "label")
    
    test_subjects <-  read.table(file.path(path,"test","subject_test.txt"),header = FALSE, sep = "",col.names = "subject")
    train_subjects <-  read.table(file.path(path,"train","subject_train.txt"),header = FALSE, sep = "",col.names = "subject")

    dataSubject  <- rbind(test_subjects, train_subjects)
    dataFeatures <- rbind(test_data, train_data)
    dataActivity <- rbind(test_label, train_label)
    
    names(dataSubject) <- c("subject")
    names(dataActivity) <- c("label")
    datafeaturesnames <- read.table(file.path(path,"features.txt"),header = FALSE, sep = " ")
    names(dataFeatures) <- datafeaturesnames$V2
    
    data <- cbind(dataFeatures, dataSubject, dataActivity)
    
    
# Step2: Extracts only the measurements of mean and standard deviation for each measurements
    
    subdatafeaturesnames <- data[,grep("mean\\(\\)|std\\(\\)", names(data))]  %>% data.table
    
   
# Step3: Uses descriptive activity names to name the activities in the data set.
    labl <- read.table(file.path(path,"activity_labels.txt"),header = FALSE, sep = " ") 
    data$label <- labl[data$label, 2]
    
# Step4: Appropriately lables the data set with descriptive variable names
    names(data) <- gsub("^t", "time", names(data))
    names(data) <- gsub("Acc", "Accelerometer", names(data))
    names(data) <- gsub("Gyro", "Gyroscope", names(data))
    names(data) <- gsub("Mag", "Magnitude", names(data))
    names(data) <- gsub("^f", "frequency", names(data))
    names(data) <- gsub("BodyBody", "Body", names(data))
    
    
# Step5: From the dataset in step 4, creates a second, independent tidy data set with the average of each variable for reach activiy and each subject

    data2 <- aggregate(.~subject+label, data, mean)
    write.csv(data2, file.path(getwd(),"data","tidydataset.csv"), row.names= FALSE)
        