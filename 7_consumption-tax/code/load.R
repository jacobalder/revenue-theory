################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/3/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Purpose: Load files
################################################################################

# Preliminaries -----------------------------------------------------------
# Loader function
loader <- function(fname,sheet,range){
  dt <-  read_excel(paste0("data/",fname), 
                    sheet = sheet,
                    range = range,
                    na = "NA",
                    trim_ws = T)
  setDT(dt)
  return(dt)  
}

# Load data from Tax Foundation, Sheet1
t1 = loader("raw/State-and-Local-Sales-Tax-Rates-2022.xlsx","Sheet1","A2:G53")
abbs = c(state.abb[1:8],"DC",state.abb[9:50])
dt = t1[,abbs:=abbs][,fips:=fips(abbs)]
colnames(dt) = c("state",	"state_tr","state_tr_rank","avg_local_tr","state_local_tr","state_local_tr_rank","max_local_tr","abbs","fips")

# Info about data: --------------------------------------------------------
#* (a) City, county and municipal rates vary. These rates are weighted by population to compute an average local tax rate.						
#* (b) Three states levy mandatory, statewide, local add-on sales taxes at the state level: California (1%), Utah (1.25%), and Virginia (1%). We include these in their state sales tax.						
#* (c) The sales taxes in Hawaii, New Mexico, and South Dakota have broad bases that include many business-to-business services.						
#* (d) Special taxes in local resort areas are not counted here.						
#* (e) Salem County, N.J., is not subject to the statewide sales tax rate and collects a local rate of 3.3125%. New Jersey's local score is represented as a negative.						
#* Sources: Sales Tax Clearinghouse; Tax Foundation calculations; State Revenue Department websites.						

# Clean up
rm(list=setdiff(ls(),c("dt")))
