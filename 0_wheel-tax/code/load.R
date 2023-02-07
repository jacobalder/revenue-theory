################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/27/22
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

# Load CIT data
dt1 = loader("raw/HistoricINVMT-ByCityandFunctionalClass-2015-2020-20210615.xls","Mileage by City and FC","A2:J16596")
colnames(dt1) = c("year","county_number","county_name","city","classification","road_length_mi","vmt_all","vmt_commercial","is_county_total","is_city_total")
dt2 = loader("Traffic.xlsx","Sheet1","A1:E11")

# Info about data: --------------------------------------------------------
# FRED Graph Observations
# Federal Reserve Economic Data
# Link: https://fred.stlouisfed.org
# Help: https://fredhelp.stlouisfed.org
# Economic Research Division
# Federal Reserve Bank of St. Louis

# Clean up
rm(list=setdiff(ls(), c("dt1","dt2")))

