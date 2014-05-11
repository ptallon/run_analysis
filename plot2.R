plot2 <- function(){
    ## This is the first project for Exploratory Data Analysis - plot 2 of 4
    filename = "household_power_consumption.txt"
    ##tab5rows <- read.table(filename, header = TRUE, sep=";", na.strings="?",nrows = 10)
    ##classes <- sapply(tab5rows, class)

    f <- file(filename,"rt");
    
    nolines <- 100
    greped<-c()
    repeat {
        lines=readLines(f,n=nolines)       #read lines
        idx <- grep("^[12]/2/2007", lines) #find those that match
        greped<-c(greped, lines[idx])      #add the found lines
        #
        if(nolines!=length(lines)) {
            break #are we at the end of the file?
        }
    }
    close(f)
    
    tc<-textConnection(greped,"rt") #now we create a text connection and load data
    myData <- read.csv(tc,sep=";",header=FALSE, na.strings="?")
    names(myData) <- c("Date", "Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
    myData$Timing <- paste(myData$Date, sep=" ", myData$Time)
    myData$Timing <- strptime(myData$Timing, "%d/%m/%Y %H:%M:%S")    
    
    png(filename="plot2.png", width=480, height=480)
    plot(myData$Timing,myData$Global_active_power,xlab="",ylab="Global Active Power (kilowatts)",type="l",main=NULL)
    dev.off()
}