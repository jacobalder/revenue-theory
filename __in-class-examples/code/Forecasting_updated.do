clear
capture cd "/Volumes/GoogleDrive/My Drive/SPEA - Teaching/SPEA - F609/Data"

global drive "`c(pwd)'"

*----------------**----------------**----------------**----------------*
* Cleaning tax rate
*----------------**----------------**----------------**----------------*
import excel using "VMT_1970_2015_Rawdata.xlsx", sheet(Taxrate) firstrow clear cellrange(g1:j75)
rename nominaltaxrate taxrate
carryforward taxrate, replace
save taxrate, replace

*----------------**----------------**----------------**----------------*
* Cleaning fuel prices
*----------------**----------------**----------------**----------------*
import excel using "VMT_1970_2015_Rawdata.xlsx", sheet(Gasoline_Price)  clear firstrow
*insheet using "http://api.eia.gov/series/?api_key=BPq6UKVX3WuS5AuOHno1In31Ddeutmkx2ctNAwR8&series_id=PET.EMM_EPM0_PTE_NUS_DPG.M.csv", clear
*insheet using "http://api.eia.gov/series/?api_key=BPq6UKVX3WuS5AuOHno1In31Ddeutmkx2ctNAwR8&series_id=PET.EMD_EPD2D_PTE_NUS_DPG.M.csv", clear

gen month=month(date)
gen year=year(date)
sort year month
gen quarter="Q1" if month<=3
replace quarter="Q2" if month>=4&month<=6 	
replace quarter="Q3" if month>=7&month<=9 	
replace quarter="Q4" if month>=10&month<=12 	
save fuel_price, replace

import fred PCU32733273, daterange(1994-01-01 2021-12-31) aggregate(monthly,avg) long clear
*----------------**----------------**----------------**----------------*
* Cleaning Mileage
*----------------**----------------**----------------**----------------*
import excel using "VMT_1970_2015_rawdata.xlsx", sheet(Original) firstrow clear
keep Year Month FED_VMT
rename FED_VMT VMT
rename Year year
rename Month month
gen quarter="Q1" if month<=3
replace quarter="Q2" if month>=4&month<=6 	
replace quarter="Q3" if month>=7&month<=9 	
replace quarter="Q4" if month>=10&month<=12 	

joinby year quarter using taxrate, unmatched(both)
tab _m
drop _m
joinby year month using fuel_price, unmatched(both)
tab _m
keep if _m==3
carryforward taxrate, replace
gsort -year
carryforward taxrate, replace
drop _m

sort year month
gen time=_n
gen timesq=time*time
gen timevar=tm(1994m4)
replace timevar=timevar+time-1
format timevar %tm
tsset timevar

*----------------**----------------**----------------**----------------*
* Regression analysis refresher
*----------------**----------------**----------------**----------------*
keep if year>1994
reg VMT gas_price
reg VMT diesel_price
reg VMT gas_price diesel_price
reg VMT time timesq
predict vmt_hat, xb
predict vmt_resid, residual
scatter vmt_resid time
graph twoway (line vmt_hat time) (line VMT time)

*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*
*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*
* identifying components of a timeseries: Non-parametric approach ----- SKIP THIS
*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*
*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*
***** 3month Moving average centered

tssmooth ma VMT_3mnth_avg=VMT, window(1 1 1)

***** 11 month Moving average centered

tssmooth ma VMT_11mnth_avg=VMT, window(5 1 5)

***** 5 month Moving average centered and weighted

tssmooth ma VMT_5mnth_avg=VMT, weight(0.07 .08 <.15> .3 .4)

*Detrend data series
gen VMT_detrend=VMT/VMT_11mnth_avg

***Identify Seasonality factors
*Step 1: find average vmt for each month in the detrended series
egen monthly_mean=mean(VMT_detrend) if time>5, by(month)

*step 2: find total for 12 months
egen temp=total(monthly_mean) if time>12, by(year)
egen total_mean=mean(temp) 
drop temp

