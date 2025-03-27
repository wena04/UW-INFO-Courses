# Some data management here to clean it up
data(Titanic)
tdf <- as.data.frame(Titanic)
TitanicData <- tdf[rep(1:nrow(tdf), tdf$Freq), -5]
TitanicData$Survived=(TitanicData$Survived=="Yes")

# And changing some levels which will affect our baseline values
TitanicData <- within(TitanicData, Class <- relevel(Class, ref = "3rd"))
TitanicData <- within(TitanicData, Age <- relevel(Age, ref = "Adult"))
names(TitanicData)
table(TitanicData$Survived)
table(TitanicData$Sex)
table(TitanicData$Age)
table(TitanicData$Class)


# Let's start with a basic model, including only an intercept
# To fit logistic regression, we specify an equation like in
#  linear regression, but using the "glm(...)" function.
# BE SURE TO specify "family="binomial"" in the function
#  as the default will assume "Survived" is a linear relationship
#  not a logistic regression.
model1=glm(Survived~1, data=TitanicData, family = "binomial")

# We can use this to find the average survival rate for everyone
x=-0.73986
exp(x)/(1+exp(x))
1/(1+exp(-x))
plogis(x)
mean(TitanicData$Survived)

summary(model1)
AIC(model1)
BIC(model1)

# We obviously need to add variables to the model, otherwise
#  we are just calculating the mean survival rate.
# We will fit 3 different models.
# One for each of the individual variables.
model2=glm(Survived~1+Sex, data=TitanicData, family = "binomial")
model3=glm(Survived~Age, data=TitanicData, family = "binomial")
model4=glm(Survived~Class, data=TitanicData, family = "binomial")

# We can check to be sure each of these 
#  variables is significant in the model
summary(model2)
summary(model3)
summary(model4)

# Each one is significant, but model 4 introduces 3 terms 
#  to the model, and not each one is significant. 
# In this context, we interpret the models terms
#  as deviation from from the baseline. 
# Here our baseline is Adult, Male, and 3rd class.
# Worth noting that there is not a significant difference
#  in survival rate of 3rd class and crew (in this model).

# To compare these models we can check AIC and BIC
c(AIC(model1), AIC(model2), AIC(model3), AIC(model4))
c(BIC(model1), BIC(model2), BIC(model3), BIC(model4))

# This seems to indicate that adding Sex to the model 
#  is the best predictor. 
currentmodel=model2

# We can actually get this same result by utilizing the
#  "step" function. The use of this is fairly complex, but
#  first requires defining a model with all possible
#  terms we want to consider. We will call this 
#  modelfull, but as we will see, there are more terms
#  than we have here.
modelfull=glm(Survived~Sex+Age+Class, data=TitanicData, family = "binomial")

# We start from model1, and use the full model as our scope of
#  potential variables to add, noting that we step forward 
# Stepping forward means we add to the model, but this function
#  can also be used "backward" to remove terms from the model.
step(model1, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=1)

# This seems to suggest adding the "Sex" predictor to the model
#  so we will update the model and call it "current.model"
current.model=glm(Survived~Sex, data=TitanicData, family = "binomial")

# Let's use "step" again to see if we should add more variables to the model
#  or stop here.
step(current.model, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=1)

# It recommends adding the "Class" variable to the model, so we will update
#  the current model with "Class". 
current.model=glm(Survived~Sex+Class, data=TitanicData, family = "binomial")
summary(current.model)

# The only remaining variable to add to the model is "Age", but
#  what about the interaction between Class and Sex? Let's add that to the
#  "modelfull" before we proceed.
modelfull=glm(Survived~Age+Class*Sex, data=TitanicData, family = "binomial")

step(current.model, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=1)

# Interestingly, using AIC to choose a model suggests that we should add
#  an interaction between "Class" and "Sex" rather than "Age". 
# We can either fit this model using this notation:
current.model=glm(Survived ~ Sex*Class,
                  data=TitanicData, family = "binomial")
# Or this notation, where we specify each of the non-interaction terms
current.model=glm(Survived ~ Sex + Class + Sex:Class,
                  data=TitanicData, family = "binomial")
# Including an interaction term without including the non-interaction
#  components can be done using Variable1:Variable2

# Again the only variable left to add is "Age", let's try doing it manually
#  and see if it is significant, then let's check if the step function agrees.

# First, what do we have?
summary(current.model)

# All terms except "Class2nd" appear to be significant. "ClassCrew" is 
#  significant but only slightly, and if we consider all the tests are are
#  conducting we might consider this to be a type 1 error, but it is clear
#  that "Class1st" is significant, so we will keep each term in the model. 

