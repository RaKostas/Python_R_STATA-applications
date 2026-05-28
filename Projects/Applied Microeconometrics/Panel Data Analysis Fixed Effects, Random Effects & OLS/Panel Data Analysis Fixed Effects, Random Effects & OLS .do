 clear all
set more off, perm
cd "C:\Users\Κωστας\Desktop\micro\6"


wbopendata, indicator(SL.UEM.TOTL.ZS; ny.gdp.pcap.pp.kd; SE.TER.ENRR.FE; SE.SEC.ENRR.FE; SL.TLF.ACTI.FE.ZS; SP.DYN.TFRT.IN; SP.POP.2024.FE.5Y; SP.POP.2529.FE.5Y ; SP.POP.3034.FE.5Y; SP.POP.3539.FE.5Y; SP.POP.4044.FE.5Y; SP.POP.4549.FE.5Y;SP.POP.5054.FE.5Y; SP.POP.5559.FE.5Y; SP.POP.6064.FE.5Y; SP.POP.6569.FE.5Y; SP.POP.7074.FE.5Y; SP.POP.7579.FE.5Y; SP.POP.80UP.FE.5Y) clear nometadata long

**Inicators we use for the assignment**
*SL.UEM.TOTL.ZS- Unemployment, total (% of total labor force)
*NY.GDP.PCAP.PP.KD-GDP per capita, PPP (constant 2017 international $)
*SE.TER.ENRR.FE-School enrollment, tertiary, female (% gross)
*SE.SEC.ENRR.FE-School enrollment, secondary, female (% gross)
*SL.TLF.ACTI.FE.ZS-Labor force participation rate, female (% of female population ages 15-64)
*SP.DYN.TFRT.IN-Fertility rate, total (births per woman)
*SP.POP.2024.FE.5Y- Population ages 20-24, female (% of female population)
*SP.POP.2529.FE.5Y-Population ages 25-29, female (% of female population)
*SP.POP.3034.FE.5Y-Population ages 30-34, female (% of female population)
*SP.POP.3539.FE.5Y-Population ages 35-39, female (% of female population)
*SP.POP.4044.FE.5Y- Population ages 40-44, female (% of female population)
*SP.POP.4549.FE.5Y-Population ages 45-49, female (% of female population)
*SP.POP.5054.FE.5Y-Population ages 50-54, female (% of female population)
*SP.POP.5559.FE.5Y-Population ages 55-59, female (% of female population)
*SP.POP.6064.FE.5Y- Population ages 60-64, female (% of female population)
*SP.POP.6569.FE.5Y-Population ages 65-69, female (% of female population)
*SP.POP.7074.FE.5Y-Population ages 70-74, female (% of female population)
*SP.POP.7579.FE.5Y-Population ages 75-79, female (% of female population)
*SP.POP.80UP.FE.5Y-Population ages 80 and above, female (% of female population)

**Generate new indicators**

 gen lfpr = sl_tlf_acti_fe_zs //Labor force participation rate
 
 gen tfr = sp_dyn_tfrt_in //Fertility rate, total (births per woman)
 
 gen gdppc = ny_gdp_pcap_pp_kd //GDP per capita
 
 gen unem = sl_uem_totl_zs // Unemployment, total (% of total labor force)
 
 gen secedu = se_sec_enrr_fe //School enrollment, secondary
 gen teredu = se_ter_enrr_fe //School enrollment, tertiary
 
 gen age2024 = sp_pop_2024_fe_5y
 gen age2529 = sp_pop_2529_fe_5y
 gen age3034 = sp_pop_3034_fe_5y 
 gen age3539 = sp_pop_3539_fe_5y 
 gen age4044 = sp_pop_4044_fe_5y
 gen age4549 = sp_pop_4549_fe_5y
 gen age5054 = sp_pop_5054_fe_5y
 gen age5559 = sp_pop_5559_fe_5y
 gen age6064 = sp_pop_6064_fe_5y
 gen age6569 = sp_pop_6569_fe_5y
 gen age7074 = sp_pop_7074_fe_5y
 gen age7579 = sp_pop_7579_fe_5y
 gen age80up = sp_pop_80up_fe_5y
 
