
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

# Filter only sources related to coal combustion
sources_data <- source_classification_code %>%
        separate(EI.Sector, into = c("Process", "Use", "Fuel"), sep = " - ") %>%
        filter(Process == "Fuel Comb", Fuel == "Coal")


# Summarize total emissions per year for souces related to coal combusition
plot_data <- summarySCC_PM25 %>%
        filter(SCC %in% sources_data$SCC) %>%
        group_by(year) %>%
        summarise(total_pollutant = sum(Emissions))

# Create and export bar chart of total pollutant emission by year for Baltimore
png("plot4.png", width = 480, height = 480, units = "px")
ggplot(data = plot_data, aes(x = year, y = total_pollutant)) + 
        geom_bar(stat="identity") +
        scale_x_continuous(name = "Year", breaks = seq(from = 1999, to = 2008, by = 3)) +
        scale_y_continuous(name = "PM2.5 emissions (tons)") +
        ggtitle("Coal combustion related PM2.5 emissions in the United States") +
        theme(plot.title = element_text(lineheight=.8, face="bold"))
dev.off()