# SOC 225: Lab 9
# Anthony Wen
# 07/24/2024
# 5 TASKS

# Welcome to Lab 9! Today, we will continue our exploration of time series data analysis, focusing on basic models for time series forecasting and an introduction to ARIMA models. By the end of this lab, you should be able to apply simple moving averages, exponential smoothing, and use ARIMA models in base R.

# Lab Goals
# - Applying simple moving averages
# - Exponential smoothing
# - Fitting ARIMA models
# - Forecasting with ARIMA
# - Evaluating forecast accuracy
# - Visualizing forecast results

# BASIC MODELS FOR TIME SERIES FORECASTING

# SIMPLE MOVING AVERAGES

# Moving averages are used to smooth out short-term fluctuations and highlight longer-term trends or cycles. You use a few nearby data values in order, average them, and define that as a new point. 
# Let's start with a simple example of applying a moving average to a time series.

# Load necessary packages
library(ggplot2)
library(forecast)

# First we're going to simulate a new set of time-series data to use in our examples. When generating random data, it is wise to set a seed value, which allows you to get the same "random" result each time.
set.seed(123)

# The rnorm in the function below generates a random distribution of 100 numbers with a mean of 50 and a standard deviation of 10. For more information, type ?rnorm. This is then plugged into the time_series function we used last week
time_series <- ts(rnorm(100, mean = 50, sd = 10), frequency = 12, start = c(2020, 1))

# Plot original time series. Note in our plot here that we're creating a dataframe for use in the graph within the plot call; the dataframe doesn't exist in the environment after running the call.
ggplot(data = data.frame(time = seq_along(time_series), value = as.numeric(time_series)), aes(x = time, y = value)) +
  geom_line() +
  labs(title = "Original Time Series", x = "Time", y = "Value")

# Apply simple moving average. 
window_size <- 3
# This function applies the moving average to our time series data. It'll create new values for each value in our time series besides the first and the last.
smoothed_series <- filter(time_series, rep(1/window_size, window_size), sides = 2)

# We can see how the values have changed by looking at them below
time_series
smoothed_series

# And then plotting the smoothed time series
ggplot(data = data.frame(time = seq_along(smoothed_series), value = as.numeric(smoothed_series)), aes(x = time, y = value)) +
  geom_line(color = 'blue') +
  labs(title = "Smoothed Time Series (Moving Average)", x = "Time", y = "Value")

# TASK 1 ***********************************************************************
# Using the above example as a guide, apply a moving average with a window size of 5 to the time series data and plot the results. How is this time series different than the one with a window size of 3?
window_size_5 <-5
smoothed_series_5 <- filter(time_series, rep(1/window_size_5, window_size_5), sides = 2)
ggplot(data = data.frame(time = seq_along(smoothed_series_5), value = as.numeric(smoothed_series_5)), aes(x = time, y = value)) +
  geom_line(color = 'blue') +
  labs(title = "Smoothed Time Series with WS of 5(Moving Average)", x = "Time", y = "Value")
smoothed_series_5
# the data seems more zoomed out, there are fewer peaks of values. We don't have just 2 rows that are changed a bit but have like 4 now. As the window increases, the values get flatter/less peaks. The resulting graph starts to look more like an average value.

# EXPONENTIAL SMOOTHING

# Exponential smoothing is a technique that applies decreasing weights to past observations. This means they matter less for our smoothed points. 
# Let's apply exponential smoothing to our time series data.

# Apply exponential smoothing. Don't worry too much about the particulars of this method, but if you're interested type ?HoltWinters.
exp_smooth_series <- HoltWinters(time_series)

# Plot the smoothed time series
plot(exp_smooth_series, main = "Exponential Smoothing")

# TASK 2 ***********************************************************************
# Apply exponential smoothing to the Nottingham Castle data from last lab and plot the results. Describe any patterns you observe. Which smoothing technique fits better? Why do you think so?
castle_smooth_series <- HoltWinters(nottem)
plot(exp_smooth_series, main = "Exponential Smoothing for Nottem")
# the observed plot has more peaks in it and the smoothed one seems to make everything flatter. The smoothed plot seems to squish all the data into the window while the observed one is still kind of like the normal data.