*step 3: generate seasonal factors
gen seasonal_factors=monthly_mean*12/total_mean

*Step 4: generate deseasonalized VMT
gen VMT_seasonally_adj=VMT/seasonal_factors


****Graphs

line VMT timevar
line VMT_detrend timevar
line VMT_11mnth_avg timevar
line VMT_seasonally_adj timevar

graph twoway ///
(line VMT_11mnth_avg timevar) ///
(line VMT_seasonally_adj timevar) ///
(line VMT timevar), legend(label (1 "Moving Average") label (2 "Seasonally adj.") label (3 "Raw Data"))


*Identify cycles
egen VMT_annual=total(VMT), by (year)
line VMT_annual year


*Identify residual
gen temp=VMT_detrend/seasonal_factors
sort year
scatter temp year

*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*
*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*
* identifying components of a timeseries: with Regression
*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*
*----------------**----------------**----------------**----------------**----------------**----------------**----------------**----------------*

graph twoway (line VMT timevar) ,  legend( label (1 "Raw Data"))

*Some regressions (cycle only)
reg VMT i.year, robust
predict vmt_dtrend01, residual
predict vmt_trend01, xb
sort timevar
scatter vmt_dtrend01 Year
graph twoway  (line vmt_trend01 timevar) (line VMT timevar) , xline(671)  legend(label (1 "Forecast") label (2 "Raw Data"))

*Some regressions (seasonality only)
reg VMT i.month, robust
predict vmt_dtrend0, residual
predict vmt_trend0, xb
sort timevar
scatter vmt_dtrend0 Year
graph twoway  (line vmt_trend0 timevar) (line VMT timevar) , xline(671)  legend(label (1 "Forecast") label (2 "Raw Data"))

*Some regressions (Detrend only)
reg VMT time, robust
predict vmt_dtrend1, residual
predict vmt_trend1, xb
sort timevar
scatter vmt_dtrend1 Year
graph twoway  (line vmt_trend1 timevar) (line VMT timevar) , xline(671)  legend(label (1 "Forecast") label (2 "Raw Data"))

*Some regressions (Detrend and seasonality only)

reg VMT time i.month, robust
predict vmt_dtrend2, residual
predict vmt_trend2, xb
sort timevar
scatter vmt_dtrend2 Year
graph twoway  (line vmt_trend2 timevar) (line VMT timevar), xline(671)  legend(label (1 "Forecast") label (2 "Raw Data"))

*Some regressions (Detrend and seasonality  and cycle only)

reg VMT time i.month i.year, robust 
predict vmt_dtrend3, residual
predict vmt_trend3, xb
sort timevar
scatter vmt_dtrend3 Year
graph twoway  (line vmt_trend3 timevar) (line VMT timevar),  xline(671) legend(label (1 "Forecast") label (2 "Raw Data")) xlabel()

*Some regressions (Detrend and seasonality  and cycle and tax rate)

reg VMT time i.month i.year taxrate, robust /* tax rate drops becasue it does change within year; i.e., the tax rate is constant across months within a given year so it is already captured by the year fixed effects */
predict vmt_dtrend4, residual
predict vmt_trend4, xb
sort timevar
scatter vmt_dtrend4 Year

graph twoway  (line vmt_trend4 timevar) (line VMT timevar),  xline(671) legend(label (1 "Forecast") label (2 "Raw Data"))

*Some regressions (tax rate ): 

graph twoway  (line taxrate timevar)
graph twoway  (line dieselPrice timevar)
graph twoway  (line gas_priceall timevar)

reg VMT gas_price diesel_price taxrate, robust 
predict vmt_dtrend5, residual
predict vmt_trend5, xb
sort timevar
scatter vmt_dtrend5 Year

graph twoway  (line vmt_trend5 timevar) (line VMT timevar)  , legend(label (1 "Forecast") label (2 "Raw Data"))

*Some regressions (tax rate and fuel pricewith seasonality): 

reg VMT gas_price diesel_price  i.month time, robust 
predict vmt_dtrend6, residual
predict vmt_trend6, xb
sort timevar
scatter vmt_dtrend6 Year

