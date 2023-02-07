################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/9/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
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

# Load
fbt = loader("raw/City of Carmel Food & Beverage Summary.xlsx","Table 1","A2:K14")
colnames(fbt) = c("Month",seq(2012,2021,1))

# Per announcement from Dr. Duncan
# Nov - $258,567.72
# Dec -  $243,409.69
fbt$`2021`[11] = 258567.72
fbt$`2021`[12] = 243409.69

# Fix Month
fbt[,Month := seq(1,12,1)]

# Clean up 
rm(list=setdiff(ls(),c("fbt")))

