plotpmf<-function(x, pmf, main="no title provided", 
                  xlab="no xlab provided"){
  plot(x, pmf, type='h', main=main, lwd=3,
       ylab='Probability', xlab =xlab)
}

# We can do things by hand
# Let's assume we are flipping weighted coins with 
# P(Heads)=.35
p=.35

# Let's create the PMF
x<-0:200

pmf<-p*(1-p)^x

plotpmf(x, pmf, xlab="Number of failures", main="Geometric PMF (p=.35)")

# What is the expected value?
mu=sum(x*pmf)

# What about the variance?
sum((x-mu)^2*pmf)
(1-p)/p^2

# dgeom will give us the PMF values
dgeom(0:9, p)
p*(1-p)^(0:9)

# pgeom will give the cumulative PMF values
sum(p*(1-p)^(0:9))
pgeom(9, p)


# we can find probabilities above using lower.tail=FALSE
#  this does NOT include the value given in the function
#  only > x, not >= x
pgeom(9, p, lower.tail=FALSE)
1-pgeom(9, p)
sum(dgeom(10:200,p))

# qgeom will find quantiles, such as Q1, Q2, or Q3
qgeom(.25, p) #Q1
qgeom(.5, p) #Q2
qgeom(.75, p) #Q3
pgeom(3, p)
pgeom(2, p)

# rgeom will generate random data
max(rgeom(10000, p))

# Example: If we flip weighted coins with p=.35, 
#  what is the probability we have 9 failures before
#  the first success?
# By hand
(1-p)^9*p

# Using dgeom
dgeom(9, p)

# What is the probability we have between 6 and 10 failures? 
# (inclusive)
# By hand
sum((1-p)^(6:10)*p)

# Using dgeom
sum(dgeom(6:10, p))

# Using pgeom
pgeom(10, p) - pgeom(5, p)
pgeom(5, p, lower.tail=FALSE) - pgeom(10, p, lower.tail=FALSE)