################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/9/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")

# fbt DATA ----------------------------------------------------------------

# Melt Long
fbt.long=melt(fbt,id.vars=c("Month"),value.name="Revenue",variable.name="FY")

# Format Date var
fbt.long[,`:=`(Day = 1)][,`:=`(Date = as.Date(with(fbt.long,paste(FY,Month,Day,sep="-")),"%Y-%m-%d"))]

# Convert FY from factor format; drop Day; rearrange cols
fbt.long = fbt.long[,FY:=as.numeric(as.character(FY))][,Day:=NULL][,c(4,2,1,3)]
setorder(fbt.long,Date)

# Make trend variable
fbt.long[,`:=`(trend = seq(1,length(FY),1))]

# Keep 2020 and 2021 for the future
fbt.full = fbt.long

# drop 2020 and 2021;
fbt.long = fbt.long[FY<=2019,]

# TS :: Wrangle into a TS
startM = as.numeric(strftime(head(fbt.long$Date, 1), format = "%m"))
startY = as.numeric(strftime(head(fbt.long$Date, 1) + 1, format =" %Y")) 
# print(ts(fbt.long$Revenue, frequency = 12, start = c(startM, startY)), calendar = T)
fbt.ts = ts(fbt.long, frequency = 12, start = c(startY))

# XTS :: Time series, revenue
fbt.xts = xts(fbt.long$Revenue,fbt.long$Date)
colnames(fbt.xts) = "Revenue"
# plot(fbt.xts)
# start(fbt.xts)
# end(fbt.xts)
# 
# ts.plot(fbt.ts)
# start(fbt.ts)
# end(fbt.ts)

# Simple Reg -------------------------------------------------------------
#* y_{it}=\alpha+\beta\ trend+\varepsilon_{it}
ols.1 = feols(Revenue ~ trend | Month, fbt.long)
ols.2 = feols(Revenue ~ trend | Month, fbt.long, vcov = 'iid')
ols.3 = feols(Revenue ~ trend | Month, fbt.long, vcov = 'hc1')

# Extended Reg ------------------------------------------------------------
#* y_{it}=\alpha+\beta\ trend+{\zeta_m+\varepsilon}_{it}
fbt.d = dummy_cols(fbt.long,select_columns=c('Month'),remove_first_dummy = T) # make Dummy Cols for zeta_m

# Make a name separator
name.plus = function(dt,pattern){
  z.names = colnames(dt[, .SD, .SDcols = patterns(paste0("^",pattern))])
  z.plus = paste0(z.names, collapse ="+")
  return(z.plus)
}

dummy_months = name.plus(fbt.d,"Month_")
fmla = as.formula(paste("Revenue ~ trend + ",dummy_months))
d.ols.1 = feols(fmla, fbt.d)
d.ols.2 = feols(fmla, fbt.d, vcov = 'iid')
d.ols.3 = feols(fmla, fbt.d, vcov = 'hc1')

# Compare Outputs
modelsummary(list(ols.1,ols.2,ols.3,d.ols.1,d.ols.2,d.ols.3))

# Save Outputs
models = list("Linear" = ols.2, "Fixed Effects" = d.ols.2)
modelsummary(models, output = "figures/t1.tex")

# Predictions
fbt.d[,`:=`(yhat = predict(d.ols.3), e=residuals(d.ols.3))][, diff:=Revenue-yhat]

# Extrapolate the Models
x = data.table(coefficients(d.ols.3), keep.rownames = T)

# Model 2
#* y_{it}=\alpha+\beta\ trend+\varepsilon_{it}
model2 = coefficients(ols.1)

# Extrapolate Model 2
fbt.full[,`:=`(y_new_m2 = trend * model2)]

# Model 3
#* y_{it}=\alpha+\beta\ trend+\varepsilon_{it}
d.fbt.full = dummy_cols(fbt.full,select_columns=c('Month'),remove_first_dummy = T) # make Dummy Cols for zeta_m

# Extrapolate
d.fbt.full[,y_new_m3 := d.ols.3$coefficients[1] + 
         d.ols.3$coefficients[2] * d.fbt.full$trend + 
         d.ols.3$coefficients[3] * d.fbt.full$Month_2 + 
         d.ols.3$coefficients[4] * d.fbt.full$Month_3 + 
         d.ols.3$coefficients[5] * d.fbt.full$Month_4 + 
         d.ols.3$coefficients[6] * d.fbt.full$Month_5 + 
         d.ols.3$coefficients[7] * d.fbt.full$Month_6 + 
         d.ols.3$coefficients[8] * d.fbt.full$Month_7 + 
         d.ols.3$coefficients[9] * d.fbt.full$Month_8 + 
         d.ols.3$coefficients[10] * d.fbt.full$Month_9 + 
         d.ols.3$coefficients[11] * d.fbt.full$Month_10 + 
         d.ols.3$coefficients[12] * d.fbt.full$Month_11 + 
         d.ols.3$coefficients[13] * d.fbt.full$Month_12
]

## Summarize
d.fbt.full[FY>=2020,`:=`(sum_revenue = sum(Revenue), sum_m2 = sum(y_new_m2), sum_m3=sum(y_new_m3)), by = FY]

# Consolidate
dt = d.fbt.full[,list(Date,FY,Month,trend,Revenue,y_new_m2,y_new_m3,sum_revenue,sum_m2,sum_m3)]
                  
rm(list=setdiff(ls(),c("dt")))
                