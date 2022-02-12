################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/1/22
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

pit = loader("raw/Data_for_IncomeTargetReport.xlsx","ActualMonthlyCollections","A1:O30")
pit = pit[,...2:=NULL]

# Fix up var names
pit = setnames(pit,2:13,c("July","August","September","October","November","December","January","February","March","April","May","June"))
pit = setnames(pit,1,c("FY"))
pit = setnames(pit,14,c("Total"))

# Fix FY
pit$FY=sub("FY","",pit$FY)

# -------------------------------------------------------------------------
# MANUALLY ENTERED IN SBA DATA --------------------------------------------
# -------------------------------------------------------------------------
full_month = loader("manual-in-sba.xlsx","monthly-rev-report","A1:O133")
jun_rep = loader("manual-in-sba.xlsx","june-reports","A1:O41")

rm(list=setdiff(ls(),c("pit","full_month","jun_rep")))

