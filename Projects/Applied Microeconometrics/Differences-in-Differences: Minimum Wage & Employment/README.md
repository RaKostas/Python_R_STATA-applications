# Differences-in-Differences: Minimum Wage & Employment — Stata

**MSc in Applied Economics and Data Analysis**  
Department of Economics, University of Patras  
*January 2021*

---

## Overview

This project implements the **Differences-in-Differences (DiD)** causal inference method to estimate the effect of a minimum wage increase on fast-food employment, replicating the landmark study of **Card & Krueger (1994)** — one of the most cited and debated papers in labour economics.

The analysis uses the original Card & Krueger dataset of 410 fast-food restaurants across New Jersey (treated) and Pennsylvania (control), observed before and after New Jersey raised its minimum wage from $4.25 to $5.05/hr in 1992.

**The primary value of this project is methodological:** it demonstrates how DiD isolates a causal effect from observational data by using a natural experiment — without randomisation — and why it is more credible than a simple before/after or cross-sectional comparison.

**References:**
> Card, D. & Krueger, A.B. (1994). Minimum wages and employment: A case study of the fast food industry in New Jersey and Pennsylvania. *American Economic Review*, 84(4), pp.772–793.
>
> Neumark, D. & Wascher, W. (2006). Minimum wages and employment: A review of evidence from the new minimum wage research. *NBER Working Paper No. 12663*.

---

## Key Techniques Demonstrated

| Technique | Purpose |
|-----------|---------|
| **Differences-in-Differences (DiD)** | Causal identification using a natural experiment — isolates the policy effect from pre-existing trends |
| **Parallel trends assumption** | The core identifying assumption: in the absence of the policy, NJ and PA employment would have followed the same trend |
| **Interaction term (`i.t##i.treated`)** | Stata syntax for the DiD estimator — the coefficient on `treated × post` is δ (the causal effect) |
| **Treatment & control group logic** | NJ = treated (minimum wage raised); PA = control (no change) |
| **Pre/post indicator variables** | `t = 0` (Feb 1992, before reform) and `t = 1` (Nov 1992, after reform) |
| **OLS with chain fixed effects** | Second model adds restaurant chain dummies (BK, KFC, Roy Rogers, Wendy's) to control for chain-level heterogeneity |
| **`margins` post-estimation** | Computes predicted employment by treatment × time cell to read off the DiD table directly |
| **Replication study** | Uses the original Card & Krueger dataset loaded directly from a public URL — fully reproducible |

---

## Why Differences-in-Differences?

A naive **before/after comparison** in New Jersey alone would confound the policy effect with any other changes happening at the same time (recession, seasonal effects, etc.). A naive **cross-sectional comparison** between NJ and PA after the reform would confound the policy effect with pre-existing differences between the two states.

DiD solves both problems by combining the two comparisons:

```
DiD = (NJ_after − NJ_before) − (PA_after − PA_before) = δ
```

This "double difference" removes:
- **Time-invariant differences** between NJ and PA (the first difference within each state)
- **Common time trends** affecting both states equally (the second difference across states)

What remains — δ — is the causal effect of the policy, **under the parallel trends assumption**: that NJ employment would have followed the same trend as PA in the absence of the wage increase.

---

## Data

**Source:** Card & Krueger (1994) dataset, loaded directly from the Boston College public repository:
```stata
use http://fmwww.bc.edu/repec/bocode/c/CardKrueger1994.dta, clear
```

No external file needed — the script loads the data automatically.

| Variable | Description |
|----------|-------------|
| `id` | Restaurant identifier (410 stores) |
| `t` | Time: 0 = February 1992 (pre-policy), 1 = November 1992 (post-policy) |
| `treated` | Treatment group: 1 = New Jersey (policy applied), 0 = Pennsylvania (control) |
| `fte` | Full-time equivalent employment (outcome variable) |
| `bk` | Dummy = 1 if Burger King restaurant |
| `kfc` | Dummy = 1 if KFC restaurant |
| `roys` | Dummy = 1 if Roy Rogers restaurant |
| `wendys` | Dummy = 1 if Wendy's restaurant |

**Sample structure:** 410 restaurants × 2 time periods = **820 observations** (balanced panel)

| State | Stores (pre) | Stores (post) |
|-------|-------------|--------------|
| Pennsylvania (control) | 79 | 79 |
| New Jersey (treated) | 331 | 331 |
| **Total** | **410** | **410** |

---

## Descriptive Statistics

Average full-time equivalent employment before and after the reform:

| | Before (Feb 1992) | After (Nov 1992) | Change |
|-|:-:|:-:|:-:|
| **Pennsylvania (control)** | 19.95 | 17.54 | −2.41 |
| **New Jersey (treated)** | 17.07 | 17.57 | +0.50 |

**DiD = (+0.50) − (−2.41) = +2.91**

PA employment fell while NJ employment rose slightly — the raw DiD already points to a positive effect of the minimum wage increase on employment.

---

## Empirical Model

```
FTE_it = β₁ + β₂·Treated_i + β₃·Post_t + β₄·(Treated × Post)_it + ε_it
```

Where:
- `β₂` = average employment difference between NJ and PA (pre-existing gap)
- `β₃` = time trend common to both states
- **`β₄` = DiD estimator = causal effect of the minimum wage policy (δ)**

The four cells of the DiD table map to:

| | Pre (t=0) | Post (t=1) |
|-|:-:|:-:|
| **PA (control)** | β₁ | β₁ + β₃ |
| **NJ (treated)** | β₁ + β₂ | β₁ + β₂ + β₃ + **β₄** |

---

## Results

### DiD Table (from `margins`)

| | NJ | PA | Difference |
|-|:-:|:-:|:-:|
| Before | 17.07 | 19.95 | −2.88 |
| After | 17.57 | 17.54 | +0.03 |
| **Change** | **+0.50** | **−2.41** | **DiD = +2.91** |

### Regression Results

|  | Model 1 | Model 2 |
|--|:-------:|:-------:|
| **Specification** | Basic DiD | DiD + chain dummies |
| Post (Nov 1992) | −2.407* | −2.403* |
| New Jersey | −2.884** | −2.324** |
| **DiD (Treated × Post)** | **+2.914*** | **+2.935**** |
| Burger King | — | +0.917 |
| KFC | — | −9.205*** |
| Roy Rogers | — | −0.897 |
| Constant | 19.949*** | 21.161*** |
| Observations | 801 | 801 |
| R² | 0.008 | 0.188 |

*Standard errors in parentheses. \*\*\* p<0.01, \*\* p<0.05, \* p<0.1*

**Key findings:**
- The DiD coefficient (+2.914 in Model 1, +2.935 in Model 2) is **positive and statistically significant** — the minimum wage increase in NJ led to approximately **2.9 more FTE employees** per restaurant relative to PA
- This replicates the Card & Krueger (1994) finding: raising the minimum wage did **not** reduce employment — contrary to the standard competitive model prediction
- Adding chain fixed effects (Model 2) increases R² from 0.008 to 0.188 and strengthens the DiD estimate's significance (from 10% to 5%)
- **KFC** is a notable outlier: −9.2 employees after the reform (highly significant), suggesting chain-specific factors beyond the policy
- The NJ coefficient (−2.884**) confirms a pre-existing employment gap between NJ and PA restaurants that is unrelated to the policy

---

---

## License

MIT License — see [LICENSE](LICENSE) for details.
