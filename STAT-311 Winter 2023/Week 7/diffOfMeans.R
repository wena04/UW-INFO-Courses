# We are going to look at the "Palmer's Penguins" dataset
# install.packages("palmerpenguins")
library(palmerpenguins)
table(penguins$species, penguins$island)

# We are going to compare one species of penguin (Adelie)
#  from two different islands (Dream and Torgersen)
species=penguins$species=="Adelie"
island1=penguins$island=="Dream"
island2=penguins$island=="Torgersen"
island3=penguins$island=="Biscoe"

# We want to know if the mass of Adelie penguins
#  from these two islands differ.
sample1=penguins$body_mass_g[species & island1]
sample2=penguins$body_mass_g[species & island2]
sample2=sample2[!is.na(sample2)] 
# There is one invalid datapoint
#  that needs to be removed, just some data cleaning!
sample3=penguins$body_mass_g[species & island3]


# Let's set up all our statistics to do it by hand!
xbar=mean(sample1)
ybar=mean(sample2)
sx=sd(sample1)
sy=sd(sample2)
nx=length(sample1)
ny=length(sample2)

# Let's calculate our standard error
SE=sqrt(sx^2/nx+sy^2/ny)

# We can use this to calculate a 95% CI
c((xbar-ybar)-qt(.975, df=min(nx-1, ny-1))*SE,
(xbar-ybar)+qt(.975, df=min(nx-1, ny-1))*SE)

# We want to conduct a hypothesis test, so let's
#  set up the hypotheses
# H0: There is no difference in weight of Adelie 
#  penguins on these two islands. (mux=muy)
# Ha: There is a difference in weight of Adelie
#  penguins on these two islands. (mux!=muy)

# Let's calculate the test statistic
T=((xbar-ybar)-0)/SE

# and the p-value
pt(T, df=min(nx-1, ny-1))*2

# We do not have evidence that the mass of Adelie penguins
#  differs for these two islands.

test.result=t.test(sample1, sample2)
names(test.result)


t.test(sample1, sample3)
t.test(sample2, sample3)
