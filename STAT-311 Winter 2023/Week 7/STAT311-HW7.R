# STAT311 - Homework 7
# Name: Anthony Wen 

# # # # # # # DO NOT EDIT BELOW # # # # # # #
tensileData=read.csv("tensileData.csv")
data("iris")
flowerData=iris
# # # # # # # DO NOT EDIT ABOVE # # # # # # #

# Question 1
# You are working as a data analyst for a private firm, 
#  and receive an email from your supervisor. 
# "Dear Employee" (You'd think he'd known your name by now)
# "I sent you over some data from experiments on the tensile strength of 
#  different steel samples. I need you to determine if there is evidence 
#  that the treated steel has a tensile strength higher than mu=377.9095. 
#  Test it at the usual alpha=5% level."
# (Note: Your test should look for the difference between mu_treatment-377.9095.)
#  This data is saved as "tensileData"
mu=377.9095

# Question 1.a
# What is the difference between the observed and expected mean under 
# the assumed hypothesis? 
# Save your answer in the variable q1.a
mu_treatment <- mean(tensileData$treated)
q1.a<- mu_treatment - mu

# Question 1.b
# What is the estimated standard error of this test? 
# Save your answer in the variable q1.b
q1.b<- sd(tensileData$treated) / sqrt(nrow(tensileData))

# Question 1.c 
# What is the test statistic T for this test? 
# Save your answer in the variable q1.c
q1.c<- q1.a / q1.b

# Question 1.d
# What is the degrees of freedom for this test? 
# Save your answer in the variable q1.d
q1.d<- nrow(tensileData) - 1

# # Question 1.e
# What is the p-value for this test? 
#Save your answer in the variable q1.e
q1.e<- pt(q1.c, df = q1.d, lower.tail = FALSE)

# Question 1.f
# TRUE or FALSE? Based on this p-value we should reject the null and 
# conclude that the treated steel has a higher mean than specified. 
# Save your answer in the variable q1.f
alpha <- 0.05
q1.f<- (q1.e < alpha)

  

# Question 2
# Your supervisor responds to your email about the analysis, 
#  but your not sure that he read it. 
# "Employee"
# "Ignore my previous email, I actually needed you to compare the control 
#  and treatment groups of the data I sent you to see if the treatment 
#  group has a higher mean than the control group. The researchers tell 
#  me that they aren't sure if the treatment impacted the variability of 
#  tensile strength, so don't assume equal variances. 
#  This needs to be on my desk by end of day."
# (Note: Your test should look for the difference between mu_treatment-mu_control.)

# Question 2.a
# What is the difference between the observed difference of means and 
# the expected difference of means under the assumed hypothesis? 
# Save your answer in the variable q2.a

control <- tensileData$control
treatment <- tensileData$treated

test.result <- t.test(control,treatment)

q2.a<- mean(treatment) - mean(control)

# Question 2.b
# What is the estimated standard error of this test? 
# Save your answer in the variable q2.b
q2.b<- test.result$stderr

# Question 2.c
# What is the test statistic T for this test? 
# Save your answer in the variable q2.c
q2.c<- q2.a / q2.b

# Question 2.d
# What is the conservative estimation of degrees of freedom for this test? 
# Save your answer in the variable q2.d

n_control <- length(tensileData$control)
n_treated <- length(tensileData$treated)

# Calculate the smaller of the two sample sizes minus one.
q2.d <- min(n_control, n_treated) - 1

# Question 2.e
# What is the p-value for this test using the conservative 
# estimation of the degrees of freedom? 
# Save your answer in the variable q2.e

q2.e<- pt(q2.c, df=q2.d,lower.tail = FALSE)

# Question 2.f
# What is the p-value for this test using the accurate estimation 
# of the degrees of freedom in the t.test function? 
# Save your answer in the variable q2.f
q2.f<- test.result$p.value / 2

# Question 2.g
# TRUE or FALSE? Based on this p-value we should reject the null and 
# conclude that the treated steel has a higher mean than the control steel. 
# Save your answer in the variable q2.g
q2.g<- (q2.f < 0.05)


# Question 3
# Your supervisor again responds to your email about the analysis, 
#  but definitely didn't read it.
# "Employee"
# "It should have been obvious," (it wasn't) "but the values in this 
#  data set are paired together, with each row representing steel samples 
#  from different manufacturers. I'm going to need you to stay late and 
#  fix the error in your analysis to account for this paired design." 
#  (Maybe you should updated your linkedin profile later)
# (Note: Your test should look for the difference between mu_treatment-mu_control.)

paired.result <- t.test(tensileData$treated - tensileData$control)


# Question 3.a
# What is the estimated standard error of this test? 
# Save your answer in the variable q3.a
q3.a<- paired.result$stderr


# Question 3.b
# What is the test statistic T for this test? 
# Save your answer in the variable q3.b

q3.b<- paired.result$statistic[[1]]

# Question 3.c
# What is the degrees of freedom for this test? 
# Save your answer in the variable q3.c
q3.c<- q2.d

# Question 3.d
# What is the p-value for this test? 
# Save your answer in the variable q3.d
q3.d<- paired.result$p.value / 2

# Question 3.e
# TRUE or FALSE? Based on this p-value we should reject the null and 
# conclude that the treated steel has a higher mean than the control steel. 
# Save your answer in the variable q3.e
q3.e<- (q3.d < 0.05)



# Question 4
# You finally got a new job in a botany lab, doing data analysis for their team. 
# (It's got better pay and benefits, but mostly you just wanted to get away from that supervisor). 
# You receive the following email from your new supervisor.
# ``Hey new person! (Sorry, I don't know your name, but I promise to learn it soon!)''
# ``I sent some measurement data on some flowers that we were doing, and we wanted 
#  to know if you could do a regression analysis to determine how the sepal length 
#  of these irises differs based on the petal width. No rush on this, we're not 
#  running a sweat shop here! The attached document should have all the details.''
# This data is saved as flowerData
# (Note: If you use the R functions to get coefficients from the model 
# (slope and intercept), you will need to index those coefficients 
# with [[1]] and [[2]] rather than [1] and [2].)

# Question 4.a
# What is the correlation between sepal length and petal width? 
# Save your answer in the variable q4.a
q4.a<- cor(flowerData$Sepal.Length, flowerData$Petal.Width)

# Question 4.b
# Using R functions or by hand, fit a regression equation to predict sepal 
#  length from petal width. What is the intercept of that equation? 
# Save your answer in the variable q4.b
model <- lm(Sepal.Length ~ Petal.Width, data = flowerData)

q4.b<- coef(model)[[1]]

# Question 4.c
# What is the slope term of the above defined equation?
# Save your answer in the variable q4.c
q4.c<- coef(model)[[2]]

# Question 4.d
# Using your estimated model, what average sepal length do you predict 
#  for an iris with a petal width of 1.75? 
# Save your answer in the variable q4.d
q4.d<- predict(model, newdata = data.frame(Petal.Width = 1.75))[[1]]

