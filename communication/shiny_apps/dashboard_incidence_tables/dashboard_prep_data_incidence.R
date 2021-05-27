# Prepare data for display on data table 
# data table must display age adjusted cancer incidence rates of most recent 5 year average 
# René Dario Herrera 
# University of Arizona Cancer Center
# renedherrera at email dot arizona dot edu 
# May 2021

# | Geography | Race | Sex | Site | Age Adjusted Incidene Rate | 

# Geography:
geo_of_interest <- c("USA", "AZ", "Catchment", "Cochise County", "Pima County", "Pinal County", "Santa Cruz County", "Yuma")

# Race: 
race_of_interest <- c("All Races", "American Indian/Alaska Native", "Hispanic", "White")

# Sex: 
sex_of_interest <- c("Male and Female", "Female", "Male")

# Cancer Site: 
# source: Genitourinary Cancers https://cancer.osu.edu/for-patients-and-caregivers/learn-about-cancers-and-treatments/cancers-conditions-and-treatment/cancer-types/genitourinary-cancers
# source: Gastrointestinal Cancers https://cancer.osu.edu/for-patients-and-caregivers/learn-about-cancers-and-treatments/cancers-conditions-and-treatment/cancer-types/gastrointestinal-cancers
cancer_site_of_interest <- c("All Cancer Sites Combined", 
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

# load packages ----
library(here)
library(tidyverse)

# read data 
# overall usa incidence by cancer ----
usa_by_cancer <- read_rds("data/tidy/incidence_us_uscs_2013-2017_by_cancer.rds")

# inspect 
glimpse(usa_by_cancer)

# see which values are present 
usa_by_cancer %>%
  distinct(SEX)

usa_by_cancer %>%
  distinct(RACE)

usa_by_cancer %>%
  distinct(SITE) %>%
  print(n = nrow(usa_by_cancer))

usa_by_cancer %>%
  distinct(YEAR)

# filter to race of interest 
focus_race <- race_of_interest

usa_by_cancer %>%
  filter(RACE %in% focus_race)

# filter to cancer of interest 
focus_cancer <- cancer_site_of_interest

usa_by_cancer %>%
  filter(SITE %in% focus_cancer)

# filter to most recent five year average 

recent <- "2013-2017"

usa_by_cancer %>%
  filter(YEAR %in% recent)

# apply all filters 
usa_by_cancer_focus <- usa_by_cancer %>%
  filter(YEAR %in% recent,
         SITE %in% focus_cancer,
         RACE %in% focus_race) %>%
  mutate(AREA = area)

# overall arizona incidence by cancer ----
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

# apply all filters 
az_by_cancer_focus <- state_by_cancer %>%
  filter(AREA == "Arizona",
         YEAR %in% recent,
         SITE %in% focus_cancer,
         RACE %in% focus_race) %>%
  mutate(source = "USCS")

incidence_table_usa_az <- bind_rows(usa_by_cancer_focus, az_by_cancer_focus) %>%
  select(16,2:4,6)

write_rds(incidence_table_usa_az, "data/tidy/dashboard_incidence_table_usa_az.rds")

# uazcc

incidence_table_uazcc <- read_rds("communication/shiny_apps/dashboard_incidence_tables/data/incidence_az_catch_2013-2017_table.rds")

# Arizona counties incidence by cancer

