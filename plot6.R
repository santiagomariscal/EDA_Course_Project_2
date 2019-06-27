
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

# Filter only motor vehicles sources
sources_data <- source_classification_code %>%
        separate(EI.Sector, into = c("Process", "Use", "Fuel"), sep = " - ") %>%
        filter(SCC.Level.One == "Mobile Sources", grepl("Vehicles", Use))


# Summarize total emissions per year for motor vehicle sources in Baltimore City and Los Angeles County
plot_data <- summarySCC_PM25 %>%
        filter(SCC %in% sources_data$SCC, fips == "24510"|fips =="06037") %>%
        group_by(year, fips) %>%
        summarise(total_pollutant = sum(Emissions))

# Create and export line chart of motor vehicle pollutant emission by year for the two cities
png("plot6.png", width = 580, height = 480, units = "px")
ggplot(data = plot_data, aes(x = year, y = total_pollutant, col = fips)) + 
        geom_point(size = 3) +
        geom_line(size = 1) +
        scale_x_continuous(name = "Year", breaks = seq(from = 1999, to = 2008, by = 3)) +
        scale_y_continuous(name = "PM2.5 emissions (tons)") +
        scale_color_discrete(name = "", labels = c("Los Angeles County", "Baltimore City")) +
        ggtitle("Motor vehicle related PM2.5 emissions in Baltimore City and Los Angeles County") +
        theme(plot.title = element_text(lineheight=5, face="bold"), legend.position = "top")
dev.off()