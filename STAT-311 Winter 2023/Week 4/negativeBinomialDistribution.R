plotpmf<-function(x, pmf, main="no title provided", 
                  xlab="no xlab provided"){
  plot(x, pmf, type='h', main=main, lwd=3,
       ylab='Probability', xlab =xlab)
}

# We can do things by hand
# Let's assume we are shuffling a deck of cards
# and drawing until we get 5 hearts (with replacement/reshuffle) 
# P(Heart)=.25
p=.25; k=5

# Let's create the PMF
x<-0:200
pmf=choose(k+x-1, x)*p^k*(1-p)^x

plotpmf(x, pmf, xlab="Number of failures", main="Negative Binomial PMF (p=.25)")

# What is the expected value?
sum(pmf*x)
mu=k*(1-p)/p

# What about the variance?
sum(pmf*(x-mu)^2)
k*(1-p)/p^2

# dnbinom will give us the PMF values
pmf[1:5]
dnbinom(0:4, k, p)

# pnbinom will give the cumulative PMF values
pnbinom(10, k, p)
sum(dnbinom(0:10, k, p))
sum(pmf[1:11])

# we can find probabilities above using lower.tail=FALSE
#  this does NOT include the value given in the function
#  only > x, not >= x
pnbinom(10, k, p, lower.tail=FALSE)
1-pnbinom(10, k, p)
sum(dnbinom(11:500, k, p))

# qnbinom will find quantiles, such as Q1, Q2, or Q3
qnbinom(.5, k, p) #Q2
pnbinom(14, k, p)
qnbinom(.25, k, p)
pnbinom(9, k, p)

# rnbinom will generate random data
max(rnbinom(10000, k, p))

# Example: If we draw cards as specified until we find
#  5 hearts, what is the probability we have 15 failures before
#  the fifth success?
# By hand
choose(5+15-1, 15)*p^5*(1-p)^15

# Using dnbinom
dnbinom(15, k, p)

# What is the probability we have between 10 and 20 failures? 
# (inclusive)
# By hand
sum(choose(5+(10:20)-1, (10:20))*p^5*(1-p)^(10:20))

# Using dnbinom
sum(dnbinom(10:20, k, p))

# Using pnbinom
pnbinom(20, k, p) - pnbinom(9, k, p)
pnbinom(9, k, p, lower.tail=FALSE)-pnbinom(20, k, p, lower.tail=FALSE)