# We also note all the interaction terms between "Class" and "Sex" are 
#  significant, which encourages keeping the class term as well.

# Let's add "Age" to the model and see if it is still significant. 
new.model=glm(Survived~Sex*Class+Age,data=TitanicData, family = "binomial")
summary(new.model)

# Not only is "Age" significant in the model, but it has impacted the
#  significance of "ClassCrew". Remember that the p-values here repesent
#  the probability of observing this strong of an effect in the model
#  assuming the effect is actually 0, but "in the model" here refers to
#  the model with all the specific variables considered. So the 
#  "ClassCrew" term is significantly different from 0 given the model
#  Survived~Sex*Class+Age

# "Class2nd" is still not sigificant, indicating that we lack evidence
#  of a significant difference in the survival rate of males in the 2nd
#  and 3rd (our baseline) classes. (Survival rate for females is highly
#  significant though, as noted from the interaction term.)

# Let's double check that the step function also adds this term.
step(current.model, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=1)

# Indeed it does appear to reduce the AIC of the model, so we will update
#  the current model. 
current.model=glm(Survived~Sex*Class+Age,data=TitanicData, family = "binomial")

# There are now no more terms to add to the model unless we include 
#  interactions between "Sex" and "Age", or "Class" and "Age", but 
#  let's give that a try.

# First we need to update the "modelfull" to include all interaction terms.
modelfull=glm(Survived~Age*Class+Age*Sex+Class*Sex, 
              data=TitanicData, family = "binomial")
# (We technically neglect the interaction term between all 3 variables, but
#  we are already running into some issues...)

# A look at the summary output reveals some issues.
summary(modelfull)

# This model may be becoming too saturated to be an accurate description 
#  of the underlying process dictating survival. This is what is called 
#  "overfitting", and what the AIC or BIC scores hope to avoid.
# Still, let's see what the step function decides.
step(current.model, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=1)

# This seems to indicate that adding the "Age" and "Class" interaction
#  term is improving the model, even with the error due to there being
#  no children in the crew.
current.model=glm(Survived~Sex*Class+Age*Class,data=TitanicData, 
                  family = "binomial")

# There is still the question of whether or not to add the interaction between
#  "Age" and "Sex" 
step(current.model, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=1)

# Using AIC, it appears that this is not a suggested model. Using AIC suggests
#  that the best model would be:
# Survived ~ Sex + Age + Class + Sex:Class + Class:Age
# But let's check that first...
summary(current.model)

# So aside from the fact that we have an error for the lack of 
#  children in the crew (which is an error in the model but
#  children not working on ship crews is probably a good call)
#  it appears that the terms for interaction between "Class"
#  and "Age" are ALL non-significant. So AIC has someone lead
#  us astray here.

# Thus by using our big statistically-minded brains, we can make
#  more informed decisions than by just using the AIC values. 
final.model=glm(Survived ~ Sex+Class+Age+Sex*Class,data=TitanicData, 
                family = "binomial")
summary(final.model)



# As a note, each time we used 'step' we took a maximum of 1 steps at a time
# This allows more careful analysis at each step, but we can alternatively 
#  just keep taking steps until the model finishes.

# Let's try that from model1 and see what we get. (We stop at 100 steps)
step(model1, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=100)

# It appears to end in the same spot. We can try taking backward 
# steps as well from the full model.

# This removes one item at a time until it reaches a maximal AIC, but will not
#  always return the same model as starting from empty and building upward.
# (Here it does return the same model)
step(modelfull, scope=list(lower=~1, upper=modelfull), 
     direction="backward", steps=100)

# We can alternatively use BIC to score the step function.
# To do this we add the argument "k=log(n)"
#  where n is the length of our data
n=length(TitanicData$Survived)
step(model1, scope=list(lower=~1, upper=modelfull), 
     direction="forward", steps=100, k=log(n))

# And backward. 
step(modelfull, scope=list(lower=~1, upper=modelfull), 
     direction="backward", steps=100, k=log(n))

# It appears to lead to the same model which, as we have noted, includes
#  non-significant terms and may be overfitting. In the end we will stick to 
#  our final model of Survived ~ Sex + Class + Age + Sex:Class
summary(final.model)

# Lastly we can check our model coefficients
final.model$coefficients

# And we can see their impact on the odds (remember that the interaction terms)
#  can only be interpreted in the context of the other variables. 
exp(final.model$coefficients)
