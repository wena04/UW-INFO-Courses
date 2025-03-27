# We can do things by hand by using the choose function
# Let's assume we are flipping 15 weighted coins with 
# P(Heads)=.6
p=.6; n=15

# Let's create the PMF
x<-0:15
pmf=choose(n,x)*p^x*(1-p)^(n-x)

# What is the expected value?
mu=sum(x*pmf)
p*n

# What about the variance?
sigma2=sum( (x-mu)^2*pmf )
n*p*(1-p)

# dbinom will give us the PMF values
dbinom(5, 15, .6)
choose(15,5)*p^5*(1-p)^10
pmf[6]
sum(dbinom(0:15, 15, .6)*0:15)

# pbinom will give the cumulative PMF values
pbinom(0, 15, .6)
dbinom(0, 15, .6)

pbinom(7, 15, .6)
sum(dbinom(0:7, 15, .6))
sum(pmf[1:8])

pbinom(9, 15, .6)-pbinom(8, 15, .6)
dbinom(9, 15, .6)

# qbinom will find quantiles, such as Q1, Q2, or Q3
qbinom(.25, 15, .6)#Q1
pbinom(7, 15, .6)
pbinom(8, 15, .6)
qbinom(.5, 15, .6)#Q2
qbinom(.75, 15, .6)#Q3

# rbinom will generate random data
rbinom(1000000, 15, .6)
mean(rbinom(1000000, 1, .6))

# Example: If we flip 15 weighted coins with p=.6, 
#  what is the probability we get 10 heads?
# By hand
choose(15, 10) * p^10 * (1-p)^(15-10)

# Using dbinom
dbinom(10, 15, .6)

# What is the probability we get between 6 and 10 heads? (inclusive)
# By hand
sum(choose(15, 6:10) * p^(6:10) * (1-p)^(15-6:10))

# Using dbinom
sum(dbinom(6:10, 15, .6))

# Using pbinom
pbinom(10, 15, .6) - pbinom(5, 15, .6)