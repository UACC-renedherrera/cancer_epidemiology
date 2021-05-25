# Prepare data for use in a shiny application data table 
# René Dario Herrera 
# May 2021

# packages 
library(here)
library(tidyverse)

# read data 
# overall usa incidence by cancer ----
usa_by_cancer <- read_rds("data/tidy/incidence_us_uscs_2013-2017_by_cancer.rds")

# inspect 
glimpse(usa_by_cancer)

# see which unique values exist
usa_by_cancer %>%
  distinct(RACE)

# see which unique values exist
usa_by_cancer %>%
  distinct(SITE) %>%
  print(n = nrow(usa_by_cancer))

# see which unique values exist
usa_by_cancer %>%
  distinct(YEAR)

# filter to race of interest 
# create value 
focus_race <- c("All Races", "American Indian/Alaska Native", "Hispanic", "White")

# view filter 
usa_by_cancer %>%
  filter(RACE %in% focus_race)

# create value 
# filter to cancer of interest 
# source: Genitourinary Cancers https://cancer.osu.edu/for-patients-and-caregivers/learn-about-cancers-and-treatments/cancers-conditions-and-treatment/cancer-types/genitourinary-cancers
# source: Gastrointestinal Cancers https://cancer.osu.edu/for-patients-and-caregivers/learn-about-cancers-and-treatments/cancers-conditions-and-treatment/cancer-types/gastrointestinal-cancers
focus_cancer <- c("All Cancer Sites Combined", 
                  "Melanomas of the Skin",
                  "Lung and Bronchus",
                  "Female Breast",
                  "Female Breast, <i>in situ</i>",
                  "Male Breast",
                  "Male and Female Breast",
                  "Male and Female Breast, <i>in situ</i>",
                  "Anus, Anal Canal and Anorectum",
                  "Colon and Rectum",
                  "Colon excluding Rectum",
                  "Esophagus",
                  "Gallbladder",
                  "Liver and Intrahepatic Bile Duct",
                  "Pancreas",
                  "Peritoneum, Omentum and Mesentery",
                  "Rectum and Rectosigmoid Junction",
                  "Small Intestine",
                  "Stomach",
                  "Urinary Bladder",
                  "Kidney and Renal Pelvis",
                  "Prostate",
                  "Male Genital System",
                  "Female Genital System"
                  )

# view filter 
usa_by_cancer %>%
  filter(SITE %in% focus_cancer)

# create value 
# filter to most recent five year average 
recent <- "2013-2017"

# view filter 
usa_by_cancer %>%
  filter(YEAR %in% recent)

# apply all filters and save new data 
usa_by_cancer_focus <- usa_by_cancer %>%
  filter(YEAR %in% recent,
         SITE %in% focus_cancer,
         RACE %in% focus_race,
         EVENT_TYPE == "Incidence") %>%
  mutate(AREA = area)

# overall usa incidence by cancer ----
state_by_cancer <- read_rds("data/tidy/USCS_by_state.rds")

# filter to race of interest 
state_by_cancer %>%
  filter(RACE %in% focus_race)

# filter to cancer site of interest 
state_by_cancer %>%
  filter(SITE %in% focus_cancer)

# filter to most recent five year average 
state_by_cancer %>%
  filter(YEAR %in% recent)

# apply all filters and save data 
az_by_cancer_focus <- state_by_cancer %>%
  filter(AREA == "Arizona",
         YEAR %in% recent,
         SITE %in% focus_cancer,
         RACE %in% focus_race,
         EVENT_TYPE == "Incidence") %>%
  mutate(source = "USCS")

# combine both usa and az data 
# select appropriate rows 
incidence_table_usa_az <- bind_rows(usa_by_cancer_focus, az_by_cancer_focus) %>%
  select(16,2:4,8)

# save data
write_rds(incidence_table_usa_az, "data/tidy/dashboard_incidence_table_usa_az.rds")

# save data for use in shiny app 
write_rds(incidence_table_usa_az, "communication/shiny_apps/dashboard_incidence_tables/data/incidence_az_catch_2013-2017_table.rds")


# uazcc

