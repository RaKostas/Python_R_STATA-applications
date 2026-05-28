use http://fmwww.bc.edu/repec/bocode/c/CardKrueger1994.dta, clear

edit

tab t

tab t trea

*diff fte,t(treated) p(t)

sum fte
*pinakas gia nov=1
bys treated:sum fte if t==1
*pinakas gia feb=0 
bys treated:sum fte if t==0


*d-i-d  model 1
tab t treated, sum(fte) nofreq mean

reg fte i.t i.treated

reg fte i.t##i.treated

reg fte i.t##i.treated i.bk i.kfc i.roys

*****************************

margins t#treated

*************************
