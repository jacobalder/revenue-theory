################################################################################
# F609 - Dr. Denvil Duncan
# Date: 5/4/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Analyze files
################################################################################
source("code/load.R")

# simple ------------------------------------------------------------------
MPG = 20

# Tax Exclusive Fuel Price
tax.ex.fp = 4.0

tax.fuel = 0.4
tax.vmt = 0.05

# Cost per mile

# Rebound Elasticity

# Percent Change in cost per mile
cpm = 0.14
# Percent Change in VMT
cpv = 0.0136

# Inputs ------------------------------------------------------------------
VMT.baseline = c(12000,12240,12485,12734,12989,13249)
VMT.updated = VMT.baseline * (1+cpv)


# Outputs -----------------------------------------------------------------
# Fuel Tax Revenue
rev.fuel = seq(240,265,5)
# Mileage Tax Revenue
rev.vmt = VMT.updated*tax.vmt
# Score = abs(difference)
score = abs(rev.fuel - rev.vmt)
score
