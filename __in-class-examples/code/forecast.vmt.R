################################################################################
# F609 
# Date: 1/12/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies:
# Outputs: 
# Purpose: Sample Vehicle Miles Traveled tax
################################################################################
# Preliminaries and packages
file.dir = "/Users/jacobalder/OneDrive - Indiana University/f609-revtheory/revenue-theory"
sub.dir = "__in-class-examples"
if(!require("pacman")) install.packages("pacman")
p_load(data.table,ggplot2,readxl)
if(!getwd() == file.path(file.dir,sub.dir)){setwd(file.path(file.dir,sub.dir))}

# Loader function with numeric columns
loader <- function(num_col,sheet){
  cols = rep("numeric",num_col)
  dt <-  read_excel("data/raw/VMT_1970_2015_Rawdata_update.xlsx", 
                   col_types = cols,
                   sheet = sheet)
  return(dt)  
}

# Load files
original <- loader(6,"Original")
gas <- loader(3,"Gasoline_Price")
tax <- loader(10,"Taxrate")

#### Not finished ####
plot(original$Year,original$`Vehicle Miles Traveled`)
plot(gas$Year,gas$real_price)
plot(tax$Year,tax$`Real Tax rate`)

# Clean
colnames(dt) = c("year","month","vmt","ytd","moving_12_mo")
dt = dt[!is.na(moving_12_mo),]

# Graph
y.axis = seq(min(dt$vmt)-1,max(dt$vmt+1),3)
x.axis = seq(min(dt$year+3),max(dt$year+3),10)
(plot = ggplot(dt) +
    geom_point(aes(x = year, y = vmt),alpha = 0.8) +
    geom_hline(yintercept=0, linetype="dashed", color = "red") + 
    labs(x = "Year",    y = "Vehicle Miles Traveled [1000 Miles]",
         title = "Vehicle Mileage Data 1970 to 2015",
         # subtitle = "Percentage Difference between Average and Effective Corporate Tax",
         caption = "Source: D. Duncan",
         # color = "Tax Revenue [Billions $]",
         # size = "Corporate Profit [Billions $]"
         ) +
    scale_x_continuous(breaks = x.axis) + 
    scale_y_continuous(breaks = y.axis) +
    theme_classic()
)

# Notes from the end of class.
# Use the model and stop in 2019; predict 2020 and 2021, 
  # then compare with what actually happened (re: Covid)
# Must capture the trend
# Must capture the seasonality
  

