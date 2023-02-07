################################################################################
# F609 - Dr. Denvil Duncan
# Date: 3/2/22
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

# Load data from Table 1.
t1 = loader("raw/44604-AverageTaxRates.xlsx","Table 1.","A1:G24")
inc = t1[3:12,c(1,3,6)]
colnames(inc) = c("inc_group","inc_2010","inc_share")

# Load data from Table 2.
t2 = loader("raw/44604-AverageTaxRates.xlsx","Table 2.","A1:F35")
tx.avg = t2[2:11,c(1,3,6)]
colnames(tx.avg) = c("inc_group","tx_iit","tx_excise")
tx.avg[,tx_excise := as.numeric(tx_excise)]

# Load data from Table 3.
t3 = loader("raw/44604-AverageTaxRates.xlsx","Table 3.","A1:F33")
tx.cum = t3[2:11,c(1,3,6)]
colnames(tx.cum) = c("inc_group","tx_iit","tx_excise")

# Join tables
dt = inc[tx.cum, on = .(inc_group = inc_group)]



# Lazy coding!! Watch out -------------------------------------------------
dt <- loader("raw/t1.xlsx","out","A1:P8")[2:6,c(1,6,7,8)]
colnames(dt) <- c("inc_group","inc_share","tx_iit","tx_excise")

# Clean up
rm(list=setdiff(ls(),c("dt")))
