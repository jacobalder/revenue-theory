################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/9/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: none
# Outputs: 
# Purpose: Food and beverage tax Main
################################################################################
# Preliminaries and packages
file.dir = "/Users/jacobalder/OneDrive - Indiana University/f609-revtheory/revenue-theory"
sub.dir = "3_food-and-beverage-tax"
pacman::p_load(collapse,data.table,fastDummies,fixest,forecast,ggplot2,lubridate,modelsummary,
               readxl,stats,stargazer,zoo,xts)
if(!getwd() == file.path(file.dir,sub.dir)){setwd(file.path(file.dir,sub.dir))}

# Run Graphs and all dependencies
source("code/graphs.R")
