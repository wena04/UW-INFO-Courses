plotpdfs<-function(x1, x2, pdf1, pdf2){
  plot(c(min(c(x1,x2)),max(c(x1,x2))), c(0,max(c(pdf1,pdf2))),
         type='n', ylab='Likelihood', main="Normal Distributions of heart rate", 
         xlab="BPM")
  lines(x1, pdf1, lwd=2)
  lines(x2, pdf2, lwd=2)
  abline(h=0)
}

# The rate at which your heart beats 
# (well, maybe not YOUR heart, but people's hearts in general)
# while at rest is approximately normal with mean 72 BPM
# and standard deviation of 12 BPM
# For newborn infants the distribution is N(176, 15)

# Let's create the PDF for both distributions
muA=72; muI=176
sdA=12; sdI=15
xAdult<-(muA-3*sdA):(muA+3*sdA)
xInfant<-(muI-3*sdI):(muI+3*sdI)

pdfAdult=1/(sdA*sqrt(2*pi))*exp(-.5*(xAdult-muA)^2/sdA^2)
pdfInfant=1/(sdI*sqrt(2*pi))*exp(-.5*(xInfant-muI)^2/sdI^2)

plotpdfs(xAdult, xInfant, pdfAdult, pdfInfant)

# dnorm will give us the PMF values
dnorm(60, mean=muA, sd=sdA)
1/(sdA*sqrt(2*pi))*exp(-.5*(60-muA)^2/sdA^2)

# pnorm will give the cumulative PMF values
#  Let's recreate the 68, 95, 99.7 rule
pnorm(1)-pnorm(-1)
pnorm(muA+1*sdA, mean=muA, sd=sdA)-pnorm(muA-1*sdA, mean=muA, sd=sdA)
pnorm(muI+1*sdI, mean=muI, sd=sdI)-pnorm(muI-1*sdI, mean=muI, sd=sdI)

pnorm(2)-pnorm(-2)
pnorm(3)-pnorm(-3)

pnorm(muA+2*sdA, mean=muA, sd=sdA)-pnorm(muA-2*sdA, mean=muA, sd=sdA)
pnorm(muI+3*sdI, mean=muI, sd=sdI)-pnorm(muI-3*sdI, mean=muI, sd=sdI)

# qnorm will find quantiles
((qnorm(.9, mean=muA, sd=sdA)-muA)/sdA)*sdI+muI
pnorm(195.2233, mean=muI, sd=sdI)

# rnorm will generate random data
radults=rnorm(10000, mean=muA, sd=sdA)
rinfants=rnorm(10000, mean=muI, sd=sdI)
hist(radults)
hist(rinfants)
hist(c(rinfants,radults))
