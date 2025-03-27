# STAT311 - Homework 4
# Name: Anthony Wen

# Question 1
# A researcher in 2022 was attempting to measure the rate of long-COVID in the population. Unbeknownst to the researcher, approximately 6.9% of the population experienced long-COVID symptoms in 2022. During one of their shifts they have time to call and survey 220 people.

# Question 1.a How many individuals surveyed does the researcher expect to identify with long-COVID? Save your answer in the variable q1.a

n <- 220  # number of people surveyed
p <- 0.069  # proportion with long-COVID symptoms

# Expected number (mean of binomial distribution)
q1.a <- n * p

# Question 1.b: What is the probability that the researcher identifies between 10 and 20 (inclusive) individuals with long-COVID symptoms in their day of surveying? Save your answer in the variable q1.b

# Probability of identifying between 10 and 20 individuals with long-COVID
q1.b <- pbinom(20, n, p) - pbinom(9, n, p)

# Question 1.c: The researcher's manager asks them to survey at least 12 people with long-COVID symptoms. What is the probability that at the end of their shift the researcher will not have surveyed 12 individuals with long-COVID symptoms? Save your answer in the variable q1.c

# Probability of surveying fewer than 12 individuals with long-COVID
q1.c <- pbinom(11, n, p)

# Question 1.d
# At the end of their shift the researcher has only surveyed 11 people with long-COVID symptoms. Their manager asks them to work overtime calling more people until they reach 12. How many more surveys total (including the 'success')  does the researcher expect to conduct before reaching their 12 person target? Save your answer in the variable q1.d

q1.d<- 1/p

# Question 1.e: What is the probability that the researcher has to make more calls than they would expect? (Reminder that R only counts 'failures') Save your answer in the variable q1.e

q1.e <- pnbinom(q1.d-1, size = 1, prob = p,lower.tail = FALSE)

# Question 1.f: Half of the researcher's shifts will see how many (or less) individuals with long-COVID symptoms? Save your answer in the variable q1.f

# This is the 50th percentile of the binomial distribution.
q1.f <- qbinom(0.5, n, p)


# Question 2
# In America, a criminal trial jury maintains the right of jury nullification, declaring not-guilty despite evidence to the contrary due to disagreements with the law being applied in the case. It is estimated that approximately  21% of acquittals (declarations of not-guilty) are the result  of jury nullification.

# Question 2.a: Among a prosecutor's recent cases, 28 were acquittals. What is the probability that 6 of them were acquitted due to jury nullification? Save your answer in the variable q2.a

n_cases <- 28  # number of acquittals
p_nullification <- 0.21  # probability of jury nullification
k_nullified <- 6  # number of cases interested in

# Probability of k_nullified out of n_cases due to nullification
q2.a <- dbinom(k_nullified, n_cases, p_nullification)

# Question 2.b: What is the probability that at least the next 5 acquittals are not the result of jury nullification? Save your answer in the variable q2.b

# Since we want at least 5 non-nullified, we need to calculate the complement Probability of 0 to 4 nullified which is 1 - Probability of 5 nullified
q2.b <- (1 - p_nullification)^5


# Question 2.c
# How many acquittals should the prosecutor expect in total to observe the 4th jury nullification acquittal? Save your answer in the variable q2.c

# Expected number of trials to get the specified number of successes
q2.c <- 4/0.21


# Question 2.d
# What is the probability that the prosecutor sees the 4th jury nullification before the 15th acquittal? Save your answer in the variable q2.d

q2.d <- pnbinom(10, size = 4, prob = 0.21)


# Question 2.e
# 90% of the time, the prosecutor should expect how many or less non-jury 
#  nullified acquittals before the next jury nullification?
# Save your answer in the variable q2.e

# We want the 90th percentile for the geometric distribution
percentile <- 0.90

q2.e <- qgeom(percentile, prob = p_nullification)

