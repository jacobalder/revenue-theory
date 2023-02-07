################################################################################
# F609 - Dr. Denvil Duncan
# Date: 3/2/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: none
# Outputs: 
# Purpose: 
################################################################################
# Preliminaries and packages
file.dir = "/Users/jacobalder/OneDrive - Indiana University/f609-revtheory/revenue-theory"
sub.dir = "6_suits"
pacman::p_load(collapse,data.table,fastDummies,fixest,forecast,ggplot2,gglorenz,lubridate,modelsummary,
               readxl,stats,stargazer,zoo,xts)
if(!getwd() == file.path(file.dir,sub.dir)){setwd(file.path(file.dir,sub.dir))}
options("digits" = 4)

# Run Graphs and all dependencies
source("code/graphs.R")
