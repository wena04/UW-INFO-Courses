# SOC 225: Final Project
# Anthony Wen
# 08/15/2024
# 7 Parts

# 1. Load Required Libraries
library(dplyr)
library(ggplot2)
library(sf)
library(gridExtra)
library(grid)
library(lubridate)
library(forecast)
library(rpart)
library(rpart.plot)
library(cluster)

# 2. Load and Explore the Data
crime_data <- read.csv("Crime_Data.csv")

# Basic data summary
summary(crime_data)
str(crime_data)
unique(crime_data$Crime.Subcategory)

# 3. Data Cleaning and Preprocessing

# Convert date columns to Date objects
crime_data$Occurred.Date <- as.Date(crime_data$Occurred.Date, format = "%m/%d/%Y")

# Handling missing values by removing rows with any NA values
crime_data_clean <- na.omit(crime_data)

# Feature Engineering
crime_data_clean$Year <- year(crime_data_clean$Occurred.Date)
crime_data_clean$Month <- month(crime_data_clean$Occurred.Date)
crime_data_clean$Day <- day(crime_data_clean$Occurred.Date)
crime_data_clean$Hour <- as.numeric(substr(crime_data_clean$Occurred.Time, 1, 2))

# Spatial Data Integration
# Filter and group data for each time period, then merge with the corresponding shapefiles ()

# 1975-2007
crime_data_pre_2008 <- crime_data_clean %>%
  filter(Occurred.Date >= "1975-01-01" & Occurred.Date < "2008-01-01") %>%
  group_by(Beat) %>%
  summarise(total_crimes = n()) %>%
  mutate(prop_crimes = total_crimes / sum(total_crimes)) %>%
  inner_join(st_read("beat_shapefiles/Seattle_Police_Department_Pre_2008_Beats_WM_-403823685701893637/Pre2008_Beats_WM.shp", quiet = TRUE), by = c('Beat' = 'beat'))

# 2008-2015
crime_data_2008_2015 <- crime_data_clean %>%
  filter(Occurred.Date >= "2008-01-01" & Occurred.Date < "2015-01-01") %>%
  group_by(Beat) %>%
  summarise(total_crimes = n()) %>%
  mutate(prop_crimes = total_crimes / sum(total_crimes)) %>%
  inner_join(st_read("beat_shapefiles/Beats_2008_to_2015_-7708752543149594113/Beats_2008_2015_WM.shp", quiet = TRUE), by = c('Beat' = 'beat'))

# 2015-2017
crime_data_2015_2017 <- crime_data_clean %>%
  filter(Occurred.Date >= "2015-01-01" & Occurred.Date < "2017-01-01") %>%
  group_by(Beat) %>%
  summarise(total_crimes = n()) %>%
  mutate(prop_crimes = total_crimes / sum(total_crimes)) %>%
  inner_join(st_read("beat_shapefiles/Seattle_Police_Department_Beats_2015_to_2017_-6117309976598584571/Beats_2015_2017_WM.shp", quiet = TRUE), by = c('Beat' = 'beat'))

# 2017-2018
crime_data_post_2017 <- crime_data_clean %>%
  filter(Occurred.Date >= "2017-01-01" & Occurred.Date < "2018-01-01") %>%
  group_by(Beat) %>%
  summarise(total_crimes = n()) %>%
  mutate(prop_crimes = total_crimes / sum(total_crimes)) %>%
  inner_join(st_read("beat_shapefiles/Current_Beats_6794773331836576823/Beats_WM.shp", quiet = TRUE), by = c('Beat' = 'beat'))

# View the cleaned data for one of the periods
head(crime_data_2008_2015) # check that it merged with the shape files
head(crime_data_clean) # check the cleaned dataset without the na values

# 4. Exploratory Data Analysis (EDA) / Create spatial plots for different time periods 

#Objective: Visualize the distribution of crimes across different police beats in Seattle for various time periods.
# How crime rates vary across different districts of Seattle.
# How crime patterns change over time.

