library(usdata)
county=county[!is.na(county$poverty),]
hist(county$poverty, xlab='Poverty Rate', 
     main='Poverty Rate of US Counties', freq=FALSE)

# Let's consider the variable 'poverty rate' for the
#  population of US counties. We can take a sample from this
#  population, for this variable, like we did in previous assignments!
n=40;
pov.rate.sample=sample(county$poverty, n)

hist(pov.rate.sample, xlab='Poverty Rate', 
     main='Poverty Rate of sample of US Counties', freq=FALSE)

# The sample distribution (not 'sampling' distribution)
#  replicates the shape of the population, but this is clearly
#  not a proportion problem! The values sampled are not 0 or 1.
# (Rerun the above and see how it changes each sample)

# What does the distribution of sample means look like?
#  Let's take a whole bunch and find out! 

N=10000
means=rep(0,N)
for(i in 1:N) 
  means[i]=mean(sample(county$poverty, n))
# Note that you can ignore the {} if your for loop is one line long

hist(means, xlab='Average Poverty Rate', breaks=25,
     main='Average Poverty Rate of samples of US Counties', freq=FALSE)

# Note that we aren't working with percentages (values 0 to 1)
#  here, but numbers in the range 0-100; we don't need to worry
#  about converting them like we would when working with proportions
#  as all the means/sds will be relative to the units of the data
#  which ARE percentages.

# We know that distribution! What are the parameters?

# According to the central limit theorem, sample means
#  from a population should follow a normal distribution
#  with mean mu (the mean of the population) and standard 
#  deviation sigma/sqrt(n) (where sigma is the population sd)
mu=mean(county$poverty)
sigma=sd(county$poverty)

x<-110:210/10
lines(x, dnorm(x, mean=mu, sd=sigma/sqrt(n)), lwd=3)
# Looks like the normal distribution holds up well! 

# What if we wanted to do hypothesis testing though? 
#  We would need to ask how unlikely an observation is, which
#  we could do by calculating the Z value. Let's check those out.
Zs=(means-mu)/(sigma/sqrt(n))

hist(Zs, xlab='Z value', breaks=25,
     main='Z values from samples', freq=FALSE)
x<--40:40/10
lines(x, dnorm(x, mean=0, sd=1), lwd=3)

# Check our normality
mean(Zs<1 & Zs>-1) # 68
mean(Zs<2 & Zs>-2) # 95
mean(Zs<3 & Zs>-3) # 997

# Again holding up great! What if we didn't know the true 
#  population mean? What if the null we were testing was
#  wrong? 
mu=mean(county$poverty)-2
Zs=(means-mu)/(sigma/sqrt(n))

hist(Zs, xlab='Z value', breaks=25,
     main='Z values from samples (incorrect mu)', freq=FALSE)
x<--40:40/10
lines(x, dnorm(x, mean=0, sd=1), lwd=3)

# What we observe and what we expect don't line up! 
#  Is that bad?
# No! That means if we test an incorrect hypothesis, we 
#  should get 'unlikely' results and reject our null! 

# There's just one little problem... where did we get
#  our population standard deviation? Let's try and 
#  calculate Z without that; we can estimate it from the data.

N=10000
means=rep(0,N)
sds=rep(0,N)
for(i in 1:N){
  tmp.sample=sample(county$poverty, n)
  means[i]=mean(tmp.sample)
  sds[i]=sd(tmp.sample)
}

# Here S is an estimate of sigma, can we use it to estimate
#  our test statistic Z? Just for no reason at all, let's call
#  it T instead of Z. 
mu=mean(county$poverty)
Ts=(means-mu)/(sds/sqrt(n))

# Each T is (sample mean - mu)/(sample sd / sqrt(n)).
hist(Ts, xlab='T value', breaks=25,
     main='T values from samples', freq=FALSE)
x<--40:40/10
lines(x, dnorm(x, mean=0, sd=1), lwd=2)

# Let's check these for the t values
mean(Ts<1 & Ts>-1) # 68
mean(Ts<2 & Ts>-2) # 95
mean(Ts<3 & Ts>-3) # 997

# It is not entirely obvious... but the normal distribution
#  doesn't fit that well - the real distribution of 
#  T statistics is a bit wider than the normal distribution

lines(x, dt(x, df=n-1), lwd=2, col='red')

# Because we estimate the standard deviation from our sample,
#  the test statistics that we generate have more variability
#  than if we somehow knew the value of sigma.

# The distribution of T follows a "Student T" distribution.
#  We need to utilize this distribution for confidence intervals
#  and hypothesis tests! 