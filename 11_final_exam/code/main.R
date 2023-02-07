################################################################################
# F609 - Dr. Denvil Duncan
# Date: 5/4/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: none
# Outputs: 
# Purpose: 
################################################################################
# Preliminaries and packages
file.dir = "/Users/jacobalder/OneDrive - Indiana University/f609-revtheory/revenue-theory"
sub.dir = "11_final_exam"
pacman::p_load(data.table,fixest,forecast,ggplot2,readxl,xts)
if(!getwd() == file.path(file.dir,sub.dir)){setwd(file.path(file.dir,sub.dir))}
options("digits" = 4)
theme_set(theme_classic())

# Run Graphs and all dependencies
source("code/stats.static.R")
source("code/stats.dynamic.R")
source("code/tables.R")

# Clean everything
rm(list=ls(all=T))