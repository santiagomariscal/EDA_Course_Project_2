
# Load library for data transformation
library(tidyverse)

# Set working directory
setwd("C:/Users/smariscal/Documents/R/Courses/Exploratory Data Analysis with R/Course Project 2")

# Check if PM2.5 summary dataset has already been loaded in R session
if (!exists("summarySCC_PM25")){
        # Download and unzip file if not found in working directory
        if (!file.exists("Source_Classification_Code.rds")){
                download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
                unzip("FNEI_data.zip")
        }
        # Read RDS files into dataframes
        summarySCC_PM25 <- readRDS("summarySCC_PM25.rds")
        source_classification_code <- readRDS("Source_Classification_Code.rds")
}

# Prepare data for chart of total emissions by year, filter for Baltimore City (fips = 24510)
plot_data <- summarySCC_PM25 %>%
        filter(fips=="24510") %>%
        group_by(year) %>%
        summarise(total_pollutant = sum(Emissions))

# Create and export bar chart of total pollutant emission by year for Baltimore City
png("plot2.png", width = 480, height = 480, units = "px")
barplot(total_pollutant ~ year, plot_data,
        main = "Total PM2.5 emissions in Baltimore City", 
        xlab = "Year", 
        ylab = "PM2.5 emissions (tons)"
        )
dev.off()