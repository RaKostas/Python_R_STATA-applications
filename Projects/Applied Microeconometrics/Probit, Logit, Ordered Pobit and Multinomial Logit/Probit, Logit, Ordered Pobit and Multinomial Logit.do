clear
set more off, perm
* import LFS_2020B_users.csv
import delimited "C:\Users\Κωστας\Desktop\micro\LFS_2020B_users.csv", delimiter(";") clear
keep if age>=25 & age<=54

*QUESTION 1
**Generate new variables**
*Gender (0/1)*
gen sex=.
replace sex=0 if a07==1 //male
replace sex=1 if a07==2 //female

*High Education (0/1)*
destring e80_2, replace
gen higheduc=e80_2
recode higheduc 1=0 2=0 3=0 4=0 5=0 6=1 7=1

*Εmployment in the private sector (0/1)*
destring e15, replace
gen private_sector=.
replace private_sector=1 if e15==7
replace private_sector=0 if e15~=7

*without employment in the previous year (0/1)*
destring e91, replace
gen no_employment=e91
recode no_employment 1=0 2=1 3=0 4=0 5=0 6=0 7=0 8=0

*Marital status single (0/1)*
gen single=a11_r // 1 Single 2 Married 3 Widows-Divorced
recode single 1=1 2=0 3=0

*Country of birth native (0/1)*
gen native=a13_reu // 1 Greece 2 European Country 3 Other
recode native 1=1 2=0 3=0


*Νumber of hours worked*
destring e25_orr, replace
gen hours_worked=e25_orr

*Number of days worked*
destring e25_days, replace
gen days_worked=e25_days

*Employment category*
gen employment_category=e16_1
replace employment_category="7" if employment_category=="6"
replace employment_category="." if employment_category=="O"
destring employment_category,replace

*sector of economic activity*
encode e14_1,gen(sector_econ_activity)

*wage scale*

destring e95a, replace
destring e95, replace
gen wage_scale = .
replace wage_scale = 01 if e95 <= 399 | (e95a==01)
replace wage_scale = 02 if (e95 >=400 & e95 <=599) | (e95a==02)
replace wage_scale = 03 if (e95 >=600 & e95 <= 749) | (e95a==03)
replace wage_scale = 04 if (e95 >=750 & e95 <= 899) | (e95a==04)
replace wage_scale = 05 if (e95 >=900 & e95 <= 999) | (e95a==05)
replace wage_scale = 07 if (e95 >=1000& e95 <= 1199) | (e95a==06)
replace wage_scale = 07 if (e95 >=1200 & e95 <= 1399) | (e95a==07)
replace wage_scale = 08 if (e95 >=1400 & e95 <= 1799) | (e95a==08)
replace wage_scale = 09 if (e95 >=1800 & e95 <= 2499) | (e95a==09)
replace wage_scale = 10 if (e95 >=2500 & e95<9999) | (e95a==10)


*********************************************************************************************

*Question A

tab katap // Κατάστση Απασχόλησης (1 Απασχολούμενος 2 Άνεργος 3 Μη Οικονομικά Ενεργός)

tab katap if sex==1

gen katapfemale=.  // Female participation
replace katapfemale=1 if katap=="1" & sex==1
replace katapfemale=1 if katap=="2" & sex==1
replace katapfemale=0 if katap=="3" & sex==1
tab katapfemale


*OLS Model*
reg katapfemale c.age i.native i.single i.ypa_r i.higheduc, robust

*marginal effects/treatment effects*
margins, dydx(*) post
est store ols, title(Model1)


*Probit Model*
probit katapfemale c.age i.native i.single i.ypa_r  i.higheduc, robust

*marginal effects/treatment effects*
margins, dydx(*) post
est store probit, title(Model2)


*Logit Model*
logit katapfemale c.age i.native i.single i.ypa_r i.higheduc, robust

*marginal effects/treatment effects*
margins, dydx(*) post
est store logit, title(Model3)

esttab ols probit logit , label nogaps star(* 0.1 ** 0.05 *** 0.01)
outreg2 [Model1 Model2 Model3] using "Table 2a", title (Marginal Effects) replace tex word nocons label dec(3) 


********************************************************************************************************************
*Question B

*Multinominal Logit*

destring katap,replace

mlogit katap c.age i.native i.single i.ypa_r i.higheduc //baseoutcome 1
margins, dydx(*) predict(outcome(1)) post
est store Model111 

mlogit katap c.age i.native i.single i.ypa_r i.higheduc, baseoutcome(2)
margins, dydx(*) predict(outcome(2)) post
est store Model222
mlogit katap c.age i.native i.single i.ypa_r i.higheduc, baseoutcome(3)
margins, dydx(*) predict(outcome(3)) post
est store Model333

esttab Model1 Model2 Model3 , label nogaps star(* 0.1 ** 0.05 *** 0.01)
outreg2 [Model111 Model222 Model333] using "Table 3", title (Marginal Effects) replace tex word nocons label dec(3) 

*marginal effects/treatment effects*


***********************************************************************************************
*Question C

*(1)employed worker*
destring e17_r3, replace
gen employedworker=e17_r3
recode employedworker 1=0 2=1 3=0


*(2)full-time employment*
destring e23, replace
gen fulltime_employ=e23
replace fulltime_employ=0 if e23==2

*(3)employment at least 5 days per week*
gen five_days=days_worked
recode five_days 1=0 2=0 3=0 4=0

*(4)employment at least 35 hours per week*
gen employ35=hours_worked
replace employ35=0 if hours_worked<35

*(5)employment category*
gen employment_category9=e16_1
replace employment_category9="." if e16_1=="O"

*(6) employmnent except for agriculture
gen notagricul=e14_1
replace notagricul="." if notagricul=="01A"

*(7) wage level
gen wage_level=wage_scale
replace wage_level=0 if e95==9999



****Assumptions****
keep if  employedworker==1 & fulltime_employ==1 & five_days~=0 & employ35~=0 & employment_category9~="." & notagricul~="." & wage_level~=0
sum higheduc private_sector no_employment single native hours_worked days_worked  employment_category sector_econ_activity wage_scale
bys sex:sum higheduc private_sector no_employment single native hours_worked days_worked  employment_category sector_econ_activity wage_scale


**Ordered probit**
oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity

*marginal effects*

margins, dydx(*) predict(outcome(1)) atmean post
est store Model4 
 
oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity
margins, dydx(*) predict(outcome(2)) atmean post
est store Model5 

oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity
margins, dydx(*) predict(outcome(3)) atmean post
est store Model6

oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity 
margins, dydx(*) predict(outcome(4)) atmean post
est store Model7 

oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity
margins, dydx(*) predict(outcome(5)) atmean post
est store Model8

oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity 
margins, dydx(*) predict(outcome(7)) atmean post
est store Model9 

oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity
margins, dydx(*) predict(outcome(8)) atmean post
est store Model10 

oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity
margins, dydx(*) predict(outcome(9)) atmean post
est store Model11

oprobit wage_scale i.sex i.higheduc i.private_sector i.no_employment i.single i.native hours_worked days_worked i.employment_category i.sector_econ_activity
margins, dydx(*) predict(outcome(10)) atmean post
est store Model12

esttab Model4 Model5 Model6 Model7 Model8 Model9 Model10 Model11 Model12, label nogaps star(* 0.1 ** 0.05 *** 0.01) 
outreg2 [Model4 Model5 Model6 Model7 Model8] using "Table 3a", title (Marginal Effects) replace tex word nocons label dec(3) 
outreg2 [Model9 Model10 Model11 Model12] using "Table 3b", title (Marginal Effects) replace tex word nocons label dec(3) 






