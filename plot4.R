plot4 <- function(){
    ## This is the first project for Exploratory Data Analysis - plot 4 of 4
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
    
    png(filename="plot4.png", width=480, height=480)
    par(mfrow=c(2,2))
    ##plot2 goes into the top left
    plot(myData$Timing,myData$Global_active_power,xlab="",ylab="Global Active Power (kilowatts)",type="l",main=NULL)
    
    ##top right
    plot(myData$Timing,myData$Voltage,xlab="datetime",ylab="Voltage",type="l",main=NULL)    
    
    ##plot3 goes into the bottom left
    plot(myData$Timing,myData$Sub_metering_1,xlab="",ylab="Energy Sub Metering",type="l",main=NULL,col="black")
    lines(myData$Timing,myData$Sub_metering_2, type = "l", col = "red")
    lines(myData$Timing,myData$Sub_metering_3, type = "l", col = "blue")
    legend("topright", col=c("black", "blue", "red"), cex = 0.95, lty=1,legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

    ##bottom right
    plot(myData$Timing,myData$Global_reactive_power,xlab="datetime",ylab="Global_reactive_power",type="l",main=NULL)    
    dev.off()
}