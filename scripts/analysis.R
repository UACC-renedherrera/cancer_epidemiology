# compare incidence USA vs AZ vs catchment
# usa is seer
# az is seer
# catchment is adhs

# set up ----
# packages
library(here)
library(tidyverse)
library(ggthemes)
library(knitr)

# load USA data ----
incidence_usa <- read_rds("data/tidy/USCS_by_cancer.rds")

unique(incidence_usa$YEAR)
unique(incidence_usa$SITE)
unique(incidence_usa$RACE)
unique(incidence_usa$SEX)

incidence_usa <- incidence_usa %>% 
  drop_na() %>%
  filter(YEAR == "2012-2016",
         SEX == "Male and Female",
         RACE == "All Races",
         EVENT_TYPE == "Incidence",
         SITE != "All Sites (comparable to ICD-O-2)",
         SITE != "Male and Female Breast",
         SITE != "Male and Female Breast, <i>in situ</i>",
         SITE != "Female Breast, <i>in situ</i>") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, 
         "USA_AGE_ADJUSTED_RATE" = AGE_ADJUSTED_RATE,
         "USA_COUNT" = COUNT,
         "USA_POPULATION" = POPULATION)

# load AZ data ----
incidence_AZ <- read_rds("data/tidy/USCS_by_state.rds")

incidence_AZ <- incidence_AZ %>%
  drop_na() %>%
  filter(AREA == "Arizona",
         YEAR == "2012-2016",
         RACE == "All Races",
         SEX == "Male and Female",
         EVENT_TYPE == "Incidence",
         SITE != "All Sites (comparable to ICD-O-2)",
         SITE != "Male and Female Breast",
         SITE != "Male and Female Breast, <i>in situ</i>",
         SITE != "Female Breast, <i>in situ</i>") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, 
         "AZ_AGE_ADJUSTED_RATE" = AGE_ADJUSTED_RATE,
         "AZ_COUNT" = COUNT,
         "AZ_POPULATION" = POPULATION)

# load catchment data ----
incidence_catch <- read_rds("data/tidy/azdhs_catchment_2012-2016_incidence_by_cancer.rds")

incidence_catch <- incidence_catch %>%
  drop_na() %>%
  filter(Cancer != "Other Invasive",
         Cancer != "Breast In Situ",
         Sex == "All") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  select(SITE = Cancer,
         "CATCH_AGE_ADJUSTED_RATE" = Age_Adj_Rate,
         "CATCH_COUNT" = Case_Count,
         "CATCH_POPULATION" = Population)

# combine into one
incidence <- full_join(incidence_usa, incidence_AZ)

full_join(incidence, incidence_catch) %>%
  arrange(desc(CATCH_AGE_ADJUSTED_RATE))

uscs_site <- incidence %>%
  distinct(SITE) %>%
  arrange(SITE)
 
azdhs_site <- incidence_catch %>%
  distinct(SITE) %>%
  arrange(SITE)