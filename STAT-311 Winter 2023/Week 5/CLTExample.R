# 76% of working Americans do not have savings for 1 month of expenses
p=.76
N=161866000 # Estimated number of "employed persons" in the US (Nov 2023)
# Fun fact, this is a record number of employed persons, 
# "nobody wants to work anymore?" may not be as true as some pretend.

# Let's build our population:
pop<-c(rep(1,N*p), rep(0, N*(1-p)))

# What does our population look like?
hist(pop)

# Let's take a sample and find the average (proportion)
# We will start by sampling n=10 people.
n=10
phat=mean(sample(pop, n))

# What about n=50? 
n=50
phat=mean(sample(pop, n))

# What about n=100? 
n=100
phat=mean(sample(pop, n))

# What about n=1000?
n=1000
phat=mean(sample(pop, n))

# Let's repeat this process multiple times
#  again with n=10
n=10
phats10<-rep(0,10000)
for(i in 1:10000){
  phat=mean(sample(pop, n))
  phats10[i]=phat
}
hist(phats10, freq=FALSE)
mean(phats10)
sd(phats10)
sqrt(p*(1-p)/n)

# with n=100
n=100
phats100<-rep(0,10000)
for(i in 1:10000){
  phat=mean(sample(pop, n))
  phats100[i]=phat
}
hist(phats100, freq=FALSE)
mean(phats100)
sd(phats100)
sqrt(p*(1-p)/n)

# According to CLT the mean should be approximately p
# SD should be approximately SQRT(p*(1-p)/n)

# with n=1000
n=1000
phats1000<-rep(0,10000)
for(i in 1:10000){
  phat=mean(sample(pop, n))
  phats1000[i]=phat
}
hist(phats1000, freq=FALSE, breaks=25)
mean(phats1000)
sd(phats1000)
sqrt(p*(1-p)/n)