# 1975-2007
plot_pre_2008 <- ggplot() +
  geom_sf(data = crime_data_pre_2008, aes(geometry = geometry, fill = prop_crimes)) +
  scale_fill_gradient(name = "Proportion of Crimes", low = "gold", high = "black") +  
  theme_void() + 
  ggtitle("1975-2007") + 
  theme(plot.title = element_text(hjust = 0.5))

# 2008-2015
plot_2008_2015 <- ggplot() +
  geom_sf(data = crime_data_2008_2015, aes(geometry = geometry, fill = prop_crimes)) +
  scale_fill_gradient(name = "Proportion of Crimes", low = "gold", high = "black") +  
  theme_void() + 
  ggtitle("2008-2015") + 
  theme(plot.title = element_text(hjust = 0.5))

# 2015-2017
plot_2015_2017 <- ggplot() +
  geom_sf(data = crime_data_2015_2017, aes(geometry = geometry, fill = prop_crimes)) +
  scale_fill_gradient(name = "Proportion of Crimes", low = "gold", high = "black") +  
  theme_void() + 
  ggtitle("2015-2017") + 
  theme(plot.title = element_text(hjust = 0.5))

# 2017-2018
plot_post_2017 <- ggplot() +
  geom_sf(data = crime_data_post_2017, aes(geometry = geometry, fill = prop_crimes)) +
  scale_fill_gradient(name = "Proportion of Crimes", low = "gold", high = "black") +  
  theme_void() + 
  ggtitle("2017-2018") + 
  theme(plot.title = element_text(hjust = 0.5))

# Combine all plots into a single visualization
final_plot <- arrangeGrob(plot_pre_2008, plot_2008_2015, plot_2015_2017, plot_post_2017, ncol = 2)
plot_title <- textGrob("Proportion of Crimes per Police Patrol Sector in Seattle", gp = gpar(fontface = "bold", fontsize = 15))
final_plot <- arrangeGrob(final_plot, top = plot_title)

# Display the final combined plot
plot(final_plot)

# shows how the lower half of seattle seems ot have a decrease in crime rates over time but the upper half of seattle has an increase
# shows how most crime occur in the east of seattle and less on the west half 

# 5. Analysis by Time of Day

# Calculate total number of each type of crime and total crimes committed
crime_counts <- crime_data %>% count(Primary.Offense.Description)
total_crimes_committed <- sum(crime_counts$n)

# Precinct with the highest reported number of crimes
precinct_max_crime <- crime_data %>% 
  count(Precinct) %>% 
  filter(n == max(n))

# Most frequent subcategory of crime
most_frequent_subcategory <- crime_data %>% 
  count(Crime.Subcategory) %>% 
  filter(n == max(n))

# Most frequent primary offense
most_frequent_primary_offense <- crime_data %>% 
  count(Primary.Offense.Description) %>% 
  filter(n == max(n))

# Hour period with the most reports of crime
hour_with_most_reports <- crime_data %>%
  mutate(Hour = format(as.POSIXct(Occurred.Time, format="%H:%M:%S"), "%H")) %>%
  count(Hour) %>%
  filter(n == max(n)) %>%
  mutate(Hour_with_Most_Reports_of_Crime = paste(Hour, ":00-", Hour, ":59", sep=""))

# Print summary information
cat("Total Number of Crime Types: ")
cat(nrow(crime_counts), "\n\n")

cat("Total Number of Crimes Committed: ")
cat(total_crimes_committed, "\n\n")

cat("Precinct with the Highest Crime Count: ")
cat(precinct_max_crime$Precinct, "\n\n")

cat("Most Frequent Subcategory of Crime: ")
cat(most_frequent_subcategory$Crime.Subcategory, "\n\n")

cat("Most Frequent Primary Offense: ")
cat(most_frequent_primary_offense$Primary.Offense.Description, "\n\n")

