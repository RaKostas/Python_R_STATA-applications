
# Panel Data Analysis: Fixed Effects, Random Effects & OLS — Stata

**MSc in Applied Economics and Data Analysis**  
School of Economics and Business Administration, Department of Economics  
*Supervisor: Prof. Nikolaos Giannakopoulos*

---

## Overview

This project demonstrates the full **panel data econometrics workflow** in Stata — from data retrieval and preparation through pooled OLS, Fixed Effects (FE), and Random Effects (RE) estimation — applied to World Bank cross-country data (1990–present).

The research context is the relationship between **Total Fertility Rate (TFR)** and **Female Labour Force Participation Rate (LFPR)** across OECD and Eurozone countries, replicating and extending Kögel (2004).

**The primary value of this project is methodological:** it shows how panel methods correct for the biases that pooled OLS introduces when unobserved heterogeneity is present — and demonstrates when and why FE vs RE should be chosen.

---

## Key Techniques Demonstrated

| Technique | Purpose |
|-----------|---------|
| **Pooled OLS with clustered SE** | Baseline estimation; establishes the naive correlation |
| **`xtset` panel declaration** | Sets the panel (country) and time (year) dimensions in Stata |
| **Fixed Effects (`xtreg, fe`)** | Removes all time-invariant country heterogeneity (culture, institutions, geography) by within-group demeaning |
| **Random Effects (`xtreg, re`)** | Assumes country effects are uncorrelated with regressors; more efficient but stronger assumption |
| **Clustered standard errors** | Correct inference when observations within a country are correlated over time (`vce(cluster id)`) |
| **Log-log specification** | Coefficients interpreted directly as elasticities |
| **Missing value imputation** | Fill gaps in World Bank series using country-level means (`mdesc`) |
| **World Bank API (`wbopendata`)** | Live data pull of 19 World Bank indicators directly inside Stata |
| **Subsample robustness check** | Eurozone-only re-estimation to test whether the global result holds in a homogeneous group |
| **Progressive model building** | 6 OLS models adding controls sequentially to isolate the effect of each variable group |

---

## Why Fixed Effects and Random Effects?

Pooled OLS ignores the **panel structure** of the data and assumes all observations are independent. In cross-country panel data, this is violated in two ways:

1. **Unobserved heterogeneity:** Countries differ in time-invariant characteristics (culture, institutions, legal systems) that affect both fertility and labour participation but are not measured. OLS wrongly attributes this variation to the included regressors, causing omitted variable bias.

2. **Serial correlation:** Observations for the same country across years are correlated, inflating precision and producing misleading standard errors.

**Fixed Effects** solves problem 1 by demeaning within each country — it only uses variation *within* a country over time, completely eliminating any time-invariant confounders. It is the more conservative and robust choice.

**Random Effects** is more efficient but requires that country effects (`c_i`) are uncorrelated with the regressors. It uses both within- and between-country variation.

The **rho statistic** in the output (≈0.96 for FE, ≈0.88 for RE) tells you what fraction of total variance comes from unobserved country heterogeneity rather than the idiosyncratic error. Values this close to 1 confirm that heterogeneity is the dominant force in the data — and that OLS results were substantially biased.

---

## Data

**Source:** World Bank Open Data API — retrieved live in Stata using `wbopendata`  
**Coverage:** Countries worldwide, 1990–present (~207 countries, ~3,500–6,750 observations depending on model)  
**No external data file required** — the script fetches all data automatically (internet connection needed)

| Variable | World Bank Code | Description |
|----------|----------------|-------------|
| `ltfr` | SP.DYN.TFRT.IN | log(Total fertility rate) — **dependent variable** |
| `llfpr` | SL.TLF.ACTI.FE.ZS | log(Female labour force participation rate) |
| `lgdppc` | NY.GDP.PCAP.PP.KD | log(GDP per capita, PPP) |
| `lunem` | SL.UEM.TOTL.ZS | log(Unemployment rate) |
| `lsecedu` | SE.SEC.ENRR.FE | log(Female secondary school enrolment) |
| `lteredu` | SE.TER.ENRR.FE | log(Female tertiary school enrolment) |
| `lage2024`–`lage4549` | SP.POP.20xx.FE.5Y | log(Female population share by age group) |

---

## Model Progression

### OLS — Building up the specification

Six progressively richer pooled OLS models establish the baseline and motivate the panel approach:

| Model | Added Controls | LFPR Elasticity | R² |
|-------|---------------|-----------------|-----|
| 1 | None (bivariate) | −0.208*** | 0.028 |
| 2 | + Year trend | −0.193*** | 0.063 |
| 3 | + Country ID | −0.184*** | 0.076 |
| 4 | + Age structure (6 groups, 20–49) | +0.034 (NS) | **0.860** |
| 5 | + Education (secondary + tertiary) | −0.241*** | 0.745 |
| 6 | + GDP per capita + unemployment | −0.228*** | 0.645 |

Model 4 is the most instructive: once age structure is controlled, the LFPR effect vanishes entirely (R² jumps to 0.860). Age group 20–24 strongly increases TFR (+0.389***) while groups 35–49 have strong negative effects — showing that demographic composition was confounding the simpler models.

### Fixed Effects vs Random Effects — Worldwide

```stata
xtset id year               // declare panel structure
xtreg ltfr ..., fe          // fixed effects
xtreg ltfr ..., re          // random effects
```

| Variable | Fixed Effects | Random Effects |
|----------|:---:|:---:|
| log(LFPR) | −0.009 (NS) | −0.157** |
| log(GDP per capita) | +0.098** | −0.022 (NS) |
| log(Unemployment) | −0.036** | −0.050*** |
| log(Secondary education) | −0.072* | −0.105*** |
| log(Tertiary education) | −0.112*** | −0.112*** |
| Year | −0.003** | +0.001 (NS) |
| Observations | 3,508 | 3,508 |
| Countries | 207 | 207 |
| **rho** | **0.961** | **0.882** |

**The key result:** In FE, the LFPR effect on TFR becomes **statistically insignificant** once unobserved country effects are removed. The negative OLS result was largely driven by cross-country differences — not within-country dynamics. This directly replicates the finding of Kögel (2004).

---

## Scatter Plot: TFR vs LFPR by Income Level

![TFR vs LFPR by income level](images/TFR%20vs%20LFPR%20by%20income%20level.png)

The relationship is heterogeneous by income group — negative in high- and upper-middle-income countries, flat or positive in low-income countries. This motivates the fixed effects approach: pooling all countries in a single OLS line ignores this structural variation.

---

## Eurozone Robustness Check

The same FE and RE models are re-run on the **19 Eurozone countries** — a homogeneous subsample that shares a currency, common monetary policy, and similar institutional frameworks.

**Result:** The negative TFR–LFPR relationship found globally is **not statistically significant** within the Eurozone in any specification. Only tertiary education remains significant (FE: −0.148*, RE: −0.137**). This confirms that the global finding is partly a cross-country artifact and highlights the importance of subsample robustness checks in panel analysis.

---

## File Description

| File | Description |
|------|-------------|
| `tfr_lfpr_panel_analysis.do` | Full Stata script — data retrieval, variable construction, OLS Models 1–6, FE, RE, Eurozone subsample |

---

## Reference

> Kögel, T. (2004). Did the association between fertility and female employment within OECD countries really change its sign? *Journal of Population Economics*, 17(1), pp.45–65.

---



---

## License

MIT License — see [LICENSE](LICENSE) for details.
