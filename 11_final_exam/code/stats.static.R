################################################################################
# F609 - Dr. Denvil Duncan
# Date: 5/4/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")

# simple ------------------------------------------------------------------
# Exclude Freight, and just years 2023-2027
years = as.character(c(2023:2027))
MPG.gas = mpg.forecast[1:15,8:12][,lapply(.SD,mean),.SDcols=years]
MPG.diesel = mpg.forecast[16,8:12][,lapply(.SD,mean),.SDcols=years]

# FRED Fuel Price Forecast
fuel = gas[diesel,on=.(date)][,`:=`(year=year(date))] #,month=month(date))]
setnames(fuel, c("value","i.value"), c("gas","diesel"))
fuel = fuel[,lapply(.SD,mean),.SDcols=c("gas","diesel")] #,by=list(year,month)]
fuel.ts <- ts(fuel)
periods = (2028-2023) #*12 + 8
fc <- forecast::forecast(fuel.ts,h=periods)

# Tax Exclusive Fuel Price with a 10-11% reduction for tax, per EIA estimate
# Inflation 
inflation = seq(1.1,2.0,.20)
tax.ex.fp = as.data.table(fc[["forecast"]][["gas"]][["mean"]]*0.90)*t(inflation)
tax.ex.dp = as.data.table(fc[["forecast"]][["diesel"]][["mean"]]*0.89)*t(inflation)


# Taxes --------------------------------------------------------------------
fed.tax.diesel = fed.tax.fuel = 0.184
state.tax.fuel = 0.3869
state.tax.diesel = 0.4024
fed.tax.vmt = 0.05

# Inputs ------------------------------------------------------------------
# EIA Projections, billion vehicle miles
VMT.baseline.gas = vmt.forecast[1:2,8:12][,lapply(.SD,sum),.SDcols=years]
VMT.baseline.diesel = vmt.forecast[3,8:12]

# Outputs -----------------------------------------------------------------
# Fuel Tax Revenue in billions of dollars
fuel.revenue = 
  function(tax,VMT,MPG){
    G = VMT * (1/MPG)
    rev = tax * G
    return(rev)
  }
combo.tax = fed.tax.fuel+state.tax.fuel
fuel.rev.gas = fuel.revenue(combo.tax, VMT.baseline.gas, MPG.gas)
fuel.rev.diesel = fuel.revenue(combo.tax, VMT.baseline.diesel, MPG.diesel)
fuel.rev = fuel.rev.gas + fuel.rev.diesel
fuel.rev

# VMT Tax Revenue in billions of dollars
fuel.revenue =
  function(tax,VMT){
  rev = tax * VMT
  return(rev)
}
vmt.rev.gas = fuel.revenue(fed.tax.vmt, VMT.baseline.gas)
vmt.rev.diesel = fuel.revenue(fed.tax.vmt, VMT.baseline.diesel)
vmt.rev = vmt.rev.gas + vmt.rev.diesel
vmt.rev

# Score = abs(difference) -------------------------------------------------
score.diesel = abs(fuel.rev - vmt.rev)
score.diesel

# Clean Up
t.static = data.table(t(rbind(fuel.rev,vmt.rev)))
colnames(t.static) = c("s.FuelT Revenue","s.VMT Revenue")
rm(list = setdiff(ls(),c("t.static")))