cat("Hour with Most Reports of Crime: ")
cat(hour_with_most_reports$Hour_with_Most_Reports_of_Crime, "\n")

# Answers at what times most crimes occur
# Shows general facts about the crime (look at PPT too)
# Answers what are the most common crimes in different districts of Seattle

# Make sure the hours in a day is between 0 and 23
crime_data_clean$Hour <- as.numeric(substr(sprintf("%04d", crime_data_clean$Occurred.Time), 1, 2))

# Filter out any anomalies where Hour is not between 0 and 23 (probably a bug in the original data to keep track of multiple days)
crime_data_clean <- crime_data_clean %>%
  filter(Hour >= 0 & Hour < 24)

# Re-run the time of day analysis with the corrected Hour values
crime_data_time_of_day <- crime_data_clean %>%
  filter(Primary.Offense.Description %in% selected_crimes) %>%
  group_by(Hour, Primary.Offense.Description) %>%
  summarise(total_crimes = n())

# Bar Plot for Crime Frequency by Hour
ggplot(crime_data_time_of_day, aes(x = Hour, y = total_crimes, fill = Primary.Offense.Description)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Crime Frequency by Time of Day for Selected Crimes in Seattle", x = "Hour of Day", y = "Total Crimes") +
  theme_minimal()

# shows general facts about crimes in seattle like which crime occurs most and how this dataset could be bias still.

# 6. Classification / Predicting Crime

# Load necessary library for classification: rpart, rpart.plot

# Prepare the data by selecting relevant features and filtering the selected crimes
classification_data <- crime_data_clean %>%
  filter(Primary.Offense.Description %in% selected_crimes) %>%
  select(Hour, Precinct, Primary.Offense.Description)

# Convert categorical variables to factors if not already
classification_data$Precinct <- as.factor(classification_data$Precinct)
classification_data$Primary.Offense.Description <- as.factor(classification_data$Primary.Offense.Description)

# Split the data into training and testing sets (70/30 split)
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(classification_data), 0.7 * nrow(classification_data))
train_data <- classification_data[train_index, ]
test_data <- classification_data[-train_index, ]

# Build a decision tree model using the training data
crime_tree <- rpart(Primary.Offense.Description ~ Hour + Precinct, data = train_data, method = "class")

# Visualize the decision tree
rpart.plot(crime_tree, type = 3, extra = 104, fallen.leaves = TRUE, main = "Decision Tree for Crime Classification")

# Predict on the test data
predictions <- predict(crime_tree, newdata = test_data, type = "class")

# Create a confusion matrix to evaluate the model's performance
confusion_matrix <- table(Predicted = predictions, Actual = test_data$Primary.Offense.Description)
print(confusion_matrix)

# Calculate accuracy of our prediction
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
cat("Model Accuracy: ", accuracy)

# 7. Conclusion and Interpretation (look at PPT or presentation for more details)
# -------------------------------------------------------------------------------
# Summary of Findings:
#
# 1. What are the most common crime in differrent districts of Seattle? At what time do most crimes occur?
#    - Shown in part #4 and 5, it seems that the most common crime is theft car prowl, but that might be different if we look at certain individual districts 
#    - these data could potentially be biased as they are only reported incidents 
#    - there seems to be trends that show that crime rates are increasing in north of seattle and decreasing in the south, but these are just general trends from the past
#
# 2. How do the rates of crime change across time in different districts
#.   - Shown in part #4 with the spacial graphs and also #5
#    - These crimes are concentrated during mostly the afternoon, indicating the need for targeted policing during these times.
#
# 3. What Crimes are likely to happen?
#    - Shown in part #6,Certain general direction in Seattle show higher rates of prostitution and drug-related crimes, like in the north or southwest

# Recommendations:
# 1. Increase police presence in high-risk districts during hours after 3pm
# 2. Revise plans to protrol districts in more risk or having increasing crime rates