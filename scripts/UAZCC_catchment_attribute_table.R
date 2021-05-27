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

# save for use in shiny app
write_rds(incidence_table, "communication/shiny_apps/dashboard_incidence_tables/data/incidence_usa_az_catchment.rds")



# disparities catchment

incidence_table %>%
  filter(IRR_Catch > 1) %>%
  select(SITE, US, AZ, Catchment) %>%
  gather(US, AZ, Catchment,
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities.rds")

# disparities catchment white

incidence_table %>%
  filter(IRR_White > 1) %>%
  slice(1:10) %>%
  select(SITE, US, AZ, Catchment, "White Non-Hispanic") %>%
  gather(US, AZ, Catchment, "White Non-Hispanic",
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities_white.rds")

# disparities catchment hispanic

incidence_table %>%
  filter(IRR_Hisp > 1) %>%
  select(SITE, US, AZ, Catchment, "White Hispanic") %>%
  gather(US, AZ, Catchment, "White Hispanic",
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities_hispanic.rds")

# disparities catchment ai

incidence_table %>%
  filter(IRR_AI > 1) %>%
  select(SITE, US, AZ, Catchment, "American Indian") %>%
  gather(US, AZ, Catchment, "American Indian",
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities_ai.rds")

# mortality ----

mortality <- read_rds("data/tidy/mortality_seer_area_race_cancer_rate.rds")

mortality_usa_az_catch <- mortality %>%
  filter(race == "All Races") %>%
  spread(key = area,
         value = rate) %>%
  arrange(desc(Catchment)) %>%
  select(!(race))

mortality_catch_race <-  mortality %>%
  filter(area == "Catchment",
         race != "All Races") %>%
  select(!(area)) %>%
  spread(key = race,
         value = rate)

mortality_table <- full_join(mortality_usa_az_catch, mortality_catch_race) %>%
  select(cancer, 
         US, 
         AZ, 
         Catchment,
         White,
         Hispanic,
         "American_Indian" = `American Indian/Alaska Native`,
         Black)

mortality_table <- mortality_table %>%
  mutate(IRR_AZ = AZ / US,
         IRR_Catch = Catchment / US,
         IRR_White = White / US,
         IRR_Hisp = Hispanic / US,
         IRR_AI = American_Indian / US,
         IRR_Black = Black / US) %>%
  arrange(desc(Catchment))

write_csv(mortality_table, "data/tidy/uazcc_mortality_table_2014-2018.csv")

# mortality disparities for catchment 
mortality_table %>%
  filter(IRR_Catch > 1) %>%
  select(cancer, US, AZ, Catchment) %>%
  arrange(desc(Catchment)) %>%
  slice(1:10) %>%
  gather(US, AZ, Catchment,
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities.rds")

# mortality disparities for white in catchment 
mortality_table %>%
  filter(IRR_White > 1) %>%
  select(cancer, US, AZ, Catchment, White) %>%
  arrange(desc(White)) %>%
  slice(1:10) %>%
  gather(US, AZ, Catchment, White, 
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities_white.rds")

# mortality disparities for hispanic in catchment 
mortality_table %>%
  filter(IRR_Hisp > 1) %>%
  select(cancer, US, AZ, Catchment, Hispanic) %>%
  arrange(desc(Hispanic)) %>%
  gather(US, AZ, Catchment, Hispanic, 
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities_hispanic.rds")

# mortality disparities for American Indian in catchment 
mortality_table %>%
  filter(IRR_AI > 1) %>%
  select(cancer, US, AZ, Catchment, American_Indian) %>%
  arrange(desc(American_Indian)) %>%
  gather(US, AZ, Catchment, American_Indian, 
         key = area,
         value = rate) %>%
  write_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities_ai.rds")
