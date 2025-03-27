# We will sample 10 X and Y values that are uncorrelated 
y<-rnorm(100)
x<-rnorm(100)
plot(x,y)

# To create a plottable example, we will look at 9
#  other variables that represent powers of x
x2<-x**2
x3<-x**3
x4<-x**4
x5<-x**5
x6<-x**6
x7<-x**7
x8<-x**8
x9<-x**9
x10<-x**10

xplotvals<-c(-3000:3000/1000)
newdata=data.frame(x=xplotvals, 
                   x2=xplotvals**2, 
                   x3=xplotvals**3, 
                   x4=xplotvals**4, 
                   x5=xplotvals**5, 
                   x6=xplotvals**6, 
                   x7=xplotvals**7, 
                   x8=xplotvals**8, 
                   x9=xplotvals**9, 
                   x10=xplotvals**10)

# Normally we would do this with the poly command
#  but it actually knows better!
# poly(x, 10)

plot(x,y)

# Let's fit and plot the basic model.
model1=lm(y~x)
abline(model1)
summary(model1)

# Now let's add x^2
model2=lm(y~x+x2)
# Takes a bit more effort to plot
plot(x,y)
ys=predict(model2, newdata=newdata)
lines(xplotvals,ys)

# Now let's add x^3
model3=lm(y~x+x2+x3)
# Takes a bit more effort to plot
plot(x,y)
ys=predict(model3, newdata=newdata)
lines(xplotvals,ys)

# Now let's jump to x^7
model7=lm(y~x+x2+x3+x4+x5+x6+x7)
# Takes a bit more effort to plot
plot(x,y)
ys=predict(model7, newdata=newdata)
lines(xplotvals,ys)

# Now let's jump to x^10
model10=lm(y~x+x2+x3+x4+x5+x6+x7+x8+x9+x10)
# Takes a bit more effort to plot
plot(x,y)
ys=predict(model10, newdata=newdata)
lines(xplotvals,ys)

# This model perfectly predicts all data points



# AIC and BIC are not silver bullets
plot(c(1,2,3,7),c(AIC(model1),AIC(model2),AIC(model3),AIC(model7)),
     type='l', xlab='predictors', ylab='AIC')
plot(c(1,2,3,7),c(BIC(model1),BIC(model2),BIC(model3),BIC(model7)),
     type='l', xlab='predictors', ylab='AIC')
