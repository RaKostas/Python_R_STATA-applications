# Industrial Efficiency & Productivity Analysis in R

**Course:** Special Topics in Business Economics
**Professor:** Kounetas Konstantinos  


---

## What This Script Does

This R script analyzes the **production efficiency and total factor productivity** of 14 manufacturing industries across **France, Germany, and Spain** over the period 1995–2011. It is structured in three independent sections, each using a different econometric method.

**Input data:** `industries.xls` — a panel dataset with annual observations per country and industry containing:
- **Output:** `GVA` — Gross Value Added at fixed 2002 prices (million ECU)
- **Inputs:** `Capital` (EUR million), `Labor` (total), `Intermediate Inputs` (EUR million), `Energy Consumption` (HBO)

**14 industries:** Basic Metals · Chemicals · Coke · Electrical Equipment · Food · Leather · Machinery · Manufacturing · Other · Pulp · Rubber · Textiles · Transport · Wood

---

## Part 1 — Data Envelopment Analysis (DEA)

### What it does

The script loops over each year from **2005 to 2011** and runs two input-oriented DEA models using the `Benchmarking` package:
- **CRS model** (`RTS="crs"`) — assumes Constant Returns to Scale
- **VRS model** (`RTS="vrs"`) — assumes Variable Returns to Scale

For each year it collects the efficiency scores (`w$eff`) per country and industry, stacks all years into a single dataframe, and computes:

```
Scale Efficiency (SE) = TE_CRS / TE_VRS
```

A score of **1 = fully efficient**. Values below 1 indicate the proportion by which inputs could be reduced without losing output. It then prints `summary()` breakdowns for each of the 14 industries within each country.

### Results

The tables below show the **mean efficiency scores** across 2005–2011 per industry.

**Table 1 — France**

| Industry | TE_CRS | TE_VRS | Scale Eff. |
|---|---|---|---|
| Basic Metals | 0.6243 | 0.6266 | 0.9963 |
| **Chemicals** | **1** | **1** | **1** |
| Coke | 0.9025 | 0.9423 | 0.9591 |
| Electrical Equipment | 0.9778 | 0.9944 | 0.9832 |
| Food | 0.5128 | 0.5189 | 0.9873 |
| **Leather** | **1** | **1** | **1** |
| **Machinery** | **1** | **1** | **1** |
| Manufacturing | 0.7575 | 0.7705 | 0.9838 |
| Other | 0.6630 | 0.6967 | 0.9495 |
| Pulp | 0.6588 | 0.6716 | 0.9804 |
| Rubber | 0.9805 | 0.9915 | 0.9888 |
| **Textiles** | **1** | **1** | **1** |
| Transport | 0.6384 | 0.6648 | 0.9600 |
| Wood | 0.9566 | 0.9942 | 0.9619 |

**Table 2 — Germany**

| Industry | TE_CRS | TE_VRS | Scale Eff. |
|---|---|---|---|
| Basic Metals | 0.7489 | 0.7570 | 0.9890 |
| **Chemicals** | **1** | **1** | **1** |
| Coke | 0.2116 | 0.8345 | 0.2981 |
| **Electrical Equipment** | **1** | **1** | **1** |
| Food | 0.4425 | 0.4463 | 0.9919 |
| Leather | 0.7532 | 1 | 0.7532 |
| Machinery | 0.7378 | 0.7478 | 0.9872 |
| Manufacturing | 0.5882 | 0.5953 | 0.9880 |
| **Other** | **1** | **1** | **1** |
| Pulp | 0.7031 | 0.7046 | 0.9978 |
| Rubber | 0.9669 | 0.9687 | 0.9981 |
| Textiles | 0.7858 | 0.7928 | 0.9914 |
| Transport | 0.7818 | 0.7974 | 0.9808 |
| Wood | 0.6843 | 0.6888 | 0.9939 |

**Table 3 — Spain**

