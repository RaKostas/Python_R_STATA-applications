# Probit, Logit, Ordered Probit & Multinomial Logit — Applied Microeconometrics in Stata

**MSc in Applied Economics and Data Analysis**  
School of Economics and Business Administration, Department of Economics  
*Supervisor: Prof. Nikolaos Giannakopoulos*

---

## Overview

This project applies a range of discrete choice econometric models to Greek Labour Force Survey (LFS) microdata from 2020 (Q2), sourced from the **Hellenic Statistical Authority (ELSTAT)**. The analysis is conducted entirely in **Stata** and covers four estimation methods:

- **OLS** (Linear Probability Model)
- **Probit**
- **Logit**
- **Multinomial Logit**
- **Ordered Probit**

The project addresses three research questions: what determines women's labour market participation in Greece, what predicts employment status for the overall population, and what factors drive an individual's wage bracket.

---

## File Description

| File | Description |
|------|-------------|
| `probit_logit_ordered.do` | Full Stata script: variable construction, three estimation questions, marginal effects, and table exports |
| `report.pdf` | Full written report with variable definitions, regression tables, and interpretation |

> **Dataset:** `LFS_2020B_users.csv` — Labour Force Survey, Greece, Q2 2020. Source: [ELSTAT public use files](https://www.statistics.gr/el/public-use-files). Not included in this repository. Download directly from the ELSTAT website.

---

## Dataset & Sample

**Source:** Hellenic Statistical Authority (ELSTAT), Labour Force Survey 2020 Q2  
**Initial filter:** Age 25–54  
**Working sample (Questions A & B):** 17,510 observations  
**Working sample (Question C):** 3,181–3,282 observations (full-time employed workers only)

### Variables Created

| Variable | Type | Description |
|----------|------|-------------|
| `sex` | Binary | 0 = Male, 1 = Female |
| `higheduc` | Binary | 0 = No higher education degree, 1 = University/Master's degree |
| `private_sector` | Binary | 0 = Public sector, 1 = Private sector |
| `no_employment` | Binary | 0 = Employed one year ago, 1 = Unemployed one year ago |
| `single` | Binary | 0 = Married/Widowed/Divorced, 1 = Single |
| `native` | Binary | 0 = Born outside Greece, 1 = Born in Greece |
| `hours_worked` | Continuous | Usual working hours per week |
| `days_worked` | Continuous | Usual working days per week |
| `employment_category` | Categorical | 1–9 (from senior management to unskilled workers) |
| `sector_econ_activity` | Categorical | 21 economic sectors (NACE classification) |
| `wage_scale` | Ordinal | 10 wage brackets from ≤€399 to ≥€2,500 |

---

## Question A — Women's Labour Market Participation (OLS, Probit, Logit)

**Research question:** What personal characteristics predict whether a woman (aged 25–54) participates in the Greek labour market?

**Dependent variable:** `katapfemale` — 1 if employed or unemployed (active in labour market), 0 if economically inactive

**Independent variables:** age, country of birth (native), marital status (single), region of residence (ypa_r), education level (higheduc)

Since the dependent variable is binary, **Probit and Logit** are the theoretically correct methods. OLS (Linear Probability Model) is included for comparison. All results are reported as **marginal effects** for consistent interpretation across models.

### Results — Marginal Effects

| Variable | OLS | Probit | Logit |
|----------|-----|--------|-------|
| Age | +0.003*** | −0.003*** | −0.000 |
| Native (=1) | +0.136*** | −0.096*** | −0.040*** |
| Single (=1) | −0.055*** | +0.069*** | −0.014** |
| High Education (=1) | +0.148*** | −0.044*** | −0.104*** |
| **Observations** | **17,510** | **17,510** | **17,510** |

*Robust standard errors. *** p<0.01, ** p<0.05, * p<0.1*

**Key findings:**
- **Education** is the strongest predictor: women with a higher education degree have approximately **+14.8% higher probability** of labour market participation (OLS), with consistent significance across all three models
- **Native-born** women are significantly more likely to participate (+13.6% OLS)
- **Single** women show higher participation likelihood (+6.9% Probit), reflecting that single women often depend solely on their own income
- Regional differences (ypa_r) exist relative to the base region of Eastern Macedonia and Thrace — Peloponnese and Attica show notably higher participation

> Note: OLS sign differences from Probit/Logit are expected — the Linear Probability Model does not account for the bounded [0,1] nature of a probability. Probit and Logit are the appropriate methods for binary outcomes.

---

## Question B — Employment Status for the Overall Population (Multinomial Logit)

**Research question:** What is the effect of individual characteristics on the probability of being employed, unemployed, or economically inactive?

**Dependent variable:** `katap` — 1 = Employed, 2 = Unemployed, 3 = Not economically active

Since the outcome has **three unordered categories**, Multinomial Logit is the appropriate method. Marginal effects are estimated separately for each outcome.

### Results — Multinomial Logit Marginal Effects

| Variable | Employed | Unemployed | Economically Inactive |
|----------|----------|------------|----------------------|
| Age | +0.003*** | −0.003*** | −0.000 |
| Native (=1) | +0.136*** | −0.096*** | −0.040*** |
| Single (=1) | −0.055*** | +0.069*** | −0.014** |
| High Education (=1) | +0.148*** | −0.044*** | −0.104*** |
| **Observations** | **17,510** | **17,510** | **17,510** |

*Robust standard errors. *** p<0.01, ** p<0.05, * p<0.1*

**Key findings:**
- **Age** raises probability of employment (+2.8%) and lowers unemployment (−2.6%) at 1% significance
- **Native-born** individuals are 13.6% more likely to be employed and 9.6% less likely to be unemployed
- **Single** individuals are 5.5% less likely to be employed but 7% more likely to be unemployed — consistent with greater economic pressure to seek work but also less stability
- **Higher education** raises employment probability by +14.8% and reduces economic inactivity by −10.4%

---

## Question C — Wage Scale Determinants (Ordered Probit)

**Research question:** What determines an individual's wage bracket in Greece?

**Dependent variable:** `wage_scale` — ordinal variable with 10 wage brackets (€0–399 up to €2,500+)

**Sample restrictions** (applied before estimation):
1. Currently employed (not self-employed/family worker)
2. Full-time employment
3. Working at least 5 days per week
4. Working at least 35 hours per week
5. Employment category must be non-missing (1–9)
6. Not working in agriculture
7. Wage information available

**Final sample:** 3,181 observations (1,830 men, 1,452 women)

### Descriptive Statistics by Sex

| Variable | Men (n=1,830) | Women (n=1,452) |
|----------|--------------|-----------------|
| Higher education (%) | 30.5% | 44.1% |
| Private sector (%) | 73.7% | 70.7% |
| Unmarried (%) | 32.0% | 23.1% |
| Native Greek (%) | 90.4% | 92.6% |
| Hours worked/week | 42.2 | 41.3 |
| Days worked/week | 5.24 | 5.19 |
| **Mean wage scale** | **4.31** | **3.87** |

Men average wage scale 4.31 vs women's 3.87 — indicating a persistent **gender wage gap** in the Greek labour market.

### Key Ordered Probit Findings

The model estimates marginal effects for each wage bracket. Key patterns:

- **Gender (female):** Women are significantly more likely to fall in the lower wage brackets (≤€899) and significantly less likely to earn above €1,000 — confirming a gender wage gap at 1% significance across all brackets
- **Higher education:** Strongly linked to higher wages. Highly educated workers are significantly more likely to earn above €900 and less likely to earn below €750
- **Private sector:** Private sector workers are more likely to earn low wages (≤€899) and less likely to earn above €900 — public sector employment offers more wage security in Greece
- **Employment category:** Senior management (base) consistently earns more than all other categories. All other categories (2–9) are significantly more likely to fall in lower wage brackets
- **Hours worked:** Each additional hour per week increases the probability of higher wages significantly
- **Economic sector:** Agriculture (base) workers are comparatively more likely to earn above €1,000 than workers in most other sectors, reflecting sector-specific collective bargaining agreements

---

## Key Skills Demonstrated

- **Discrete choice modelling:** Probit, Logit, Multinomial Logit, Ordered Probit
- **Marginal effects:** Computing and interpreting `margins, dydx(*)` in Stata for non-linear models
- **Model selection:** Justifying when OLS, Probit/Logit, Multinomial Logit, or Ordered Probit is appropriate
- **Complex variable construction:** Recoding, destringing, generating interaction-ready categorical variables from raw survey data
- **Real survey microdata:** Working with ELSTAT's Labour Force Survey — a large, messy, real-world dataset
- **Publication-quality output:** `outreg2` and `esttab` for Word/LaTeX regression tables
- **Gender wage analysis:** Interpreting sex-disaggregated descriptive statistics and regression outputs

---



## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
