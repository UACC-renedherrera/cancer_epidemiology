# set up ----
# load packages
library(here)
library(tidyverse)
library(knitr)
library(ggthemes)

# arizona, all races ----
# age adjusted incidence for cancer of the oral cavity
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# all races
# all AZ counties
# both male and female sex
oral_cavity <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_20200604.csv",
                        na = c("", "NA", "**", "*"),
                        skip = 1,
                        col_names = c("Year", 
                                      "Sex", 
                                      "Case_Count", 
                                      "Population", 
                                      "Age_Adj_Rate", 
                                      "95CI_min", 
                                      "95CI_max"),
                        col_types = cols(Year = col_factor(),
                                         Sex = col_factor(),
                                         Case_Count = col_number(),
                                         Population = col_number(),
                                         Age_Adj_Rate = col_number(),
                                         "95CI_min" = col_number(),
                                         "95CI_max" = col_number()),
)

glimpse(oral_cavity)

#calculate crude rate and add calculated variable
oral_cavity <- oral_cavity %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_oral_cavity_incidence_plot <- oral_cavity %>%
  filter(Year != "All") %>%
  ggplot(mapping = aes(y = Age_Adj_Rate, x = Year, color = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(0, 20)) +
  scale_x_discrete(labels = NULL) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "for Arizona, years 1997-2017",
       y = "Age Adjusted Rate per 100,000",
       x = "Year 1997-2017",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table with variables Year, Male, Female, Total
AZ_oral_cavity_incidence_table <- oral_cavity %>%
  filter(Year != "All") %>%
  select(Year, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Year, Male, Female, All) %>%
  kable()

# arizona, white non-hispanic ----
# age adjusted incidence for cancer of the oral cavity
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# white, non-hispanic
# all AZ counties
# both male and female sex 
oral_cavity_white <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_white_by_year_20200604.csv",
                        na = c("", "NA", "**", "*"),
                        skip = 1,
                        col_names = c("Year", 
                                      "Sex", 
                                      "Case_Count", 
                                      "Population", 
                                      "Age_Adj_Rate", 
                                      "95CI_min", 
                                      "95CI_max"),
                        col_types = cols(Year = col_factor(),
                                         Sex = col_factor(),
                                         Case_Count = col_number(),
                                         Population = col_number(),
                                         Age_Adj_Rate = col_number(),
                                         "95CI_min" = col_number(),
                                         "95CI_max" = col_number()),
)

glimpse(oral_cavity_white)

#calculate crude rate and add calculated variable
oral_cavity_white <- oral_cavity_white %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_oral_cavity_incidence_white_plot <- oral_cavity_white %>%
  filter(Year != "All") %>%
  ggplot(mapping = aes(y = Age_Adj_Rate, x = Year, color = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(0, 20)) +
  scale_x_discrete(labels = NULL) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "for Arizona, years 1997-2017, White, Non-Hispanic",
       y = "Age Adjusted Rate per 100,000",
       x = "Year 1997-2017",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table with variables Year, Male, Female, Total
AZ_oral_cavity_incidence_white_table <- oral_cavity_white %>%
  filter(Year != "All") %>%
  select(Year, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Year, Male, Female, All) %>%
  kable()

# arizona, white hispanic ----
# age adjusted incidence for cancer of the oral cavity
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# white, Hispanic
# all AZ counties
# both male and female sex 
oral_cavity_hispanic <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_hispanic_by_year_20200604.csv",
                              na = c("", "NA", "**", "*"),
                              skip = 1,
                              col_names = c("Year", 
                                            "Sex", 
                                            "Case_Count", 
                                            "Population", 
                                            "Age_Adj_Rate", 
                                            "95CI_min", 
                                            "95CI_max"),
                              col_types = cols(Year = col_factor(),
                                               Sex = col_factor(),
                                               Case_Count = col_number(),
                                               Population = col_number(),
                                               Age_Adj_Rate = col_number(),
                                               "95CI_min" = col_number(),
                                               "95CI_max" = col_number()),
)

glimpse(oral_cavity_hispanic)