| Industry | TE_CRS | TE_VRS | Scale Eff. |
|---|---|---|---|
| Basic Metals | 0.5327 | 0.5347 | 0.9963 |
| Chemicals | 0.5296 | 0.5553 | 0.9530 |
| Coke | 0.5875 | 0.9696 | 0.5962 |
| Electrical Equipment | 0.4747 | 0.4864 | 0.9753 |
| Food | 0.3554 | 0.3574 | 0.9943 |
| Leather | 0.4924 | 0.5381 | 0.9143 |
| Machinery | 0.7360 | 0.7465 | 0.9859 |
| Manufacturing | 0.5640 | 0.5820 | 0.9684 |
| Other | 0.5530 | 0.5634 | 0.9811 |
| Pulp | 0.7376 | 0.7427 | 0.9931 |
| Rubber | 0.5229 | 0.5458 | 0.9576 |
| Textiles | 0.5653 | 0.5818 | 0.9721 |
| Transport | 0.3848 | 0.4073 | 0.9420 |
| Wood | 0.5185 | 0.5408 | 0.9586 |

> **France:** Chemicals, Leather, Machinery and Textiles achieve full Scale Efficiency (SE = 1). The Food industry is the worst technical performer (TE_CRS = 0.51 — must reduce inputs by ~50%).  
> **Germany:** Chemicals, Electrical Equipment and Other are fully scale-efficient. The Coke sector is the extreme outlier with TE_CRS = 0.21 and SE = 0.30 — it needs to change inputs by ~70%.  
> **Spain:** No industry reaches full scale efficiency. Efficiency levels are uniformly lower than in the other two countries.

The script produces three **kernel density plots** — one for TE_CRS, one for TE_VRS, and one for Scale Efficiency — showing the distribution of scores across all industries and years combined for the three countries:

![Figure 1 — Density Plots of Efficiency](assets/plots/fig1_density_efficiency.png)

The CRS and VRS density curves show a bimodal distribution — a cluster of lower-efficiency industries around 0.5–0.6 and a second peak near 1.0. The Scale Efficiency plot shows a sharp spike at 1.0, confirming that most industries operate close to their optimal scale even when their technical efficiency is lower.

---

## Part 2 — Malmquist Productivity Index (MPI)

### What it does

The script filters each country's data to just the years **2000 and 2010** and calls `malm()` from the `productivity` package with VRS, input-oriented orientation. The Malmquist index measures how much **Total Factor Productivity (TFP)** changed between the two periods and decomposes it into:

- **Efficiency Change (effch):** Did industries close the gap to the frontier?
- **Technical Change (tech):** Did the frontier itself shift (innovation)?

A value **> 1 = improvement**, **< 1 = deterioration**, **= 1 = no change**. This is run separately for France, Germany, and Spain.

### Results

**Table 4 — Malmquist Index in France (2000 → 2010)**

| Industry | Malmquist | Effic. Change | Tech. Change |
|---|---|---|---|
| Basic Metals | 0.7908 | 0.8228 | 0.9611 |
| Chemicals | 1.0731 | 1.0000 | 1.0731 |
| **Coke** | **1.4190** | 1.0423 | 1.3614 |
| Electrical Equipment | 1.3478 | 1.0000 | 1.3478 |
| Food | 0.8778 | 0.7434 | 1.1809 |
| Leather | 0.9784 | 1.0000 | 0.9784 |
| Machinery | 1.2569 | 1.0000 | 1.2569 |
| Manufacturing | 0.8248 | 0.8720 | 0.9458 |
| Other | 0.8809 | 1.0000 | 0.8809 |
| Pulp | 1.0367 | 1.0599 | 0.9781 |
| Rubber | 1.1728 | 1.0000 | 1.1728 |
| Textiles | 1.4109 | 1.0000 | 1.4109 |
| Transport | 1.0873 | 0.7396 | 1.4700 |
| Wood | 1.2003 | 1.0379 | 1.1564 |
| **Mean** | **1.0057** | 1.0265 | 1.2240 |

**Table 5 — Malmquist Index in Germany (2000 → 2010)**

| Industry | Malmquist | Effic. Change | Tech. Change |
|---|---|---|---|
| Basic Metals | 1.0529 | 0.8384 | 1.2559 |
| Chemicals | 1.5555 | 1.0000 | 1.5555 |
| Coke | 0.5013 | 0.2872 | 1.7454 |
| Electrical Equipment | 1.4213 | 1.0000 | 1.4213 |
| Food | 0.6945 | 0.5290 | 1.3128 |
| Leather | 1.0632 | 0.8444 | 1.2591 |
| Machinery | 0.9415 | 0.7221 | 1.3039 |
| Manufacturing | 0.8871 | 0.6978 | 1.2714 |
| Other | 1.1843 | 1.0000 | 1.1843 |
| Pulp | 0.8922 | 0.7292 | 1.2235 |
| Rubber | 1.1786 | 1.0101 | 1.1668 |
| Textiles | 1.1081 | 0.8836 | 1.2541 |
| **Transport** | **1.5990** | 0.9071 | **1.7628** |
| Wood | 1.0057 | 0.7000 | 1.2780 |
| **Mean** | **1.1527** | 0.8697 | 1.3568 |