# Question 3
# An ornothologist (a bird scientist) is spending one hour each day bird watching
#  around the habitat of a rare finch. They spot on average about 87 birds each day
#  but only 6 of them are finches. Keep in mind that the rate is expressed per 
#  hour but some of the following questions relate to the number of minutes. 

# Question 3.a
# What is the probability that the researcher spots between 80 and 100 birds (inclusive)
#  during an hour of observation.
# Save your answer in the variable q3.a

lambda_birds <- 87
lambda_finches <- 6

q3.a <- ppois(100, lambda_birds) - ppois(79, lambda_birds)


# Question 3.b
# What is the probability that the researcher spots between 8 and 10 finches (inclusive)
#  during an hour of observation.
# Save your answer in the variable q3.b
q3.b<- ppois(10, lambda_finches) - ppois(7, lambda_finches)

# Question 3.c
# If the researcher spots a total of 95 birds during a shift, what is the probability
#  that at least 7 of them are finches?
# Save your answer in the variable q3.c
q3.c<- 1-pbinom(6,95,6/87) 

# Question 3.d
# What is the probability that the researcher spots less than 4 finches on a given day?
# Save your answer in the variable q3.d
q3.d<- ppois(3, lambda_finches)

# Question 3.e
# What is the probability that the researcher does not spot 4 or more finches (per day)
# at least once in the next 3 days? 
# Save your answer in the variable q3.e
q3.e<- (1 - (1 - ppois(3, lambda_finches)))^3

# Question 3.f
# How many minutes does the researcher expect to wait before spotting their first finch?
# Save your answer in the variable q3.f
q3.f<- 60 / lambda_finches

# Question 3.g
# What is the probability that the researcher waits 20 or more minutes to spot their
#  first finch on a given shift?
# Save your answer in the variable q3.f
q3.g<- pexp(20, rate=lambda_finches/60,lower.tail = FALSE)

# Question 3.h
# What is the probability that the researcher waits 60 or more minutes to spot their
#  first finch on a given shift?
# Save your answer in the variable q3.h
q3.h<- pexp(60, rate=lambda_finches/60,lower.tail = FALSE)

# Question 3.i
# What is the probability that they spots 0 finches on a given shift?
# Save your answer in the variable q3.i
q3.i<- dpois(0, lambda_finches)


# Question 4: The average weight of newborn babies in the US is approximately 3300 grams, with a standard deviation of about 550 grams. Weights are approximately normally distributed.

# Question 4.a
# What proportion of babies born have birth weights between 2800 and 3800 grams?
# Save your answer in the variable q4.a

mean_weight <- 3300
sd_weight <- 550

q4.a<- pnorm(3800, mean_weight, sd_weight) - pnorm(2800, mean_weight, sd_weight)

# Question 4.b
# Weights below 2500 grams are considered to be low birth weight, linked to many 
#  health complications in infancy and later life. How many standard deviations
#  below the mean is 2500 grams? 
# Save your answer in the variable q4.b
z_2500 <- (2500 - mean_weight) / sd_weight

q4.b <- z_2500

# Question 4.c
# For a standard normal distribution (mean 0, sd 1), what is the probability
#  of getting a result below the number of standard deviations found above?
# Save your answer in the variable q4.c
q4.c<- pnorm(z_2500)

# Question 4.d
# Approximately 14.2% of black infants were considered low birth weight in 2019-2021.
#  What weight (in grams) should approximately 14.2% of infants be below?
# Save your answer in the variable q4.b
q4.d<- qnorm(0.142, mean_weight, sd_weight)

# Question 4.e
# The heaviest 10% of babies have what weight (in grams)?
# Save your answer in the variable q4.e
q4.e<- qnorm(0.1, mean_weight, sd_weight, lower.tail=FALSE)

# Question 4.f
# If an infant is 1.2 standard deviations below average birth weight, how much
#  do they weigh (in grams)?
# Save your answer in the variable q4.f
q4.f<- mean_weight - (1.2 * sd_weight)
