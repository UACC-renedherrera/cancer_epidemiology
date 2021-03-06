# breast cancer and tribal communities
# set up ----
# packages
library(here)
library(tidyverse)

# for Arizona ----
# by cancer ----
# read data
by_state <- read_rds("data/tidy/USCS_by_state.rds")

# by AZ county ----
# read data to environment
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds")

glimpse(by_state)

by_state %>%
  distinct(YEAR)

by_state %>%
  distinct(SITE)

# generate table for az native american
native_az_breast <- by_state %>%
  filter(AREA == "Arizona",
         RACE == "American Indian/Alaska Native",
         YEAR == "2013-2017",
         SITE == "Female Breast") %>%
  select(AREA, AGE_ADJUSTED_RATE, EVENT_TYPE, RACE, SEX, SITE, YEAR) 

native_az_breast

str(by_az_county)

# generate table for az native american for each county
native_az__counties_breast <- by_az_county %>%
  filter(STATE == "AZ",
         RACE == "American Indian/Alaska Native",
         SITE == "Female Breast")  %>%
  select(AREA, AGE_ADJUSTED_RATE, EVENT_TYPE, RACE, SEX, SITE, YEAR) 

native_breast <- rbind(native_az__counties_breast, native_az_breast)

native_breast %>%
  distinct(AREA, SEX, YEAR)

catchment_breast <- tribble(
  ~AREA, ~EVENT_TYPE, ~AGE_ADJUSTED_RATE,
  "Catchment", "Incidence", 60.09,
  "Catchment", "Mortality", NA
)

native_breast <- native_breast %>%
  filter(SEX == "Female") %>%
  select(AREA, EVENT_TYPE, AGE_ADJUSTED_RATE) 

native_breast <- rbind(native_breast, catchment_breast)

# save to csv for sharing
write_csv(native_breast, "data/tidy/breast_cancer_in_tribal_communities.csv")

table_native_breast <- read_csv("data/tidy/breast_cancer_in_tribal_communities.csv")

table_native_breast %>%
  drop_na() %>%
  arrange(EVENT_TYPE, AREA)

# Pascua Yaqui Tribe 
# https://www.pascuayaqui-nsn.gov/Documents/2016_PYT_CHA.pdf
# no data specific to breast cancer incidence or mortality 

