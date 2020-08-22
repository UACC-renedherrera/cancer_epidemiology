# rationale ----
# use this script to combine values from both USCS & ADHS
# to form data table for UAZCC characterization

# set up ----
# load packages
library(here)
library(tidyverse)
library(knitr)

# incidence ----
# read dataset USCS ----
incidence_uscs <- read_rds("data/tidy/incidence_us_uscs_2013-2017_by_cancer.rds")

glimpse(incidence_uscs)
str(incidence_uscs)

incidence_uscs <- incidence_uscs  %>%
  filter(YEAR == "2013-2017",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE != "All Sites (comparable to ICD-O-2)") %>%
  mutate(SITE = case_when( #variable == old ~ new,
    SITE == "All Cancer Sites Combined" ~ "Overall",
    SITE == "Female Breast" ~ "Breast Invasive (Female)",
    SITE == "Cervix" ~ "Cervix Uteri (Female)",
    SITE == "Colon and Rectum" ~ "Colorectal",
    SITE == "Corpus and Uterus, NOS" ~ "Corpus Uteri and Uterus, NOS (Female)",
    SITE == "Corpus" ~ "Corpus (Female)",
    SITE == "Melanomas of the Skin" ~ "Cutaneous Melanoma",
    SITE == "Gallbladder" ~ "Gallbladder and Other Biliary",
    SITE == "Kidney and Renal Pelvis" ~ "Kidney/Renal Pelvis",
    SITE == "Leukemias" ~ "Leukemia",
    SITE == "Non-Hodgkin Lymphoma" ~ "Non-Hodgkins Lymphoma",
    SITE == "Ovary" ~ "Ovary (Female)",
    SITE == "Prostate" ~ "Prostate (Male)",
    SITE == "Testis" ~ "Testis (Male)",
    SITE == "Oral Cavity and Pharynx" ~ "Oral Cavity",
    SITE == "Hodgkin Lymphoma" ~ "Hodgkins Lymphoma",
    TRUE ~ as.character(SITE)
  ),
  SEX = case_when(
    SEX == "Male and Female" ~ "All",
    TRUE ~ as.character(SEX)
  )) %>%
  select(SITE,
         US = AGE_ADJUSTED_RATE)

# read dataset ADHS ----
incidence_adhs <- read_rds("data/tidy/incidence_az_catch_2013-2017_table.rds")

glimpse(incidence_adhs)

incidence_adhs <- incidence_adhs %>%
  mutate(SITE = case_when( #variable == old ~ new,
    SITE == "All" ~ "Overall",
    TRUE ~ as.character(SITE)
  ))

incidence_uscs


# combine ----
incidence <- full_join(incidence_uscs, incidence_adhs) %>%
  arrange(desc(Catchment))

incidence_table <- incidence %>%
  mutate(IRR_AZ = AZ / US,
       IRR_Catch = Catchment / US,
       IRR_White = `White Non-Hispanic` / US,
       IRR_Hisp = `White Hispanic` / US,
       IRR_AI = `American Indian` / US,
       IRR_Black = Black / US) %>%
  arrange(desc(Catchment))

write_csv(incidence_table, "data/tidy/uazcc_incidence_table_2013-2017.csv")

incidence_table %>%
  filter(IRR_Catch > 1) %>%
  select(SITE, US, AZ, Catchment) %>%
  gather(US, AZ, Catchment,
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities.rds")

# mortality ----

mortality <- read_rds("data/tidy/combined_mortality_for_uazcc_attribute_table.rds")

mortality <- mortality %>%
  mutate(IRR_AZ = AZ_age_adjusted_rate / usa_age_adjusted_rate,
         IRR_Catch = Catch_age_adjusted_rate / usa_age_adjusted_rate,
         IRR_White = white_Age_Adjusted_Rate / usa_age_adjusted_rate,
         IRR_Hisp = hispanic_Age_Adjusted_Rate / usa_age_adjusted_rate,
         IRR_AI = AI_Age_Adjusted_Rate / usa_age_adjusted_rate,
         IRR_Black = black_Age_Adjusted_Rate / usa_age_adjusted_rate)

write_rds(mortality, "data/tidy/uazcc_mortality_table.rds")
