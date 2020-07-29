# rationale ---- 
# use this script to combine values from both USCS & ADHS

# set up ---- 
# load packages 
library(here)
library(tidyverse)
library(knitr)

# incidence ---- 
# read dataset USCS ---- 
USCS_incidence_USA_AZ <- read_rds("data/tidy/USCS_incidence_2012_2016_USA_AZ.rds")

# read dataset ADHS ---- 
ADHS_incidence_catch <- read_rds("data/tidy/incidence_azdhs_az_catch_race_2012-2016.rds")

# recode ADHS to match USCS ---- 
ADHS_incidence_catch <- ADHS_incidence_catch %>%
  mutate(Cancer = as_factor(Cancer)) %>%
  mutate(Cancer = fct_recode(Cancer, 
                    "Overall" = "All",
                    "Female Breast" = "Breast Invasive",
                    "Kidney and Renal Pelvis" = "Kidney/Renal Pelvis",
                    "Oral Cavity and Pharynx" = "Oral Cavity",
                    "Corpus and Uterus, NOS" = "Corpus Uteri and Uterus, NOS",
                    "Cervix" = "Cervix Uteri"
                    ))

# recode ADHS to match USCS ----  
USCS_incidence_USA_AZ <- USCS_incidence_USA_AZ %>% 
  select(Cancer = "SITE",
         USA_AGE_ADJUSTED_RATE) %>%
  mutate(Cancer = fct_recode(
    Cancer,
    "Overall" = "All Cancer Sites Combined",
    "Colorectal" = "Colon and Rectum",
    "Cutaneous Melanoma" = "Melanomas of the Skin",
    "Non-Hodgkins Lymphoma" = "Non-Hodgkin Lymphoma",
    "Leukemia" = "Leukemias",
    "Gallbladder and Other Biliary" = "Gallbladder",
    "Gallbladder and Other Biliary" = "Other Biliary",
    "Hodgkins Lymphoma" = "Hodgkin Lymphoma",
  ))

# combine ---- 
incidence <- full_join(USCS_incidence_USA_AZ, ADHS_incidence_catch)

incidence_table <- incidence %>%
  mutate(IRR_AZ = AZ_Age_Adj_Rate / USA_AGE_ADJUSTED_RATE,
       IRR_Catch = catch_Age_Adj_Rate / USA_AGE_ADJUSTED_RATE,
       IRR_White = catch_white_Age_Adj_Rate / USA_AGE_ADJUSTED_RATE,
       IRR_Hisp = catch_hisp_Age_Adj_Rate / USA_AGE_ADJUSTED_RATE,
       IRR_AI = catch_ai_Age_Adj_Rate / USA_AGE_ADJUSTED_RATE,
       IRR_Black = catch_black_Age_Adj_Rate / USA_AGE_ADJUSTED_RATE) %>%
  arrange(desc(catch_Age_Adj_Rate))

write_rds(incidence_table, "data/tidy/uazcc_incidence_table.rds")

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
