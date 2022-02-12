################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/9/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Graphs
################################################################################
source("code/stats.R")

# June Percentage difference
pdf("figures/jun.per_diff.xts.pdf")
plot(jun.per_diff.xts)
dev.off()

# June Mean Percentage difference FY
pdf("figures/jun.mean_diff_FY.pdf")
plot(jun.mean_diff_FY)
abline(0,0,col = 2,lty = "dashed",lwd = 4)
dev.off()

# June Mean Percentage difference Month
pdf("figures/jun.mean_diff_Month.pdf")
plot(jun.mean_diff_Month)
abline(0,0,col = 2,lty = "dashed",lwd = 4)
dev.off()

# Seasonal trends
pdf("figures/pit_ts_trends.pdf")
plot(as.ts(decompose_pit$seasonal))
plot(as.ts(decompose_pit$trend))
plot(as.ts(decompose_pit$random))
plot(decompose_pit)
dev.off()

# Composed Forecast
pdf("figures/pit_ts_forecast.pdf")
plot(pit.fc,
     xlab = "Time",
     ylab = "Actual Revenues Collected",
     flwd = 2)
lines(decompose_pit$trend, col = 4, lty = "dashed",lwd = 3)
dev.off()
