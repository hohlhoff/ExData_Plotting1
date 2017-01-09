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

# combine date and time into a single entity
fdat[,1] <- as.POSIXct(paste(fdat$Date, fdat$Time), format="%Y-%m-%d %H:%M:%S")

# plot according to specifications
with(fdat,plot(fdat$Date,fdat$Global_active_power,type="l", xlab="DateTime", ylab="Global active Power(killowatts)"))

# copy plot to png file and close the png device
dev.copy(png,file="Plot2.png", width = 480, height = 480)
dev.off()

