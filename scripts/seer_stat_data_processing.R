# seer stat exports

# set up ----
# load packages
library(here)
library(tidyverse)
library(knitr)
library(ggthemes)
library(knitr)

# read dataset mortality ----
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
  geom_col(position = "dodge", alpha = 0.8) +
  labs(title = "Top 5 Cancer Deaths in Catchment for years 2013-2017",
       subtitle = "all sexes, all races",
       x = "Age Adjusted Rate per 100,000",
       y = "",
       caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)") +
  facet_wrap("sex") +
  theme_solarized()

# read dataset hispanic mortality ---- 
catchment_mortality_hispanic <- read_rds("data/tidy/seer_stat_catchment_mortality_hispanic_2013-2017.rds")

# determine top five cancers for each sex grouping 
# table
catchment_mortality_hispanic %>% 
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
           cancer != "Colon excluding Rectum" &
           cancer != "All Causes of Death" & 
           cancer != "All Malignant Cancers" & 
           !(cancer %in% cancer_to_exclude)) %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  kable(caption = "Age adjusted mortality rate per 100,000 for five county catchment, for all Hispanic only, all races combined, for all sexes, and all cancer, year 2013-2017",
        col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000"))

# plot
catchment_mortality_hispanic %>%
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
           cancer != "Colon excluding Rectum" &
           cancer != "All Causes of Death" & 
           cancer != "All Malignant Cancers" & 
           !(cancer %in% cancer_to_exclude)) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(title = "Top 5 Cancer Deaths in Catchment for years 2013-2017",
       subtitle = "hispanic only ",
       x = "Age Adjusted Rate per 100,000",
       y = "",
       caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)") +
  facet_wrap("sex") +
  theme_solarized()

# pima mortality by cancer ----
# read dataset 
pima_mortality_by_cancer <- read_rds("data/tidy/seer_stat_pima_mortality_2013-2017.rds")

# determine top five cancers for each sex grouping 
# filter out "system"
# and save to value for use later
cancer_to_exclude <- str_subset(pima_mortality_by_cancer$cancer, " System")

# table
pima_mortality_by_cancer %>% 
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
           cancer != "Colon excluding Rectum" &
           cancer != "All Causes of Death" & 
           cancer != "All Malignant Cancers" & 
           !(cancer %in% cancer_to_exclude)) %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  kable(caption = "Age adjusted mortality rate per 100,000 for five county catchment, for all races combined, for all sexes, and all cancer, year 2013-2017",
        col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000"))

# plot 
pima_mortality_by_cancer %>% 
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
           cancer != "Colon excluding Rectum" &
           cancer != "All Causes of Death" & 
           cancer != "All Malignant Cancers" & 
           !(cancer %in% cancer_to_exclude)) %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(title = "Top 5 Cancer Deaths in Pima County, AZ",
       subtitle = "Five year average 2013-2017; All races",
       x = "Age Adjusted Mortality Rate per 100,000",
       y = "",
       caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)") +
  facet_wrap("sex") +
  theme_solarized()

# pima mortality by race ----
# read dataset 
pima_mortality_by_race <- read_rds("data/tidy/seer_stat_pima_mortality_2013-2017_by_race.rds")

# determine top five cancers for each sex grouping 

# table
pima_mortality_by_race %>% 
  group_by(race, sex) %>%
  select(year, cancer, race, sex, age_adjusted_rate) %>%
  kable(caption = "Age adjusted mortality rate per 100,000 for Pima County, AZ, for all sexes, and all cancer, year 2013-2017",
        col.names = c("Year", "Cancer", "Race", "Sex", "Age Adjusted Rate per 100,000"))

# plot 
pima_mortality_by_race %>% 
  group_by(race, sex) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(sex, age_adjusted_rate), fill = sex)) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(title = "Top 5 Cancer Deaths in Pima County, AZ",
       subtitle = "Five year average 2013-2017; All races",
       x = "Age Adjusted Mortality Rate per 100,000",
       y = "",
       caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)") +
  facet_wrap("race") +
  theme_solarized() +
  theme(legend.position = "bottom")