**Table 6 — Malmquist Index in Spain (2000 → 2010)**

| Industry | Malmquist | Effic. Change | Tech. Change |
|---|---|---|---|
| Basic Metals | 1.0134 | 0.9665 | 1.0486 |
| Chemicals | 1.0895 | 1.0000 | 1.0895 |
| **Coke** | **0.3457** | 1.0000 | **0.3457** |
| Electrical Equipment | 0.9511 | 1.0023 | 0.9489 |
| Food | 1.0802 | 0.9029 | 1.1964 |
| Leather | 0.5772 | 0.6880 | 0.8389 |
| Machinery | 0.9371 | 1.0000 | 0.9371 |
| Manufacturing | 0.6363 | 0.7591 | 0.8382 |
| Other | 0.9643 | 1.0000 | 0.9643 |
| Pulp | 1.0232 | 1.0000 | 1.0232 |
| Rubber | 1.0880 | 0.9781 | 1.1124 |
| Textiles | 0.6766 | 0.7913 | 0.8551 |
| Transport | 1.1455 | 0.9461 | 1.2108 |
| Wood | 1.0253 | 1.1001 | 0.9320 |
| **Mean** | **0.8967** | 0.9382 | 0.9529 |

The script produces histogram panels for each country showing the distribution of the Malmquist index across the 14 industries:

![Figure 2 — Malmquist Index For Each Country](assets/plots/fig2_malmquist.png)

> **France** (mean MPI = 1.006): Most industries improved. Coke had the largest gain (+42%). Basic Metals deteriorated the most (MPI = 0.79).  
> **Germany** (mean MPI = 1.15): Strongest overall growth (+15%). Transport leads at MPI = 1.60, driven by a +76% technology advance. Coke collapsed (MPI = 0.50) due to severe efficiency loss.  
> **Spain** (mean MPI = 0.90): The only country with an **overall productivity decline**. Coke was devastated (MPI = 0.35) entirely due to technology deterioration. Transport is the one bright spot across all three countries.

---

## Part 3 — Stochastic Frontier Analysis (SFA)

### What it does

The script estimates a **parametric production frontier** for France and Germany using the `frontier` package's `sfa()` function on the full time series. Each country's data is first converted to a panel dataframe with `pdata.frame()` (from the `plm` package). Two production function specifications are estimated and compared:

**Cobb-Douglas** (log-linear):
```
ln(GVA) = β₀ + β₁ln(K) + β₂ln(L) + β₃ln(II) + β₄ln(EC) + v - u
```

**Translog** (flexible — adds squared and cross terms for all four inputs):
```
ln(GVA) = β₀ + Σβᵢln(xᵢ) + Σβᵢᵢ·0.5·ln(xᵢ)² + Σβᵢⱼ·ln(xᵢ)·ln(xⱼ) + v - u
```

The **Likelihood Ratio (LR) test** (`logLik()`) confirms whether the Translog model fits better. Efficiency scores are then extracted from the winning model using `eff(model, asInData=TRUE)` and appended back to the data, followed by a density plot and per-industry summaries.

### Model Estimation Results

**Table 7 — SFA France**

| Variable | Cobb-Douglas Coeff. | t-value | Translog Coeff. | t-value |
|---|---|---|---|---|
| log(Capital) | 0.022 | 0.68 | 1.416 | **4.36** |
| log(Labor) | 0.478 | **18.61** | 0.691 | 1.71 |
| log(Intermediate Inputs) | 0.502 | **17.30** | 0.937 | **2.12** |
| log(Energy Consumption) | −0.013 | −1.12 | −0.567 | **−4.03** |
| Intercept | 1.259 | **8.07** | −6.104 | **−3.67** |
| σ²ᵤ | 0.0029 | 0.69 | 0.0034 | **62.19** |
| σ²ᵥ | 0.0377 | **9.78** | 0.0196 | **11.99** |
| **Mean Efficiency** | **0.9953** | | **0.9949** | |
| Observations | 238 | | 238 | |
| LR Test | −0.126 (6 df, p=0) | | −0.091 (16 df, p=0) | |

