# SOC 225: Lab 12
# Anthony Wen
# 08/05/2024
# 5 TASKS

# Welcome to Lab 12! Today, we will explore the basics of classification in predictive modeling. By the end of this lab, you should be able to understand the concepts of classification, build and evaluate decision trees, and implement k-nearest neighbors (k-NN) classification.
# Lab Goals
# - Understand the basics of classification.
# - Build and evaluate decision tree models using rpart.
# - Implement k-NN classification using the class package.

# INTRODUCTION TO CLASSIFICATION

# Classification is a supervised learning technique used to predict categorical labels. It's essential in various fields such as spam detection, medical diagnosis, and sentiment analysis.
# Let's start with a simple example of a classification problem. We will use the iris dataset, which contains measurements of different iris flower species.

# Load necessary libraries. You probably don't have some of these libraries installed, be sure to install them before continuing.
library(rpart)
library(class)
library(datasets)
library(rpart.plot)


# Let's start with the iris dataset
data(iris)

# And take a peek at it
head(iris)

# We'll split the data into training and testing sets to build our models, like we did when trying to predict time series trends
set.seed(123) # For reproducibility

# This gives a set of values that are a subset of the iris data to use in our model. Note that the sum of the length of training and test data is the same as iris data.
sample_index <- sample(seq_len(nrow(iris)), size = 0.7*nrow(iris))
train_data <- iris[sample_index, ]
test_data <- iris[-sample_index, ]

# DECISION TREES

# Decision trees are a popular classification method. They split the data into subsets based on the value of input features, creating a tree-like model of decisions.

# We can build a decision tree using the rpart package. Type ?rpart for more information
tree_model <- rpart(Species ~ ., data = train_data, method = "class")
print(tree_model)
rpart.plot(tree_model, main = "Decision Tree for Iris Dataset", cex = 0.6, extra = 104)

# You should see that your model has split the types of flowers based on various categorizations that are common within groups. Flowers with a petal length less than 2.5 are exclusively setosa, the first split in the tree. For flowers with a petal length greater than 2.5, we can usually determine the difference between virginica and versicolor flowers by checking if the petal width is less than 1.8.

# You can see the percentage of flowers in that categorization that fit each branch by looking at the decimals in the box. The percentages at the bottom define how many of the total flowers are represented in that box, whereas the text highlights the most common species in the box.

# TASK 1 ***********************************************************************
# Build a decision tree model using the iris dataset, but this time use only the first two features: Sepal.Length and Sepal.Width. Plot the resulting tree and explain how it differs
# Hint: You'll need to remove other columns from the dataframe or treat the prediction model like it's an lm from last lab......

iris_sepal <- iris[, c("Sepal.Length", "Sepal.Width", "Species")]
sample_index <- sample(seq_len(nrow(iris_sepal)), size = 0.7 * nrow(iris_sepal))
train_data <- iris_sepal[sample_index, ]
test_data <- iris_sepal[-sample_index, ]
train_data_scaled <- scale(train_data[, 1:2]) 
test_data_scaled <- scale(test_data[, 1:2]) 
tree_model_sepal <- rpart(Species ~ Sepal.Length + Sepal.Width, data = train_data, method = "class")
print(tree_model_sepal)
rpart.plot(tree_model_sepal, main = "Decision Tree for Iris Dataset (Sepal Features Only)", cex = 0.6, extra = 104)

# k-NEAREST NEIGHBORS (k-NN)

# k-NN is a simple and intuitive classification algorithm. It classifies a data point based on the majority class among its k-nearest neighbors.
# We can implement k-NN using the class package, but first we need to standardize the data.

train_data_scaled <- scale(train_data[, -5])
test_data_scaled <- scale(test_data[, -5])

knn_pred <- knn(train = train_data_scaled, test = test_data_scaled, cl = train_data$Species, k = 3)
table(knn_pred, test_data$Species)

# The table above shows the results of the model when trying to predict the species of the test data based on similarities in the training data. You should see that it correctly guesses most of the flower types, with only one not answered correctly. That's pretty good!

# TASK 2 ***********************************************************************
# Implement k-NN classification using the iris dataset, but use k = 8. Evaluate the performance compared to the k = 3 model. 
knn_pred_k3 <- knn(train = train_data_scaled, test = test_data_scaled, cl = train_data$Species, k = 3)
confusion_matrix_k3 <- table(knn_pred_k3, test_data$Species)
print(confusion_matrix_k3)
knn_pred_k8 <- knn(train = train_data_scaled, test = test_data_scaled, cl = train_data$Species, k = 8)
confusion_matrix_k8 <- table(knn_pred_k8, test_data$Species)
print(confusion_matrix_k8)

#the k=3 model seems to be more accurate and also stable but only by a little bit
# since k = 3 has 1 inccorrect value but k = 8 has 2

# EVALUATING CLASSIFICATION MODELS

# It's crucial to evaluate the performance of classification models to understand their effectiveness. Common metrics include accuracy, precision, recall, and F1-score. We'll only be looking at accuracy today, but the rest of these are made easy in the 'caret' package.
# Let's evaluate the decision tree model from earlier

# The predict function uses our predicted classification proportions to assess how well our model would determine the classifications for the test data. We'll then generate a table similar to how we judged our k-NN model.
tree_pred <- predict(tree_model, test_data, type = "class")
conf_matrix_tree <- table(tree_pred, test_data$Species)
print(conf_matrix_tree)

# We can see that our decision tree model does a pretty good job at classifying the flower types, getting one wrong but a different one than the k-NN model.

# TASK 3 ***********************************************************************
# Calculate the accuracy of the decision tree model built in TASK 1 using the table above (known as a confusion matrix). The accuracy is defined as the sum of correct classifications divided by the total test observations. Feel free to do this in shorthand or systematically on the data frame (Lenient on this question).

tree_pred1 <- predict(tree_model, test_data, type = "class")
conf_matrix_tree <- table(tree_pred1, test_data$Species)
print(conf_matrix_tree)

#looking at the tree I had for task 1, I can calculate the accuracy by 
# Correct predictions 35 (Setosa) + 80 (Versicolor) + 54 (Virginica) = 169
# Total predictions: 35 + 0 + 1 + 4 + 80 + 17 + 1 + 29 + 54 = 221
# 169/221 = 76.51%

# TASK 4 ***********************************************************************
# Calculate the accuracy of the decision tree model built in TASK 2 using the table above.
#looking at the tree I had for task 2, I can calculate the accuracy by
# 14 +13+16 = 43
# 43/45 = 95.555556%

# TASK 5 ***********************************************************************
# Based on your interpretation of the Tasks for today, which method do you like better? Why? Appreciate the thoughts!
# I liked the first method since it was easier to implement. But if I really was allowed to choose, I didn't want to use any of them since I don't really get either of them... 

# Conclusion
# In this lab, we explored the basics of classification, built decision tree models using rpart, and implemented k-NN classification using the class package. Understanding and applying these techniques is crucial for predictive modeling in various domains.

# Be sure to SAVE THIS FILE and upload it into Canvas when you have completed all tasks. Please submit as a .R file.