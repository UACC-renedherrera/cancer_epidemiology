# set up
# packages 
library(here)
library(tidyverse)
library(purrr)
library(ggthemes)
library(knitr)

# use data to replicate State Cancer Profiles but for Arizona and five county catchment only
# age adjusted incidence:
# 1. by cancer
# 2. by race
# 3. by sex
# 4. by age
# 5. by year

# produce a bar chart to show top five cancers for 2012-2016
# at the county level, only years 2012-2016 are available

# read data
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds")

# examine dataset
glimpse(by_az_county)

levels(by_az_county$SITE)
levels(by_az_county$SEX)
levels(by_az_county$RACE)

# incidence
# all cancers
# all races
# all sexes
# each county
# incidence
by_az_county %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2012-2016"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of new cancers for AZ Counties",
    subtitle = "years 2012-2016"
  )
