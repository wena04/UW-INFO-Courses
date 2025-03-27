# It is estimated that (in 2022) approximately 22% of
#  US hospitals were understaffed.

p=.22

# Let's imagine we sample n=672 hospitals and find
#  phat=.223 or 22.3% of our sample is understaffed.

phat=.223; n=672

# First off, what is the distribution of phat values?
#  Let's simulate it with N=10,000 sample means (phat)
N=100000
phatvals<-rep(0,N)
for(i in 1:N){
  phatvals[i]=rbinom(1, n, p)/n
}

hist(phatvals,freq=FALSE, breaks=15, 
     main="Sampling distribution of phat",
     xlab="phat", ylim=c(-50,25), yaxt='n', ylab='')
lines(150:300/1000, dnorm(150:300/1000, p, sqrt(p*(1-p)/n)))

# Where is our middle 95%? 

qnorm(.025, p, sqrt(p*(1-p)/n))
qnorm(.975, p, sqrt(p*(1-p)/n))

p+qnorm(.975)*sqrt(p*(1-p)/n)
p-qnorm(.975)*sqrt(p*(1-p)/n)

polygon(c(189:251/1000,251/1000,189/1000),
        c(dnorm(189:251/1000, p, sqrt(p*(1-p)/n)),0,0), 
        col = rgb(0, 0, 255, max = 255, alpha = 125))

abline(v=p, lwd=3)
abline(v=qnorm(.025, p, sqrt(p*(1-p)/n)), lwd=1, col="blue", lty=2)
abline(v=qnorm(.975, p, sqrt(p*(1-p)/n)), lwd=1, col="blue", lty=2)

plotCI<-function(phat_in, i){
  Z=qnorm(.975)
  CI=c(phat_in-Z*sqrt(phat_in*(1-phat_in)/n),
       phat_in+Z*sqrt(phat_in*(1-phat_in)/n))
  if(CI[1]<p & CI[2]>p) color="blue"
  else color="orange"
  points(phat_in,i,col=color, lwd=2)
  lines(CI,c(i,i),col=color, lwd=2)
}

# Let's check our CI for our sample

phat=.223; n=672

# We can calculate our CI using the formula: phat +- Z * SE

SE=sqrt(phat*(1-phat)/n)
Z=qnorm(.975)

CI=c(phat-Z*SE, 
     phat+Z*SE)

print(CI)

plotCI(phat, -1)

# Let's sample a few more potential phat

plotCI(rbinom(1, n, p)/n, -2)
plotCI(rbinom(1, n, p)/n, -3)
plotCI(rbinom(1, n, p)/n, -4)
plotCI(rbinom(1, n, p)/n, -5)

# And a few more

for(i in -(6:50))
  plotCI(rbinom(1, n, p)/n, i)




fulltest<-function(){
  hist(phatvals,freq=FALSE, breaks=15, 
       main="Sampling distribution of phat",
       xlab="phat", ylim=c(-50,25), yaxt='n', ylab='')
  lines(150:300/1000, dnorm(150:300/1000, p, sqrt(p*(1-p)/n)))
  
  polygon(c(189:251/1000,251/1000,189/1000),
          c(dnorm(189:251/1000, p, sqrt(p*(1-p)/n)),0,0), 
          col = rgb(0, 0, 255, max = 255, alpha = 125))
  
  abline(v=p, lwd=3)
  abline(v=qnorm(.025, p, sqrt(p*(1-p)/n)), lwd=1, col="blue", lty=2)
  abline(v=qnorm(.975, p, sqrt(p*(1-p)/n)), lwd=1, col="blue", lty=2)

  for(i in -(1:50))
    plotCI(rbinom(1, n, p)/n, i)
}

fulltest()
