## Advanced Regression Modeling: Linear, Logistic, and Zero-Inflated Models

This project explores various regression modeling techniques, including multiple linear regression, binary logistic regression, and zero-inflated Poisson/negative binomial models. The study investigates the impact of maternal characteristics on birthweight, as well as alcohol and drug usage on drinking patterns.

---

## Introduction
The project demonstrates advanced regression techniques:
- **Multiple Linear Regression**: To evaluate the impact of maternal characteristics (e.g., age, social class, BMI, vitamins) on birthweight.
- **Binary Logistic Regression**: To assess the effects of alcohol and smoking on the likelihood of low birthweight.
- **Zero-Inflated and Negative Binomial Models**: To analyze drinking patterns considering excess zeros in the data.

These methods provide insights into relationships between predictors and outcomes, addressing challenges like multicollinearity, overdispersion, and excess zeros.

---

## Dataset
1. **Birthweight Dataset**:
   - Contains data on maternal characteristics, vitamin intake, and infant birthweight.
   - Key variables: Birthweight, Age, BMI, Social Class, Vitamin intake (Folate, VitC, VitB6, VitB12, VitE).

2. **Detox Dataset**:
   - Analyzes the effects of sex, drug use, and age on drinking patterns.
   - Key variables: Number of drinks, sex, drug use, and age.

---

## Methodology
### 1. Multiple Linear Regression:
- Dependent variable: **Birthweight**
- Independent variables: Maternal characteristics (Age, Social Class, BMI) and Vitamin intake.
- Diagnostic checks:
  - Linearity, Normality (Q-Q plot), and Homoscedasticity.
  - Multicollinearity via Variance Inflation Factor (VIF).

### 2. Binary Logistic Regression:
- Dependent variable: Likelihood of **low birthweight (<=2800g)**.
- Independent variables: Alcohol consumption, smoking, and their interaction.
- Key Metrics:
  - Odds Ratios (OR).
  - Model fit via Deviance.

### 3. Poisson and Zero-Inflated Regression Models:
- Analyzed drinking patterns using:
  - Standard Poisson regression.
  - Zero-inflated Poisson (ZIP).
  - Standard Negative Binomial (NB).
  - Zero-inflated Negative Binomial (ZINB).
- Model comparison via Vuong's test to evaluate goodness of fit.

---

## Results
### 1. Multiple Linear Regression:
- R-squared: 3% variance in birthweight explained by predictors.
- Significant predictors:
  - Age (positive relationship with birthweight).
  - BMI levels (higher BMI linked to higher birthweight).
  - Social Class (lower social class associated with reduced birthweight).
- Diagnostic Issues:
  - Multicollinearity detected with Vitamin B6 and Folate.

### 2. Binary Logistic Regression:
- Alcohol consumption and smoking significantly impacted low birthweight likelihood.
- Interaction terms between alcohol and smoking showed a positive relationship with low birthweight risk.

### 3. Zero-Inflated and Negative Binomial Models:
- **Zero-inflated Poisson (ZIP)**:
  - Best fit for handling excess zeros in drinking patterns.
  - Identified sex and drug use as significant predictors of drinking patterns.
- **Negative Binomial (NB) vs ZINB**:
  - ZINB handled overdispersion better, providing narrower confidence intervals and more reliable predictions.

---

## Setup Instructions
### Prerequisites:
- Install R and required libraries:
  ```R
  install.packages(c("haven", "MASS", "pscl", "olsrr", "mctest", "car", "Metrics", "usdm"))
Steps to Run:

Add the datasets (Data.csv and detox.sav) to the appropriate directory.
Run the R code

## Key Findings
Linear regression revealed significant relationships but was limited by low R-squared and multicollinearity issues.

Logistic regression highlighted the interactive effects of alcohol and smoking on birthweight.

ZIP and ZINB models demonstrated superior performance in analyzing datasets with excess zeros and overdispersion.

## Future Work
Extend the analysis to include advanced regression techniques like LASSO or Ridge regression.

Explore machine learning approaches (e.g., random forest or gradient boosting) for prediction tasks.

Evaluate the impact of additional predictors and interactions.