# ARIMA MODELS

# Introduction to ARIMA Models
# ARIMA (AutoRegressive Integrated Moving Average) is a popular time series forecasting model. These stats behind these models are well beyond this course, but data scientists like to use them to represent future changes in time series data.
# Let's fit an ARIMA model to our time series data.

# Fit ARIMA model
arima_model <- auto.arima(time_series)

# Print model summary
summary(arima_model)

# TASK 3 ***********************************************************************
# Fit an ARIMA model to the Nottingham Castle data as well. Don't worry too much about the output of the model summary for now, we'll go more into that next week.
nottem_arima_model <- auto.arima(nottem)
# Print model summary
summary(nottem_arima_model)

# FORECASTING WITH ARIMA

# Once we have fitted an ARIMA model, we can use it to forecast future values.
# Let's forecast the next 12 periods of our simulated time series.

# Forecast the next 12 periods. Type ?forecast to learn more.
forecast_values <- forecast(nottem_arima_model, h = 12)

# Plot forecast
plot(forecast_values, main = "ARIMA Forecast")

# TASK 4 ***********************************************************************
# Use the Nottingham ARIMA model from Task 3 to forecast the next 12 periods and plot the forecasted values along with the original time series. Which forecast do seems to fit better with the observed values? Why do you think so?
#the predicted one (blue line) doesn't seems to fit more with the previous data just looking at the height and width of the blue line. it hovers around the mean value of 50 but it doesn't spike up and down as much as before. There's a reasonable chance that this estimate is like not right. 

# EVALUATING FORECAST ACCURACY

# Evaluating the accuracy of forecasts is crucial for determining the reliability of our model. One way to do this without being a fortune teller is to see how reliable your model is at predicting a subset of the data you have.
# We will split our data into training and test sets and evaluate our model's accuracy.

# Split data into training and test sets. Type ?window for more information.
train <- window(time_series, end = c(2022, 12))
test <- window(time_series, start = c(2023, 1))

# Fit ARIMA model on training data
arima_model_train <- auto.arima(train)

# Forecast on test data
forecast_test <- forecast(arima_model_train, h = length(test))

# Calculate accuracy and compare the values. A close model would have similar point values. Type ?accuracy for more information.
accuracy(forecast_test, test)

# We can also see what values were predicted by the training model using the plots we learned above. Compare these values to our observed time series plot to compare accuracy.
plot(forecast_test, main = "Training Data Forecast")
plot(time_series, main = "Time Series Data")

# TASK 5 ***********************************************************************
# Create a training and test set for the Nottingham Data. The training data should end in December 1929 and the test data should start in January 1930. Report the accuracy metrics for your model and plot the forecasted values of the training model. Which forecast was closer?
train_n <- window(nottem, end = c(1929, 12))
test_n <- window(nottem, start = c(1930, 1))
arima_model_train_n <- auto.arima(train_n)
forecast_test_n <- forecast(arima_model_train_n, h = length(test_n))
accuracy(forecast_test_n, test_n)
plot(forecast_test_n, main = "Training Data Forecast")
plot(nottem, main = "Nottem Data")
# the temperature model/weather data, just looking at the temperature height and such for the future, seems to fit a bit more with the original one just looking at the heigh and the peaks. It doesn't flatten out at the end like the other data does. This is probably because temerpature within a year is probably pretty consistent every year. Kinda difficult to understand the specifically what this question was asking but yeah...

# Conclusion
# In this lab, we continued our exploration of time series data analysis. We applied simple moving averages, exponential smoothing, and fitted ARIMA models to our data. Additionally, we forecasted future values, evaluated forecast accuracy, and visualized forecast results. These skills are essential for making reliable forecasts and understanding the underlying patterns in time series data.

# Be sure to SAVE THIS FILE and upload it into Canvas when you have completed all tasks. Please submit as an .R file.