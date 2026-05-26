* Mincer's Earnings Function — Applied Microeconometrics*
*Data: Women aged 30–54, cross-section 1975*



*keep wanted variables and their sum*
keep age wage exper educ 
sum wage educ exper

*select a specific range of the sample and the sum*
keep if age>=30 & age<=54
keep if wage>=.1282 & wage<=25
sum wage educ exper
*generate log variable*
gen log_wage=log(wage)
sum log_wage educ exper


*density plots*

kdensity log_wage
kdensity wage


*scatter plots*
tw (scatter wage educ) (lfit wage educ)
tw (scatter wage exper) (lfit wage exper)

tw (scatter wage log_wage educ)
tw (scatter log_wage exper) (lfit log_wage exper)


*generate squared variable*
gen exp2= exper^2

*regression model*
reg log_wage educ exper, rob
est store Model1

reg log_wage educ exper exp2,rob
est store Model2

outreg2 [Model1] using "Table 1", replace tex word nocons label dec(3)
outreg2 [Model2] using "Table 2", replace tex word nocons label dec(3)

*matrix plots*
graph matrix log_wage educ exper exp2
acprplot educ , lowess
acprplot exper , lowess 
acprplot exp2 , lowess

*generate multiplied variable*
gen edxp= exper * educ

*downsize the sample and run a regression*
keep if educ >= 13
keep if exper <= 10

reg wage educ exper edxp,rob
est store Model3
outreg2 [Model3] using "Table 3",replace tex word nocons label dec(3)
