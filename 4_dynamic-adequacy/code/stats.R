################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/16/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")
dt[,`:=`(lbase = log(packs), lrev.inc = log(inc.tax.rev/(defl/100)), lrev.cig = log(cig.tax.rev/(defl/100)))]

# Make into time series
ts = ts(dt)

# Regressions -------------------------------------------------------------
# buoyancy
buoyancy = feols(lrev.cig~lrev.inc,ts,vcov = "hc1")
summary(lm(lrev.cig~lrev.inc,ts))
summary(buoyancy)

# elasticity
elasticity = feols(lbase~lrev.inc+i(tr),ts,vcov = "hc1")
summary(lm(lbase~lrev.inc+i(tr),ts))
summary(elasticity)

# Summarize
modelsummary(list(buoyancy,elasticity),output = "figures/regressions.txt")

# stability 
sd.t = function(var){
  var = dt$lrev.cig
  n = length(var)
  sd = sqrt(sum((var - diff(var))^2/ (n - 1)))
  return(sd)
}

sd.t(dt$lrev.cig)
sd.t(dt$lrev.inc)
sd.t(dt$lbase)

# Graph?
p = function(dt,var,label,color,inch){
  ggplot(dt) + 
    geom_line(aes(x = year, y = var/1000)) + 
    labs(x = "Year", y = label, color = "Model") + 
    theme_classic() + 
    scale_color_brewer(palette=color)
    ggsave(paste0("figures/",label,".pdf"),
           units = "in", width = inch, height = inch)
}
p(dt,dt$cig.tax.rev,"Cigarette Tax Revenue","Dark2",3)
p(dt,dt$inc.tax.rev,"Income Tax Revenue","RdBu",3)
p(dt,dt$lrev.cig,"Logged Cigarette Tax Revenue","Dark2",3)
p(dt,dt$lrev.inc,"Logged Income Tax Revenue","RdBu",3)
