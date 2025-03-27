#install.packages("palmerpenguins")
library("palmerpenguins")

plot(penguins$flipper_length_mm, penguins$body_mass_g,
     xlab='Flipper length (mm)', ylab='Body mass (g)',
     main='Penguin bodymorphism')

# Let's fit the same basic model to this data
basic.model=lm(body_mass_g~flipper_length_mm, data=penguins)
abline(basic.model)

# Let's check our diagnostics and make sure this is a good fit
qqnorm(basic.model$residuals)
plot(basic.model$fitted.values, basic.model$residuals)
abline(h=0)
# Looks great! Perfect, we're done! 

# Or are we...? 
plot(penguins$flipper_length_mm, penguins$body_mass_g,
     xlab='Flipper length (mm)', ylab='Body mass (g)',
     main='Penguin bodymorphism', 
     col=c('black','orange','blue')[penguins$species])
legend("topleft", legend=levels(penguins$species), 
       col=c('black','orange','blue'), pch=1)

# It looks like there is a relationship between the species
#  and the ratio of flipper length to body mass

# Let's try adding the species to the model and see 
#  how that impacts our ability to predict and accurately
#  represent this data!

# If we add species as a factor with penguins$species
#  it will introduce a new intercept term for each species.
# Note that this only works because "species" is a 'factor'
#  data object rather than a list of strings
# We can convert other data into factors with as.factor(variable)
#  but we shouldn't need that here!

intercept.model=lm(body_mass_g~flipper_length_mm+species, 
                   data=penguins)
summary(intercept.model)
abline(a=intercept.model$coefficients[[1]],
       b=intercept.model$coefficients[[2]],
       col='black', lwd=2)
abline(a=intercept.model$coefficients[[1]]+intercept.model$coefficients[[3]],
       b=intercept.model$coefficients[[2]],
       col='orange', lwd=2)
abline(a=intercept.model$coefficients[[1]]+intercept.model$coefficients[[4]],
       b=intercept.model$coefficients[[2]],
       col='blue', lwd=2)

# Again note that each species has its own intercept, with Adelie
#  penguins represented by the base intercept (and every other
#  represented by that plus their own intercept)

# Let's check our diagnostics and make sure this is a good fit
qqnorm(intercept.model$residuals)
plot(intercept.model$fitted.values, intercept.model$residuals)
abline(h=0)
# Data seems a little more separated but that's okay!


# If we want to give each species its own slope, we
#  can consider an interaction model. By default, interaction
#  terms also add the terms to the equation as non-interaction 
#  terms, so we only need species*flipper, 
#  not species*flipper + flipper + species
# We could remove one of these terms, such as the intercepts
#  with species*flipper-species, but we won't do that here (try yourself!)
interaction.model=lm(body_mass_g~flipper_length_mm*species, 
                   data=penguins)
summary(interaction.model)

# Check the diagnostics;
qqnorm(interaction.model$residuals)
plot(interaction.model$fitted.values, interaction.model$residuals)
abline(h=0)
# Still looks good!

# Let's see how they look!
plot(penguins$flipper_length_mm, penguins$body_mass_g,
     xlab='Flipper length (mm)', ylab='Body mass (g)',
     main='Penguin bodymorphism', 
     col=c('black','orange','blue')[penguins$species])
legend("topleft", legend=levels(penguins$species), 
       col=c('black','orange','blue'), pch=1)

# It can be a bit involved to draw the different lines here, 
#  but we will use the predict() function to try and fit them
# We need to create proper 'levels' to describe the species
species=levels(penguins$species)
print(species)
x=165:235
y_adelie=predict(interaction.model, 
                 newdata=data.frame(flipper_length_mm=x, 
                                    species=rep(species[1],length(x))))
y_chinstrap=predict(interaction.model, 
                 newdata=data.frame(flipper_length_mm=x, 
                                    species=rep(species[2],length(x))))
y_gentoo=predict(interaction.model, 
                 newdata=data.frame(flipper_length_mm=x, 
                                    species=rep(species[3],length(x))))

lines(x, y_adelie, col='black', lwd=2)
lines(x, y_chinstrap, col='orange', lwd=2)
lines(x, y_gentoo, col='blue', lwd=2)

# The black and orange lines don't look all that different,
#  which comports with our p-values for the model!
summary(interaction.model)
