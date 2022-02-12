################################################################################
# F609 - Dr. Denvil Duncan
# Date: 2/1/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: none
# Outputs: 
# Purpose: revenue targets main
################################################################################
# Preliminaries and packages
file.dir = "/Users/jacobalder/OneDrive - Indiana University/f609-revtheory/revenue-theory"
sub.dir = "2_revenue-targets"
pacman::p_load(collapse,data.table,forecast,ggplot2,lubridate,readxl,stats,zoo,xts)
if(!getwd() == file.path(file.dir,sub.dir)){setwd(file.path(file.dir,sub.dir))}

# Run Graphs and all dependencies
source("code/graphs.R")