graph twoway  (line vmt_trend6 timevar) (line VMT timevar) , legend(label (1 "Forecast") label (2 "Raw Data"))


*Some regressions (Detrend and seasonality  and cycle ): in sample prediction

reg VMT time i.month i.year  if Year<2015, robust 
predict vmt_dtrend7, residual
predict vmt_trend7, xb
sort timevar
scatter vmt_dtrend7 Year

graph twoway  (line vmt_trend7 timevar) (line VMT timevar)  if Year>2012, legend(label (1 "Forecast") label (2 "Raw Data"))



*Comparing predictions
graph twoway  (line vmt_trend6 timevar, clcolor(magneta) clpattern(dash)) ///
			  (line vmt_trend5 timevar, clcolor(green) clpattern(shortdash)) ///
			  (line vmt_trend4 timevar, clcolor(gray) clpattern(shortdash)) ///
			  (line vmt_trend3 timevar, clcolor(cyan) clpattern(dash_dot)) ///
			  (line vmt_trend2 timevar, clcolor(blue) clpattern(longdash)) ///
			  (line vmt_trend1  timevar, clcolor(red) clpattern(dot)) ///
			  (line VMT        timevar, clcolor(black) clpattern(solid)) , xline(2085)  ///
legend(label(1 "Tx_P_S_r") label(2 "Tx_P_r")  label(3 "T_S_C_r") label(4 "T_S_C")  label(5 "T_S")  label(6 "T")  label(7 "Raw") row(2) region(lstyle(none)) size(vsmall))

graph twoway  (line vmt_trend6 timevar, clcolor(magneta) clpattern(dash)) ///
			  (line vmt_trend5 timevar, clcolor(green) clpattern(shortdash)) ///
			  (line vmt_trend4 timevar, clcolor(gray) clpattern(shortdash)) ///
			  (line vmt_trend3 timevar, clcolor(cyan) clpattern(dash_dot)) ///
			  (line vmt_trend2 timevar, clcolor(blue) clpattern(longdash)) ///
			  (line vmt_trend1  timevar, clcolor(red) clpattern(dot)) ///
			  (line VMT        timevar, clcolor(black) clpattern(solid)) if Year>2012 , xline(219)  ///
legend(label(1 "Tx_P_S_r") label(2 "Tx_P_r")  label(3 "T_S_C_r") label(4 "T_S_C")  label(5 "T_S")  label(6 "T")  label(7 "Raw") row(2) region(lstyle(none)) size(vsmall))

****Comparing forecasts using errors
foreach v in vmt_trend6 vmt_trend5 vmt_trend4 vmt_trend3 vmt_trend2 vmt_trend1{
	gen `v'_error=VMT-`v'
	gen abs_`v'_error=abs(`v'_error)
	gen abspct_`v'_error=abs_`v'_error/VMT
	gen abssq_`v'_error=`v'_error*`v'_error
	
	egen mad_`v'=total(abs_`v'_error)
	egen mape_`v'=total(abspct_`v'_error)
	egen mse_`v'=total(abssq_`v'_error)
	}
sum mse* mad* mape*

foreach v in vmt_trend7{
	gen `v'_error=VMT-`v'
	gen abs_`v'_error=abs(`v'_error)
	gen abspct_`v'_error=abs_`v'_error/VMT
	gen abssq_`v'_error=`v'_error*`v'_error
	egen mad_`v'=total(abs_`v'_error) if Year==2015
	egen mape_`v'=total(abspct_`v'_error) if Year==2015
	egen mse_`v'=total(abssq_`v'_error) if Year==2015
	}
sum mse_vmt_trend7 mad_vmt_trend7 mape_vmt_trend7

// the two methods below require actual data. these are ususlly done in realtime throught the year for which the forecast applies. See for example, monthly reports for Indiana.
*Bias
note: bias = total error to date divided by number of periods. This requires actual data.

*Tracking
note: tracking=bias/MAD 