**Table 8 — SFA Germany**

| Variable | Cobb-Douglas Coeff. | t-value | Translog Coeff. | t-value |
|---|---|---|---|---|
| log(Capital) | 0.637 | **8.46** | −0.614 | −0.88 |
| log(Labor) | 0.707 | **10.93** | 0.710 | 1.13 |
| log(Intermediate Inputs) | −0.256 | **−4.27** | −0.005 | −0.005 |
| log(Energy Consumption) | −0.044 | **−2.09** | 1.440 | **4.11** |
| Intercept | 2.902 | **9.22** | 5.349 | 1.57 |
| σ²ᵤ | 0.065 | 0.66 | 0.012 | **7.19** |
| σ²ᵥ | 0.070 | 1.99 | 0.048 | **12.01** |
| **Mean Efficiency** | **0.9786** | | **0.9908** | |
| Observations | 238 | | 238 | |
| LR Test | 0.008 (6 df, p=0) | | −1.375 (16 df, p=0) | |

The Translog model is selected in both countries (LR test p-value = 0). Efficiency scores are extracted from the Translog model and plotted as density curves:

### Industry-Level SFA Efficiency

**Table 9 — France (Translog)** | **Table 10 — Germany (Translog)**

| Industry | France | Germany |
|---|---|---|
| Basic Metals | 0.9953 | 0.9920 |
| Chemicals | 0.9948 | 0.9908 |
| Coke | 0.9946 | 0.9861 |
| Electrical Equipment | 0.9941 | 0.9901 |
| Food | 0.9962 | **0.9937** |
| **Leather** | **0.9932** | **0.9878** |
| Machinery | 0.9942 | 0.9913 |
| Manufacturing | 0.9956 | 0.9923 |
| Other | 0.9948 | 0.9911 |
| Pulp | 0.9950 | 0.9926 |
| Rubber | 0.9949 | 0.9903 |
| Textiles | 0.9955 | 0.9898 |
| **Transport** | **0.9966** | 0.9933 |
| Wood | 0.9944 | 0.9903 |
| **Mean** | **0.9949** | **0.9908** |

**Figure 3 — SFA Efficiency Density, France**

![Figure 3 — Density Plot of Efficiency in France](assets/plots/fig3_sfa_france.png)

**Figure 4 — SFA Efficiency Density, Germany**

![Figure 4 — Density Plot of Efficiency in Germany](assets/plots/fig4_sfa_germany.png)

> The France density curve shows a **bimodal distribution** — a small cluster around 0.992–0.993 and the main mass centered around 0.994–0.996, indicating most industries are near-frontier but a few lag slightly.  
> Germany's density shows a **tighter, single-peaked curve** at ~0.991, indicating more uniformly distributed (and slightly lower) efficiency scores across industries.  
> **Leather is the worst-performing industry in both countries** (France: 0.9932, Germany: 0.9878). Transport leads France (0.9966), Food leads Germany (0.9937).

---

## Required R Packages

```r
library(readxl)       # Read Excel data files
library(lpSolveAPI)   # Linear programming (dependency for DEA)
library(ucminf)       # Unconstrained minimization (used by SFA optimizer)
library(Benchmarking) # DEA — dea()
library(productivity) # Malmquist index — malm()
library(frontier)     # SFA — sfa(), eff()
library(sfa)          # Additional SFA utilities
library(plm)          # Panel data frames — pdata.frame()
library(pastecs)      # Descriptive statistics — stat.desc()
library(ggpubr)       # Plot helpers
library(lmtest)       # Hypothesis testing
```

---

## References

1. Farrell, M.J. (1957). The measurement of productive efficiency. *Journal of the Royal Statistical Society*.
2. Charnes, A. et al. (1978). Measuring the efficiency of decision making units. *European Journal of Operational Research*.
3. Caves, D.W. et al. (1982). The economic theory of index numbers and the measurement of input, output, and productivity. *Econometrica*.
4. Aigner, D., Lovell, C.K., & Schmidt, P. (1977). Formulation and estimation of stochastic frontier production function models. *Journal of Econometrics*.
5. Banker, R.D. (1984). Estimating most productive scale size using data envelopment analysis. *European Journal of Operational Research*.
6. Coelli, T.J. et al. (2005). *An Introduction to Efficiency and Productivity Analysis*. Springer.
