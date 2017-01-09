# The following code assumes that the datafile has been downloaded,
# that the dowloaded file has been unzipped and that the data file
# household_power_consumption.txt is in the working directory

# first read the entire data set
edat <- read.csv("household_power_consumption.txt",header=TRUE,sep=";")

# select observations with date (as a string) equal to 1/2/2007
fdat1 <- subset(edat,edat$Date=="1/2/2007")

# select observations with date (as a string) equal to 2/2/2007
fdat2 <- subset(edat,edat$Date=="2/2/2007")

# combine the data frames into a single data frame; delete edat to free memory
fdat <- rbind(fdat1,fdat2)
rm(edat)

# change the class and entries of the fist column to date
fdat[,1] <- sub("/2/","feb",fdat[,1])
fdat[,1] <- as.Date(fdat[,1],"%d%b%Y")

# change the class and entries of the second column to time
library(chron)
fdat[,2] <- chron(times=fdat[,2])

# change the class and entries of the third column to numeric
fdat$Global_active_power <- as.numeric(as.character(fdat$Global_active_power))

# change the class and entries of the 4th column to numeric
fdat$Global_reactive_power <- as.numeric(as.character(fdat$Global_reactive_power))

# change the class and entries of the fifth column to numeric
fdat$Voltage <- as.numeric(as.character(fdat$Voltage))

# change the class and entries of columns 7 to 9 to numeric
fdat$Sub_metering_1 <- as.numeric(as.character(fdat$Sub_metering_1))
fdat$Sub_metering_2 <- as.numeric(as.character(fdat$Sub_metering_2))
fdat$Sub_metering_3 <- as.numeric(as.character(fdat$Sub_metering_3))


# combine date and time into a single entity; store it in the first column
fdat[,1] <- as.POSIXct(paste(fdat$Date, fdat$Time), format="%Y-%m-%d %H:%M:%S")

# plot according to specifications
par(mfrow=c(2,2)) # 4 plots in 2 rows, 2columns

# plot the first graph
with(fdat,plot(fdat$Date,fdat$Global_active_power,type="l", xlab="DateTime", ylab="Global active Power(killowatts)"))

# plot the 2nd graph
with(fdat,plot(fdat$Date,fdat$Voltage,type="l", xlab="DateTime",ylab="Voltage"))

# plot the 3rd graph
with(fdat,plot(fdat$Date,fdat$Sub_metering_1,type="n", xlab="DateTime",ylab="Energy sub metering"))
lines(fdat$Date,fdat$Sub_metering_1,col="black")
lines(fdat$Date,fdat$Sub_metering_2,col="red")
lines(fdat$Date,fdat$Sub_metering_3,col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1), lwd=c(2.5,2.5,2.5),col=c("black","red","blue"))

# plot the 4th graph
with(fdat,plot(fdat$Date,fdat$Global_reactive_power,ylim=c(0.0,0.5),type="l", xlab="DateTime",ylab="Global_reactive_power"))

# copy plot to png file and close the png device
dev.copy(png,file="Plot4.png", width = 480, height = 480)
dev.off()

