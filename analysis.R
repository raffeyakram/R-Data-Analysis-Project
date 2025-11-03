# Project: DSC 441 - Data Exploration and Transformation
# File: analysis.R
# Author: Raffey Akram
# Date: 11/03/2025
# Purpose: Comprehensive data preparation and exploratory data analysis (EDA) 
#          on the Adult Income and US Population datasets.

# --- 0. Setup: Load Required Libraries ---
# Requires: tidyverse (dplyr, ggplot2, tidyr) and GGally
library(tidyverse)
library(GGally)

# --- Problem 1: Adult Data Set - Exploratory Data Analysis (EDA) ---
cat("--- 1. Adult Data Set: EDA ---\n")

# Load Data (Assumes adult.csv is in the project folder)
adult <- read.csv("adult.csv") 

# A. Summarize & Compare Variables
# Summary statistics provided insights: Age is slightly right-skewed; Hours-per-Week
# is centered around 40 but has extreme outliers up to 99.
summary(adult) 

# B. Visualization: Boxplots for Central Tendency and Outliers
adult_long <- adult %>%
  pivot_longer(cols = c(age, hours.per.week),
               names_to = "Variable",
               values_to = "Value")

# Visualize Age and Hours-per-Week to check for distribution and outliers
boxplot_plot <- ggplot(adult_long, aes(x = Variable, y = Value, fill = Variable)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Distribution of Age and Work Hours", caption = "Boxplots reveal extreme outliers in 'hours.per.week'.")

print(boxplot_plot)
# ggsave("output_boxplot_age_hours.png", plot = boxplot_plot) # Uncomment to save output

# C. Visualization: Scatterplot Matrix for Pairwise Correlations
numerical_vars <- adult %>% 
  select(age, education.num, capital.gain, capital.loss, hours.per.week)

scatterplot_matrix <- ggpairs(
  numerical_vars,
  title = "Pairwise Relationships (Correlation Matrix)",
  aes(alpha = 0.5)
)
print(scatterplot_matrix)
# ggsave("output_scatterplot_matrix.png", plot = scatterplot_matrix)

# E. Visualization: Income vs. Education (Proportional Analysis)
stacked_bar_plot <- ggplot(adult, aes(x = education, fill = income.bracket)) +
  geom_bar(position = "fill") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Income Proportion by Education Level",
       y = "Proportion of Income (>50K vs <=50K)")

print(stacked_bar_plot)
# ggsave("output_education_vs_income.png", plot = stacked_bar_plot)

# --- Problem 2: Population Data - Transformation and Aggregation ---
cat("\n--- 2. Population Data: Data Wrangling ---\n")

# Load Data
pop_even <- read.csv("population_even.csv") 
pop_odd <- read.csv("population_odd.csv")

# A. Join Data Tables (Full Join on 'STATE')
population_all <- full_join(pop_even, pop_odd, by = "STATE")

# B. Data Cleaning: Select, Rename, and Reorder Columns
population_all <- population_all %>%
  # Remove duplicate columns and select only necessary ID/Population columns
  select(STATE, NAME = NAME.x, starts_with("POPESTIMATE"))

# Rename columns (e.g., POPESTIMATE2010 -> 2010)
names(population_all) <- gsub("POPESTIMATE", "", names(population_all))

# C. Handling Missing Values (Interpolation by surrounding year average)
# Imputing missing year data with the average of the previous and next year (e.g., 2014 = avg(2013, 2015))
interpolate_na <- function(df) {
  for (i in 1:nrow(df)) {
    for (j in 3:(ncol(df))) { 
      if (is.na(df[i, j])) {
        prev_value <- df[i, j - 1]
        next_value <- df[i, j + 1]
        if (!is.na(prev_value) & !is.na(next_value)) {
          df[i, j] <- round(mean(c(prev_value, next_value), na.rm = TRUE))
        }
      }
    }
  }
  return(df)
}

population_all <- interpolate_na(population_all)
cat("NA Count After Imputation:", sum(is.na(population_all)), "\n")

# D. Tidyverse Aggregation
# a. Max population in a single year per state
max_pop_state <- population_all %>%
  rowwise() %>%
  mutate(max_population = max(c_across(starts_with("20")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(STATE, NAME, max_population)

# b. Total population across all years per state
total_pop_state <- population_all %>%
  rowwise() %>%
  mutate(Total_Population = sum(c_across(starts_with("20")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(STATE, NAME, Total_Population)

# --- Problem 3: Population Trends Visualization ---
cat("\n--- 3. Population Trends Visualization ---\n")

# Reshape from Wide to Long Format for ggplot time-series plotting
selected_names <- c("California", "Texas", "New York")

population_long <- population_all %>%
  filter(NAME %in% selected_names) %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "Year", 
    values_to = "Population"
  ) %>%
  mutate(Year = as.integer(Year)) 

# Visualization: Line graph of Population Trends
population_trend_plot <- ggplot(population_long, 
                                aes(x = Year, y = Population, color = NAME, group = NAME)) +
  geom_line(linewidth = 1) + 
  geom_point() +
  scale_x_continuous(breaks = unique(population_long$Year)) +
  theme_minimal() +
  labs(title = "Population Trends (2010-2019) in Key States",
       x = "Year",
       y = "Population (in millions)",
       color = "State",
       caption = "Data Source: US Census Bureau (via course files)")

print(population_trend_plot)
# ggsave("output_population_trends.png", plot = population_trend_plot)