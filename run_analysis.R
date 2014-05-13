run_analysis <- function(){
    ## set working directory
    setwd("C:/R_files_Coursera")
    
    ## specify files containing data
    testfile  <- "X_test.txt"
    trainfile <- "X_train.txt"
    namesfile <- "features.txt"
    subjectTest  <- "subject_test.txt"
    subjectTrain <- "subject_train.txt"
    yTestfile  <- "y_test.txt"
    yTrainfile <- "y_train.txt"
    
    ## read data from files into specified data frames
    testData <- read.table(testfile,  header = FALSE, sep="", na.strings="NA")
    trainData <- read.table(trainfile, header = FALSE, sep="", na.strings="NA")
    subjectTestData   <- read.table(subjectTest,  header = FALSE, sep="", na.strings="NA")
    subjectTrainData  <- read.table(subjectTrain,  header = FALSE, sep="", na.strings="NA")
    TestActivityData  <- read.table(yTestfile,  header = FALSE, sep="", na.strings="NA")
    TrainActivityData <- read.table(yTrainfile,  header = FALSE, sep="", na.strings="NA")
    dataNames <- read.table(namesfile,  header = FALSE, sep="", na.strings="NA")
    
    ## Set up column names for data frames containing subjects and activities
    names(subjectTestData)   <- c("Subject")
    names(subjectTrainData)  <- c("Subject")
    names(TestActivityData)  <- c("Activity")
    names(TrainActivityData) <- c("Activity")

    ## Using the column labels, determine what columns contain mean and std information
    meanVars <- grep("mean()", dataNames[,2], fixed=TRUE)
    stdVars <- grep("std()", dataNames[,2], fixed=TRUE)  

    ## Determine the column indexs for columns containing mean and std information
    df1 <- data.frame(meanVars)
    names(df1) <- c("ref")
    df2 <- data.frame(stdVars)
    names(df2) <- c("ref")
    allVars <- merge(df1,df2, all=TRUE)

    colrefs <- c()
    for(i in 1:nrow(allVars)){
        colrefs <- append(colrefs,allVars[i,1])
    }
    
    ## Subset from the data only those columns containing mean and std information
    myTestData  <- testData[, colrefs]
    myTrainData <- trainData[,colrefs] 

    ## Subset from the labels data frame only those labels for columns containing mean and std information
    newDataNames <- dataNames[colrefs,2]

    ## Apply the labels to the subsetted test and train data frames
    names(myTestData)  <- newDataNames
    names(myTrainData) <- newDataNames

    ## merge the test and train data frames
    allData <- merge(myTestData,myTrainData, all=TRUE)
    
    ## Merge the subject and activity data frames respectively
    allSubjects <- merge(subjectTestData, subjectTrainData, all=TRUE)
    allActivity <- rbind(TestActivityData, TrainActivityData)

    ## Column bind the subjects and activities data frames to the right of the merged test and train data frame
    D1 <- cbind(allData, allSubjects)
    myData <- cbind(D1,allActivity)

    ## Edit the column labels for clarity and readability
    oldNames <- names(myData)
    o1 <- gsub("-X",".X",oldNames, fixed=TRUE) 
    o2 <- gsub("-Y",".Y",o1, fixed=TRUE) 
    o3 <- gsub("-Z",".Z",o2, fixed=TRUE) 
    o4 <- gsub("-mean()","Mean",o3, fixed=TRUE) 
    o5 <- gsub("-std()","Std",o4, fixed=TRUE) 
    o6 <- gsub("fBody","f.",o5, fixed=TRUE) 
    o7 <- gsub("tBody","t.",o6, fixed=TRUE) 
    o8 <- gsub("Acc","Acc.",o7, fixed=TRUE) 
    o9 <- gsub("tGravity","t.Gravity.",o8, fixed=TRUE) 
    o10 <- gsub("Gyro","Gyro.",o9, fixed=TRUE) 
    o11 <- gsub("Jerk","Jerk.",o10, fixed=TRUE) 
    o12 <- gsub("Body","Body.",o11, fixed=TRUE) 
    o13 <- gsub("Mag","Mag.",o12, fixed=TRUE) 
    names(myData) <- o13    
    newNames <- names(myData)

    ## Here we begin the process of creating a new tidy data file.
    ## use the aggregate function to create means by subject and by activity 
    tData <- aggregate(myData, by=list(myData$Subject,myData$Activity), FUN="mean")
    
    ## clean up the tidy data by stripping the subject and activity columns from the right side of the data frame
    tidyData <- tData[,1:68]

    ## rename the first and second columns from group.1 and group.2 to subject and activity respectively
    colnames(tidyData)[1] <- "Subject"
    colnames(tidyData)[2] <- "Activity"
    
    ## write out the tidy data to a file, omitting the row names
    write.table(tidyData,file="tidydata.txt",sep="\t",row.names=FALSE)
}