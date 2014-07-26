# plot4.R - Plot the Graphic to Answer the Fourth Question
# Submitted by Christopher Bortz
# For Exploratory Data Analysis Section 4 - Dr. Roger Peng
# July 7 - August 4, 2014
# Course Project 2 - Emmissions

# Step 0: Set up our environment
library(plyr)
library(ggplot2)

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

# Step 3: Subset the SCC data to include only Coal Combustion Sources
SCCCoal <- subset(SCC, grepl("Coal", EI.Sector))  ## 99 Levels with Coal Combustion

# Step 4: Filter NEI to include only emission sources from coal
NEICoal <- merge(NEI, SCCCoal, by.x = "SCC", by.y = "SCC") # Narrows NEI down to 28,480 rows by 20 cols

# Step 5: Summarize my data by year
pm25total <- ddply(NEICoal, .(year), summarize, total = sum(Emissions, na.rm = TRUE))

# Step 6: Create the plot using ggplot
thePlot <- ggplot(pm25total, aes(x = year, 
                                 y = total)) + 
    geom_line() + 
    geom_point() + 
    xlab("Year") + 
    ylab("Total PM 2.5 Emissions (in tons)") +
    ggtitle("Total PM 2.5 Emissions From Coal Combustion 1999 - 2008 (US)")

# Step 7: Print the plot to the screen
print(thePlot)

# Step 8: Save the plot to a png file
png("./plot4t.png")
print(thePlot)
dev.off()
