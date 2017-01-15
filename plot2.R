################################################################################
#                                                                              #
# Filename:     plot2.R                                                        #
#                                                                              #
# Description:  File containing the R language code that produces the second   #
#               of the required plots.                                         #
#                                                                              #
################################################################################

#-------------------------------------------------------------------------------
#Step 0:
#We start by checking if required data is available in the working directory.
#If not, we will download it from the web and then, it will be unzipped:

#If the data is not available (as a text file):
if(!file.exists("household_power_consumption.txt")) {
        
        #If the zip file is not in the working directory, we download it from
        #the web:
        if (!file.exists("exdata_data_household_power_consumption.zip")) {
                
                #We download the dataset from the web provided in the instructions:
                URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                download.file(URL, destfile = "exdata_data_household_power_consumption.zip")
                
        }
        
        #Once we are sure that the zip file is available, we unzip it:
        unzip("exdata_data_household_power_consumption.zip")
        
}
#Note: We have done two different checks in order to save time and resources.
#Data could be in the working directory but only in its zip version. In that
#case, it should not be downloaded again.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#Step 1:
#Given the size of the dataset, we will try to reduce the time needed for
#loading it into memory. To do this, we will use the techniques learned in the
#first week of the course called "R Programming" (second course of Data Science
#specialization).

#We begin by loading the initial part of the dataset to a temporary data.frame:
temporary <- read.table("household_power_consumption.txt", header = TRUE,
                        sep =";", na.strings= "?", nrows = 100)

#Knowledge of the object type stored in each column, allows us to speed up the
#loading of the file. It can be passed as a parameter to the "read.table()"
#function, so we create a variable called "classes" that will contain it:
classes <- sapply(temporary, class)
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
#Step 2:
#Based on the information gathered in the previous step, we proceed to load the
#file into the computer's memory. At this point, we know three important data
#that can speed up loading the file:
#
#1. The type of object contained in each column (stored in a variable called
#   "classes").
#2. The total number of rows in the dataset (provided in the instructions).
#3. NA values are stored as "?" (also provided in the instructions).

#We create the variable "numberrows" with the number of rows in the dataset:
numberrows <- 2075259

#We call the "read.table()" function with the parameters explained above. The
#dataset will be stored in memory as a data.frame:
raw_data <- read.table("household_power_consumption.txt", header = TRUE,
                       sep =";", na.strings= "?", nrows = numberrows,
                       colClasses = classes)
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
#Step 3:
#Once the data is loaded into memory, we subset the data.frame based on the
#date range in which we are interested:

#Start date (stored as a POSIXlt object):
start <- strptime("01/02/2007", format = "%d/%m/%Y")

#End date (also stored as a POSIXlt object):
end <- strptime("02/02/2007", format = "%d/%m/%Y")

#We create a new variable that contains the original column of dates as POSIXlt
#objects. Acting this way we can operate with the dates (we are interested in
#making comparisons):
alldates <- strptime(raw_data$Date, format = "%d/%m/%Y")

#We collect in a logical vector whether the date of each observation matches
#with the required or not:
index <- ((start <= alldates) & (alldates <= end))

#We create a new data.frame that comes from a subset of "raw_data" based in the
#"index" variable gathered with the previous command:
interval <- raw_data[index,] 
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
#Step 4:
#Finally, we proceed to the actual realization of the plot. It is a graphical
#representation of the "Global_active_power" variable that will be stored in a
#png file called "plot2.png":

#We open a PNG device and we configure it with the dimensions requested:
png("plot2.png", width = 480, height = 480)

#We create the desired plot:
plot(as.numeric(as.character(interval$Global_active_power)), type = "l",
     axes = FALSE, ann = FALSE, col = "black")

#We proceed to its annotation:
box()
axis(1, at=c(1, 1440, 2880), lab=c("Thu","Fri", "Sat"))
axis(2, at=seq(0, 6, 2))
title(ylab = "Global Active Power (kilowatts)")

#We close the PNG file device:
dev.off()
#-------------------------------------------------------------------------------
