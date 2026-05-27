# Regression, Gradient Descent & Cross-Validation in R and Python

**MSc in Applied Economics and Data Analysis**  
School of Economics and Business Administration, Department of Economics  
*Supervisor: Prof. Tzagarakis Manolis*



---

## Overview

This assignment focuses on regression estimation and optimisation algorithms — comparing how Ordinary Least Squares (OLS) and Gradient Descent methods arrive at the same solution, evaluating a memory-efficient Mini Batch variant, and measuring model generalisation via 10-Fold Cross-Validation.

Every analysis is implemented **twice** — once in **R** and once in **Python** — to validate results and demonstrate cross-language proficiency.

---

## File Descriptions

| File | Language | What it does |
|------|----------|-------------|
| `Estimation with OLS.R` | R | Estimates a multiple linear regression model using OLS on the Communities & Crime dataset. |
| `OLS & Gradient Descent.R` | R | Implements Batch Gradient Descent from scratch in R and compares estimated coefficients to OLS. |
| `OLS & Gradient Descent on Bicycles in the city of Porto.R` | R | Applies OLS and Gradient Descent to bicycle usage data from Porto. |
| `Mini Batch Gradient Descent.R` | R | Implements Mini Batch Gradient Descent in R with configurable batch size. |
| `OLS & Bacth Gradient Descent.py` | Python | OLS via `sklearn` + Batch Gradient Descent from scratch using `numpy` on the Communities & Crime dataset. Plots cost per iteration. |
| `Mini Batch Gradient Descent.py` | Python | Mini Batch Gradient Descent in Python with configurable batches and learning rate. |
| `10-Fold Cross Validation in R.r` | R | 10-Fold Cross-Validation in R using `caret` on the Forest Fires dataset. Reports RMSE per fold and mean RMSE. |
| `10-Fold Cross Validation.py` | Python | 10-Fold Cross-Validation in Python using `sklearn.model_selection.KFold`. Includes a second run with filtered data (area < 3.2) for outlier sensitivity analysis. |

---

## Part 1 — OLS Regression

### Dataset

**UCI Communities and Crime** — 1,994 observations of US communities.

**Model:**
```
ViolentCrimesPerPop = β₀ + β₁·medIncome + β₂·whitePerCap + β₃·blackPerCap
                         + β₄·HispPerCap + β₅·NumUnderPov + β₆·PctUnemployed
                         + β₇·HoursVacant + β₈·MedRent + β₉·NumStreet
```

No missing values were found in the selected variables.

### OLS Results (R and Python — identical coefficients)

| Variable | Estimate | Std. Error | t value | Significance |
|----------|----------|------------|---------|--------------|
| (Intercept) | 0.072757 | 0.018542 | 3.924 | *** |
| medIncome | -0.782995 | 0.053616 | -14.604 | *** |
| whitePerCap | 0.455847 | 0.042609 | 10.698 | *** |
| blackPerCap | -0.051762 | 0.031218 | -1.658 | . |
| HispPerCap | 0.003313 | 0.028981 | 0.114 | (ns) |
| NumUnderPov | 0.206630 | 0.071060 | 2.908 | ** |
| PctUnemployed | 0.382167 | 0.026784 | 14.269 | *** |
| HoursVacant | 0.137245 | 0.057584 | 2.383 | * |
| MedRent | 0.333588 | 0.037807 | 8.823 | *** |
| NumStreet | 0.216013 | 0.051263 | 4.214 | *** |

*Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1*

**R² = 0.4456 | Adjusted R² = 0.4431 | F-statistic: 177.2 (p < 2.2×10⁻¹⁶)**

**Key findings:**
- `medIncome` has the largest negative effect: a 1-unit increase in violent crime is associated with a 0.78-unit decrease in median income
- `whitePerCap` and `PctUnemployed` are among the strongest positive predictors
- `HispPerCap` is the only variable that is **not** statistically significant
- `blackPerCap` is significant only at the 10% level
- The Python OLS results are **identical** to R, confirming correct implementation in both languages

---

## Part 2 — Batch Gradient Descent

Batch Gradient Descent is an iterative optimisation algorithm that processes **all training examples** at each step to update the coefficient vector θ.

**Configuration:**
- Learning rate (α): **0.9** (Python) / **0.01** (R versions)
- Iterations: **200** (Python) / **100** (R)
- Initial θ: zeros (Python) / random (R)
- Cost function: Mean Squared Error

**Update rule:**
```
θ = θ - α · (Xᵀ(Xθ - y)) / m
```

The cost-per-iteration plot confirms the algorithm converges: cost decreases monotonically toward the OLS solution. Batch GD is accurate but computationally expensive for large datasets — it must process all 1,994 observations at every iteration.

### Comparison: OLS vs Gradient Descent

Both methods converge to the same coefficient estimates, confirming that Gradient Descent is a valid iterative alternative to the closed-form OLS solution when matrix inversion is expensive or impractical.

---

## Part 3 — Mini Batch Gradient Descent

Mini Batch Gradient Descent is a compromise between Batch GD (all data per step) and Stochastic GD (one sample per step). It processes a **random subset** of the data at each iteration, balancing convergence stability with computational cost.

**Configuration:**
- Number of batches: 10 (batch size ≈ m/10)
- Learning rate α and number of iterations are configurable

At each epoch, random indexes are sampled from the dataset, θ is updated using only that batch, and the cost is recorded. Because batch indexes change each epoch, the cost curve is noisier than Batch GD — but convergence is faster in practice for large datasets.

**Applied to:** Communities & Crime data (Python) and Bicycles in Porto (R)

---

## Part 4 — OLS & Gradient Descent on Bicycles in Porto

A self-contained analysis applying both OLS and Gradient Descent to a real-world bicycle usage dataset from the **city of Porto**. The two methods are run in sequence and their coefficient estimates compared directly — demonstrating that Gradient Descent reaches the same solution as OLS given sufficient iterations.

---

## Part 5 — 10-Fold Cross-Validation

### Dataset

**UCI Forest Fires (Montesinho Park, Portugal)** — 517 observations.

**Model:**
```
area = β₀ + β₁·temp + β₂·wind + β₃·rain
```

The dataset is shuffled before splitting to avoid ordering bias.

### Approach

- K = 10 folds; train on 9 folds, test on 1 fold at each iteration
- Metric: Root Mean Squared Error (RMSE) per fold
- Final result: **mean RMSE across all 10 folds**

**Second run (outlier sensitivity):**
- Dataset filtered to `area < 3.2` to remove large fire events
- Cross-validation repeated on the restricted sample
- Mean RMSE compared between the full and filtered datasets

### Findings

The comparison between the two runs highlights a critical modelling issue: a small number of extreme fire events (very large burned areas) can dramatically inflate RMSE. Filtering to `area < 3.2` reduces variance in the target variable significantly, leading to a lower mean RMSE. This demonstrates why outlier analysis is an essential pre-modelling step.

---

## Technologies & Libraries

### Python
- `numpy`, `pandas` — Data manipulation and matrix operations
- `sklearn.linear_model.LinearRegression` — OLS estimation
- `sklearn.model_selection.KFold` — Cross-validation splitting
- `sklearn.metrics.mean_squared_error` — RMSE calculation
- `matplotlib` — Cost convergence plot
- `tabulate` — Formatted coefficient output

### R
- `stats::lm` — OLS linear regression
- `caret` — Cross-validation framework
- Base R — Gradient descent implementations from scratch

---


---

## License

This project is licensed under the MIT License — see the [LICENSE](../../../LICENSE) file for details.
