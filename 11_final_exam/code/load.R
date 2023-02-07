################################################################################
# F609 - Dr. Denvil Duncan
# Date: 5/4/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Purpose: Load files
################################################################################

# Preliminaries -----------------------------------------------------------
# Fred.loader function
fred.loader <- function(fname){
  dt <- fread(paste0("data/raw/",fname),na.strings = ".")
  colnames(dt) = c("date","value")
  dt <- dt[year(date)>=2000,]
  return(dt)  
}

# EIA.loader function 
eia.loader <- function(fname){
  dt <- readr::read_csv("data/raw/table7-eia.csv",skip = 4, na = "na")
  setDT(dt)
  setnames(dt,c("...1"),c("key"))
  return(dt)  
}

# CBO.loader function
cbo.loader <- function(range){
  dt <- readxl::read_excel("data/raw/57110-data.xlsx",sheet = "Figure 1",range = range)
  setDT(dt)
  dt <- dt[,year:=seq(2013,2031,1)][,c(4,1,2,3)]
  colnames(dt) = c("year","outlays","inflows","eoy_balance")
  return(dt)  
}

# eia.fuel <- function(sheet,range){
#   dt <- readxl::read_excel("data/raw/fuel-real_prices.xlsx",sheet = sheet,range = range)
#   setDT(dt)
#   colnames(dt) = c("year","outlays","inflows","eoy_balance")
#   return(dt)
# }

# Load data
gas <- fred.loader("gas-fred.csv")
diesel <- fred.loader("diesel-fred.csv")
vmt <- fred.loader("vmt-fred.csv")
eia <- eia.loader("table7-eia.csv")
fhwa.highway <- cbo.loader(range = "B9:D28")
fhwa.transit <- cbo.loader(range = "F9:H28")[,year:=fhwa.highway$year]
# eia.fuel(sheet = "Diesel-A",range = "A40:D85")

# Clean up EIA data
vmt.forecast <- eia[units=="billion vehicle mile",]
mpg.forecast <- eia[units=="mpg",]

# Clean up
# rm(list=setdiff(ls(), c("dt1","dt2")))

