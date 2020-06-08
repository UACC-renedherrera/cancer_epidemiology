# import and tidy data from 
# Arizona Cancer Registry Query Module 

# set up ---- 
library(here)
library(tidyverse)
library(ggthemes)
library(knitr)

# what are the top 5 incident cancers?

# scope of query 

# top 5 incidence catchment ----
# year: 2012-2016
# cancer site: all
# race: all
# county: Cochise, Pima, Pinal, Santa Cruz, Yuma 
# grouped by cancer, sex

# read data 
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
azdhs_catch_incidence <- read_csv("data/raw/AZDHS/query_catchment_incidence.csv",
                            na = c("", "NA", "**", "*"),
                            skip = 1,
                            col_names = c("Cancer",
                                          "Sex",
                                          "Case_Count",
                                          "Population",
                                          "Age_Adj_Rate",
                                          "95CI_min",
                                          "95CI_max"),
                            col_types = cols(Cancer = col_character(),
                                             Sex = col_factor(),
                                             Case_Count = col_number(),
                                             Population = col_number(),
                                             Age_Adj_Rate = col_number(),
                                             "95CI_min" = col_number(),
                                             "95CI_max" = col_number()),
)

# examine dataset
glimpse(azdhs_catch_incidence)

# top 5 incidence for each sex
azdhs_catch_top_5_inc <- azdhs_catch_incidence %>%
  group_by(Sex) %>%
  filter(Cancer != "All",
         Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5)

# view as table 
azdhs_catch_top_5_inc %>% 
  select(Sex, Cancer, Age_Adj_Rate) %>%
  kable()

# top 5 incidence catchment hispanic ----
# year: 2012-2016
# cancer site: all
# race: White, Hispanic
# county: Cochise, Pima, Pinal, Santa Cruz, Yuma 
# grouped by cancer, sex

# read data 
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
azdhs_catch_incidence_hisp <- read_csv("data/raw/AZDHS/query_catchment_incidence_hisp.csv",
                                      na = c("", "NA", "**", "*"),
                                      skip = 1,
                                      col_names = c("Cancer",
                                                    "Sex",
                                                    "Case_Count",
                                                    "Population",
                                                    "Age_Adj_Rate",
                                                    "95CI_min",
                                                    "95CI_max"),
                                      col_types = cols(Cancer = col_character(),
                                                       Sex = col_factor(),
                                                       Case_Count = col_number(),
                                                       Population = col_number(),
                                                       Age_Adj_Rate = col_number(),
                                                       "95CI_min" = col_number(),
                                                       "95CI_max" = col_number()),
)

glimpse(azdhs_catch_incidence_hisp)

# top 5 incidence for each sex
azdhs_catch_incidence_hisp <- azdhs_catch_incidence_hisp %>%
  group_by(Sex) %>%
  filter(Cancer != "All",
         Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5)

# view as table 
azdhs_catch_incidence_hisp %>% 
  select(Sex, Cancer, Age_Adj_Rate) %>%
  kable()
