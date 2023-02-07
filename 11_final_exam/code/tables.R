################################################################################
# F609 - Dr. Denvil Duncan
# Date: 5/4/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Make Tables
################################################################################
source("code/load.R")
# CBO projections of Fuel Tax Revenue
cbo.fhwa = fhwa.highway[fhwa.transit,on=.(year)][,`:=`(sum.inflows = inflows + i.inflows,
                                                       sum.outlays = outlays + i.outlays)]
cbo.rev.fuel = cbo.fhwa[year>=2023&year<=2027,list(year,sum.inflows,sum.outlays,eoy_balance)] 

# Combine tables
t.combo = t.combo[,`:=`(year = 2023:2027)][cbo.rev.fuel,on=.(year)]
t.combo[,`:=`(s.score=abs(`s.FuelT Revenue`-`s.VMT Revenue`),
              d.score=abs(`s.FuelT Revenue`-`d.VMT Revenue`))]

out.table = t(t.combo[,list(year,`s.FuelT Revenue`,sum.inflows,`s.VMT Revenue`,`d.VMT Revenue`,s.score,d.score)])
write.csv(out.table,"figures/out.table.csv")

# CBO projections of Outlays
outlay.table = t.combo[,list(year,sum.outlays,eoy_balance,`s.FuelT Revenue`,`s.VMT Revenue`,`d.VMT Revenue`)]
outlay.table[,`:=`(fuel.def = abs(sum.outlays-`s.FuelT Revenue`),
                   stat.def = abs(sum.outlays-`s.VMT Revenue`),
                   dyna.def = abs(sum.outlays-`d.VMT Revenue`))]
write.csv(t(outlay.table),"figures/outlay.table.csv")
