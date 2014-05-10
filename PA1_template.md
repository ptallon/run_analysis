Peer Assignment #1
================== 

This is an R Markdown document containing the results of the 1st peer assignment.  

Part #1 - Descriptive Data
==========================
We show a histogram of the total number of steps taken daily alongside data for the mean and median.


```r
filename <- "activity.csv"
myReadData <- read.csv(filename, sep = ",", header = TRUE, na.strings = "NA")

myReadData[, 1] <- as.numeric(myReadData[, 1])
myData <- subset(myReadData, !is.na(myReadData$steps))

dailytotal <- tapply(myData$steps, myData$date, sum)
meansteps <- mean(dailytotal, na.rm = TRUE)
medsteps <- median(dailytotal, na.rm = TRUE)
hist(dailytotal, xlab = "Total Number of Daily Steps", ylab = "Frequency", main = "Histogram of Total Number of Daily Steps")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 

```r

cat(sprintf("Mean:   %.2f", meansteps), "\n")
```

```
## Mean:   10766.19
```

```r
cat(sprintf("Median: %.2f", medsteps), "\n")
```

```
## Median: 10765.00
```


Part #2 - Time Series Analysis
==============================
Next, we examine a time series plot of the 5-minute intervals (x-axis) and the average number of steps taken, averaged across all days (y-axis). We also show which interval has the maximum number of steps?

```r
intervalmeans <- tapply(myData$steps, myData$interval, mean)
y <- intervalmeans[1:nrow(intervalmeans)]
x <- names(intervalmeans)
plot(x, y, xlab = "Time Intervals", ylab = "Number of Steps", type = "l", main = "Time Series - Average Steps by Time Interval")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

```r
myDF <- data.frame(x, y)
SortedData <- myDF[order(myDF[, 2], decreasing = TRUE), ]
big <- as.numeric(row.names(SortedData[1, ]))
cat(sprintf("The interval with the greatest average number of steps is %.0f", 
    big), "\n")
```

```
## The interval with the greatest average number of steps is 835
```


Part #3 - Imputting Missing Values
==================================
Some cells in the steps column are missing. We recode these missing values using the means of the appropriate time intervals. We then review how this has impacted the mean and median and show a revised histogram.

```r
missing <- nrow(myReadData) - nrow(myData)
cat(sprintf("The number of missing (NA) rows is %.0f", missing), "\n")
```

```
## The number of missing (NA) rows is 2304
```

```r

for (i in 1:nrow(myReadData)) {
    if (is.na(myReadData$steps[i])) {
        int_time <- as.character(myReadData$interval[i])
        int_mean <- myDF[rownames(myDF) == int_time, 2]
        myReadData$steps[i] <- int_mean
    }
}

newdata <- myReadData
revised_dailytotal <- tapply(newdata$steps, newdata$date, sum)
revised_meansteps <- mean(revised_dailytotal, na.rm = TRUE)
revised_medsteps <- median(revised_dailytotal, na.rm = TRUE)
d_mean <- revised_meansteps - meansteps
d_median <- revised_medsteps - medsteps
cat(sprintf("Mean   (revised): %.2f    Change in Mean   = %.02f", revised_meansteps, 
    d_mean), "\n")
```

```
## Mean   (revised): 10766.19    Change in Mean   = 0.00
```

```r
cat(sprintf("Median (revised): %.2f    Change in Median = %.02f", revised_medsteps, 
    d_median), "\n")
```

```
## Median (revised): 10766.19    Change in Median = 1.19
```

```r
hist(revised_dailytotal, xlab = "Total Number of Daily Steps (means used for missing data)", 
    ylab = "Frequency", main = "Histogram of Total Number of Daily Steps")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 


Part #4 - Weekdays vs. Weekends
===============================
In this final part, we review differences in the total number of steps between weekdays and weekends.

```r
newdata$day <- weekdays(as.Date(newdata$date))
newdata$day <- factor(newdata$day)

oldvalues <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", 
    "Sunday")
newvalues <- factor(c("N", "N", "N", "N", "N", "Y", "Y"))

newdata$we <- newvalues[match(newdata$day, oldvalues)]

weData <- subset(newdata, newdata$we == "Y")
not_weData <- subset(newdata, newdata$we == "N")
we_means <- tapply(weData$steps, weData$interval, mean)
notwe_means <- tapply(not_weData$steps, not_weData$interval, mean)
y1 <- we_means[1:nrow(we_means)]
x1 <- names(we_means)
y2 <- notwe_means[1:nrow(notwe_means)]
x2 <- names(notwe_means)

par(mfrow = c(2, 1))
plot(x1, y1, xlab = "", ylab = "Number of Steps", type = "l", main = "Weekend")
plot(x2, y2, xlab = "Time Intervals", ylab = "Number of Steps", type = "l", 
    main = "Weekday")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

