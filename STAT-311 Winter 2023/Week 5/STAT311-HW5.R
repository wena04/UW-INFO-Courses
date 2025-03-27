# STAT311 - Homework 5
# Name: Anthony Wen

# Question 1.a
# Construction a function called ci.for.proportion which calculates confidence intervals for proportions. Your function should take three arguments, ci.for.proportion(phat, n, conf) phat is the sample proportion, n is the sample  size, and conf is the level of confidence, expressed as a real number  between 0 and 1.
# Your function should return a list of two items, representing the lower and upper bound of a confidence interval for the specified level of confidence.
n <- 100
phat <- 0.3
conf <- 0.95
ci.for.proportion <- function(phat, n, conf){
  SE <- sqrt(phat * (1 - phat) / n)
  Z <- qnorm(1 - (1 - conf) /2)
  ME <- Z * SE
  lowerbound <- phat - ME
  upperbound <- phat + ME
  return(c(lowerbound, upperbound))
}
ci.for.proportion(phat,n,conf)

# Question 2

# The state of Florida is in the midst of a homeowners insurance crisis, with insurance costs skyrocketing and pricing many homeowners out of the market. More and more homeowners are resorting to self-insurance, saving money that would be spent on insurance in the hopes that the savings can cover any issues  that arise that would normally fall under an insurance policy. (Some people might call this `not having insurance', but sure, let's  go with `self-insurance'.)

# A survey of 487 Florida homeowners found that 82 of those surveyed 
# reported relying on self-insurance.

# Question 2.a
# Based on the sample proportion found, what is the estimated standard error of the distribution of phat? Save your answer in the variable q2.a

n <- 487
phat <- 82 / n
p <- phat
SE <- sqrt(p * (1 - p) / n)
q2.a <- SE

# Question 2.b
# Calculate a 90% confidence interval for the true proportion of Florida homeowners who rely on self-insurance. (Your answer should be formatted similarly to the function output, if done by hand). 
# Save your answer in the variable q2.b
q2.b<- ci.for.proportion(phat, n, 0.90)

# Question 2.c
# If the true proportion of Florida homeowners relying on self-insurance were p=.177, what is the true standard error of the distribution of phat? 
# Save your answer in the variable q2.c

p_true <- 0.177
SE_true <- sqrt(p_true * (1 - p_true) / n)
q2.c <- SE_true
  
# Question 2.d
# If the true proportion of Florida homeowners relying on self-insurance were p=.177, what is the probability that the interval you found in q2.b contains the true proportion? 
# Save your answer in the variable q2.d

q2.d <- 1


# Question 2.e
# If the true proportion of Florida homeowners relying on self-insurance were 
# p=.202, what is the true standard error of the distribution of phat? 
# Save your answer in the variable q2.e

# Parameters
p <- 0.202
n <- 487

# True standard error
SE <- sqrt(p * (1 - p) / n)
q2.e <- SE

# Question 2.f
# If the true proportion of Florida homeowners relying on self-insurance were 
# p=.202, what is the probability a 95% interval constructed from the sample 
# used in q2.b would contains the true proportion? 
# Save your answer in the variable q2.f

q2.f <- 0

# Question 2.g
# If the true proportion of Florida homeowners relying on self-insurance were 
# p=.202, what is the probability a 95% interval constructed from a new sample 
# of size 487 would contains the true proportion? 
# Save your answer in the variable q2.g

q2.g <- 0.95

      


# Question 3


# Question 3.a
# Based on the proposed hypothesis test of the researcher, what is the 
# assumed value of the population parameter p. 
# Save your answer in the variable q3.a

p <- 0.141
q3.a <- 0.141


# Question 3.b
# How many standard deviations (or standard errors) away from the mean is the 
# observed sample proportion? 
# Save your answer in the variable q3.b

n <- 189
phat <- 19 / n
SE <- sqrt(p * (1 - p) / n)
Z <- (phat - p) / SE
q3.b <- Z


# Question 3.c
# What is the probability under the null hypothesis of observing an estimate 
# of the parameter as or more extreme than the observed phat? 
# (This is the p-value). 
# Save your answer in the variable q3.c

q3.c <- pbinom(19, size = n, prob = q3.a, lower.tail = TRUE)

# Question 3.d
# What is the maximum number of students reporting using e-cigarettes that 
# would lead the researchers to reject the null hypothesis? 
# (The sample size remains unchanged). 
# Save your answer in the variable q3.d

q3.d <- 18

# Question 3.e
# What is the exact probability of committing a type 1 (type I) error if the 
# null hypothesis is true? 
# Save your answer in the variable q3.e

q3.e <- pbinom(18,n,q3.a)

# A much larger study of high school students found that 10.0% of students 
# used e-cigarettes. Assume this is the true value of the parameter.

# Question 3.f
# Based on the true value of the parameter, what is the probability of 
# committing a type 1 (type I) error? 
# Save your answer in the variable q3.f


q3.f <- 0

# Question 3.g
# Based on the true value of the parameter, what is the probability of 
# observing a level of e-cigarette use that would causes the researchers 
# to reject the null hypothesis? (This is the power of the test). 
# Save your answer in the variable q3.g

q3.g <- 1 - pbinom(q3.d, size = n, prob = 0.1, lower.tail = FALSE)

