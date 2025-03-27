plotpmf<-function(x, pmf, main="no title provided", 
                  xlab="no xlab provided"){
  plot(x, pmf, type='h', main=main, lwd=3,
       ylab='Probability', xlab =xlab)
}

plotpdf<-function(x, pmf, main="no title provided", 
                  xlab="no xlab provided"){
  plot(x, pmf, type='l', main=main, lwd=3,
       ylab='Likelihood', xlab =xlab)
}

# Starting with the Poisson distribution
# We can do things by hand
# Let's model the number of fish that swim through the locks
#  in a one hour time span, which for the season in question 
#  averages to 25 fish per hour.
lambda=25

# Let's create the PMF
x<-0:100

pmf=lambda^x*exp(-lambda)/factorial(x)

plotpmf(x, pmf, xlab='Number of fish', main='Fish distribution')
# What is the expected value?
sum(pmf*x)
mu=lambda

# What about the variance?
sum(pmf*(x-mu)^2)

# dpois will give us the PMF values
dpois(x, lambda)[0:5]
pmf[1:6]

# ppois will give the cumulative PMF values
ppois(25, lambda)
ppois(24, lambda)

# we can find probabilities above using lower.tail=FALSE
#  this does NOT include the value given in the function
#  only > x, not >= x
1-ppois(24, lambda)
ppois(24, lambda, lower.tail=FALSE)

# qpois will find quantiles, such as Q1, Q2, or Q3
qpois(.5, lambda)
qpois(.99, lambda)

# rpois will generate random data
rpois(10, lambda)

# Example: If we count the number of fish passing through
#  the locks per hour, what is the probability that we observe
#  exactly 15 fish?
# By hand
lambda^15*exp(-lambda)/factorial(15)

# Using dpois
dpois(15, lambda)

# What is the probability we have between 10 and 20 fishes? 
# (inclusive)
# By hand
x<-10:20

sum(lambda^x*exp(-lambda)/factorial(x))

# Using dpois
sum(dpois(x,lambda))

# Using ppois
ppois(9, lambda, lower.tail=FALSE)-ppois(20, lambda, lower.tail=FALSE)




# Next moving to the exponential distribution
# Let's model the time between each fish observation
#  in a one hour time span, which for the season in question 
#  averages to 25 fish per hour.
lambda=25

# Let's create the PDF
x<-0:100/100

pdf=lambda*exp(-lambda*x)

plotpdf(x,pdf,xlab='Fish waiting time (h)', main='Exponential distribution')

# What is the expected value?
# We can't find it from our pdf, as it is just a sample of points
#  instead let's try simulating it?
mean(rexp(10000000, rate=lambda))
1/lambda

# What about the variance?
var(rexp(10000000, rate=lambda))
1/lambda^2

# dexp will give us the PDF values
dexp(0:10/100,lambda)

# pexp will give the cumulative PDF values
#  or the cumulative distribution function - the CDF
plot(1:100/100,pexp(1:100/100,lambda),type='l')
pexp(1/60, lambda)

# we can find probabilities above using lower.tail=FALSE
#  here, the distinction between  > x and >= x is irrelevant
pexp(1/60, lambda, lower.tail=FALSE)

# qexp will find quantiles, such as Q1, Q2, or Q3
qexp(.999, lambda)

# rexp will generate random data, as we've seen
rexp(100, lambda)

# Example: If we arrive at the locks and wait until we see 
#  a fish swim through, what is the probability that we wait 
#  one minute exactly?
# Using pexp
pexp(1/60, lambda)-pexp(1/60, lambda)

# What is the probability we wait between 1 and 5 minutes? 
# Using pexp
pexp(5/60, lambda)-pexp(1/60, lambda)

# What is the probability that we end up waiting at least 2 minutes?
1-pexp(2/60, lambda)
pexp(2/60, lambda, lower.tail=FALSE)

# What is the probability that we end up waiting
#  4 minutes given we have waited for 2 minutes?
# P(A|B)=P(A and B)/P(B)
PB=pexp(2/60, lambda, lower.tail=FALSE)
PAandB=pexp(4/60, lambda, lower.tail=FALSE)

PAandB/PB==PB
# This is the memoryless property