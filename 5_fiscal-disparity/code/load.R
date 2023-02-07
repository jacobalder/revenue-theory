################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/22/22
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

# Load data
dt = loader("raw/Data for RTS.xlsx","Original data","A1:Q52")
dt = dt[-1,][,-c(9,16)]
dt$`State Taxes 2012`[43] = "Texas"
dt$`State Taxes 2012`[31] = "New Mexico"

# Put all Data in thousands
dt[,`:=`(`General Sales and Gross Receipts Taxes $K`=as.numeric(`General Sales and Gross Receipts Taxes $K`),
         `Individual Income Taxes $K` = as.numeric(`Individual Income Taxes $K`),
         `Corporation Net Income Taxes $K` = as.numeric(`Corporation Net Income Taxes $K`),
         `Personal Consumption Expenditure $M` = 1000*as.numeric(`Personal Consumption Expenditure $M`),
         `GDP from Utilties, $M` = 1000*as.numeric(`GDP from Utilties, $M`),
         `Cigarette Sales, M Packs` = 1000*as.numeric(`Cigarette Sales, M Packs`),
         `GDP $M` = 1000*as.numeric(`GDP $M`))]

# Fix names
colnames(dt) = c("state","sales_tax","fuel_tax","utility_tax","tobacco_tax",
                 "ind_income_tax","corp_net_inc_tax","total_revenue","personal_consumption",
                 "motor_fuel_consumption","utility_gdp","cigarette_sales","personal_income",
                 "gdp","population")

# Clean up NAs
remove_na = function(x){x[is.na(x)] <- 0; x}
dt.no_na = dt[, lapply(.SD, remove_na), .SDcols = c("sales_tax","ind_income_tax","corp_net_inc_tax")]
dt = cbind(dt,dt.no_na)
dt = dt[,-c(2,6,7)]

# Make Regions
source("code/region_maker.R")
dt = region_maker(dt)

# GDP per Capita
dt = dt[,`:=`(gdp_per_capita = gdp/population,
              pers_inc_per_cap = personal_income/population)]

# Reorder Columns
dt = dt[,list(state,region,sales_tax,fuel_tax,utility_tax,tobacco_tax,ind_income_tax,corp_net_inc_tax,total_revenue,
         personal_consumption,motor_fuel_consumption,utility_gdp,cigarette_sales,personal_income,gdp,population,gdp_per_capita,pers_inc_per_cap)]

# Weight to mean
min_max_norm <- function(x) {
  (x - min(x))/(max(x) - min(x))
}

# Weight include outliers
sd_norm <- function(x){
  (x - mean(x)) / sd(x)
}

# Two kinds of normalization
dt.minmax.norm <- dt[,lapply(dt[,3:17], min_max_norm)][,`:=`(state=dt$state,region=dt$region)]
dt.sd.norm <- dt[,lapply(dt[,3:17], sd_norm)][,`:=`(state=dt$state,region=dt$region)]

# Clean up
rm(list=setdiff(ls(),c("dt","dt.minmax.norm","dt.sd.norm")))
