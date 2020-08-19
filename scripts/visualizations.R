# set up ----
# packages

library(here)
library(tidyverse)
library(ggthemes)

# read incidence data for 2013-2017
incidence <- read_rds("data/tidy/incidence_usa_az_catch_2013-2017_by_cancer.rds")

# OVERVIEW ----

# Map of Rate of New Cancers catchment ----
# Cancer Incidence for each AZ county
# highlight catchment






# Chart of Rate of New Cancers catchment ----
# Cancer Incidence for each AZ county
# highlight catchment
# show vertical line for US Rate
# show vertical line for AZ Rate



# Chart of Top 10 Cancers by Rates of New Cancer Cases ----
# Cancer incidence for catchment
# 2013-2017, All Races/Ethnicities, Male and Female

# read data 
incidence_catchment_by_cancer <- read_rds("data/tidy/azdhs_catchment_2013-2017_incidence_by_cancer.rds")

# subset and visualize
incidence_catchment_by_cancer %>%
  filter(Sex == "All",
         Cancer != "All",
         Cancer != "Breast Invasive",
         Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = Age_Adj_Rate, y = reorder(Cancer, Age_Adj_Rate))) +
  geom_bar(stat = "identity", fill = "#0C234B") +
  geom_label(aes(label = Age_Adj_Rate)) +
  labs(
    title = "Top 10 Cancers by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment 2013-2017, All Races/Ethnicities, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000"
  ) +
  theme_clean()

# Chart of Top 10 Cancers by Rates of Cancer Deaths ----
# Cancer mortality for catchment
# 2014-2018, All Races/Ethnicities, Male and Female

# read data
mortality_catchment_by_cancer <- read_rds("data/tidy/mortality_az_catch_by_cancer_for_UAZCC_2014-2018_all_race_all_sex.rds")

# subset and visualize
mortality_catchment_by_cancer %>%
  filter( cancer != "All Malignant Cancers") %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_bar(stat = "identity", fill = "#0C234B") +
  geom_label(aes(label = age_adjusted_rate)) +
  labs(
    title = "Top 10 Cancers by Rates of Cancer Deaths",
    subtitle = "UAZCC Catchment 2014-2018, All Races/Ethnicities, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000"
  ) +
  theme_clean()

# DEMOGRAPHICS ---- 

# Chart of Rate of New Cancers, All Races/Ethnicities, Both Sexes ---- 
# All Types of Cancer, catchment, 2014-2018

# read data




# Chart of Rate of New Cancers by Race/Ethnicity, Both Sexes ---- 
# All Types of Cancer, United States, 2013-2017



# Chart of Rate of New Cancers by Age Group (years), All Races, Both Sexes ---- 
# All Types of Cancer, United States, 2013-2017



# Chart of Rate of New Cancers by Sex and Race/Ethnicity ---- 
# All Types of Cancer, United States, 2013-2017



# TRENDS ---- 

# trend line chart Annual Rates of New Cancers, 1999-2017 ---- 
# Changes Over Time: All Types of Cancer
# New Cancers, All Ages, All Races/Ethnicities, Both Sexes


# bar chart Annual Number of New Cancers, 1999-2017 ---- 
# Changes Over Time: All Types of Cancer
# New Cancers, All Ages, All Races/Ethnicities, Both Sexes


# Map of Nationwide Changes in Rates of New Cancers, 1999-2017 ---- 
# Changes Over Time: All Types of Cancer
# New Cancers, All Ages, All Races/Ethnicities, Both Sexes


# RISK FACTORS alcohol ---- 

# Rate of New Alcohol-associated Cancers by Cancer Type
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# Rate of New Alcohol-associated Cancers by State
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# Rate of New Alcohol-associated Cancers by Race/Ethnicity
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# Rate of New Alcohol-associated Cancers by Age Group (years)
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS HPV ---- 

# Rate of New HPV-associated Cancers by Cancer Type
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# Rate of New HPV-associated Cancers by State
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# Rate of New HPV-associated Cancers by Race/Ethnicity
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# Rate of New HPV-associated Cancers by Age Group (years)
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS obesity  ---- 

# Rate of New obesity-associated Cancers by Cancer Type
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# Rate of New obesity-associated Cancers by State
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# Rate of New obesity-associated Cancers by Race/Ethnicity
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# Rate of New obesity-associated Cancers by Age Group (years)
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS physical inactivity  ---- 

# Rate of New physical inactivity-associated Cancers by Cancer Type
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# Rate of New physical inactivity-associated Cancers by State
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# Rate of New physical inactivity-associated Cancers by Race/Ethnicity
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# Rate of New physical inactivity-associated Cancers by Age Group (years)
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS tobacco   ---- 

# Rate of New tobacco -associated Cancers by Cancer Type
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017



# Rate of New tobacco -associated Cancers by State
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017



# Rate of New tobacco -associated Cancers by Race/Ethnicity
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017



# Rate of New tobacco -associated Cancers by Age Group (years)
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017