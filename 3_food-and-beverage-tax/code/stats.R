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
fbt.full = fbt.long
# drop 2020 and 2021;
fbt.long = fbt.long[FY<=2019,]

# TS :: Wrangle into a TS
startM = as.numeric(strftime(head(fbt.long$Date, 1), format = "%m"))
startY = as.numeric(strftime(head(fbt.long$Date, 1) + 1, format =" %Y")) 
# print(ts(fbt.long$Revenue, frequency = 12, start = c(startM, startY)), calendar = T)
fbt.ts = ts(fbt.long, frequency = 12, start = c(startY))

# Make trend variable
fbt.long[,`:=`(trend = seq(1,length(FY),1))]

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

# Predictions
fbt.d[,`:=`(yhat = predict(d.ols.3), e=residuals(d.ols.3))][, diff:=Revenue-yhat]
summary(fbt.d$diff)
plot(y = fbt.d$diff, x = fbt.d$trend)
lines(y = fbt.d$diff, x = fbt.d$trend)
plot(y = fbt.d$Revenue, x = fbt.d$trend)
dev.off()

# Extrapolate the Models
x = data.table(coefficients(d.ols.3), keep.rownames = T)



# Decompose fbt
ts_fbt = ts(fbt.ts, frequency = 12)
decompose_fbt = decompose(ts_fbt, "additive")

# Forecast
fbt.fc = forecast(ts_fbt,h=12,robust = T)

# -------------------------------------------------------------------------
# DATA FROM IN SBA --------------------------------------------------------
# -------------------------------------------------------------------------
# June percentage xts
jun.per_diff = jun_rep[Individual_AGI=="Difference_%",][,Individual_AGI:=NULL]
jun.per_diff.long=melt(jun.per_diff,id.vars=c("FY","Y-T-D"),value.name="Difference_%",variable.name="Month")
jun.per_diff.long[,`:=`(Day = 1)][,`:=`(Date = as.Date(with(jun.per_diff.long,paste(FY,Month,Day,sep="-")),"%Y-%B-%d"))][,Day:=NULL]
jun.per_diff.xts = xts(jun.per_diff.long$`Difference_%`,jun.per_diff.long$Date)

# June mean percentage 
jun.mean_diff_FY = jun.per_diff.long[,.(mean_diff = mean(`Difference_%`)),by = list(FY)]
jun.mean_diff_Month = jun.per_diff.long[,.(mean_diff = mean(`Difference_%`)),by = list(Month)]
