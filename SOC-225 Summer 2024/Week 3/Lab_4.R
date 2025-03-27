# SOC 225: Lab 4
# Anthony Wen
# 7/3/2024
# 5 Tasks

# Welcome to Lab 4 for SOC 225! In this lab, we'll focus on Exploratory Data Analysis (EDA). EDA involves summarizing the main characteristics of your data, often using visual methods. We'll cover basic descriptive statistics and data visualization using ggplot2.

# Lab Goals
# -- Calculating basic descriptive statistics
# -- Creating histograms, boxplots, and scatter plots with ggplot2

#DESCRIPTIVE STATISTICS

# Let's start by loading the necessary libraries and data.
library(dplyr)
# You'll need to install ggplot2 if you haven't used it before. It's super useful for making advanced graphs and charts.
#install.packages("ggplot2")
library(ggplot2)

# Load the "Lab_3_Data.csv" file (used in last lab) into a data frame called data.
data <- read.csv("Lab_3_Data.csv")

# Calculating descriptive statistics helps us understand the distribution and central tendency of our data.
# We'll calculate the mean, median, mode, and range for the "Age" column below.
mean_age <- mean(data$Age, na.rm = TRUE)
median_age <- median(data$Age, na.rm = TRUE)
# Note there isn't a default mode function. This is a bit janky, but works.
mode_age <- as.numeric(names(sort(table(data$Age), decreasing = TRUE)[1]))
range_age <- range(data$Age, na.rm = TRUE)

# And view in the console here.
mean_age
median_age
mode_age
range_age

# TASK 1 ***********************************************************************
# Calculate and display the mean, median, mode, and range for the "Income" column for data rows that have an Age >= 45.
mean_income <- mean(data$Income, na.rm = TRUE)
median_income <- median(data$Income, na.rm = TRUE)
# Note there isn't a default mode function. This is a bit janky, but works.
mode_income <- as.numeric(names(sort(table(data$Income), decreasing = TRUE)[1]))
range_income <- range(data$Income, na.rm = TRUE)

mean_income
median_income
mode_income
range_income

# DATA VISUALIZATION WITH GGPLOT2

# Visualization is a powerful tool for EDA. We'll use the ggplot2 package to create histograms, boxplots, and scatter plots.

# HISTOGRAMS

# Histograms show the distribution of a single variable.
# Let's create a histogram of the "Age" column.
ggplot(data, aes(x = Age)) +
geom_histogram(binwidth = 5, fill = "blue", color = "black") +
labs(title = "Histogram of Age", x = "Age", y = "Frequency")

# TASK 2 ***********************************************************************
# Create a histogram of the "Income" column. Use a binwidth of 10000. Use colors of your choice and make sure the axes are labeled and the graph has a title. 
ggplot(data, aes(x = Age)) +
  geom_histogram(binwidth = 10000, fill = "blue", color = "black") +
  labs(title = "Histogram of Income", x = "Income", y = "Frequency")

# BOXPLOTS

# Boxplots show the distribution of a variable and highlight outliers.
# Let's create a boxplot of the "Age" column.
ggplot(data, aes(x = Category, y = Age)) +
  geom_boxplot(fill = "purple", color = "black") +
  labs(title = "Boxplot of Age", y = "Age", x = "Category")

# TASK 3 ***********************************************************************
# Create a boxplot of the "Income" column by the group "Category". Remember colors and labels.
ggplot(data, aes(x = Category, y = Income)) +
  geom_boxplot(fill = "purple", color = "black") +
  labs(title = "Boxplot of Income", y = "Income", x = "Category")

# SCATTER PLOTS
# Scatter plots show the relationship between two variables.
# Let's create a scatter plot of "Age" vs "Income".
ggplot(data, aes(x = Age, y = Income)) +
geom_point(color = "red") +
labs(title = "Scatter Plot of Age vs Income", x = "Age", y = "Income")

# TASK 4 ***********************************************************************
# Create a scatter plot of "Age" vs "Income" colored by "Category". (Hint: ?aes)
ggplot(data, aes(x = Age, y = Income, color = Category)) +
  geom_point() +
  labs(title = "Scatter Plot of Age vs Income Colored by Category", x = "Age", y = "Income")

# TASK 5 ***********************************************************************
# In your own words, interpret the relationship between Age and Income.

# There is no clear relationship between age and income. But I assume that it is that the 
# higher your age, the more income you have, so a positive correlation between age and income.

# That's it for Lab 4! You've learned how to calculate basic descriptive statistics and create various types of plots using ggplot2. These skills are crucial for understanding and presenting your data.

# Quick Question: Please rate the difficulty of this lab from 1 to 5.
# 4
# Be sure to SAVE THIS FILE and upload it to Canvas when you have completed all tasks. Please submit as a .R file.