encode countrycode, gen(id)



tab id
tab id, nol

mdesc
**Panel data**
xtset id year

**Log of variables**
foreach var of varlist lfpr tfr gdppc unem secedu teredu age2024 age2529 age3034 age3539 age4044 age4549  age5054 age5559 age6064 age6569 age7074 age7579 age80up {
     gen l`var' = log(`var')
}
****Scatter


twoway (scatter tfr lfpr, by(incomelevelname)) (lfit tfr lfpr)


****Estimated models
** model1


reg ltfr c.llfpr, vce(cluster id)
est store Model1


** model2
reg ltfr c.llfpr year, vce(cluster id)
est store Model2


** model3
reg ltfr c.llfpr year id, vce(cluster id)
est store Model3


** model4
reg ltfr c.llfpr lage2024 lage2529 lage3034 lage3539 lage4044 lage4549 year id, vce(cluster id)
est store Model4


** model5


reg ltfr c.(llfpr lsecedu lteredu) year id, vce(cluster id)
est store Model5

** model6


reg ltfr c.(llfpr lgdppc lunem) year id, vce(cluster id)
est store Model6



****Fixed effects
xtreg ltfr c.(llfpr lgdppc lunem lsecedu lteredu) year, vce(cluster id) fe
est store fe
****Random effects
xtreg ltfr c.(llfpr lgdppc lunem lsecedu lteredu) year, vce(cluster id) re
est store re
outreg2 [fe re] using "Table 7",replace tex word nocons label dec(3)
*******************************************************************************************
*** Eurozone
gen eurozone=.

replace eurozone=1 if countrycode=="AUT"
replace eurozone=2 if countrycode=="BEL"
replace eurozone=3 if countrycode=="CY"
replace eurozone=4 if countrycode=="DEU"
replace eurozone=5 if countrycode=="EST"
replace eurozone=6 if countrycode=="FIN"
replace eurozone=7 if countrycode=="FRA"
replace eurozone=8 if countrycode=="GRC"
replace eurozone=9 if countrycode=="IRL"
replace eurozone=10 if countrycode=="ITA"
replace eurozone=11 if countrycode=="LTU"
replace eurozone=12 if countrycode=="LUX"
replace eurozone=13 if countrycode=="LVA"
replace eurozone=14 if countrycode=="MLT"
replace eurozone=15 if countrycode=="NLD"
replace eurozone=16 if countrycode=="PRT"
replace eurozone=17 if countrycode=="SVN"
replace eurozone=18 if countrycode=="SVK"
replace eurozone=19 if countrycode=="ESP"







*****OLS
reg ltfr c.(llfpr lgdppc lunem lsecedu lteredu) year, vce(cluster eurozone) 
est store Model8
****Fixed effects
xtreg ltfr c.(llfpr lgdppc lunem lsecedu lteredu) year, vce(cluster eurozone) fe
estimates store fe
****Random effects
xtreg ltfr c.(llfpr lgdppc lunem lsecedu lteredu) year, vce(cluster eurozone) re
estimates store re
outreg2 [fe re] using "Table 9",replace tex word nocons label dec(3)




outreg2 [Model1] using "Table 1",replace tex word nocons label dec(3)
outreg2 [Model2] using "Table 2",replace tex word nocons label dec(3)
outreg2 [Model3] using "Table 3",replace tex word nocons label dec(3)
outreg2 [Model4] using "Table 4",replace tex word nocons label dec(3)
outreg2 [Model5] using "Table 5",replace tex word nocons label dec(3)
outreg2 [Model6] using "Table 6",replace tex word nocons label dec(3)
outreg2 [Model8] using "Table 8",replace tex word nocons label dec(3)














