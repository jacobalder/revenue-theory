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

# Rebound Effect ----------------------------------------------------------
# Cost per mile
cost = 
  function(MPG,
           fuel.price,
           fed.tax,
           state.tax,
           vmt.tax
           ){
  cost = (1/MPG)*t(fuel.price + fed.tax + state.tax) + vmt.tax
  return(cost)
  }

# With NO VMT
cost.gas = cost(MPG.gas,tax.ex.fp,fed.tax.fuel,state.tax.fuel,vmt.tax = 0)
cost.diesel = cost(MPG.diesel,tax.ex.dp,fed.tax.diesel,state.tax.diesel,vmt.tax = 0)

# With VMT tax and NO fuel tax
VMT.cost.gas = cost(MPG.gas,tax.ex.fp,fed.tax = 0,state.tax.fuel,vmt.tax = fed.tax.vmt)
VMT.cost.diesel = cost(MPG.diesel,tax.ex.dp,fed.tax = 0,state.tax.diesel,vmt.tax = fed.tax.vmt)

# Percent Change
cpm = function(c1,c2){
  x = (c2-c1)/c1
  return(x)}

cpm.gas = cpm(cost.gas,VMT.cost.gas)
cpm.diesel = cpm(cost.diesel,VMT.cost.diesel)

# Percent Change in VMT
elasticity = -0.081
cpv.gas = elasticity * (cpm.gas/cost.gas)
cpv.diesel = elasticity * (cpm.diesel/cost.diesel)

# Inputs ------------------------------------------------------------------
# EIA Projections, billion vehicle miles
VMT.baseline.gas = vmt.forecast[1:2,8:12][,lapply(.SD,sum),.SDcols=years]
VMT.baseline.diesel = vmt.forecast[3,8:12]

# UPDATED VMT
VMT.updated.gas = VMT.baseline.gas * (1+cpv.gas)
VMT.updated.diesel = VMT.baseline.diesel * (1+cpv.diesel)

# Outputs -----------------------------------------------------------------
# # Fuel Tax Revenue in billions of dollars
# fuel.revenue = 
#   function(tax,VMT,MPG){
#     G = VMT * (1/MPG)
#     rev = tax * G
#     return(rev)
#   }
# combo.tax = fed.tax.fuel+state.tax.fuel
# fuel.rev.gas = fuel.revenue(combo.tax, VMT.updated.gas, MPG.gas)
# fuel.rev.diesel = fuel.revenue(combo.tax, VMT.updated.diesel, MPG.diesel)
# fuel.rev = fuel.rev.gas + fuel.rev.diesel
# fuel.rev

# VMT Tax Revenue in billions of dollars
vmt.revenue =
  function(tax,VMT){
    rev = tax * VMT
    return(rev)
  }
vmt.rev.gas = vmt.revenue(fed.tax.vmt, VMT.updated.gas)
vmt.rev.diesel = vmt.revenue(fed.tax.vmt, VMT.updated.diesel)
vmt.rev = vmt.rev.gas + vmt.rev.diesel
vmt.rev

# Clean up
# t.dynamic = data.table(t(rbind(fuel.rev,vmt.rev)))
# colnames(t.dynamic) = c("d.FuelT Revenue","d.VMT Revenue")
# t.combo = data.table(t.static,t.dynamic)
t.combo = data.table(t.static,t(vmt.rev))
setnames(t.combo,"V1","d.VMT Revenue")
rm(list = setdiff(ls(),c("t.combo")))
