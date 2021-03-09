# read in data
# fips: A five-digit number (represented as a string) indicating the U.S. county
# SCC: The name of the source as indicated by a digit string (see source code classification table)
# Pollutant: A string indicating the pollutant
# Emissions: Amount of PM2.5 emitted, in tons
# type: The type of source (point, non-point, on-road, or non-road)
# year: The year of emissions recorded
pm0 <- readRDS("summarySCC_PM25.rds")

# convert data types
pm0 <- transform(pm0, year=factor(year))
pm0 <- transform(pm0, type=factor(type))
pm0 <- transform(pm0, Pollutant=factor(Pollutant))
pm0 <- transform(pm0, SCC=factor(SCC))

# subset data to just Baltimore
baltimore <- subset(pm0, (fips %in% c("24510","06037")))
library(dplyr)
baltimore <- baltimore %>% mutate(site = factor(if_else(fips=="24510",
                                                        "Baltimore",
                                                        "Los Angeles County")))

# read in classification table
SCC <- readRDS("Source_Classification_Code.rds")
merged <- merge(baltimore, SCC, by.x="SCC", by.y="SCC")

# subset data to just motor vehicle related
vehicle <- merged[grep("Mobile - On-Road", merged$EI.Sector),]

# calculate totals per year
spm0 <- aggregate(vehicle$Emissions, by=list(vehicle$year, vehicle$site), FUN=sum)
names(spm0) <- c("year", "site", "Emissions")

# plot totals per year
par(mfrow = c(1,1), mar=c(5,4,3,1))
library(ggplot2)
g <- ggplot(spm0, aes(group=site, x=year, y=Emissions, color=site))
p <- g + geom_line() + ylab("PM2.5 total emissions (tons)") +
    theme(plot.title = element_text(size=10)) +
    ggtitle("Total PM2.5 Emissions per year for motor vehicle sources in Baltimore vs. Los Angeles County")
print(p)

# save to file
outFile <- "plot6.png"
print(paste("saving chart to:", outFile, "..."))
dev.copy(device=png, file=outFile)
dev.off()