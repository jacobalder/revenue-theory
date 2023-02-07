################################################################################
# F609 - Dr. Denvil Duncan
# Date: 3/2/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")
source("code/functions.R")

# Subset to get the right quintiles
dt.q = dt[1:5,]

# Normalize the iit vector
dt.minmax.norm <- dt.q[,lapply(dt.q[,list(tx_iit)], min_max_norm)]

# Bind
dt.q[,tx_iit.norm:=dt.minmax.norm$tx_iit]

# Run the suits index function to get the two measures
suits.iit <- suits(dt.q$tx_iit,dt.q$inc_share)
suits.excise <- suits(dt.q$tx_excise,dt.q$inc_share)
