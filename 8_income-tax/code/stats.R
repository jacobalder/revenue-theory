################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/10/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")

make.ts <- 
  function(obj){
    ts = ts(obj[2:65], start = c(2006, 1), frequency = 4)
    xts = xts(obj$values, obj$date)
    return(xts)
}

# CIT DATA ----------------------------------------------------------------
cit = make.ts(dt1)

# Corporate DATA ----------------------------------------------------------------
profit = make.ts(dt2)
