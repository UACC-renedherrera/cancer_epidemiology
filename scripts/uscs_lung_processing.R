library(here)
library(tidyverse)
library(janitor)

# by AZ county ----
# read data to environment
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds") %>%
  clean_names()

# examine the data 
str(by_az_county)
glimpse(by_az_county)
unique(by_az_county$race)
unique(by_az_county$area)
unique(by_az_county$site)
unique(by_az_county$year)

