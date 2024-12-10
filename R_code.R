library(haven)  
library(MASS)   
library(pscl)   
library(olsrr)  
library(mctest) 
library(car)    
library(Metrics) 
library(usdm)   

# Load the dataset
birthweight_data <- read.csv("C:/Desktop/Regression/Deon.csv")  # Read birthweight data
detox_data <- read_sav("C:/Desktop/Regression/detox.sav")  # Read detox dataset

# Convert Social Class & BMI to factors for categorical variables
birthweight_data$SocialClass <- as.factor(birthweight_data$SocialClass)
birthweight_data$BMI <- as.factor(birthweight_data$BMI)

# 1: Multiple Linear Regression
# Model Birthweight as a function of Age, SocialClass, BMI, Folate, VitC, VitB6, VitB12, and VitE
model <- lm(Birthweight ~ Age + SocialClass + BMI + Folate + VitC + VitB6 + VitB12 + VitE, data = birthweight_data)

# Diagnostic Plots for the Multiple Linear Regression Model
plot(model)  # Standard diagnostic plots
summ(model)  # Summary of the linear regression model

# Normality of Residuals (Q-Q Plot)
qqnorm(residuals(model))  # Q-Q plot for checking normality of residuals
qqline(residuals(model), col = 2)  # Add reference line

# Diagnostics: Residuals, Leverage, Influence, etc.
par(mfrow=c(2,2))  # Set up a 2x2 grid for diagnostic plots
plot(model)  # Standard diagnostic plots
par(mfrow=c(1,1))  # Reset to a single plot for clarity

# Influence Measures
ols_regress(Birthweight ~ Age + SocialClass + BMI + Folate + VitC + VitB6 + VitB12 + VitE, data = birthweight_data)  # Regression diagnostics

# Influence Plot for Identifying Outliers and Influential Observations
influencePlot(model, id.n = 5, main = "Influence Plot", sub = NULL, identify = 0.5, scale = 3.5)  # Identify influential points

# Plot of Various Influence Diagnostics
ols_plot_dffits(model)  # DFFITS plot
ols_plot_resid_stud_fit(model)  # Residuals vs fitted plot
ols_plot_dfbetas(model)  # Plot of DFBetas
ols_plot_diagnostics(model)  # Overall diagnostics
ols_plot_resid_lev(model)  # Residual vs Leverage plot
outlierTest(model)  # Test for outliers

# Multicollinearity: Check for issues in predictor variables
mctest(model, type=c("b"), na.rm = TRUE, Inter=TRUE, method ="VIF", all=TRUE, corr=TRUE, vif=5)  # Variance Inflation Factor (VIF)

# Eigenvalue Analysis for Multicollinearity
eigprop(model)  # Check eigenvalues to assess multicollinearity
mc.plot(model, Inter = TRUE)  # Multicollinearity plot with interactions
mc.plot(model, vif = 5, ev = 20, Inter = TRUE)  # Plot with VIF and Eigenvalue thresholds

# 2: Binary Logistic Regression
# Recode Birthweight into a binary outcome variable ("Underweight" if Birthweight <= 2800)
birthweight_data$Underweight <- ifelse(birthweight_data$Birthweight <= 2800, "Underweight", "Normal")

# Recode Birthweight as a binary response (1 = Underweight, 0 = Normal)
birthweight_data$Response <- ifelse(birthweight_data$Birthweight <= 2800, 1, 0)

# Run Binary Logistic Regression to investigate Alcohol and Smoking effects
logit_model <- glm(Response ~ Alcohol * Smoking, data = birthweight_data, family = binomial)

# Print Summary of Logistic Regression Model
summary(logit_model)  # Show results of logistic regression

# Calculate Odds Ratios
cbind(Estimate = round(coef(logit_model), 3), OR = round(exp(coef(logit_model)), 3))  # Calculate and show odds ratios

# 3: Poisson Regression and Negative Binomial Models for Detox Data
# Part A: Examine dependent variable 'drinks'
# Zero-Inflated Poisson Model: Poisson regression with extra zeros for detox data
model_zip <- zeroinfl(drinks ~ sex + drug + age | sex + drug + age, data = detox_data, dist = "poisson")

# Display Summary of Zero-Inflated Poisson Model
model_zip  # Zero-inflated Poisson model summary
summary(model_zip)  # Detailed summary of ZIP model

# Standard Poisson Regression Model: Simple Poisson regression model for 'drinks'
model_poisson <- glm(drinks ~ sex + drug + age, data = detox_data, family = poisson)
model_poisson  # Display results of Poisson model
summary(model_poisson)  # Summary of Poisson regression model

# Model Comparison: Compare Zero-Inflated Poisson vs Standard Poisson Model
vuong(model_zip, model_poisson)  # Vuong test for model comparison (ZIP vs Standard Poisson)

# Part B: Negative Binomial Regression
# Negative Binomial Zero-Inflated Model for 'drinks' (ZINB)
model_ZINB <- zeroinfl(drinks ~ sex + drug + age | sex + drug + age, dist="negbin", data = detox_data)
summary(model_ZINB)  # Summary of Zero-Inflated Negative Binomial Model

# Standard Negative Binomial Regression: Negative Binomial model for 'drinks'
model_negbin <- glm.nb(drinks ~ sex + drug + age, data = detox_data)
model_negbin  # Display results of Negative Binomial regression
summary(model_negbin)  # Summary of Negative Binomial model

# Model Comparison: ZINB vs Negative Binomial
vuong(model_ZINB, model_negbin)  # Compare ZINB and Negative Binomial models

# Comparison between Poisson and Negative Binomial Models
vuong(model_ZINB, model_zip)  # Compare ZINB vs Poisson model
