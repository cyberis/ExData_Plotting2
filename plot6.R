# plot6.R - Plot the Graphic to Answer the Sixth Question
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

# Step 3: Subset the NEI data to include only Baltimore (fips 24510) or Los Angeles (fips 06037)
NEICities <- subset(NEI, fips %in% c("24510", "06037")) # 11,416 Observations

# Step 4: Subset the SCC data to include only Motor Vehicles (EI.Sector has the word "Vehicles" in it)
SCCVehicles <- subset(SCC, grepl("Vehicles", EI.Sector))  ## 1,138 Levels with On Road Motor Vehicles

# Step 5: Filter NEI to include only emission data for baltimore from motor vehicles
NEICityVeh <- merge(NEICities, SCCVehicles, by.x = "SCC", by.y = "SCC") # Narrows NEICities from 11,416 down to 2,099 rows by 20 cols

# Step 6: Summarize my data by year and fips location
pm25mean <- ddply(NEICityVeh, .(year, fips), summarize, mean = mean(Emissions, na.rm = TRUE))

# Step 7: Create the plot using ggplot
thePlot <- ggplot(pm25mean, aes(x = year, 
                                y = mean,
                                colour = fips,
                                linetype = fips)) + 
    geom_line() + 
    geom_point() + 
    xlab("Year") + 
    ylab("Average PM 2.5 Emissions (in tons)") +
    scale_colour_discrete(name = "Cities",
                        breaks = c("06037", "24510"),
                        labels = c("Los Angeles", "Baltimore")) +
    guides(linetype = FALSE) +
    ggtitle("Average PM 2.5 Emissions From Motor Vehicles\n Baltimore City vs Los Angles, CA, MD 1999 - 2008")

# Step 8: Print the plot to the screen
print(thePlot)

# Step 9: Save the plot to a png file
png("./plot6a.png")
print(thePlot)
dev.off()
