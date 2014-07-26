# plot1.R - Plot the Graphic to Answer the First Question
# Submitted by Christopher Bortz
# For Exploratory Data Analysis Section 4 - Dr. Roger Peng
# July 7 - August 4, 2014
# Course Project 2 - Emmissions

# Step 0: Set up our environment
library(plyr)

# Step 1: Get the Data if we don't already have it
if(!file.exists("./data")) {
    dir.create("./data")
}
if(!file.exists("./data/NEI_data.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./data/NEI_data.zip", method="curl")
}
if(file.exists("./data/NEI_data.zip") & !file.exists("./data/summarySCC_PM25.rds")) {
    unzip("./data/NEI_data.zip", exdir = "./data")
}

# Step 2: Load the RDS files
if(file.exists("./data/summarySCC_PM25.rds") & !exists("NEI")) {
    NEI <- readRDS("./data/summarySCC_PM25.rds") # 6,497,651 rows by 6 cols
}
if(file.exists("./data/Source_Classification_Code.rds") & !exists("SCC")) {
    SCC <- readRDS("./data/Source_Classification_Code.rds") # 11,717 rows by 15 cols
}

# Step 3: Summarize my data by year
pm25mean <- ddply(NEI, .(year), summarize, mean = mean(Emissions, na.rm = TRUE))

# Step 4: Plot the means by year on the screen
with(pm25mean, plot(year, 
                    mean,
                    type = "l",
                    main = "Average PM 2.5 Emissions in the US from 1999-2008",
                    xlab = "",
                    ylab = "Avg PM 2.5 Emissions (in tons)"))

# Step 5: Save the plot to a png file
png("./plot1a.png")
with(pm25mean, plot(year, 
                    mean,
                    type = "l",
                    main = "Average PM 2.5 Emissions in the US from 1999-2008",
                    xlab = "",
                    ylab = "Average PM 2.5 Emissions (in tons)"))
dev.off()