#calculate crude rate and add calculated variable
oral_cavity_hispanic <- oral_cavity_hispanic %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_oral_cavity_incidence_hispanic_plot <- oral_cavity_hispanic %>%
  filter(Year != "All") %>%
  ggplot(mapping = aes(y = Age_Adj_Rate, x = Year, color = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(0, 20)) +
  scale_x_discrete(labels = NULL) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "for Arizona, years 1997-2017, White, Hispanic",
       y = "Age Adjusted Rate per 100,000",
       x = "Year 1997-2017",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table with variables Year, Male, Female, Total
AZ_oral_cavity_incidence_hispanic_table <- oral_cavity_hispanic %>%
  filter(Year != "All") %>%
  select(Year, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Year, Male, Female, All) %>%
  kable()

# catchment, all races ----
# age adjusted incidence for cancer of the oral cavity
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# all races
# Cochise, Pima, Pinal, Santa Cruz, and Yuma counties only
# both male and female sex
oral_cavity_catch <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_catchment_20200604.csv",
                        na = c("", "NA", "**", "*"),
                        skip = 1,
                        col_names = c("Year", 
                                      "Sex", 
                                      "Case_Count", 
                                      "Population", 
                                      "Age_Adj_Rate", 
                                      "95CI_min", 
                                      "95CI_max"),
                        col_types = cols(Year = col_factor(),
                                         Sex = col_factor(),
                                         Case_Count = col_number(),
                                         Population = col_number(),
                                         Age_Adj_Rate = col_number(),
                                         "95CI_min" = col_number(),
                                         "95CI_max" = col_number()),
)

glimpse(oral_cavity_catch)

#calculate crude rate and add calculated variable
oral_cavity_catch <- oral_cavity_catch %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_catch_oral_cavity_plot <- oral_cavity_catch %>%
  filter(Year != "All") %>%
  ggplot(mapping = aes(y = Age_Adj_Rate, x = Year, color = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(0, 20)) +
  scale_x_discrete(labels = NULL) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "for Catchment, years 1997-2017",
       y = "Age Adjusted Rate per 100,000",
       x = "Year 1997-2017",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table with variables Year, Male, Female, Total
AZ_catch_oral_cavity_table <- oral_cavity_catch %>%
  filter(Year != "All") %>%
  select(Year, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Year, Male, Female, All) %>%
  kable()

# catchment, white non-hispanic ----
# age adjusted incidence for cancer of the oral cavity
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# white, non-hispanic
# Cochise, Pima, Pinal, Santa Cruz, and Yuma counties only
# both male and female sex 
oral_cavity_catch_white <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_catchment_white_by_year_20200604.csv",
                              na = c("", "NA", "**", "*"),
                              skip = 1,
                              col_names = c("Year", 
                                            "Sex", 
                                            "Case_Count", 
                                            "Population", 
                                            "Age_Adj_Rate", 
                                            "95CI_min", 
                                            "95CI_max"),
                              col_types = cols(Year = col_factor(),
                                               Sex = col_factor(),
                                               Case_Count = col_number(),
                                               Population = col_number(),
                                               Age_Adj_Rate = col_number(),
                                               "95CI_min" = col_number(),
                                               "95CI_max" = col_number()),
)

glimpse(oral_cavity_catch_white)

#calculate crude rate and add calculated variable
oral_cavity_catch_white <- oral_cavity_catch_white %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_catch_oral_cavity_white_plot <- oral_cavity_catch_white %>%
  filter(Year != "All") %>%
  ggplot(mapping = aes(y = Age_Adj_Rate, x = Year, color = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(0, 20)) +
  scale_x_discrete(labels = NULL) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "for Catchment, years 1997-2017, White, Non-Hispanic",
       y = "Age Adjusted Rate per 100,000",
       x = "Year 1997-2017",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table with variables Year, Male, Female, Total
AZ_catch_oral_cavity_white_table <- oral_cavity_catch_white %>%
  filter(Year != "All") %>%
  select(Year, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Year, Male, Female, All) %>%
  kable()

# catchment, white hispanic ----
# age adjusted incidence for cancer of the oral cavity
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# white, Hispanic
# Cochise, Pima, Pinal, Santa Cruz, and Yuma counties only
# both male and female sex 
oral_cavity_catch_hispanic <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_catchment_hispanic_by_year_20200604.csv",
                                 na = c("", "NA", "**", "*"),
                                 skip = 1,
                                 col_names = c("Year", 
                                               "Sex", 
                                               "Case_Count", 
                                               "Population", 
                                               "Age_Adj_Rate", 
                                               "95CI_min", 
                                               "95CI_max"),
                                 col_types = cols(Year = col_factor(),
                                                  Sex = col_factor(),
                                                  Case_Count = col_number(),
                                                  Population = col_number(),
                                                  Age_Adj_Rate = col_number(),
                                                  "95CI_min" = col_number(),
                                                  "95CI_max" = col_number()),
)

glimpse(oral_cavity_catch_hispanic)