# pima mortality by age group ---- 
# read dataset 
pima_mortality_by_age <- read_rds("data/tidy/seer_stat_pima_mortality_2013-2017_by_age.rds")

# top 5
# table
pima_mortality_by_age %>%
  group_by(sex) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  select(year, cancer, sex, age_group, age_adjusted_rate) %>%
  kable(caption = "Age groups with highest mortality due to cancer for Pima County; ",
        col.names = c("Year", "Cancer", "Sex", "Age Group", "Age Adjusted Rate per 100,000"))

# plot 
pima_mortality_by_age %>%
  group_by(sex) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(age_group, age_adjusted_rate))) +
  geom_col(position = "dodge") +
  facet_wrap("sex") +
  labs(title = "Age Groups with Most Cancer Deaths in Pima County, AZ",
       subtitle = "Five year average 2013-2017; All races combined",
       x = "Age Adjusted Mortality Rate per 100,000",
       y = "",
       caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)") +
  theme_solarized() +
  theme(legend.position = "bottom")

# mortality for usa ---- 

cancers_to_exclude <- c("Digestive System",
                        "Respiratory System",
                        "Male Genital System",
                        "Urinary System",
                        "Female Genital System",
                        "Liver")

mortality_usa_by_cancer <- read_rds("data/tidy/seer_mortality_usa_by_cancer_2014-2018_all_race_all_sex.rds")

mortality_usa_by_cancer_for_uazcc <- mortality_usa_by_cancer %>%
  filter(!(cancer %in% cancer_to_exclude)) %>%
  select(cancer, usa_age_adjusted_rate)

# mortality for uazcc AZ ----
mortality_az_by_cancer_for_UAZCC <- read_rds("data/tidy/seer_mortality_AZ_all_race_all_sex_2014-2018_by_cancer.rds")

cancers_to_exclude <- c("Digestive System",
                       "Respiratory System",
                       "Male Genital System",
                       "Urinary System",
                       "Female Genital System",
                       "Liver")

mortality_az_by_cancer_for_UAZCC <- mortality_az_by_cancer_for_UAZCC %>%
  filter(!(cancer %in% cancer_to_exclude)) %>%
  select(cancer,
         "AZ_age_adjusted_rate" = age_adjusted_rate)

# mortality for UAZCC AZ catchment ---- 
mortality_az_catch_by_cancer_for_UAZCC <- read_rds("data/tidy/mortality_az_catch_by_cancer_for_UAZCC_2014-2018_all_race_all_sex.rds")

mortality_az_catch_by_cancer_for_UAZCC <- mortality_az_catch_by_cancer_for_UAZCC %>%
  filter(!(cancer %in% cancer_to_exclude)) %>%
  select(cancer,
         "Catch_age_adjusted_rate" = age_adjusted_rate) 

combined_mortality_AZ_catch_for_UAZCC <- full_join(mortality_az_by_cancer_for_UAZCC, mortality_az_catch_by_cancer_for_UAZCC) 

combined_mortality_for_uazcc <- full_join(combined_mortality_AZ_catch_for_UAZCC, mortality_usa_by_cancer_for_uazcc) %>% 
  arrange(desc(Catch_age_adjusted_rate, AZ_age_adjusted_rate)) 

combined_mortality_for_uazcc <- combined_mortality_for_uazcc %>% 
  select(cancer, usa_age_adjusted_rate, AZ_age_adjusted_rate, Catch_age_adjusted_rate) %>% 
  arrange(desc(Catch_age_adjusted_rate, AZ_age_adjusted_rate, usa_age_adjusted_rate)) %>%
  drop_na() 

combined_mortality_for_uazcc %>%
  kable()
