# These values will define our distributions
means=c(17,18,17,17,17)
sds=c(3,3,3,3,3)
ns=c(35,24,62,38,19)
k=5

# These remain the same for each test
dfg=k-1
dfe=sum(ns)-k

# This will save our simulated F values
N=10000
Fvals=rep(0,N)

# Run the simulation!
for(i in 1:N){
  samp1=rnorm(ns[1], mean=means[1], sd=sds[1])
  samp2=rnorm(ns[2], mean=means[2], sd=sds[2])
  samp3=rnorm(ns[3], mean=means[3], sd=sds[3])
  samp4=rnorm(ns[4], mean=means[4], sd=sds[4])
  samp5=rnorm(ns[5], mean=means[5], sd=sds[5])
  
  grandmean=mean(c(samp1,samp2,samp3,samp4,samp5))
  xbars.list=c(mean(samp1),mean(samp2),mean(samp3),mean(samp4),mean(samp5))
  S.list=c(sd(samp1),sd(samp2),sd(samp3),sd(samp4),sd(samp5))
  MSG=1/dfg*sum(ns*(xbars.list-grandmean)^2)
  MSE=1/dfe*sum((ns-1)*S.list^2)
  Fvals[i]=MSG/MSE
}

# Does the distribution found match the expected?
hist(Fvals,freq=FALSE)
lines(0:700/100, df(0:700/100, df1=dfg, df2=dfe),lwd=3)


# Let's try it for real with our penguins data!
library(palmerpenguins)
Adelie=penguins$body_mass_g[penguins$species=="Adelie"]
Chinstrap=penguins$body_mass_g[penguins$species=="Chinstrap"]
Gentoo=penguins$body_mass_g[penguins$species=="Gentoo"]

# Do we have large samples or normal distributions?
table(penguins$species)
hist(Adelie); hist(Chinstrap); hist(Gentoo, breaks=20)

# Are the variances the same?
library("lattice")
dotplot(body_mass_g~species, data=penguins)
dotplot(penguins$body_mass_g~penguins$species)

# Note that there are explicit tests to confirm the above! 
#  But we would need a bit more statistics classes
#  to cover it all, so we focus on the core! 

# Now let's do the actual analysis! 
pengu.anova=aov(body_mass_g~species, data=penguins)
pengu.anova
summary(pengu.anova)
