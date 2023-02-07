################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/22/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")
adjust = 6265034.7

rts1 = function(base,tax){
  # Part 3. National Total Collections / Base
  rep_rate = sum(tax)/sum(base)
  
  # Part 4. Estimate revenue
  new_rev = rep_rate * base
  
  # Return
  return(new_rev)
}

# New Estimated Revenues
gen_sales = rts1(dt[,personal_consumption],dt[,sales_tax])
fuel = rts1(dt[,motor_fuel_consumption],dt[,fuel_tax])
utility = rts1(dt[,utility_gdp],dt[,utility_tax])
tobacco = rts1(dt[,cigarette_sales],dt[,tobacco_tax])
income = rts1(dt[,personal_income],dt[,ind_income_tax])
corp = rts1(dt[,gdp],dt[,corp_net_inc_tax])

# Part 5. Aggregate the columns
dt = cbind(dt,gen_sales,fuel,utility,tobacco,income,corp)

# Sum / population
dt[,`:=`(revenue_capacity = gen_sales+fuel+utility+tobacco+income+corp)][,`:=`(
         rev_capacity_percap = revenue_capacity/population)]

# Total Capacities
national_total = sum(dt$rev_capacity_percap*adjust)
national_total_percap = national_total/sum(dt$population)
dt[,`:=`(RTS = (rev_capacity_percap/national_total_percap)*100)]
a = dt[order(-RTS)[1:5],list(state,RTS)]
b = dt[order(-RTS)[46:50],list(state,RTS)]
dt[order(-RTS),list(state,RTS,tax_effort)]


# Tax Effort --------------------------------------------------------------
dt[,`:=`(tax_effort = (total_revenue/revenue_capacity)*100)]
c = dt[order(-tax_effort)[1:5],list(state,tax_effort)]
d = dt[order(-tax_effort)[46:50],list(state,tax_effort)]
dt[order(-tax_effort),list(state,tax_effort)]

# Per Capita etc
pc = dt[order(-pers_inc_per_cap)[1:5],list(state,pers_inc_per_cap)]
pd = dt[order(-pers_inc_per_cap)[46:50],list(state,pers_inc_per_cap)]
dt[order(-pers_inc_per_cap),list(state,pers_inc_per_cap)]

pcgdp_T = dt[order(-gdp_per_capita)[1:5],list(state,gdp_per_capita)]
pcgdp_B = dt[order(-gdp_per_capita)[46:50],list(state,gdp_per_capita)]
dt[order(-gdp_per_capita),list(state,gdp_per_capita)]

fwrite(cbind(a,b,c,d),"figures/out.csv")