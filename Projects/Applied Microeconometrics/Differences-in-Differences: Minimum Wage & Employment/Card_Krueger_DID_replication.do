/*===========================================================================
  PROJECT:  Minimum Wage & Employment — Differences-in-Differences
            Replication of Card & Krueger (1994)
  DATE:     January 2021

  Two regression models are estimated:
    Model 1 — Basic DiD (treatment × post interaction only)
    Model 2 — DiD with restaurant chain fixed effects (BK, KFC, Roy Rogers)
 DATA:
  CardKrueger1994.dta — loaded directly from the Boston College public
  repository.
===========================================================================*/


use http://fmwww.bc.edu/repec/bocode/c/CardKrueger1994.dta, clear


* Check time periods and cross-tabulation of time × treatment
tab t

tab t trea

*diff fte,t(treated) p(t)

* Overall summary of the outcome variable
sum fte

* Mean FTE after the reform (November 1992, t=1) by treatment group
bys treated:sum fte if t==1

* Mean FTE before the reform (February 1992, t=0) by treatment group
bys treated:sum fte if t==0


* Two-way table of mean FTE by time and treatment — the raw DiD table
* Rows: time periods (0=pre, 1=post), Columns: treatment groups (0=PA, 1=NJ)
tab t treated, sum(fte) nofreq mean


/*---------------------------------------------------------------------------
*REGRESSION MODELS

 i.t##i.treated generates:
    - main effect of t (Post dummy)
    - main effect of treated (NJ dummy)
    - interaction term t#treated (the DiD coefficient = causal effect δ)

  MODEL 1: Basic DiD
    Estimates the pure causal effect of the reform with no additional controls.

  MODEL 2: DiD + Chain Fixed Effects
    Adds restaurant chain dummies to control for chain-level employment
    differences unrelated to the policy (e.g. KFC tends to employ fewer
    workers than other chains).
---------------------------------------------------------------------------*/


* --- Preliminary: Main effects only (no interaction) ---
* Shows the individual effects of time and treatment before combining them.
reg fte i.t i.treated



* --- Model 1: Basic DiD ---
reg fte i.t##i.treated


* --- Model 2: DiD + chain fixed effects ---
reg fte i.t##i.treated i.bk i.kfc i.roys



/*---------------------------------------------------------------------------
 MARGINS (PREDICTED MEANS BY CELL)
  Post-estimation: compute predicted mean FTE for each treatment × time cell.
  This directly reads off the four cells of the DiD table:
    PA pre  | PA post
    NJ pre  | NJ post
  The DiD = (NJ post − NJ pre) − (PA post − PA pre)
---------------------------------------------------------------------------*/
* Re-run Model 1 (margins requires the last regression in memory)
reg fte i.t##i.treated

* Predicted means for each treatment × time cell
margins t#treated

*************************
