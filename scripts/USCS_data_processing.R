# set up
# packages 
library(here)
library(tidyverse)
library(purrr)
library(ggthemes)
library(knitr)

# produce a line graph to show top five cancers for 2012-2016
# at the county level, only years 2012-2016 are available

# read data
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds")

# examine dataset
glimpse(by_az_county)

levels(by_az_county$SITE)
levels(by_az_county$SEX)
levels(by_az_county$RACE)

# add fips codes to each county

# incidence
# all cancers
# all races
# all sexes
# each county
by_az_county %>%
  filter(EVENT_TYPE == "Incidence",
         SITE == "All Cancer Sites Combined",
         SEX == "Male and Female",
         RACE == "All Races") %>%
  drop_na() %>%
  select(AREA)
