################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/1/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")

# PIT DATA ----------------------------------------------------------------
# Melt Long
pit.long=melt(pit,id.vars=c("FY","Total"),value.name="Revenue",variable.name="Month")

# Format Date var
pit.long[,`:=`(Day = 1)][,`:=`(Date = as.Date(with(pit.long,paste(FY,Month,Day,sep="-")),"%Y-%B-%d"))]
pit.long = pit.long[,FY:=as.numeric(FY)][,Day:=NULL][FY<=2021,]
setorder(pit.long,FY,Month)

# Time series, revenue
pit.xts = xts(pit.long$Revenue,pit.long$Date)
colnames(pit.xts) = "Revenue"
plot(pit.xts)
start(pit.ts)
end(pit.ts)

# Wrangle into a TS
startM <- as.numeric(strftime(head(pit.long$Date, 1), format = "%m"))
startY <- as.numeric(strftime(head(pit.long$Date, 1) + 1, format =" %Y"))
trunc.pit.long = pit.long[FY>=2019,.(Revenue,Date,FY)]

# Decompose PIT
ts_pit = ts(trunc.pit.long, frequency = 12)
decompose_pit = decompose(ts_pit, "additive")

# Forecast
pit.fc = forecast(trunc.pit.long$Revenue,h=12,robust = T)

# -------------------------------------------------------------------------
# DATA FROM IN SBA --------------------------------------------------------
# -------------------------------------------------------------------------
#* Filter out from Individual AGI to keep just the `Difference %`
jun.per_diff = jun_rep[Individual_AGI=="Difference_%",][,Individual_AGI:=NULL]
jun.per_diff.long=melt(jun.per_diff,id.vars=c("FY","Y-T-D"),value.name="Difference_%",variable.name="Month")
jun.per_diff.long[,`:=`(Day = 1)][,`:=`(Date = as.Date(with(jun.per_diff.long,paste(FY,Month,Day,sep="-")),"%Y-%B-%d"))][,Day:=NULL]
jun.per_diff.xts = xts(jun.per_diff.long$`Difference_%`,jun.per_diff.long$Date)

# June median percentage 
jun.median_diff_FY = jun.per_diff.long[,.(median_diff = 100*median(`Difference_%`)),by = list(FY)]
jun.median_diff_Month = jun.per_diff.long[,.(median_diff = 100*median(`Difference_%`)),by = list(Month)]
