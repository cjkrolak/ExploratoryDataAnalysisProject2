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

# read in classification table
SCC <- readRDS("Source_Classification_Code.rds")
merged <- merge(pm0, SCC, by.x="SCC", by.y="SCC")

# subset data to just coal related
seachCol <- c("Short.Name")
coal <- merged[grep("Coal", merged$EI.Sector),]

# calculate totals per year
spm0 <- aggregate(coal$Emissions, by=list(coal$year), FUN=sum)
names(spm0) <- c("year", "Emissions")

# plot totals per year
par(mfrow = c(1,1), mar=c(5,4,3,1))
library(ggplot2)
g <- ggplot(spm0, aes(x=year, y=Emissions))
p <- g + geom_bar(stat="identity") + ylab("PM2.5 total emissions (tons)") +
    ggtitle("Total PM2.5 Emissions per year for coal combustion sources")
print(p)

# save to file
outFile <- "plot4.png"
print(paste("saving chart to:", outFile, "..."))
dev.copy(device=png, file=outFile)
dev.off()