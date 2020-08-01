# seer stat exports

# set up ----
# load packages
library(here)
library(tidyverse)
library(knitr)

# 5 county catchment ----
# mortality data obtained from seer stat
# age adjusted mortality rates
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2013-2017'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# {Site and Morphology.Cause of death recode} = '  All Malignant Cancers'

# read data from saved export
catchment_mortality <- read_delim("data/raw/seer_stat/mortality_catchment_all_race_all_sex_2013-2017.txt",
  delim = ",",
  col_names = c(
    "cancer",
    "sex",
    "age_adjusted_rate",
    "case_count",
    "population"
  ),
  col_types = cols(
    "cancer" = col_factor(),
    "sex" = col_factor(),
    "age_adjusted_rate" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^")
)

catchment_mortality <- drop_na(catchment_mortality)

# save dataset
write_rds(catchment_mortality, "data/tidy/seer_stat_catchment_mortality_2013-2017.rds")

# examine data set
glimpse(catchment_mortality)
str(catchment_mortality$cancer)
unique(catchment_mortality$cancer)

# five county catchment, hispanic ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years','Unknown'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2013-2017'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Origin recode 1990+ (Hispanic, Non-Hisp)} = 'Spanish-Hispanic-Latino'
# {Site and Morphology.Cause of death recode} = '  All Malignant Cancers'

# read data from saved export
catchment_mortality_hispanic <- read_delim("data/raw/seer_stat/mortality_catchment_all_race_hispanic_all_sex_2013-2017.txt",
  delim = ",",
  col_names = c(
    "cancer",
    "sex",
    "age_adjusted_rate",
    "standard_error",
    "lower_ci",
    "upper_ci",
    "case_count",
    "population"
  ),
  col_types = cols(
    "cancer" = col_factor(),
    "sex" = col_factor(),
    "age_adjusted_rate" = col_number(),
    "standard_error" = col_number(),
    "lower_ci" = col_number(),
    "upper_ci" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^")
)

catchment_mortality_hispanic <- drop_na(catchment_mortality_hispanic)

# save dataset
write_rds(catchment_mortality_hispanic, "data/tidy/seer_stat_catchment_mortality_hispanic_2013-2017.rds")

# examine data set
glimpse(catchment_mortality_hispanic)
str(catchment_mortality_hispanic$cancer)
unique(catchment_mortality_hispanic$cancer)

# pima county mortality by cancer ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2013-2017'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Pima County (04019)'
# {Site and Morphology.Cause of death recode} = '  All Malignant Cancers'

# read data from saved export
pima_mortality_by_cancer <- read_delim("data/raw/seer_stat/mortality_pima_all_race_all_sex_2013-2017.txt",
  delim = ",",
  col_names = c(
    "cancer",
    "sex",
    "age_adjusted_rate",
    "standard_error",
    "lower_ci",
    "upper_ci",
    "case_count",
    "population"
  ),
  col_types = cols(
    "cancer" = col_factor(),
    "sex" = col_factor(),
    "age_adjusted_rate" = col_number(),
    "standard_error" = col_number(),
    "lower_ci" = col_number(),
    "upper_ci" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^", "NA")
)

# drop na
pima_mortality_by_cancer <- drop_na(pima_mortality_by_cancer)

# add columns to describe dataset
pima_mortality_by_cancer <- pima_mortality_by_cancer %>%
  mutate(
    year = "2013-2017",
    race = "All Races"
  )

# save dataset
write_rds(pima_mortality_by_cancer, "data/tidy/seer_stat_pima_mortality_2013-2017.rds")

# pima county mortality by race ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2013-2017'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Pima County (04019)'
# {Site and Morphology.Cause of death recode} = '  All Malignant Cancers'

# read data from saved export
pima_mortality_by_race <- read_delim("data/raw/seer_stat/mortality_pima_all_race_all_sex_2013-2017_by_race.txt",
  delim = ",",
  col_names = c(
    "race",
    "sex",
    "age_adjusted_rate",
    "standard_error",
    "lower_ci",
    "upper_ci",
    "case_count",
    "population"
  ),
  col_types = cols(
    "race" = col_factor(),
    "sex" = col_factor(),
    "age_adjusted_rate" = col_number(),
    "standard_error" = col_number(),
    "lower_ci" = col_number(),
    "upper_ci" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^", "NA")
)

# drop NA values
pima_mortality_by_race <- drop_na(pima_mortality_by_race)

# add variables to define data
pima_mortality_by_race <- pima_mortality_by_race %>%
  mutate(
    cancer = "All cancers combined",
    year = "2013-2017"
  )

# save dataset
write_rds(pima_mortality_by_race, "data/tidy/seer_stat_pima_mortality_2013-2017_by_race.rds")

# pima county mortality by age ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2013-2017'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Pima County (04019)'
# {Site and Morphology.Cause of death recode} = '  All Malignant Cancers'

# read data from saved export
pima_mortality_by_age <- read_delim("data/raw/seer_stat/mortality_pima_all_race_all_sex_2013-2017_by_age.txt",
  delim = ",",
  col_names = c(
    "age_group",
    "sex",
    "age_adjusted_rate",
    "standard_error",
    "lower_ci",
    "upper_ci",
    "case_count",
    "population"
  ),
  col_types = cols(
    "age_group" = col_factor(),
    "sex" = col_factor(),
    "age_adjusted_rate" = col_number(),
    "standard_error" = col_number(),
    "lower_ci" = col_number(),
    "upper_ci" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^", "NA")
)

# drop NA values
pima_mortality_by_age <- drop_na(pima_mortality_by_age)

# add variables to define data
pima_mortality_by_age <- pima_mortality_by_age %>%
  mutate(
    cancer = "All cancers combined",
    year = "2013-2017"
  )

# save dataset
write_rds(pima_mortality_by_age, "data/tidy/seer_stat_pima_mortality_2013-2017_by_age.rds")

# mortality USA ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2014-2018'
# {Site and Morphology.Cause of death recode} = '    Oral Cavity and Pharynx','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','    Bones and Joints','    Soft Tissue including Heart','      Melanoma of the Skin','    Breast','      Cervix Uteri','      Corpus and Uterus, NOS','      Ovary','      Vagina','      Vulva','      Prostate','      Testis','      Penis','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','    Eye and Orbit','    Brain and Other Nervous System','    Endocrine System','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','    Myeloma','      Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia'
#
# citation: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).

mortality_usa_by_cancer <- read_delim("data/raw/seer_stat/mortality_usa_all_race_all_sex_2014-2018_by_cancer.txt",
  delim = ",",
  col_names = c(
    "cancer",
    "usa_age_adjusted_rate",
    "case_count",
    "population"
  ),
  col_types = cols(
    "cancer" = col_factor(),
    "usa_age_adjusted_rate" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^", "NA")
)

mortality_usa_by_cancer <- mortality_usa_by_cancer %>%
  drop_na() %>%
  arrange(desc(usa_age_adjusted_rate)) %>%
  filter(cancer != "All Causes of Death")

list_of_cancer <- mortality_usa_by_cancer %>%
  select(cancer) %>%
  mutate(cancer = as.character(cancer)) %>%
  arrange(cancer) %>%
  kable()

write_rds(mortality_usa_by_cancer, "data/tidy/seer_mortality_usa_by_cancer_2014-2018_all_race_all_sex.rds")

# mortality AZ ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2014-2018'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# {Site and Morphology.Cause of death recode} = '    Oral Cavity and Pharynx','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','    Bones and Joints','    Soft Tissue including Heart','      Melanoma of the Skin','    Breast','      Cervix Uteri','      Corpus and Uterus, NOS','      Ovary','      Vagina','      Vulva','      Prostate','      Testis','      Penis','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','    Eye and Orbit','    Brain and Other Nervous System','    Endocrine System','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','    Myeloma','      Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia'

# citation:
# Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).

mortality_az_by_cancer <- read_delim("data/raw/seer_stat/mortality_az_all_race_all_sex_2014-2018_by_cancer.txt",
  delim = ",",
  col_names = c(
    "cancer",
    "age_adjusted_rate",
    "case_count",
    "population"
  ),
  col_types = cols(
    "cancer" = col_factor(),
    "age_adjusted_rate" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^", "NA")
)

mortality_az_by_cancer_for_UAZCC <- mortality_az_by_cancer %>%
  drop_na() %>%
  arrange(desc(age_adjusted_rate)) %>%
  filter(cancer != "All Causes of Death")

write_rds(mortality_az_by_cancer_for_UAZCC, "data/tidy/seer_mortality_AZ_all_race_all_sex_2014-2018_by_cancer.rds")

# mortality catchment ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2014-2018'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# {Site and Morphology.Cause of death recode} = '    Oral Cavity and Pharynx','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','    Bones and Joints','    Soft Tissue including Heart','      Melanoma of the Skin','    Breast','      Cervix Uteri','      Corpus and Uterus, NOS','      Ovary','      Vagina','      Vulva','      Prostate','      Testis','      Penis','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','    Eye and Orbit','    Brain and Other Nervous System','    Endocrine System','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','    Myeloma','      Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia'
#
# Citation: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).

mortality_az_catch_by_cancer <- read_delim("data/raw/seer_stat/mortality_catchment_all_race_all_sex_2014-2018_by_cancer.txt",
  delim = ",",
  col_names = c(
    "cancer",
    "age_adjusted_rate",
    "case_count",
    "population"
  ),
  col_types = cols(
    "cancer" = col_factor(),
    "age_adjusted_rate" = col_number(),
    "case_count" = col_number(),
    "population" = col_number()
  ),
  na = c("", "^", "NA")
)

mortality_az_catch_by_cancer_for_UAZCC <- mortality_az_catch_by_cancer %>%
  drop_na() %>%
  arrange(desc(age_adjusted_rate)) %>%
  filter(cancer != "All Causes of Death")

write_rds(mortality_az_catch_by_cancer_for_UAZCC, "data/tidy/mortality_az_catch_by_cancer_for_UAZCC_2014-2018_all_race_all_sex.rds")

# mortality catchment non hispanic white ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Origin recode 1990+ (Hispanic, Non-Hisp)} = 'Non-Spanish-Hispanic-Latino','Spanish-Hispanic-Latino'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2014-2018'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# {Site and Morphology.Cause of death recode} = '  All Malignant Cancers'

# Citation: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).


mortality_az_catch_by_race <- read_delim("data/raw/seer_stat/mortality_catchment_2014-2018_by_race.txt",
  delim = ",",
  col_names = c(
    "Race",
    "Ethnicity",
    "Age_Adjusted_Rate",
    "Count",
    "Population"
  ),
  col_types = cols(
    "Race" = col_factor(),
    "Ethnicity" = col_factor(),
    "Age_Adjusted_Rate" = col_number(),
    "Count" = col_number(),
    "Population" = col_number()
  ),
  na = c("", "^", "NA")
)

mortality_az_catch_by_race <- read_delim("data/raw/seer_stat/mortality_catchment_2014-2018_by_race_cancer.txt",
  delim = ",",
  col_names = c(
    "Ethnicity",
    "cancer",
    "Race",
    "Age_Adjusted_Rate",
    "Count",
    "Population"
  ),
  col_types = cols(
    "Ethnicity" = col_factor(),
    "cancer" = col_factor(),
    "Race" = col_factor(),
    "Age_Adjusted_Rate" = col_number(),
    "Count" = col_number(),
    "Population" = col_number()
  ),
  na = c("", "^", "NA")
)

write_rds(mortality_az_catch_by_race, "data/tidy/seer_mortality_catch_cancer_by_race.rds")

mortality_az_catch_hispanic <- read_delim("data/raw/seer_stat/mortality_catchment_2014-2018_by_race_cancer_hispanic.txt",
  delim = ",",
  col_names = c(
    "cancer",
    "Ethnicity",
    "Age_Adjusted_Rate",
    "Count",
    "Population"
  ),
  col_types = cols(
    "cancer" = col_factor(),
    "Ethnicity" = col_factor(),
    "Age_Adjusted_Rate" = col_number(),
    "Count" = col_number(),
    "Population" = col_number()
  ),
  na = c("", "^", "NA")
)

write_rds(mortality_az_catch_hispanic, "data/tidy/seer_mortality_catch_cancer_hispanic.rds")
