# First we read in our data and and do a little data cleaning
bikesdat=read.csv('bikesData.csv')
# The temperatures need to be scaled up to their proper values
bikesdat$temp=bikesdat$temp*41 
# We also want to toss missing values.
bikesdat=bikesdat[!is.na(bikesdat$temp),]

# For this example we are going to drop high temp days as this 
#  leads to non-linearity
bikesdat=bikesdat[bikesdat$temp<28,] 
N=length(bikesdat$temp)[1]

# We will take a sample of 75 days
n=75
set.seed(311)
samp=sample(1:N,n)
x=bikesdat$temp[samp]
y=bikesdat$cnt[samp]
plot(x,y,xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')

# Fitting our model is simple in R!
bikes.model=lm(y~x) # could do lm(cnt~temp, data=bikesdat)
summary(bikes.model)
abline(bikes.model)

# Let's save our coefficients for later.
b0=bikes.model$coefficients[[1]]
b1=bikes.model$coefficients[[2]]

# Calculating the standard errors is tedius by hand, but the model can be
#  can be used to get some of the values, and we can get others from
#  functions such as the variance.

# The MSE is the variance of the residuals * (n-1)/(n-2)
MSE=var(bikes.model$residuals) * (n-1)/(n-2)

# The numerator of the term in the SE equation for sum((xi-xbar)^2) 
#  is the variance of x * (n-1)
denominator=var(x)*(n-1)

# Let's find CIs and PIs for temperatures of X=16ºC and X=24ºC
x1=16; x2=24

# We will denote the standard error of the CIs with SEmu 
# (since we are finding a mean)
# We will denote the standard error of the PIs with SEy
SEmu1=sqrt(MSE*(1/n + (x1-mean(x))^2/denominator))
SEmu2=sqrt(MSE*(1/n + (x2-mean(x))^2/denominator))

SEy1=sqrt(MSE*(1 + 1/n + (x1-mean(x))^2/denominator))
SEy2=sqrt(MSE*(1 + 1/n + (x2-mean(x))^2/denominator))

# Let's save our 'means'
yhat1=b0+b1*x1
yhat2=b0+b1*x2

# And we need our T-value! We will construct 95% intervals 
Tstar=qt(.975, df=n-2)

# Now lets construct intervals! First the CIs.
CI1=c(yhat1-Tstar*SEmu1, yhat1+Tstar*SEmu1)
CI2=c(yhat2-Tstar*SEmu2, yhat2+Tstar*SEmu2)

print(paste("95% CI for x=", x1, ": (" ,CI1[1], ", ", CI1[2], ")" ,sep=''))
print(paste("95% CI for x=", x2, ": (" ,CI2[1], ", ", CI2[2], ")" ,sep=''))

# And the PIs...
PI1=c(yhat1-Tstar*SEy1, yhat1+Tstar*SEy1)
PI2=c(yhat2-Tstar*SEy2, yhat2+Tstar*SEy2)

print(paste("95% PI for x=", x1, ": (" ,PI1[1], ", ", PI1[2], ")" ,sep=''))
print(paste("95% PI for x=", x2, ": (" ,PI2[1], ", ", PI2[2], ")" ,sep=''))

# Let's investigate these real quick...
plot(x,y,xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')
abline(bikes.model)

# Let's look at the first prediction interval
print(paste("PI for x=", x1, ": (" ,PI1[1], ", ", PI1[2], ")" ,sep=''))
abline(h=PI1[1], lty=2)
abline(h=PI1[2], lty=2)
abline(v=15, lty=3)
abline(v=17, lty=3)

# Let's add all the points between 23 and 25 degrees
inds=(bikesdat$temp>=15 & bikesdat$temp<=17)
points(bikesdat$temp[inds], bikesdat$cnt[inds], pch=3)


# What about the second prediction interval?
plot(x,y,xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')
abline(bikes.model)
print(paste("PI for x=", x2, ": (" ,PI2[1], ", ", PI2[2], ")" ,sep=''))
abline(h=PI2[1], lty=2)
abline(h=PI2[2], lty=2)
abline(v=23, lty=3)
abline(v=25, lty=3)

# Let's add all the points between 15 and 17 degrees
inds=(bikesdat$temp>=23 & bikesdat$temp<=25)
points(bikesdat$temp[inds], bikesdat$cnt[inds], pch=3)

# Investigating the CIs is a little more involved
# First let's learn how to make predictions, PIs and CIs 
#  using the native R functions.
# As always, it is very simple! 
?predict
predict(bikes.model)
predict(bikes.model, newdata=data.frame(x=c(x1,x2)))
# Here we define new data using x, since that's what the model
#  uses to define the explanatory variable

# If we instead used lm(cnt~temp, data=bikesdat)
#  then newdata would be newdata=data.frame(temp=c(x1,x2))

# To get CIs and PIs, we need to specify the interval type.
predict(bikes.model, newdata=data.frame(x=c(x1,x2)),
        interval="confidence")
predict(bikes.model, newdata=data.frame(x=c(x1,x2)),
        interval="prediction")

# You can use this as a data frame by passing it into 
#  as.data.frame
predict.df=as.data.frame(predict(bikes.model, 
                                 newdata=data.frame(x=c(x1,x2)),
                                 interval="confidence"))

# These default to 95% intervals, 
#  but we can get different intervals using "level"
predict(bikes.model, newdata=data.frame(x=c(x1,x2)), 
        interval="confidence", level=.99)
predict(bikes.model, newdata=data.frame(x=c(x1,x2)), 
        interval="prediction", level=.90)

# Let's see how they look for all values of X
plot(x,y,xlab='Temp (Celcius)', ylab='Rentals',
     main='Predicting bikeshare rental from temperature')
abline(bikes.model)

# Let's make prediction and confidence intervals for all
#  observed values of X, from 5 to 30.
newdata=data.frame(x=(50:300)/10)
CIall=predict(bikes.model, newdata=newdata, 
        interval="confidence", level=.95)
PIall=predict(bikes.model, newdata=newdata, 
        interval="prediction", level=.95)

# Sadly the CIall and PIall are not actual data frames
#  so we need to index them like matrices
lines(newdata$x, CIall[,2], lty=2, lwd=2, col='orange')
lines(newdata$x, CIall[,3], lty=2, lwd=2, col='orange')
lines(newdata$x, PIall[,2], lty=2, lwd=2, col='skyblue')
lines(newdata$x, PIall[,3], lty=2, lwd=2, col='skyblue')

# Look at all the points?
# points(bikesdat$temp, bikesdat$cnt, pch=3)

# Let's try making more regression equations from
#  other samples of the data.
set.seed(3110)
intercepts=rep(0,100)
slopes=rep(0,100)

# We will take a sample of 75 days
for(i in 1:100){
  n=75
  samp0=sample(1:N,n)
  x0=bikesdat$temp[samp0]
  y0=bikesdat$cnt[samp0]

  bikes.model0=lm(y0~x0)

  # Let's save our coefficients for later.
  intercepts[i]=bikes.model0$coefficients[[1]]
  slopes[i]=bikes.model0$coefficients[[2]]
}

for(i in 1:100)
  abline(a=intercepts[i], b=slopes[i])
abline(a=b0, b=b1, col='green', lwd=2)
lines(newdata$x, CIall[,2], lty=2, lwd=2, col='orange')
lines(newdata$x, CIall[,3], lty=2, lwd=2, col='orange')
