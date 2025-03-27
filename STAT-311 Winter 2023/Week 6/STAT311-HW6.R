# STAT311 - Homework 6
# Name: Anthony Wen

# # # # # # # DO NOT EDIT # # # # # # #
vehicleTheft=c(1031, 951, 931, 911, 917, 1004, 951)
gambler=c(15, 30, 36, 50, 57, 59, 55, 48, 36, 20, 17)
# # # # # # # DO NOT EDIT # # # # # # #

# Question 1
# We wish to test the hypothesis that the rate of vehicle thefts is constant 
#  throughout the week. This data can be found in the variable vehicleTheft.

# Question 1.a
# Calculate the expected counts for the number of theft of vehicle crimes for 
# each day of the week. Your answer should be in the form of a list of length 7.
# Save your answer in the variable q1.a

n <- sum(vehicleTheft)  # Total number of thefts
expected <- rep(n / 7, 7)  # Assuming thefts are evenly distributed across the week
q1.a <- expected

# Question 1.b
# Calculate the chi2 test statistic for testing the hypothesis described. 
# Save your answer in the variable q1.b
q1.b<- sum((vehicleTheft - expected)^2 / expected)

# Question 1.c
# Calculate the p-value for the hypothesis. 
# Save your answer in the variable q1.c
q1.c<- pchisq(q1.b, df=6, lower.tail=FALSE)

# TRUE or FALSE, testing at a 5% level, we can reject the null 
# hypothesis and conclude that vehicle thefts are more 
# common on Monday and Saturday. 
# Save your answer in the variable q1.d
q1.d<- FALSE



# Question 2
# A nervous gambler finds that they keep losing money at the craps table, 
# and suspect the house of cheating. They record a large number of rolls 
# (over which they continue to lose money...) and find the following data.

# Note that in craps, each roll is a roll of two dice, summed together, taking 
# values from 2 to 12. This data can be found in the variable gambler.

# Question 2.a
# To find evidence that the dice are unfair, what will be the assumed 
# distribution of each possible value? Your answer should be a list of 
# length 11, with the first value representing P(X=2), the second P(X=3), etc. 
# Save your answer in the variable q2.a

probabilities <- c(1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1) / 36
q2.a<- probabilities
  
# Question 2.b
# Calculate the expected counts for the number of rolls of each die. 
# Your answer should be in the form of a list of length 11. 
# Save your answer in the variable q2.b

expected_rolls <- probabilities * sum(gambler)
q2.b <- expected_rolls

# Question 2.c
# Calculate the chi2 test statistic for testing the hypothesis that the dice are unfair. 
# Save your answer in the variable q2.c

q2.c <- sum((gambler - expected_rolls)^2 / expected_rolls)

# Question 2.d
# Calculate the p-value for the hypothesis. 
# Save your answer in the variable q2.d

q2.d <- pchisq(q2.c, df=10, lower.tail=FALSE)
  
# Question 2.e
# TRUE or FALSE, testing at a 5% level, the gambler cannot reject 
# the hypothesis that the dice are fair. 
# Save your answer in the variable q1.e

q2.e<- q2.d >= 0.05
  


# Question 3
# A survey of voters in "Frontline" counties, counties that represent highly 
# contested regions for congressional races, contacted a total of 1000 voters. 
# Poll respondents were split in half, and each half was asked different questions. 
# 322 of 500 respondents agreed with "Making community college tuition-free for all". 
# 341 of 500 respondents agree with "Making community college tuition-free for
# families with incomes below $125,000 a year". 
# We wish to test the hypothesis that the percentage of voters in frontline 
# districts supporting free community college for lower income families is 
# higher than the percentage supporting free community college for all families. 
# Specifically, we test against the alternative p{lower income}-p{all}>0.
# 
# Note that these questions should be solved using a normal approximation, 
# not the exact or continuity corrected solutions provided by prop.test.


# Sample sizes
n_all <- 500
n_lower_income <- 500

# Number of respondents who agreed
agree_all <- 322
agree_lower_income <- 341

# Proportions
p_all <- agree_all / n_all
p_lower_income <- agree_lower_income / n_lower_income

# Question 3.a
# If we don't assume the two proportions are the same, what is our best 
# estimate of the standard error of the difference between these two proportions? 
# Save your answer in the variable q3.a

SE_a <- sqrt(p_all * (1 - p_all) / n_all + p_lower_income * (1 - p_lower_income) / n_lower_income)
q3.a <- SE_a
  
# Question 3.b
# Using the estimate of the standard error found above, calculate a 95% 
# confidence interval for the difference between the percentage supporting 
# free community college for lower income families and the percentage supporting 
# free community college for all families. (Specifically calculate a CI 
# for p{lower income}-p{all}). 
# Save your answer in the variable q3.b

Z_95 <- qnorm(0.975)  # Z-score for 95% CI
CI_lower <- (p_lower_income - p_all) - Z_95 * SE_a
CI_upper <- (p_lower_income - p_all) + Z_95 * SE_a
q3.b <- c(CI_lower, CI_upper)

# Question 3.c
# Under the assumption needed for our hypothesis test, we can calculate a 
# more accurate estimate of the standard error of the difference between 
# the two proportions; calculate that value. 
# Save your answer in the variable q3.c

p_pooled <- (agree_all + agree_lower_income) / (n_all + n_lower_income)
SE_pooled <- sqrt(p_pooled * (1 - p_pooled) * (1/n_all + 1/n_lower_income))
q3.c <- SE_pooled

# Question 3.d
# Calculate the test statistic Z for this hypothesis test. 
# Save your answer in the variable q3.d

Z_d <- (p_lower_income - p_all) / SE_pooled
q3.d <- Z_d

# Question 3.e
# Calculate the p-value for this hypothesis test. 
# Save your answer in the variable q3.e

p_value <- pnorm(Z_d, lower.tail = FALSE)
q3.e <- p_value

# Question 3.f
# TRUE or FALSE, testing at a 5\% level, we can reject the alternative that a 
# higher proportion of voters support free community college for lower income 
# families than support free community college for all families. 
# Save your answer in the variable q3.f

q3.f <- p_value < 0.05
  
  




