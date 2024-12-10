library(haven)
library(MASS)
library(pscl)
library(olsrr)
library(mctest)
library(car)
library(Metrics)
library(usdm)

birthweight_data <- read.csv("C:/Desktop/Regression/Deon.csv")
detox_data <- read_sav("C:/Desktop/Regression/detox.sav")

# Convert Social Class & BMI to a factor
birthweight_data$SocialClass <- as.factor(birthweight_data$SocialClass)
birthweight_data$BMI <- as.factor(birthweight_data$BMI)

model <- lm(Birthweight ~ Age + SocialClass + BMI + Folate + VitC + VitB6 +
              VitB12 + VitE, data = birthweight_data)
plot(model)
summ(model)


qqnorm(residuals(model))
qqline(residuals(model), col = 2)

# Diagnostics

par(mfrow=c(2,2))  # Set up a 2x2 grid for diagnostic plots
plot(model)
par(mfrow=c(1,1))  # Reset to a single plot

ols_regress(Birthweight ~ Age + SocialClass + BMI + Folate + VitC +
              VitB6 + VitB12 + VitE, data = birthweight_data)

# Influential Points

# Cook's Distance
influencePlot(model, id.n = 5, main = "Influence Plot", sub = NULL,
              identify = 0.5, scale = 3.5)

ols_plot_dffits(model)
ols_plot_resid_stud_fit(model)
ols_plot_dfbetas(model)
ols_plot_diagnostics(model)
ols_plot_resid_lev(model)
outlierTest(model)


# Multi collinearity
mctest(model, type=c("b"),na.rm = TRUE, Inter=TRUE, method ="VIF",
       all=TRUE, corr=TRUE, vif=5)


eigprop(model)
mc.plot(model, Inter = TRUE)
mc.plot(model, vif = 5, ev = 20, Inter = TRUE)


# Re-code the variable Birth weight
birthweight_data$Underweight <- ifelse(birthweight_data$Birthweight <= 2800,
                                       "Underweight", "Normal")

# Re-code as binary response
birthweight_data$Response <- ifelse(birthweight_data$Birthweight <= 2800, 1, 0)

# Run binary logistic regression
logit_model <- glm(Response ~ Alcohol * Smoking, data = birthweight_data,
                   family = binomial)

# Print the summary of the logistic regression model
summary(logit_model)

cbind(Estimate = round(coef(logit_model),3),
      OR = round(exp(coef(logit_model)),3))


# Part A

# Zero-Inflated Poisson Model
model_zip <- zeroinfl(drinks ~ sex + drug + age | sex + drug + age,
                      data = detox_data, dist = "poisson")
model_zip
summary(model_zip)


# Standard Poisson Regression Model
model_poisson <- glm(drinks ~ sex + drug + age, data = detox_data,
                     family = poisson)

model_poisson
summary(model_poisson)


# Comparison Model1
vuong(model_zip, model_poisson)
# zip > standard


# Part B

# 1 ZINB

model_ZINB <- zeroinfl(drinks ~ sex + drug + age | sex + drug + age,
                       dist="negbin", data = detox_data)
summary(model_ZINB)


# 2 Standard Negative Binomial Regression
model_negbin <- glm.nb(drinks ~ sex + drug + age, data = detox_data)
model_negbin
summary(model_negbin)


# comparison
vuong(model_ZINB, model_negbin)


# Comparison btw Poisson and nb
vuong(model_ZINB, model_zip)

