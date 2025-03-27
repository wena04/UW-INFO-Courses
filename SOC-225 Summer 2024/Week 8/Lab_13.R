# SOC 225: Lab 13
# Anthony Wen
# 08/7/2024
# 6 TASKS

# Welcome to Lab 13, the Last Lab!!! Today, we will explore the basics of machine learning by building and evaluating simple linear and logistic regression models. By the end of this lab, you should be able to define machine learning, understand the concepts of linear and logistic regression, and build models using R.

# Lab Goals
# - Introduction to machine learning
# - Simple linear regression recap
# - Logistic regression
# - Practical machine learning example

# INTRODUCTION TO MACHINE LEARNING

# Machine learning is a field of artificial intelligence that uses algorithms to learn from and make predictions on data. It has applications in various domains such as healthcare, finance, and marketing.

# Machine learning builds off of statistical models. We'll review those again here, get those interpretations ready!

# SIMPLE LINEAR REGRESSION RECAP

# Linear regression is a basic and commonly used type of predictive analysis. It allows us to model the relationship between a dependent variable and one or more independent variables.

# Let's build a simple linear regression model using the diamonds dataset from the ggplot2 package.
library(ggplot2)
data(diamonds)

# Building a linear regression model to predict 'price' using 'carat' (weight) as the independent variable.
linear_model <- lm(price ~ carat, data = diamonds)

# Summary of the model to see coefficients, R-squared, and p-values. Note that as the value of 'carat' increases by 1, the price goes up by 7756.
summary(linear_model)

# TASK 1 ***********************************************************************
# Build a simple linear regression model using the iris dataset. Predict 'Sepal.Length' using 'Petal.Length' as the independent variable. Interpret your model results.
data("iris")
linear_model1 <- lm(Sepal.Length ~ Petal.Length, data = iris)
summary(linear_model1)

# LOGISTIC REGRESSION

# Logistic regression is used for classification problems where the dependent variable is categorical. It models the probability that a given input belongs to a certain category.

# We can use a logistic regression to predict whether a diamond is premium based on its characteristics.

# The 'cut' variable in the diamonds dataset is categorical with multiple levels. Let's simplify it to binary for this example (Ideal = 1, Not Ideal = 0).
diamonds$cut_binary <- ifelse(diamonds$cut == "Ideal", 1, 0)

# Building a logistic regression model to predict 'cut_binary' using 'carat' (weight) and 'depth'.
logistic_model <- glm(cut_binary ~ carat + depth, data = diamonds, family = binomial)

# Summary of the model to see coefficients, p-values, and model fit. We intrepret the coefficients of these models a little differently: instead of leading to a direct increase or decrease in the dependent variable, they represent an increase or decrease in the log odds of being in a particular category. That goes a bit beyond this class, so for now, take a general approach and suggest that a negative coefficient decreases the odds of being an 'Ideal' diamond and a positive coefficient increases the odds.
summary(logistic_model)

# TASK 2 ***********************************************************************
# Build a logistic regression model using the iris dataset. Predict 'Species' (Create a binary: setosa vs. non-setosa) using 'Sepal.Width' and 'Petal.Width' as independent variables. Interpret your model results.
iris$check <- ifelse(iris$Species == "setosa", 1, 0)
logistic_model1 <- glm(check ~ Sepal.Length + Petal.Width, data = iris, family = binomial)
summary(logistic_model1)

# EVALUATING MODEL PERFORMANCE

# For linear regression, we use metrics like R-squared and Mean Squared Error (MSE) to evaluate model performance.

# For logistic regression, we use metrics like accuracy, precision, recall, and the confusion matrix.

# Evaluating the linear regression model
# Calculate R-squared: This value suggests how much of the variation in the dependent variable is accounted for in our model.
r_squared <- summary(linear_model)$r.squared
print(paste("R-squared:", r_squared))

# Evaluating the logistic regression model
# Calculate predicted probabilities: This segment predicts whether diamonds are 'Ideal' based on the logistic model we previously made. It will produce a probability that the diamond is 'Ideal'.
predicted_probs <- predict(logistic_model, type = "response")

