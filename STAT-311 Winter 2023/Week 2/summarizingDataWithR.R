chicks=chickwts
head(chicks)

# We can calculate means and standard deviations using the formulas
mymean=sum(chicks$weight)/length(chicks$weight)

# When calculating the standard deviation, it is helpful to note
#  that atomic formulas applied to vectors apply to the entire vector
squares=(chicks$weight-mymean)**2
sqrt(sum(squares)/(length(squares) - 1))

# Of course, being designed for statistical analysis, the 
#  tools for these simple calculations are similarly simple
mean(chicks$weight)
sd(chicks$weight)**2
var(chicks$weight)

# We can still use subsetting of our data if we want to see
#  how the means differ for two diets, such as "soybean" or "casein"
# We can either subset the data frame and look at weights
#  or subset the weights directly; both work.
mean(chicks[chicks$feed=="soybean",]$weight)
mean(chicks$weight[chicks$feed=="casein"])

# We can view the data using various graphical displays, lets start
#  with histograms. We can make a histogram easily in R using
#  the hist() function. We can make either a frequency or density
#  histogram, but frequency is the default. freq=FALSE in the function
#  will instead plot a density.
hist(chicks$weight, freq=FALSE,breaks=10)

# By default the labels on the graph are bad... we can change them with
#  xlab, ylab, and main arguments to the function. The y axis is fine
#  here but the x axis and title should change.
hist(chicks$weight, freq=FALSE, breaks=10,
     xlab="Weights (g)", main="Distribution of Chick Weights")

# We can construct boxplots with boxplot(), but a boxplot of a 
#  single variable isn't very informative. Instead we can view
#  how one variable relates to another using variable1~variable2,
#  where variable1 is numerical and variable2 is categorical.
#  We will use a similar notation when doing regression.
boxplot(chicks$weight~chicks$feed)

# Again be sure to fix the axis labels and titles!
boxplot(chicks$weight~chicks$feed, xlab='Feed type',
        ylab='Weight (g)', 
        main='Comparing Chick Weights by Feed Type')


# Lastly if we want to make a scatterplot, we use the plot()
#  function, which takes the X variable then the Y variable as
#  arguments. Alternatively we can use the same notation with ~
#  as above, in which case the y is left of ~, and the x to the right
# For this example we will use the cars dataset
head(cars)
plot(cars$speed, cars$dist)
plot(cars$dist~cars$speed)

# Fix your titles though! 
plot(cars$dist~cars$speed, xlab="Speed (mph)", 
     ylab="Stopping Distance (ft)", 
     main="Vehicle Stopping Distances Based on Speed")
