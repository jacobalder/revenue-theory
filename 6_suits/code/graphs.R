################################################################################
# F609 - Dr. Denvil Duncan
# Date: 3/2/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Graphs
################################################################################
source("code/stats.R")

# Remove "All Quintiles"
dt.p = dt.q[1:5,]

# Plot and save
axis.text = "Accum. Percent of Total "
axis.scale = seq(0,1,0.2)
ggplot(dt.p) + 
  stat_lorenz(aes(tx_excise, color = "Excise"), desc = T) +
  stat_lorenz(aes(tx_iit.norm, color = "Ind. Income")) +
  geom_abline(linetype = "dashed", color = "darkgray") +
  labs(x = paste0(axis.text,"Income"), y = paste0(axis.text,"Tax Buden"), color = "Tax",
       title = "Lorenz Curves for Federal Taxes", caption = "Data from CBO 2010 Report") + 
  coord_fixed() +
  scale_x_continuous(breaks = axis.scale) + scale_y_continuous(breaks = axis.scale) + 
  annotate("point", x = 0.8, y = 0.945) +
  annotate("text", x = 0.75, y = 0.945, label = "italic(A)",parse = T) +
  annotate("point", x = 0.8, y = 0.170) +
  annotate("text", x = 0.75, y = 0.170, label = "italic(B)",parse = T) +
  theme_minimal()

ggsave("figures/lorenz.pdf", units = "in", width = 6, height = 6)

# Output a table
fwrite(dt.q,"figures/out.csv")
suits.out = data.table(suits.excise,suits.iit)
fwrite(suits.out,"figures/suits.csv")
