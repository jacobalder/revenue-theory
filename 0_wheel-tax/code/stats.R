################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/27/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")

# Edit dt1
dt1[,`:=`(traffic_density = vmt_all/road_length_mi)]
monroe <- dt1[county_number == 53,]
bloomington <- monroe[city == "Bloomington",] # Exclude "totals"

# Table 1
t1 = monroe[city == "Bloomington Total",list(year,road_length_mi,round(vmt_all/1000,0),round(vmt_commercial/1000,0))]

# Edit dt2
feols(inregistration~inpop+btpop|year,data=dt2)

# Corporate DATA ----------------------------------------------------------------
profit = make.ts(dt2)
