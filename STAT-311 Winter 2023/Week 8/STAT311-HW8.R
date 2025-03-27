# STAT311 - Homework 8
# Name: Anthony Wen

# You may need to install the relevant libraries, but 
#  only run the following command once, ever, do not
#  leave it uncommented in your submission.
# install.packages("palmerpenguins")
library(palmerpenguins)

makeplot<-function(){
  plot(penguins$bill_depth_mm, penguins$bill_length_mm, 
       col=c('black','blue','orange')[as.factor(penguins$species)],
       pch=c(1,2)[as.factor(penguins$sex)])
  legend("topleft", legend=c(levels(penguins$species),"female","male"), 
         col=c('black','blue','orange','black','black'), pch=c(5,5,5,1,2))
}

# The following plot might help with understanding the
#  following analysis.
# NOTE: YOU MUST RECOMMENT THIS BLOCK BEFORE SUBMITTING
#  TO GRADESCOPE. GENERATING PLOTS IN SUBMITTED CODE
#  WILL FAIL THE AUTOGRADER.
# UNCOMMENT below to show, RECOMMENT before submitting
# makeplot() 

# All of these questions look at modeling the relationship
#  between bill length and bill depth of penguins, specifically
#  trying to predict length from depth.

# Note that answer need to be formatted correctly; gradescope will
#  not accept 'named numbers', which can be converted to numeric variables
#  by using double square braces: [[1]]
# Output by functions such as lm will often by named numbers, be
#  careful when extracting values from these functions, and use
#  double square braces when appropriate: ie lm(...)$coefficients[[2]]

model <- lm(bill_length_mm ~ bill_depth_mm, data=penguins)

# Question 1
# Fit a model to predict bill length from bill depth for
#  the palmerpenguins data, just called 'penguins'

# What is the estimated intercept term of the model?
# Save your answer in the variable q1.a
q1.a<- coef(model)[[1]]

# What is the estimated slope term of the model?
# Save your answer in the variable q1.b
q1.b<- coef(model)[[2]]

# Predict the expected bill length for a penguin with
#  a bill depth of 14mm.
# Save your answer in the variable q1.c
q1.c<- predict(model, newdata=data.frame(bill_depth_mm=14))[[1]]

# Construct a 90% prediction interval for the 
#  bill length of a penguin with a bill depth of 19mm
# Save your answer in the variable q1.d
# Your answer should be formatted as c(lowerbound,upperbound)
q1.d<- as.numeric(predict(model, newdata=data.frame(bill_depth_mm=19), interval="prediction", level=0.90)[,2:3])

# Construct a 99% confidence interval for the average bill
#  length of a penguin with a bill depth of 19mm.
# Save your answer in the variable q1.e
# Your answer should be formatted as c(lowerbound,upperbound)
q1.e<- as.numeric(predict(model, newdata=data.frame(bill_depth_mm=19), interval="confidence", level=0.99)[,2:3])

# What is the p-value for determining if there is evidence that
#  the slope of this model is different from 0?
# Save your answer in the variable q1.f
q1.f<- summary(model)$coefficients["bill_depth_mm", "Pr(>|t|)"]


# Question 2
# Fit a model to predict bill length from bill depth with
# different intercepts (but not slopes) based on sex for
#  the palmerpenguins data

model_sex <- lm(bill_length_mm ~ bill_depth_mm + sex, data=penguins)

# What is the estimated intercept term for female penguins?
# Save your answer in the variable q2.a
q2.a<- coef(model_sex)["(Intercept)"][[1]]

# What is the estimated intercept term for male penguins?
# Save your answer in the variable q2.b
q2.b<- q2.a + coef(model_sex)["sexmale"][[1]]

# What is the expected bill length for a male
#  penguin with a bill depth of 14mm?
# Save your answer in the variable q2.c
q2.c<- predict(model_sex, newdata=data.frame(bill_depth_mm=14, sex="male"))[[1]]

# Construct a 95% prediction interval for the 
#  bill length of a female penguin with a bill depth of 19mm
# Save your answer in the variable q2.d
# Your answer should be formatted as c(lowerbound,upperbound)
q2.d<- as.numeric(predict(model_sex, newdata=data.frame(bill_depth_mm=19, sex="female"), interval="prediction", level=0.95)[,2:3])

# Construct a 95% confidence interval for the 
#  slope of the regression equation
# Save your answer in the variable q2.e
# Hint: The degrees of freedom depends on the
#  number of parameters in the model, but can be
#  found from the output of the summary(lm(...)) command
summary_model_sex <- summary(model_sex)
slope_estimate <- summary_model_sex$coefficients["bill_depth_mm", "Estimate"]
slope_se <- summary_model_sex$coefficients["bill_depth_mm", "Std. Error"]

