# SOC 225: Lab 5
# Anthony Wen
# 7/8/2024
# 7 TASKS

# Welcome to Lab 5 for SOC 225! In this lab, we'll delve deeper into data visualization using ggplot2 and explore advanced techniques such as multi-faceted plots, customized themes, adding annotations, and creating interactive plots with plotly.

# Lab Goals:
# --Advanced ggplot2 visualizations
# --Creating multi-faceted plots
# --Customizing themes
# --Adding annotations
# --Creating interactive plots with plotly


#SETUP

# First, let's load the necessary libraries. Make sure you have ggplot2 and plotly installed. If not, install them using install.packages("ggplot2") and install.packages("plotly").
library(ggplot2)
library(plotly)

# For this lab, we will use primarily the 'diamonds' dataset that comes with ggplot2.
# We'll load it up here from the ggplot2 package
data(diamonds)

# We'll also be using the Lab_3_Data that we've become familiar with. Be sure to set that working directory!
# setwd("C:/Users/brown/Documents/UW/2024Su/SOC225/Labs")
data <- read.csv("Lab_3_Data.csv")

# TASK 1 ***********************************************************************
# Notice anything odd about the diamonds dataset in the environment?
# The diamonds just shows "Promise" when you initially load it, but when you click it it turns back to a normal dataframe again

# A <Promise> object is like a preview of a dataframe that comes from a downloaded package: it's an efficient way of storing data that doesn't load into the enviroment right away. To convert diamonds to a dataframe, you can click on it, view it, or do it directly below.
diamonds<-data.frame(diamonds)

# ADVANCED GGPLOT2 VISUALIZATIONS

# MULTI-FACETED PLOTS
# Let's start with creating multi-faceted plots. These plots allow us to split our data into multiple panels based on a categorical variable, like color or state.
# The example below makes a multi-faceted plot using the Lab_3_Data
ggplot(data, aes(x = Age, y = Income)) +
  geom_point() +
  facet_wrap(~Category)

# Note that this creates a smaller scatter plot for each of the sub-categories in the facet wrapped variable.

# TASK 2 ***********************************************************************
# Create a scatter plot of 'carat' vs 'price' and facet it by the 'cut' variable.
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  facet_wrap(~cut)

# CUSTOMIZED THEMES

# ggplot2 provides various themes to customize the appearance of your plots. We can also create our own themes for a personalized look.
# To test this out, here is a bar plot that examines the count of each Category in Lab_3_Data with a Light theme, plus some add-ons to that theme.
# We didn't use bar plots last week, type ?geom_bar() in the console for more
ggplot(data, aes(x = Category)) +
  geom_bar() +
  theme_light() +
  theme(
    axis.title = element_text(size = 20, color = "yellow"),
    axis.text = element_text(size = 8)
  )

# TASK 3 ***********************************************************************
# Create a bar plot of the count of diamonds by 'cut' and apply the 'theme_minimal()' theme. Customize the theme by modifying the text size and color of axis titles.
ggplot(diamonds, aes(x = cut)) +
  geom_bar() +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 20, color = "red"),
    axis.text = element_text(size = 8)
  )

# ADDING ANNOTATIONS

# Adding annotations helps highlight specific points or regions in your plot, making it more informative.
# We can do this using the annotate() function like the example below. Note that due to the placing of the x and y values, it is important to know your data before annotating.
ggplot(data, aes(x = Age, y = Income)) +
  geom_point() +
  annotate("text", x = 75, y = 95000, label = "75+ And Making Money!", color = "red", size = 5)

# TASK 4 ***********************************************************************
# Create a scatter plot of 'carat' vs 'price' and add an annotation to highlight diamonds with carat greater than 3 and price over 15000.
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  annotate("text", x = 3, y = 15000, label = "15000+ And over 3 carat", color = "red", size = 5)

# INTERACTIVE PLOTS WITH PLOTLY
# Plotly is a graphing library that makes interactive plots. We can easily convert ggplot2 plots into interactive plots using ggplotly().
# We can convert a ggplot2 plot to an interactive plot using ggplotly() like the example below
plot1 <- ggplot(data, aes(x = Age, y = Income)) +
  geom_point()

ggplotly(plot1)

# Note that we save the plot as an object. That's a GGPlot object. If we wanted to do it all on one line, here's what we get.
ggplotly(ggplot(data, aes(x = Age, y = Income)) +
           geom_point())

#Saving the plot allows you to come back to it later! If you don't supply a plot, ggplotly will use the last one you created.

# TASK 5 ***********************************************************************
# Create a scatter plot of 'carat' vs 'price' and use ggplotly() to make it interactive. Display the interactive plot.
plot2 <- ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point()

ggplotly(plot2)

# Let's create a comprehensive plot combining multiple techniques we've learned so far.

# TASK 6 ***********************************************************************
# Create a scatter plot of 'carat' vs 'price', facet by 'cut', customize the theme, add an annotation, and make it interactive using ggplotly().
plot3 <- ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  facet_wrap(~cut) + 
  theme_minimal() + 
  theme(
    axis.title = element_text(size = 20, color = "red"),
    axis.text = element_text(size = 8)
  ) + 
  annotate("text", x = 3, y = 15000, label = "15000+ And over 3 carat", color = "red", size = 2)

ggplotly(plot3)

# TASK 7 ***********************************************************************
# Any general trends in price by carat? 
# the price increases as carat increases, there's a positive correlation between them

# That's it for Lab 5! Advanced data visualization techniques in ggplot2 and plotly enable us to create insightful and interactive visual representations of data. These skills are essential for effectively communicating your findings.

# Still doing good? Anything you'd like to be sure I hit before the end of the summer?
# The class is getting a lot harder all of a sudden... but otherwise its ok
# Be sure to SAVE THIS FILE and upload it into Canvas when you have completed all 7 Tasks. Please submit as a .R file.
