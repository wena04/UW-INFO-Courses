# Let's calculate the normal approximation!
n=72; p=.25;
SE = sqrt(p*(1-p)/n)
phat=26/72; phatcc=25.5/72;

Zcc = (phatcc - p) / SE
Zcc

# The probability of getting a value at or higher
#  than the given Z:
pnorm(Zcc, lower.tail=FALSE)

# Or we can find directly:
pnorm(phatcc, mean=p, sd=SE, lower.tail=FALSE)

# And what about the exact probability with binomial?
pbinom(26-.5, size=n, prob=p, lower.tail=FALSE)




# How do we find the rejection region? 
# Starting with normal
Z=qnorm(.95)
rejection_region=p+Z*SE
rejection_region

# Or we can find directly
qnorm(.05, mean=p, sd=SE, lower.tail=FALSE)

# And the binomial distribution? 
qbinom(.95, size=n, prob=p)
qbinom(.05, size=n, prob=p, lower.tail=FALSE)

# We need to be careful here; 
pbinom(24-.5, size=n, prob=p, lower.tail=FALSE)

# We would fail to reject for this value, but would
#  reject for this value +1
pbinom(25-.5, size=n, prob=p, lower.tail=FALSE)

# So what is the probability that we reject if p=.41?
ptrue=.41

# Normal approximation:
SE=sqrt(ptrue*(1-ptrue)/n)
Z=(rejection_region-ptrue)/SE
Z

pnorm(Z, lower.tail=FALSE)
pnorm(rejection_region, mean=ptrue, sd=SE, lower.tail=FALSE)

# Exact binomial? 
pbinom(25-.5, size=n, prob=ptrue, lower.tail=FALSE)
