# More Penguins!
library(palmerpenguins)

# We need to lose a few missing data points
# these lines remove missing NA values
penguins=penguins[!is.na(penguins$flipper_length_mm),]
penguins=penguins[!is.na(penguins$body_mass_g),]


# We want to explore the relationship between
#  body mass and flipper length, using flipper
#  length to predict body mass
plot(penguins$flipper_length_mm, penguins$body_mass_g,
     xlab='Flipper Length (mm)', ylab='Body Mass (g)',main='')

# First off, it does appear linear! 
# Let's try doing things by hand.
y=penguins$body_mass_g; x=penguins$flipper_length_mm
xbar=mean(x); ybar=mean(y)
sx=sd(x); sy=sd(y)
R=cor(x,y)

b1=sy/sx*R
b0=ybar-b1*xbar

# What is our equation?
print(paste("yhat=",b0,"(g) +",b1,"(g/mm) x"))

# We can add the regession line to the plot using abline
?abline
abline(a=b0, b=b1, lwd=3)

# As always, there is an easier way to do this in R!
lm(y~x)

# We can write this out in a few different ways 
#  using the original data frame
lm(penguins$body_mass_g~penguins$flipper_length_mm)
lm(body_mass_g~flipper_length_mm, data=penguins)


# If we save our results of the lm() function, we can
#  add it to a plot!
model=lm(body_mass_g~flipper_length_mm, data=penguins)
plot(penguins$flipper_length_mm, penguins$body_mass_g,
     xlab='Flipper Length (mm)', ylab='Body Mass (g)',main='')
abline(model, lwd=2)

# We can also get a bit more info out of a model
#  by saving it and using the summary function
summary(model)


# There is a bit more going on here than meets the eye
#  and we can do a more complex analysis of this data...
#  next week.

plot(penguins$flipper_length_mm, penguins$body_mass_g,
     xlab='Flipper Length (mm)', ylab='Body Mass (g)',main='',
     pch=as.integer(penguins$species), 
     col=c("orange","skyblue","black")[as.integer(penguins$species)])
legend("topleft",pch=c(1,2,3), col=c("orange","skyblue","black"), 
       legend=c("Adelie", "Chinstrap", "Gentoo"))
