################################################################################
# F609, Dr. Denvil Duncan
# Date: 1/26/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: main.R
# Outputs: 
# Purpose: Revenue Forecasting Assignment for State of Indiana
################################################################################
loader <- function(sheet,range){
  dt <-  read_excel("data/class-downloads/Data_for_Forecasting_HW.xlsx", 
                    sheet = sheet,
                    range = range,
                    na = "NA")
  setDT(dt)
  return(dt)  
}

# Load & Clean files --------------------------------------------------------
### General Tax Revenue
tax <- loader("Data","A6:E203")
tax = tax[!apply(is.na(tax) | tax == "", 1, all)]
tax = setnames(tax,1:5,c("CY","FY","Qtr","Sales_Tax_Rev","IITax_Rev"))

### Corporate Income Tax
cit <- loader("CIT","C2:P17")
# Rename variables
cit = setnames(cit,1:12,c("July","August","September","October","November","December","January","Febuary","March","April","May","June"))
cit = setnames(cit,13:14,c("YTD_Total","FY"))
cit$FY[15]="FY2020"
cit$FY=sub("FY","",cit$FY)
cit.long=melt(cit,id.vars=c("FY","YTD_Total"),
                  value.name="Revenue",
                  variable.name="Month")

# Format Date var
cit.long$Day = 1
cit.long$Date = as.Date(with(cit.long,paste(FY,Month,Day,sep="-")),"%Y-%B-%d")
cit.long[,Day:=NULL]
setorder(cit.long,FY,Month)

# Reset CIT
cit = cit.long
rm(cit.long)

rm(list=setdiff(ls(),c("cit","tax")))