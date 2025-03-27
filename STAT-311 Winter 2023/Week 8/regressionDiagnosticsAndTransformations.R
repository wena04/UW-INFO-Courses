# First we read in our data and and do a little data cleaning
bikesdat=read.csv('bikesData.csv')
# The temperatures need to be scaled up to their proper values
bikesdat$temp=bikesdat$temp*41
# We also want to toss missing values.
bikesdat=bikesdat[!is.na(bikesdat$temp),]
N=length(bikesdat$temp)[1]

# We will take a sample of 125 days
# Note, we have NOT dropped higher temps!
n=125
set.seed(3110)
samp=sample(1:N,n)
x=bikesdat$temp[samp]
y=bikesdat$cnt[samp]
plot(x, y, xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')

bikes.model=lm(y~x)
abline(bikes.model)
summary(bikes.model)

# This is not a good fit! We can see more accurately by looking
#  at a diagnostic, comparing the fitted values with residuals
plot(bikes.model$fitted.values, bikes.model$residuals, 
     xlab='fitted values', ylab='residuals')
abline(h=0) # Points will fall around a line at resid=0

# We can also check to see if residuals follow a normal distribution
#  around 0, which we are assuming
hist(bikes.model$residuals, freq=FALSE, xlab='Residuals', breaks=20)
qqnorm(bikes.model$residuals)

# This should be a straight line! An "S" like shape indicates "s"hort tails
#  while an "H" like shape indicates "h"eavy tails.

# This should have NO trend! It possibly has some trend! 

# Let's try transforming some of the data; first, 'normalizing'
#  where we subtract mean(x) (or y) and divide by sd(x) (or y), 
#  rendering all values to have mean 0 and SD of 1.
x.scaled=(x-mean(x))/sd(x)
y.scaled=(y-mean(y))/sd(y)

plot(x.scaled, y.scaled, xlab='Temp (normalized)', 
     ylab='Rentals (normalized)',
     main='Predicting bikeshare rental from temperature')
bikes.scaled.model=lm(y.scaled~0+x.scaled)
abline(bikes.scaled.model)
summary(bikes.scaled.model)

# This is not a good fit! We can see more accurately by looking
#  at a diagnostic, comparing the fitted values with residuals
plot(bikes.model$fitted.values, bikes.model$residuals, 
     xlab='fitted values', ylab='residuals')
abline(h=0) # Points will fall around a line at resid=0

# And check QQnorm...
qqnorm(bikes.scaled.model$residuals)

# Wow, we accomplished literally nothing (except getting rid of the
#  intercept I guess?) :(

# Let's try something different; rather than scaling the data, let's
#  add more variables to the analysis! But we only have X and Y...
#  we can add transformations of X, such as sqrt(X), X^2, X^3, ...
#  we will try adding both x^2 and x^3
plot(x, y, xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')
bikes.mvmodel=lm(y~poly(x, degree=3, raw=TRUE))
# Our model is y=b0+b1*x+b2*x^2+b3*x^3
summary(bikes.mvmodel)

# Sadly the abline function no longer suits our needs.
abline(bikes.mvmodel)
# We will draw this one by hand, 
#  but we need the coefficients of the model
xrange<-5:35
b0=bikes.mvmodel$coefficients[[1]]
b1=bikes.mvmodel$coefficients[[2]]
b2=bikes.mvmodel$coefficients[[3]]
b3=bikes.mvmodel$coefficients[[4]]

lines(xrange, b0+b1*xrange+b2*xrange^2+b3*xrange^3)

# This is not a good fit! We can see more accurately by looking
#  at a diagnostic, comparing the fitted values with residuals
plot(bikes.mvmodel$fitted.values, bikes.mvmodel$residuals, 
     xlab='fitted values', ylab='residuals')
abline(h=0) # Points will fall around a line at resid=0
# Note that the variance is non-constant, 
#  with more spread toward higher values

# We can also check to see if residuals follow a normal distribution
#  around 0, which we are assuming
qqnorm(bikes.model$residuals)


# Let's try just adding X and X^2 to the model, no X^3
plot(x, y, xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')
bikes.mvmodel=lm(y~poly(x, degree=2, raw=TRUE))
summary(bikes.mvmodel)

# We will draw this one by hand, but we need the coefficients of the model
xrange<-5:35
b0=bikes.mvmodel$coefficients[[1]]
b1=bikes.mvmodel$coefficients[[2]]
b2=bikes.mvmodel$coefficients[[3]]

lines(xrange, b0+b1*xrange+b2*xrange^2)

# This is not a good fit! We can see more accurately by looking
#  at a diagnostic, comparing the fitted values with residuals
plot(bikes.mvmodel$fitted.values, bikes.mvmodel$residuals, 
     xlab='fitted values', ylab='residuals')
abline(h=0) # Points will fall around a line at resid=0
# Note that the variance is non-constant, with more spread toward higher values

# We can also check to see if residuals follow a normal distribution
#  around 0, which we are assuming
qqnorm(bikes.model$residuals)

# Sadly this has the same problem! This analysis might require using more
#  variables to assess the complex relationships going on here! 

# Let's try transforming y and see what happens
# Let's try just adding X and X^2 to the model, no X^3
plot(x, sqrt(y), xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')
bikes.mvmodel=lm(sqrt(y)~poly(x, degree=2, raw=TRUE))
summary(bikes.mvmodel)

# We will draw this one by hand, but we need the coefficients of the model
xrange<-5:35
b0=bikes.mvmodel$coefficients[[1]]
b1=bikes.mvmodel$coefficients[[2]]
b2=bikes.mvmodel$coefficients[[3]]

lines(xrange, b0+b1*xrange+b2*xrange^2)

# Let's see if it fits well
plot(bikes.mvmodel$fitted.values, bikes.mvmodel$residuals, 
     xlab='fitted values', ylab='residuals')
abline(h=0) # Points will fall around a line at resid=0

# This is NOT a good transformation of y.