# Prepare data for display on data table 
# data table must display age adjusted cancer incidence rates of most recent 5 year average 
# René Dario Herrera 
# University of Arizona Cancer Center
# renedherrera at email dot arizona dot edu 
# May 2021

# set up ---- 
# load packages ----
library(here)
library(tidyverse)
library(janitor)

# set values for USCS filters
# | Geography | Race | Sex | Site | Age Adjusted Incidene Rate | 

# Geography:
geo_of_interest <- c("USA", "AZ", "Catchment", "Cochise County", "Pima County", "Pinal County", "Santa Cruz County", "Yuma")

# Race: 
race_of_interest <- c("All Races", "American Indian/Alaska Native", "Hispanic", "White")

# Sex: 
sex_of_interest <- c("Male and Female", "Female", "Male")

# Recent:
recent <- "2013-2017"

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

# read data ----
# overall usa incidence by cancer uscs ----
uscs_usa_by_cancer <- read_rds("data/tidy/incidence_us_uscs_2013-2017_by_cancer.rds") %>%
  clean_names()

# inspect 
glimpse(uscs_usa_by_cancer)

# see which values are present 
uscs_usa_by_cancer %>%
  distinct(sex)

uscs_usa_by_cancer %>%
  distinct(race)

uscs_usa_by_cancer %>%
  distinct(site) %>%
  print(n = nrow(uscs_usa_by_cancer))

uscs_usa_by_cancer %>%
  distinct(year)

# filter to race of interest 
focus_race <- race_of_interest

uscs_usa_by_cancer %>%
  filter(race %in% focus_race)

# filter to cancer of interest 
focus_cancer <- cancer_site_of_interest

uscs_usa_by_cancer %>%
  filter(site %in% focus_cancer)

# filter to most recent five year average 
uscs_usa_by_cancer %>%
  filter(year %in% recent)

# apply all filters 
uscs_usa_by_cancer_focus <- uscs_usa_by_cancer %>%
  filter(year %in% recent,
         site %in% focus_cancer,
         race %in% focus_race) %>%
  mutate(source = "USCS") %>%
  select(area, year, race, sex, site, age_adjusted_rate, source)

# overall arizona incidence by cancer uscs ----
uscs_az_by_cancer <- read_rds("data/tidy/USCS_by_state.rds") %>%
  clean_names

# filter to race of interest 
uscs_az_by_cancer %>%
  filter(race %in% focus_race)

# filter to cancer site of interest 
uscs_az_by_cancer %>%
  filter(site %in% focus_cancer)

# filter to most recent five year average 
uscs_az_by_cancer %>%
  filter(year %in% recent)

# apply all filters 
az_by_cancer_focus <- uscs_az_by_cancer %>%
  filter(area == "Arizona",
         year %in% recent,
         site %in% focus_cancer,
         race %in% focus_race) %>%
  mutate(source = "USCS") %>%
  select(area, year, race, sex, site, age_adjusted_rate, source)

# individual arizona counties uscs incidence ----
uscs_az_counties_by_cancer <- read_rds("data/tidy/USCS_by_az_county.rds") %>%
  clean_names()

# inspect
glimpse(uscs_az_counties_by_cancer)

# apply filters
uscs_az_counties_by_cancer_by_focus <- uscs_az_counties_by_cancer %>%
  filter(year %in% recent,
         site %in% focus_cancer,
         race %in% focus_race) %>%
  mutate(source = "USCS") %>%
  select(area, year, race, sex, site, age_adjusted_rate, source)

# combine all uscs data frames to one df
uscs_incidence <- bind_rows(uscs_usa_by_cancer_focus, 
                                   az_by_cancer_focus,
                                   uscs_az_counties_by_cancer_by_focus)

uscs_incidence

# uazcc catchment incidence ----
uazcc_catchment <- read_rds("communication/shiny_apps/dashboard_incidence_tables/data/incidence_az_catch_2013-2017_table.rds") %>%
  clean_names() 

# inspect 
glimpse(uazcc_catchment)

uazcc_catchment %>%
  distinct(area) 

uazcc_catchment %>%
  distinct(race) 

uazcc_catchment$race <- 
recode(uazcc_catchment$race,
       "American Indian" = "American Indian/Alaska Native",
       "White Hispanic"  = "Hispanic",
       "White Non-Hispanic" = "White"
       )

uazcc_catchment %>%
  distinct(sex)

uazcc_catchment$sex <- 
  recode(uazcc_catchment$sex,
         "All" = "Male and Female"
  )

uazcc_sites <- uazcc_catchment %>%
  distinct(site)

uazcc_catchment$site <- recode(#x, old = new
  uazcc_catchment$site,
    "All" = "All Cancer Sites Combined",
    "Cutaneous Melanoma" = "Melanomas of the Skin",
    "Breast Invasive" = "Male Breast",
    "Breast Invasive (Female)" = "Female Breast",
    "Colorectal" = "Colon and Rectum",
    "Gallbladder and Other Biliary" = "Gallbladder",
    "Kidney/Renal Pelvis" = "Kidney and Renal Pelvis",
    "Prostate (Male)" = "Prostate",
    "Testis (Male)" = "Male Genital System",
    "Cervix Uteri (Female)" = "Female Genital System",
    "Ovary (Female)" = "Female Genital System"
  )

# correct so that prostate = male sex
uazcc_catchment_prostate <- uazcc_catchment %>%
  filter(site == "Prostate",
         sex == "Male and Female") %>%
  drop_na() %>%
  mutate(sex = "Male")
  
# add the prostate rows back 
uazcc_catchment <- bind_rows(uazcc_catchment,
          uazcc_catchment_prostate)
  
# apply filters 
azdhs_uazcc_catchment_incidence <- uazcc_catchment %>%
  filter(year %in% recent,
         site %in% focus_cancer,
         race %in% focus_race,
         area == "Catchment") %>%
  select(area, year, race, sex, site, age_adjusted_rate, source) %>%
  filter(!(
    site == "Prostate" & sex == "Male and Female"
  ))

azdhs_uazcc_catchment_incidence

# combine uscs and adhs ---- 
incidence_table <- bind_rows(uscs_incidence,
                             azdhs_uazcc_catchment_incidence) %>%
  drop_na()

# write to rds to use in shiny app 
write_rds(incidence_table, "communication/shiny_apps/dashboard_incidence_tables/data/incidence_table.rds")
