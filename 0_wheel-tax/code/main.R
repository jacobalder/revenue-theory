################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/10/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: none
# Outputs: 
# Purpose: 
################################################################################
# Preliminaries and packages
file.dir = "/Users/jacobalder/OneDrive - Indiana University/f609-revtheory/revenue-theory"
sub.dir = "0_wheel-tax"
pacman::p_load(data.table,fixest,forecast,ggplot2,readxl,xts)
if(!getwd() == file.path(file.dir,sub.dir)){setwd(file.path(file.dir,sub.dir))}
options("digits" = 4)
theme_set(theme_classic())

# Run Graphs and all dependencies
source("code/graphs.R")

# Clean everything
rm(list=ls(all=T))