#calculate crude rate and add calculated variable
oral_cavity_catch_hispanic <- oral_cavity_catch_hispanic %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_catch_oral_cavity_plot_hispanic <- oral_cavity_catch_hispanic %>%
  filter(Year != "All") %>%
  ggplot(mapping = aes(y = Age_Adj_Rate, x = Year, color = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(0, 20)) +
  scale_x_discrete(labels = NULL) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "for Catchment, years 1997-2017, White, Hispanic",
       y = "Age Adjusted Rate per 100,000",
       x = "Year 1997-2017",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table with variables Year, Male, Female, Total
AZ_catch_oral_cavity_table_hispanic <- oral_cavity_catch_hispanic %>%
  filter(Year != "All") %>%
  select(Year, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Year, Male, Female, All) %>%
  kable()

# arizona, by race ---- 
# age adjusted incidence for cancer of the oral cavity grouped by race
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# grouped by race
# all AZ counties
oral_cavity_race <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_race_20200604.csv",
                        na = c("", "NA", "**", "*"),
                        skip = 1,
                        col_names = c("Race", 
                                      "Sex", 
                                      "Case_Count", 
                                      "Population", 
                                      "Age_Adj_Rate", 
                                      "95CI_min", 
                                      "95CI_max"),
                        col_types = cols(Race = col_factor(),
                                         Sex = col_factor(),
                                         Case_Count = col_number(),
                                         Population = col_number(),
                                         Age_Adj_Rate = col_number(),
                                         "95CI_min" = col_number(),
                                         "95CI_max" = col_number()),
)

glimpse(oral_cavity_race)

#calculate crude rate and add calculated variable
oral_cavity_race <- oral_cavity_race %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_oral_cavity_race_plot <- oral_cavity_race %>%
  filter(Race != "All") %>%
  ggplot(mapping = aes(x = Age_Adj_Rate, y = Race, fill = Sex)) +
  geom_bar(position = "dodge", stat = "identity", alpha = 0.75, color = "gray") +
  scale_x_continuous(limits = c(0, 20)) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "Arizona total for years 1997-2017",
       x = "Age Adjusted Rate per 100,000",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table  
AZ_oral_cavity_race_table <- oral_cavity_race %>%
  select(Race, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Race, Male, Female, All) %>%
  kable()

# catchment, by race ---- 
# age adjusted incidence for cancer of the oral cavity grouped by race
# read dataset to environment
# years 1997-2017
# cancer site: oral cavity
# grouped by race
# Cochise, Pima, Pinal, Santa Cruz, and Yuma counties only
oral_cavity_race_catch <- read_csv("../data/raw/az_cancer_registry_incidence_oral_cavity_catchment_race_20200604.csv",
                             na = c("", "NA", "**", "*"),
                             skip = 1,
                             col_names = c("Race", 
                                           "Sex", 
                                           "Case_Count", 
                                           "Population", 
                                           "Age_Adj_Rate", 
                                           "95CI_min", 
                                           "95CI_max"),
                             col_types = cols(Race = col_factor(),
                                              Sex = col_factor(),
                                              Case_Count = col_number(),
                                              Population = col_number(),
                                              Age_Adj_Rate = col_number(),
                                              "95CI_min" = col_number(),
                                              "95CI_max" = col_number()),
)

glimpse(oral_cavity_race_catch)

#calculate crude rate and add calculated variable
oral_cavity_race_catch <- oral_cavity_race_catch %>%
  mutate(crude_rate = round((Case_Count / Population) * 100000, digits = 2))

# generate plot visualization 
AZ_catch_oral_cavity_race_plot <- oral_cavity_race_catch %>%
  filter(Race != "All") %>%
  ggplot(mapping = aes(x = Age_Adj_Rate, y = Race, fill = Sex)) +
  geom_bar(position = "dodge", stat = "identity", alpha = 0.75, color = "gray") +
  scale_x_continuous(limits = c(0, 20)) +
  labs(title = "Age-Adjusted Cancer Incidence Rates: Oral Cavity",
       subtitle = "Catchment total for years 1997-2017",
       x = "Age Adjusted Rate per 100,000",
       caption = "Source: Arizona Cancer Registry, 1997-2017") +
  theme_solarized()

# prepare data table  
AZ_catch_oral_cavity_race_table <- oral_cavity_race_catch %>%
  select(Race, Sex, Age_Adj_Rate) %>%
  spread(Sex, Age_Adj_Rate) %>%
  select(Race, Male, Female, All) %>%
  kable()