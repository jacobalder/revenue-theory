################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/1/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Graphs
################################################################################
source("code/stats.R")

# June Percentage difference
pdf("figures/jun.per_diff.xts.pdf")
plot(jun.per_diff.xts, 
     ylab = "Percentage Difference",
     flwd = 2, 
     main = "Monthly Revenue Forecasts")
dev.off()

# June Mean Percentage difference FY
pdf("figures/jun.mean_diff_FY.pdf")
plot(jun.median_diff_FY)
abline(0,0,col = 2,lty = "dashed",lwd = 4)
dev.off()

# June Mean Percentage difference Month
pdf("figures/jun.mean_diff_Month.pdf")
plot(jun.median_diff_Month)
abline(0,0,col = 2,lty = "dashed",lwd = 4)
dev.off()

# GGplot way
inch = 4
g1 = ggplot(jun.median_diff_Month) + 
  geom_point(aes(x = Month, y = median_diff)) +
  labs(x = "Month", y = "Median Difference [%]") + 
  geom_hline(yintercept=0, linetype='dotted', col = 'red') +
  annotate("text", x = "January", y = 0, label = "Median Difference = 0", vjust = -0.5) + 
  theme_classic() + 
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1))
ggsave("figures/g1_jun.median_diff_Month.pdf",g1,"pdf",
       units = "in", width = inch, height = inch)

(g2 = ggplot(jun.median_diff_FY) + 
  geom_point(aes(x = FY, y = median_diff)) +
  labs(x = "Fiscal Year", y = "Median Difference [%]") + 
  geom_hline(yintercept=0, linetype='dotted', col = 'red') +
  annotate("text", x = 2015, y = 0, label = "Median Difference = 0", vjust = -0.5) + 
  theme_classic() 
)
ggsave("figures/g2_jun.median_diff_FY.pdf",g2,"pdf",
       units = "in", width = inch, height = inch)

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
     ylab = "Actual Revenues Collected [$]",
     flwd = 2)
lines(decompose_pit$trend, col = 4, lty = "dashed",lwd = 3)
dev.off()
plot(f1)

# Output Forecast
x = pit.fc$mean
write.csv(x, "figures/forecast.x.csv")
