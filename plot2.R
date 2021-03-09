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

# subset data to just Baltimore
baltimore <- subset(pm0, fips="24510")


# calculate totals per year
spm0 <- aggregate(baltimore$Emissions ~ baltimore$year, FUN=sum)

# plot totals per year
par(mfrow = c(1,1), mar=c(5,4,3,1))
plot(spm0, main="Total PM2.5 Emissions per year in Baltimore (fips=24510)",
     xlab="year", ylab="total PM2.5 emissions (tons)",
     pch=21, lty=1)

# save to file
outFile <- "plot2.png"
print(paste("saving chart to:", outFile, "..."))
dev.copy(device=png, file=outFile)
dev.off()