# Convert probabilities to binary predictions (threshold = 0.5)::If a diamond is given a probability greater than a coin flip of being ideal, we'll count it.
predicted_classes <- ifelse(predicted_probs > 0.5, 1, 0)

# Create a confusion matrix: Like on Monday, we want to see which classifications the model got right and wrong.
confusion_matrix <- table(predicted_classes, diamonds$cut_binary)
print(confusion_matrix)

# TASK 3 ***********************************************************************
# Evaluate the linear regression model you built in TASK 1. Calculate and print the R-squared value.

r_squared1 <- summary(linear_model1)$r.squared
print(paste("R-squared:", r_squared1))
# "R-squared: 0.759954645772515"

# TASK 4 ***********************************************************************
# Evaluate the logistic regression model you built in TASK 2. Calculate and print the confusion matrix.
predicted_probs1 <- predict(logistic_model1, type = "response")
predicted_classes1 <- ifelse(predicted_probs1 > 0.5, 1, 0)
confusion_matrix1 <- table(predicted_classes1, iris$check)
print(confusion_matrix1)

#predicted_classes1   0   1
#                 0 100   0
#                 1   0  50

# PRACTICAL MACHINE LEARNING EXAMPLE

# Let's use the diamonds dataset to build and evaluate a machine learning model.

# Split the dataset into training and testing sets
set.seed(123)
train_index <- sample(1:nrow(diamonds), 0.7 * nrow(diamonds))
train_data <- diamonds[train_index, ]
test_data <- diamonds[-train_index, ]

# Building a logistic regression model to predict whether a diamond is premium based on its characteristics.
ml_model <- glm(cut_binary ~ carat + depth + table + price, data = train_data, family = binomial)

# Summary of the model
summary(ml_model)

# Predicting on the test set
predictions <- predict(ml_model, newdata = test_data, type = "response")
predicted_classes <- ifelse(predictions > 0.5, 1, 0)

# Creating a confusion matrix
confusion_matrix <- table(predicted_classes, test_data$cut_binary)
print(confusion_matrix)

# The logistic model will be our 'standard' approach. We'll now use a super simple machine learning model, the decision tree model we used last time.

# Building a decision tree model using the rpart package
library(rpart)

# Building the model
tree_model <- rpart(cut_binary ~ carat + depth + table + price, data = train_data, method = "class")

# Summary of the model
print(tree_model)

# Predicting on the test set
tree_predictions <- predict(tree_model, newdata = test_data, type = "class")

# Creating a confusion matrix
tree_confusion_matrix <- table(tree_predictions, test_data$cut_binary)
print(tree_confusion_matrix)

# TASK 5 ***********************************************************************
# Which model, ml_model or tree_model, correctly predicted more of the test dataset? What were the accuracy percentages of each?

# standard = (8121+4813)/16182 = 79.93
# tree_model = (8387+5893)/16182 = 88.27
# the tree model is more accurate

# TASK 6 ***********************************************************************
# Build a decision tree model using the rpart package to predict the species of iris flowers. Evaluate the model's performance on a test dataset. Calculate and print the accuracy of the model.

set.seed(123)
train_index <- sample(1:nrow(iris), 0.7 * nrow(iris))
train_data1 <- iris[train_index, ]
test_data1 <- iris[-train_index, ]
iris_model <- rpart(check ~ Sepal.Length + Petal.Width, data = train_data1, method = "class")
# Summary of the model
print(iris_model)

# Predicting on the test set
iris_predictions <- predict(iris_model, newdata = test_data1, type = "class")
# Creating a confusion matrix
iris_confusion_matrix <- table(iris_predictions, test_data1$check)
print(iris_confusion_matrix)
# iris_predictions  0  1
#               0 31  0
#               1  0 14
# accuracy: (13+14)/45 = 60%

# Conclusion
# In this lab, we explored the basics of machine learning by building and evaluating simple linear and logistic regression models. We also built a practical machine learning model using the diamonds dataset. These skills are foundational for further study and application of machine learning techniques.

# Be sure to SAVE THIS FILE and upload it into Canvas when you have completed all tasks. Please submit as a .R file.