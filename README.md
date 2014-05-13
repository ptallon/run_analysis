run_analysis
============

This document describes the steps used to create a tidy data file containing variable means by subject and activity for data constructed through the merger of test and training data. The data is HAR data maintained by the University of California Irvine. The steps are as follows:

- Set working directory
- Specify files containing key test and training data along with data on subjects and activities
- Read data from files into specified data frames
- Set up column names for data frames containing subjects and activities
- Using the column labels, determine what columns contain mean and std information
- Determine the column indexs for columns containing mean and std information
- Subset from the data only those columns containing mean and std information
- Subset from the labels DF only those labels for columns containing mean and std information
- Apply the labels to the subsetted test and train data frames
- Merge the test and train data frames
- Merge the subject and activity data frames respectively
- Column bind the subjects and activities DF to the right of the merged test and train DF
- Edit the column labels for clarity and readability
- Begin the process of creating a new tidy data file
- Use the aggregate function to create means by subject and by activity 
- Clean up the tidy data by removing the subject & activity columns from the right side of the DF
- Rename the first and second columns from group.1 and group.2 to subject and activity
- Write out the tidy data to a file, omitting the row names
