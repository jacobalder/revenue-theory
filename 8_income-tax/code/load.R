################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/10/22
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
  colnames(dt) = c("date","values")
  return(dt)  
}

# Load CIT data
dt1 = loader("raw/fred-cit.xls","FRED Graph","A11:B76")
dt2 = loader("raw/fred-corporate-profit.xls","FRED Graph","A11:B76")

# Info about data: --------------------------------------------------------
# FRED Graph Observations
# Federal Reserve Economic Data
# Link: https://fred.stlouisfed.org
# Help: https://fredhelp.stlouisfed.org
# Economic Research Division
# Federal Reserve Bank of St. Louis

# Clean up
rm(list=setdiff(ls(), c("dt1","dt2")))

