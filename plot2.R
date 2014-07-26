# plot2.R - Plot the Graphic to Answer the Second Question
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

# Step 3: Subset the NEI data to include only Baltimore (fips 24510)
NEIBalt <- subset(NEI, fips == "24510")

# Step 4: Summarize my data by year
pm25total <- ddply(NEIBalt, .(year), summarize, total = sum(Emissions, na.rm = TRUE))

# Step 5: Plot the means by year on the screen
with(pm25total, plot(year, 
                    total,
                    type = "l",
                    main = "Total PM 2.5 Emissions in \nBaltimore City, MD from 1999-2008",
                    xlab = "",
                    ylab = "Total PM 2.5 Emissions (in tons)"))

# Step 6: Save the plot to a png file
png("./plot2t.png")
with(pm25total, plot(year, 
                    total,
                    type = "l",
                    main = "Total PM 2.5 Emissions in \nBaltimore City, MD from 1999-2008",
                    xlab = "",
                    ylab = "Total PM 2.5 Emissions (in tons)"))
dev.off()
