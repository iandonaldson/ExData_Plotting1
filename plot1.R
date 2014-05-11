#download data
setwd(".")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="power.zip", method="curl")
dateDownloaded <- date()
unzip("power.zip")
#the unzipped archive is called "household_power_consumption.txt"

#read in the data
#note it is possible to read in only a portion of the data but i am not doing that
#note it is possible to read in character strings and convert to date/time but i am not doing that either
#http://stackoverflow.com/questions/13022299/specify-date-format-for-colclasses-argument-in-read-table-read-csv
theseColClasses <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
all.data <- read.table("household_power_consumption.txt", 
                       header=TRUE, 
                       colClasses=theseColClasses, 
                       na.strings="?", 
                       sep=";", 
                       stringsAsFactors=FALSE)

#clean up date and time
newDate<-as.Date(all.data$Date, format="%d/%m/%Y")
all.data$Date <- newDate
newTime<-format(strptime(all.data$Time, format="%H:%M:%S"), "%H:%M:%S");
all.data$Time <- newTime

#select subset of data and save a copy
sub.data <- subset(all.data, Date=="2007-02-01" | Date=="2007-02-02")
write.table(sub.data, file="sub.data.txt", quote=FALSE, row.names=FALSE, sep="\t")
theseColClasses <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
sub.data2<- read.table("sub.data.txt", header=TRUE, 
                       colClasses=theseColClasses,  
                       sep="\t", 
                       stringsAsFactors=FALSE)

#remove incomplete rows
sub.data<-sub.data[complete.cases(sub.data),]

#dim(sub.data)
##[1] 2880    9
#sum(is.na(sub.data))
##[1] 0

#clean up
rm(all.data, newDate, newTime)


#make the plot and save as a file
#1
par(mfrow=c(1,1))
with(sub.data, hist(Global_active_power, 
                    col="red", 
                    main="Global Active Power", 
                    xlab="Global Active Power (kilowatts)"));

dev.copy(png, file = "plot1.png", width=480, height=480)
dev.off()


