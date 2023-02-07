################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/16/22
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
                    na = "NA")
  setDT(dt)
  return(dt)  
}

# Load data
original = loader("raw/Data for Tobacco Tax.xlsx","Original","A2:F33")
work = loader("raw/Data for Tobacco Tax.xlsx","Work","A1:G32")

# Compare
original[,1]==work[,1]
original[,3]==work[,3]
original[,5]==work[,5]

dt = work[year<2015,]
colnames(dt) = c("year","cig.tax.rev","packs","inc.tax.rev","pop","defl","tr")

rm(list=setdiff(ls(),c("dt")))
