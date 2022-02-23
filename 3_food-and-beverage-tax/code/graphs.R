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

# Rescale
rescale = 1000
dt = dt[,`:=` (r = Revenue/rescale, m2 = (y_new_m2/rescale) + 129, m3 = y_new_m3/rescale)]
date_intercept = dt$Date[97]
inch = 6

(g1 = ggplot(dt) + 
  geom_vline(xintercept=date_intercept, linetype='dashed', color='gray', size = 0.9) + 
  geom_line(aes(x = Date, y = r, color = "Actual Revenue")) + 
  geom_line(aes(x = Date, y = m3, color = "Fixed Effects Model")) + 
  geom_line(aes(x = Date, y = m2, color = "Linear OLS Model")) + 
  labs(x = "Year", y = "Revenue [$ millions]", color = "Results") + 
  theme_classic() + 
  scale_color_brewer(palette="Dark2")
)
ggsave("figures/g1.pdf",g1,"pdf",
       units = "in", width = inch+2, height = inch)

# Output table
forecast = dt[FY>=2020,list(FY,Month,Revenue,y_new_m2,y_new_m3)]
write.csv(forecast, file = "figures/forecast.csv")
