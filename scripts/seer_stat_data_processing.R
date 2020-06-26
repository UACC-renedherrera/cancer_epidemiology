# seer stat exports

# set up
# load packages
library(here)
library(tidyverse)
library(knitr)
library(ggthemes)

# read dataset
catchment_mortality <- read_rds("data/tidy/seer_stat_catchment_mortality_2013-2017.rds")

# determine top five cancers for each sex grouping 
# table
catchment_mortality %>% 
  group_by(sex) %>%
  filter(cancer != "All Causes of Death" & cancer != "All Malignant Cancers") %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  kable(caption = "Age adjusted mortality rate per 100,000 for five county catchment, for all races combined, for all sexes, and all cancer, year 2013-2017",
        col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000"))

# plot
catchment_mortality %>%
  group_by(sex) %>%
  filter(cancer != "All Causes of Death" & cancer != "All Malignant Cancers") %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_col(position = "dodge", alpha = 0.5) +
  labs(title = "Top 5 Cancer Deaths in Catchment for years 2013-2017",
       subtitle = "all sexes, all races",
       x = "Age Adjusted Rate per 100,000",
       y = "",
       caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)") +
  facet_wrap("sex") +
  theme_solarized()

# read dataset
catchment_mortality_hispanic <- read_rds("data/tidy/seer_stat_catchment_mortality_hispanic_2013-2017.rds")

# determine top five cancers for each sex grouping 
# table
catchment_mortality_hispanic %>% 
  group_by(sex) %>%
  filter(cancer != "All Causes of Death" & cancer != "All Malignant Cancers") %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  kable(caption = "Age adjusted mortality rate per 100,000 for five county catchment, for all Hispanic only, all races combined, for all sexes, and all cancer, year 2013-2017",
        col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000"))

# plot
catchment_mortality_hispanic %>%
  group_by(sex) %>%
  filter(cancer != "All Causes of Death" & cancer != "All Malignant Cancers") %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_col(position = "dodge", alpha = 0.5) +
  labs(title = "Top 5 Cancer Deaths in Catchment for years 2013-2017",
       subtitle = "hispanic only ",
       x = "Age Adjusted Rate per 100,000",
       y = "",
       caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)") +
  facet_wrap("sex") +
  theme_solarized()