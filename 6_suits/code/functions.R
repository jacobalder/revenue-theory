################################################################################
# F609 - Dr. Denvil Duncan
# Date: 3/2/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Store all the Functions
################################################################################
# Lag Shifter addition
lag_shifter_add <- function(a){
  a.shift = shift(a,1,0,"lag")
  a.shift.cum = rep(NA,length(a))
  for (i in 1:length(a)) {
    a.shift.cum[i] <- a[i] - a.shift[i] # Here's the addition 
  }
  return(a.shift.cum)
}

# Lag Shifter subtraction
lag_shifter_sub <- function(a){
  a.shift = shift(a,1,0,"lag")
  a.shift.cum = rep(NA,length(a))
  for (i in 1:length(a)) {
    a.shift.cum[i] <- a[i] - a.shift[i] # Here's the subtraction
  }
  return(a.shift.cum)
}

# Generate new Suits Index `S`
suits <- function(x,y){
  A = lag_shifter_add(x)
  B = lag_shifter_sub(y)
  C = A*B
  D = C/2
  S = (5000 - sum(D)) / 5000
  return(S)
}

# Weight to mean
min_max_norm <- function(x) {
  (x - min(x))/(max(x) - min(x))
}
