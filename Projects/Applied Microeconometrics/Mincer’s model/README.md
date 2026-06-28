# Mincer's Earnings Function — Applied Microeconometrics in Stata

**MSc in Applied Economics and Data Analysis**  
School of Economics and Business Administration, Department of Economics  
*Supervisor: Prof. Nikolaos Giannakopoulos*

---

## Overview

This project implements and analyses **Mincer's Earnings Function** — one of the most influential models in labour economics — using real-world data from 1975. The analysis is conducted entirely in **Stata** and follows the theoretical framework outlined in:

> Heckman, J., Lochner, L., & Todd, P. (2003). *Fifty Years of Mincer Earnings Regressions*. NBER Working Paper No. 9732.

The goal is to quantify how **education** and **work experience** affect individual hourly wages, and to explore the diminishing marginal returns of experience and the simultaneous effect of education and experience through an interaction term.

---

## File Description

| File | Description |
|------|-------------|
| `mincer_earnings.do` | Full Stata script: data preparation, visualisations, three OLS regression models, and diagnostic plots |


> **Dataset:** Cross-sectional microeconomic data from 1975 (women aged 30–54). Source: university e-class platform. Not included in this repository due to data access restrictions — contact the course instructor for access.

---

## Theoretical Background

Mincer's model describes the relationship between log wages, education, and experience:

```
ln(wage) = α + r·S + β₁·Exper + β₂·Exper² + ε
```

Where:
- `S` = years of schooling
- `Exper` = years of potential work experience
- `Exper²` = squared experience (captures diminishing returns)
- `r` = rate of return to education (Mincer's key parameter)
- `ε` = disturbance term

The log-linear specification means coefficients are interpreted as **percentage changes**: a coefficient of 0.11 on education means one additional year of schooling raises wages by approximately 11%.

The concave income-experience profile (positive `Exper` coefficient, negative `Exper²` coefficient) reflects the empirical regularity that wage growth slows with age and eventually turns negative near retirement.

---

## Data Preparation

**Original dataset:** Cross-sectional observations of men and women in 1975  
**Working sample:** Women aged 30–54 with hourly wage > 0  
**Final sample size: 403 observations**

Filtering steps:
1. Kept only variables: `age`, `wage`, `educ`, `exper`
2. Restricted age: 30 ≤ age ≤ 54
3. Restricted wage: removed zero-wage observations (wage ≥ 0.1282)
4. Total dropped: 350 observations

### Descriptive Statistics

| Variable | Obs | Mean | Std. Dev. | Min | Max |
|----------|-----|------|-----------|-----|-----|
| wage ($/hr) | 403 | 4.12 | 3.15 | 0.16 | 25.00 |
| educ (years) | 403 | 12.67 | 2.28 | 5 | 17 |
| exper (years) | 403 | 12.46 | 7.30 | 0 | 35 |

Key observations:
- Average wage of $4.12/hr reflects 1975 female labour market conditions
- Most women in the sample have completed high school (~12.67 years education)
- Wide experience range (0–35 years) with high standard deviation

---

## Log Transformation

A log transformation is applied to the wage variable before regression. This is standard practice in earnings models for three reasons:
1. Raw wages are **right-skewed** — the log transformation brings the distribution closer to normal
2. Coefficients are directly interpretable as **percentage effects**
3. Outlier wages have less distorting influence

### Scatter Plot: Wage and Log Wage vs Education

![Scatter wage vs education](images/Scatter%20wage%20vs%20education.png)

The blue dots (raw wage) show high variance at upper education levels. The red dots (log wage) are more evenly spread, confirming the stabilising effect of the transformation.

### Kernel Density: Raw Wage (right-skewed)

![Kernel density wage](images/Kernel%20density%20wage.png)

The distribution is heavily right-skewed — most observations cluster around $2–$5/hr with a long tail toward high earners.

### Kernel Density: Log Wage (approximately normal)

![Kernel density log wage](images/Kernel%20density%20log%20wage.png)

After transformation, the distribution is approximately bell-shaped and symmetric — suitable for OLS regression.

---

## Regression Models

### Model 1 — Basic Mincer (no diminishing returns)

```
log_wage = β₀ + β₁·educ + β₂·exper + ε
```

| Variable | Coefficient | Std. Error | Significance |
|----------|------------|------------|--------------|
| educ | 0.111 | 0.013 | *** (p<0.01) |
| exper | 0.019 | 0.004 | *** (p<0.01) |
| **R²** | **0.165** | | |

**Interpretation:**
- One additional year of education → **+11% wage increase** (t = 8.3, highly significant)
- One additional year of experience → **+1.9% wage increase** (t = 4.42, highly significant)
- Both variables reject H₀ (coefficient = 0) at the 1% significance level

---

### Model 2 — Mincer with Diminishing Returns (experience²)

```
log_wage = β₀ + β₁·educ + β₂·exper + β₃·exper² + ε
```

| Variable | Coefficient | Std. Error | Significance |
|----------|------------|------------|--------------|
| educ | 0.109 | 0.013 | *** (p<0.01) |
| exper | 0.047 | 0.016 | *** (p<0.01) |
| exper² | -0.001 | 0.000 | ** (p<0.05) |
| **R²** | **0.173** | | |

**Interpretation:**
- Education effect stable: still ~**+10.9% per year** (t = 8.10)
- Experience effect rises to **+4.7% per year** when diminishing returns are accounted for (t = 2.92)
- The **negative coefficient on exper²** (−0.001) confirms diminishing returns — wage growth from experience decelerates as years accumulate
- R² improves from 0.165 → 0.173, confirming Model 2 is a better fit

---

### Model 3 — Interaction Term (subsample: high education, low experience)

```
wage = β₀ + β₁·educ + β₂·exper + β₃·(educ × exper) + ε
```

**Subsample:** Women with educ ≥ 13 years AND exper ≤ 10 years → **66 observations**

Research hypothesis: *Do highly educated women with little experience earn less?*  
H₀: β₃ = 0 (interaction has no effect)

| Variable | Coefficient | Std. Error | Significance |
|----------|------------|------------|--------------|
| educ | 1.007 | 0.413 | ** (p<0.05) |
| exper | 0.449 | 1.032 | — |
| educ × exper | -0.022 | 0.066 | — |
| **R²** | **0.178** | | |

**Interpretation:**
- The interaction term (`edxp`) is **not statistically significant** — we fail to reject H₀
- **Conclusion:** Highly educated women with limited experience do **not** earn significantly less than their peers
- Only education remains a significant predictor in this subsample

---

## Diagnostic Plots

Added-Component-Plus-Residual (ACPR) plots are used after Model 2 to check whether the functional form of each variable is correctly specified. Non-linearity in the ACPR plot for a variable would suggest a transformation is needed.

```stata
acprplot educ , lowess
acprplot exper , lowess
acprplot exp2 , lowess
```

A matrix plot (`graph matrix`) visualises pairwise relationships between all four variables: `log_wage`, `educ`, `exper`, `exp2`.

---


---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
