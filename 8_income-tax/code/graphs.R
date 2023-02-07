################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/10/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Graphs
################################################################################
source("code/stats.R")

# First Quarter of the TCJA
events <- xts("", as.Date("2018-01-01"))

# Federal Tax Receipts: Corporate
png("figures/federal_receipts_cit.png", width = 900, height = 300)
plot(cit, 
     ylab = "Billions of Dollars",
     flwd = 2, 
     main = "Federal Tax Receipts: Corporate Tax")
addEventLines(events, col="red", lwd=2, lty="dashed")
dev.off()


# Corporate Tax Revenue After Tax
png("figures/corporate_revenue_after_tax.png", width = 900, height = 300)
plot(profit, 
     ylab = "Billions of Dollars",
     flwd = 2, 
     main = "Corporate Revenue after Tax")
addEventLines(events, col="red", lwd=2, lty="dashed")
dev.off()
