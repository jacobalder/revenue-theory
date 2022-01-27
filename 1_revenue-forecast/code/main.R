################################################################################
# F609, Dr. Denvil Duncan
# Date: 1/26/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies:
# Outputs: 
# Purpose: Revenue Forecasting Assignment for State of Indiana
################################################################################
# Setup -------------------------------------------------------------------
file.dir = "/Users/jacobalder/OneDrive - Indiana University/f609-revtheory/revenue-theory"
sub.dir = "1_revenue-forecast"
if(!getwd() == file.path(file.dir,sub.dir)){setwd(file.path(file.dir,sub.dir))}

# Load Packages
if(!require("pacman")) install.packages("pacman")
p_load(data.table,ggplot2,readxl,fixest,forecast,stargazer,modelsummary)

# p_load(here,haven,data.table,sandwich,lmtest,ggplot2,dplyr,tictoc,fixest,
       # parallel,modelsummary,car,stargazer,gridExtra,collapse,ivreg,fastDummies,vtable,xtable)
set.seed(121)
options("digits" = 4)

# Part A ------------------------------------------------------------------
source("code/load.R")

# Part B ------------------------------------------------------------------
source("code/stats.R")