# Degrees of freedom from the model summary for the t distribution
degrees_freedom <- summary_model_sex$df[2]

# Calculate the critical t-value for a 95% CI
alpha <- 0.05
t_crit <- qt(1 - alpha/2, degrees_freedom)

# Calculate the confidence interval
lower_bound <- slope_estimate - t_crit * slope_se
upper_bound <- slope_estimate + t_crit * slope_se
q2.e <- as.numeric(c(lower_bound, upper_bound))

# TRUE or FALSE: Using the p-values to determine parameter significance, 
#  we should keep the sex differentiated intercept in this model.
# Save your answer in the variable q2.f
q2.f<- summary_model_sex$coefficients["sexmale", "Pr(>|t|)"] < 0.05




# Question 3
# Fit a model to predict bill length from bill depth with
# different intercepts and slopes based on sex for
#  the palmerpenguins data

model_sex_slope <- lm(bill_length_mm ~ bill_depth_mm*sex, data=penguins)

# What is the estimated slope term for female penguins?
# Save your answer in the variable q3.a
q3.a<- coef(model_sex_slope)["bill_depth_mm"][[1]]

# What is the estimated slope term for male penguins?
# Save your answer in the variable q3.b
q3.b<- q3.a + coef(model_sex_slope)["bill_depth_mm:sexmale"][[1]]

# Construct a 90% prediction interval for the 
#  bill length of a male penguin with a bill depth of 15mm
# Save your answer in the variable q3.c
# Your answer should be formatted as c(lowerbound,upperbound)
q3.c<- as.numeric(predict(model_sex_slope, newdata=data.frame(bill_depth_mm=15, sex="male"), interval="prediction", level=0.90)[,2:3])

# Construct a 99% confidence interval for the average
#  bill length of a female penguin with a bill depth of 18mm
# Save your answer in the variable q3.d
# Your answer should be formatted as c(lowerbound,upperbound)
q3.d<- as.numeric(predict(model_sex_slope, newdata=data.frame(bill_depth_mm=18, sex="female"), interval="confidence", level=0.99)[,2:3])

# What is the p-value for determining the signficance of the 
#  difference in slope for male penguins?
# Save your answer in the variable q3.e
q3.e<- summary(model_sex_slope)$coefficients["bill_depth_mm:sexmale", "Pr(>|t|)"]

# TRUE or FALSE: Using the p-values to determine parameter significance, 
#  we should keep the sex differentiated intercept and slope in this model.
# Save your answer in the variable q3.f
q3.f<- (q3.e < 0.05)



# Question 4
# Fit a model to predict bill length from bill depth with
# different intercepts and slopes based on species for
#  the palmerpenguins data

model_species <- lm(bill_length_mm ~ bill_depth_mm*species, data=penguins)

# What is the estimated intercept term for Adelie penguins?
# Save your answer in the variable q4.a
q4.a<- coef(model_species)["(Intercept)"][[1]]

# What is the estimated intercept term for Gentoo penguins?
# Save your answer in the variable q4.b
q4.b<- q4.a + coef(model_species)["speciesGentoo"][[1]]

# What is the estimated slope term for Adelie penguins?
# Save your answer in the variable q4.c
q4.c<- coef(model_species)["bill_depth_mm"][[1]]

# What is the estimated slope term for Chinstrap penguins?
# Save your answer in the variable q4.d
q4.d<- q4.c + coef(model_species)["bill_depth_mm:speciesChinstrap"][[1]]

# What is the expected bill length for a Gentoo
#  penguin with a bill depth of 15mm?
# Save your answer in the variable q4.e
q4.e<- predict(model_species, newdata=data.frame(bill_depth_mm=15, species="Gentoo"))[[1]]

# Construct a 80% prediction interval for the 
#  bill length of a Chinstrap penguin with a bill depth of 20mm.
# Save your answer in the variable q4.f
# Your answer should be formatted as c(lowerbound,upperbound)
q4.f<- as.numeric(predict(model_species, newdata=data.frame(bill_depth_mm=20, species="Chinstrap"), interval="prediction", level=0.80)[,2:3])


# Construct a 90% confidence interval for the average
#  bill length of an Adelie penguin with a bill depth of 17mm
# Save your answer in the variable q4.g
# Your answer should be formatted as c(lowerbound,upperbound)
q4.g<- as.numeric(predict(model_species, newdata=data.frame(bill_depth_mm=17, species="Adelie"), interval="confidence", level=0.90)[,2:3])

#Question 5
# Which model do you think best describes the data?
#  Your answer should be one of the following. 
#  You can ensure correct format by selecting your answer
#  using q5.answers[#]
# Note: each model refers to the question number
# Save your answer in the variable q5.a
q5.answers=c("Model 1", "Model 2", "Model 3", "Model 4")
q5.a<- q5.answers[4]