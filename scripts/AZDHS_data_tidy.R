# import and tidy data from
# Arizona Cancer Registry Query Module

# set up ----
# packages
library(here)
library(tidyverse)

########### Incidence data for 2013-2017 ######################################
# by cancer

########### Incidence for AZ ##################################################
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 4:34 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Apache, Cochise, Coconino, Gila, Graham, Greenlee, La Paz, Maricopa, Mohave, Navajo, Pima, Pinal, Santa Cruz, Yavapai, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_az <- read_csv("data/raw/AZDHS/query_incidence_az_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "SITE",
    "SEX",
    "COUNT",
    "POPULATION",
    "AGE_ADJUSTED_RATE",
    "AGE_ADJUSTED_CI_LOWER",
    "AGE_ADJUSTED_CI_UPPER"
  ),
  col_types = cols(
    "SITE" = col_factor(),
    "SEX" = col_factor(),
    "COUNT" = col_number(),
    "POPULATION" = col_number(),
    "AGE_ADJUSTED_RATE" = col_number(),
    "AGE_ADJUSTED_CI_LOWER" = col_number(),
    "AGE_ADJUSTED_CI_UPPER" = col_number()
  )
)

incidence_az

# add variables to identify dataset
incidence_az <- incidence_az %>%
  mutate(
    YEAR = "2013-2017",
    RACE = "All Races",
    source = "AZDHS IBIS Query System",
    area = "AZ"
  )

write_rds(incidence_az, "data/tidy/incidence_az_azdhs_2013-2017_by_cancer.rds")

############ Incidence for UAZCC Catchment ####################################
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Tue, Jun 9, 2020 8:57 AM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

# read data
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
incidence_catch <- read_csv("data/raw/AZDHS/query_catchment_incidence_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "SITE",
    "SEX",
    "COUNT",
    "POPULATION",
    "AGE_ADJUSTED_RATE",
    "AGE_ADJUSTED_CI_LOWER",
    "AGE_ADJUSTED_CI_UPPER"
  ),
  col_types = cols(
    "SITE" = col_character(),
    "SEX" = col_factor(),
    "SEX" = col_number(),
    "POPULATION" = col_number(),
    "AGE_ADJUSTED_RATE" = col_number(),
    "AGE_ADJUSTED_CI_LOWER" = col_number(),
    "AGE_ADJUSTED_CI_UPPER" = col_number()
  ),
)

incidence_catch

# add variables to identify dataset
incidence_catch <- incidence_catch %>%
  mutate(
    YEAR = "2013-2017",
    RACE = "All Races",
    source = "AZDHS IBIS Query System",
    area = "Catchment"
  )

incidence_catch

# save dataset to file
write_rds(azdhs_catch_incidence_2017, "data/tidy/incidence_az_catchment_azdhs_2013-2017_by_cancer.rds")

############ Incidence for UAZCC Catchment White Non Hispanic #################
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 3:25 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_white <- read_csv("data/raw/AZDHS/query_incidence_catch_white_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "SITE",
    "SEX",
    "COUNT",
    "POPULATION",
    "AGE_ADJUSTED_RATE",
    "AGE_ADJUSTED_CI_LOWER",
    "AGE_ADJUSTED_CI_UPPER"
  ),
  col_types = cols(
    "SITE" = col_factor(),
    "SEX" = col_factor(),
    "COUNT" = col_number(),
    "POPULATION" = col_number(),
    "AGE_ADJUSTED_RATE" = col_number(),
    "AGE_ADJUSTED_CI_LOWER" = col_number(),
    "AGE_ADJUSTED_CI_UPPER" = col_number()
  ),
)

incidence_catch_white

# add variables to identify dataset
incidence_catch_white <- incidence_catch_white %>%
  mutate(
    YEAR = "2013-2017",
    RACE = "White Non-Hispanic",
    source = "AZDHS IBIS Query System",
    area = "Catchment"
  )

incidence_catch_white

write_rds(incidence_catch_white, "data/tidy/incidence_az_catchment_azdhs_2013-2017_white_by_cancer.rds")

############ Incidence for UAZCC Catchment White Hispanic #####################
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 3:28 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Hispanic
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_hispanic <- read_csv("data/raw/AZDHS/query_catchment_incidence_2013_2017_hisp.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "SITE",
    "SEX",
    "COUNT",
    "POPULATION",
    "AGE_ADJUSTED_RATE",
    "AGE_ADJUSTED_CI_LOWER",
    "AGE_ADJUSTED_CI_UPPER"
  ),
  col_types = cols(
    "SITE" = col_factor(),
    "SEX" = col_factor(),
    "COUNT" = col_number(),
    "POPULATION" = col_number(),
    "AGE_ADJUSTED_RATE" = col_number(),
    "AGE_ADJUSTED_CI_LOWER" = col_number(),
    "AGE_ADJUSTED_CI_UPPER" = col_number()
  ),
)

# add variables to identify dataset
incidence_catch_hispanic <- incidence_catch_hispanic %>%
  mutate(
    YEAR = "2013-2017",
    RACE = "White Hispanic",
    source = "AZDHS IBIS Query System",
    area = "Catchment"
  )

incidence_catch_hispanic

write_rds(incidence_catch_hispanic, "data/tidy/incidence_az_catchment_azdhs_2013-2017_hispanic_by_cancer.rds")

############ Incidence for UAZCC Catchment American Indian ####################
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 3:30 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	American Indian
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_ai <- read_csv("data/raw/AZDHS/query_incidence_catch_amer_ind_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "SITE",
    "SEX",
    "COUNT",
    "POPULATION",
    "AGE_ADJUSTED_RATE",
    "AGE_ADJUSTED_CI_LOWER",
    "AGE_ADJUSTED_CI_UPPER"
  ),
  col_types = cols(
    "SITE" = col_factor(),
    "SEX" = col_factor(),
    "COUNT" = col_number(),
    "POPULATION" = col_number(),
    "AGE_ADJUSTED_RATE" = col_number(),
    "AGE_ADJUSTED_CI_LOWER" = col_number(),
    "AGE_ADJUSTED_CI_UPPER" = col_number()
  ),
)

# add variables to identify dataset
incidence_catch_ai <- incidence_catch_ai %>%
  mutate(
    YEAR = "2013-2017",
    RACE = "American Indian",
    source = "AZDHS IBIS Query System",
    area = "Catchment"
  )

incidence_catch_ai

write_rds(incidence_catch_ai, "data/tidy/incidence_az_catchment_azdhs_2013-2017_ai_by_cancer.rds")

############ Incidence for UAZCC Catchment Black ##############################
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 3:33 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	Black
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_black <- read_csv("data/raw/AZDHS/query_incidence_catch_black_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "SITE",
    "SEX",
    "COUNT",
    "POPULATION",
    "AGE_ADJUSTED_RATE",
    "AGE_ADJUSTED_CI_LOWER",
    "AGE_ADJUSTED_CI_UPPER"
  ),
  col_types = cols(
    "SITE" = col_factor(),
    "SEX" = col_factor(),
    "COUNT" = col_number(),
    "POPULATION" = col_number(),
    "AGE_ADJUSTED_RATE" = col_number(),
    "AGE_ADJUSTED_CI_LOWER" = col_number(),
    "AGE_ADJUSTED_CI_UPPER" = col_number()
  ),
)

# add variables to identify dataset
incidence_catch_black <- incidence_catch_black %>%
  mutate(
    YEAR = "2013-2017",
    RACE = "Black",
    source = "AZDHS IBIS Query System",
    area = "Catchment"
  )

write_rds(incidence_catch_black, "data/tidy/incidence_az_catchment_azdhs_2013-2017_black_by_cancer.rds")

############ combine AZ, UAZCC, White, Hispanic, AI, Black ####################

incidence_table <- bind_rows(
  incidence_az,
  incidence_catch,
  incidence_catch_white,
  incidence_catch_hispanic,
  incidence_catch_ai,
  incidence_catch_black
)

#### write RDS for shiny app #### 
write_rds(incidence_table, "communication/shiny_apps/dashboard_incidence_tables/data/incidence_az_catch_2013-2017_table.rds")

############ output incidence table ###########################################

str(incidence_table)
glimpse(incidence_table)

azdhs_list_of <- distinct(incidence_table, SITE)

incidence_table <- incidence_table %>%
  filter(
    SEX == "All",
    SITE != "Breast Invasive",
    SITE != "Other Invasive"
  ) %>%
  drop_na(AGE_ADJUSTED_RATE)


###############################################################################
# write dataset to RDS ----

write_rds(incidence_table, "data/tidy/incidence_az_catchment_azdhs_2013-2017_by_cancer_race.rds")


# library(dataMaid)

# what are the top 5 incident cancers?

# scope of query

# top 5 incidence catchment ----
# year: 2012-2016
# cancer site: all
# race: all
# county: Cochise, Pima, Pinal, Santa Cruz, Yuma
# sort by cancer
# group by sex

# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Tue, Jun 9, 2020 8:52 AM, MST
# Year Filter	2016, 2015, 2014, 2013, 2012
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex


# read data
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
azdhs_catch_incidence_2016 <- read_csv("data/raw/AZDHS/query_catchment_incidence_2012-2016.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    Cancer = col_character(),
    Sex = col_factor(),
    Case_Count = col_number(),
    Population = col_number(),
    Age_Adj_Rate = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

# examine dataset
glimpse(azdhs_catch_incidence_2016)

# add variables to define dataset
azdhs_catch_incidence_2016 <- azdhs_catch_incidence_2016 %>%
  mutate(
    Year = "2012-2016",
    Race = "All Races"
  ) %>%
  drop_na()

# save dataset to file
write_rds(azdhs_catch_incidence_2016, "data/tidy/azdhs_catchment_2012-2016_incidence_by_cancer.rds")

# use datamaid package to generate codebook
makeCodebook(azdhs_catch_incidence_2016, file = "data/tidy/codebook_azdhs_catch_incidence_2016.Rmd")

# top 5 incidence catchment hispanic ----
# year: 2012-2016
# cancer site: all
# race: White, Hispanic
# county: Cochise, Pima, Pinal, Santa Cruz, Yuma
# grouped by cancer, sex

# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Tue, Jun 9, 2020 8:54 AM, MST
# Year Filter	2016, 2015, 2014, 2013, 2012
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Hispanic
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex


# read data
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
azdhs_catch_incidence_2016_hisp <- read_csv("data/raw/AZDHS/query_catchment_incidence_2012_2016_hisp.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    Cancer = col_character(),
    Sex = col_factor(),
    Case_Count = col_number(),
    Population = col_number(),
    Age_Adj_Rate = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

# add variables to identify dateset
azdhs_catch_incidence_2016_hisp <- azdhs_catch_incidence_2016_hisp %>%
  mutate(
    Year = "2012-2016",
    Race = "White, Hispanic"
  )

# save dataset to file
write_rds(azdhs_catch_incidence_2016_hisp, "data/tidy/azdhs_catchment_2012-2016_hispanic_incidence_by_cancer.rds")

# use datamaid package to generate codebook
makeCodebook(azdhs_catch_incidence_2016_hisp, file = "data/tidy/codebook_azdhs_catch_incidence_2016_hisp.Rmd")

# top 5 incidence catchment ----
# year: 2013-2017
# cancer site: all
# race: all
# county: Cochise, Pima, Pinal, Santa Cruz, Yuma
# sort by cancer
# group by sex

# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Tue, Jun 9, 2020 8:57 AM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

# read data
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
azdhs_catch_incidence_2017 <- read_csv("data/raw/AZDHS/query_catchment_incidence_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    Cancer = col_character(),
    Sex = col_factor(),
    Case_Count = col_number(),
    Population = col_number(),
    Age_Adj_Rate = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

# add variables to identify dataset
azdhs_catch_incidence_2017 <- azdhs_catch_incidence_2017 %>%
  mutate(
    Year = "2013-2017",
    Race = "All Races"
  )

# change sex from "All" to "Male and female"
azdhs_catch_incidence_2017$Sex <- recode_factor(azdhs_catch_incidence_2017$Sex, "All" = "Male and female")

# save dataset to file
write_rds(azdhs_catch_incidence_2017, "data/tidy/azdhs_catchment_2013-2017_incidence_by_cancer.rds")

# use datamaid package to generate codebook
makeCodebook(azdhs_catch_incidence_2017, file = "data/tidy/codebook_azdhs_catch_incidence_2017.Rmd")

# top 5 incidence catchment hispanic ----
# year: 2013-2017
# cancer site: all
# race: White, Hispanic
# county: Cochise, Pima, Pinal, Santa Cruz, Yuma
# grouped by cancer, sex

# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Tue, Jun 9, 2020 8:55 AM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Hispanic
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

# read data
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
azdhs_catch_incidence_2017_hisp <- read_csv("data/raw/AZDHS/query_catchment_incidence_2013_2017_hisp.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    Cancer = col_character(),
    Sex = col_factor(),
    Case_Count = col_number(),
    Population = col_number(),
    Age_Adj_Rate = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

# add variables to identify dataset
azdhs_catch_incidence_2017_hisp <- azdhs_catch_incidence_2017_hisp %>%
  mutate(
    Year = "2013-2017",
    Race = "White, Hispanic"
  )

# change sex from "All" to "Male and female"
azdhs_catch_incidence_2017_hisp$Sex <- recode_factor(azdhs_catch_incidence_2017$Sex, "All" = "Male and female")

# save dataset to file
write_rds(azdhs_catch_incidence_2017_hisp, "data/tidy/azdhs_catchment_2013-2017_hispanic_incidence_by_cancer.rds")

# use datamaid package to generate codebook
makeCodebook(azdhs_catch_incidence_2017_hisp, file = "data/tidy/codebook_azdhs_catch_incidence_2017_hisp.Rmd")

# pima county incidence by cancer ----
# by cancer
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Fri, Jun 26, 2020 9:41 AM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Pima
# Data Grouped By	Cancer Sites, Sex

# read data
pima_incidence_by_cancer <- read_csv("data/raw/AZDHS/query_pima_incidence_2013-2017_by_cancer.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    Cancer = col_factor(),
    Sex = col_factor(),
    Case_Count = col_number(),
    Population = col_number(),
    Age_Adj_Rate = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

# add variables to define dataset
pima_incidence_by_cancer <- pima_incidence_by_cancer %>%
  mutate(
    Year = "2013-2017",
    Race = "All Races"
  )

pima_incidence_by_cancer$Sex <- fct_recode(pima_incidence_by_cancer$Sex, "Male and Female" = "All")

# save dataset to file
write_rds(pima_incidence_by_cancer, "data/tidy/azdhs_pima_2013-2017_incidence_by_cancer.rds")

# use datamaid package to generate codebook
makeCodebook(pima_incidence_by_cancer, file = "data/tidy/codebook_azdhs_pima_incidence_2013-2017_by_cancer.Rmd")

# pima county incidence by race ----
# by race; all
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Fri, Jun 26, 2020 12:37 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Pima
# Data Grouped By	Race, Sex

# read data
pima_incidence_by_race <- read_csv("data/raw/AZDHS/query_pima_incidence_2013-2017_by_race.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Race",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    Race = col_factor(),
    Sex = col_factor(),
    Case_Count = col_number(),
    Population = col_number(),
    Age_Adj_Rate = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

# add variables to define dataset
pima_incidence_by_race <- pima_incidence_by_race %>%
  mutate(
    Year = "2013-2017",
    Cancer = "All Cancers Combined"
  )

pima_incidence_by_race$Sex <- fct_recode(pima_incidence_by_race$Sex, "Male and Female" = "All")

# save dataset to file
write_rds(pima_incidence_by_race, "data/tidy/azdhs_pima_2013-2017_incidence_by_race.rds")

# use datamaid package to generate codebook
makeCodebook(pima_incidence_by_race, file = "data/tidy/codebook_azdhs_pima_incidence_2013-2017_by_cancer.Rmd")

# pima county by sex ----
# see above
pima_incidence_by_cancer

# pima county by age ----
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Count of Incident Cancer
# Module	Arizona Cancer Registry Query Module
# Measure	Count of Incident Cancer (04/28/2020)
# Time of Query	Wed, Jul 8, 2020 7:19 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Age Group Filter	0-4 years, 5-9 years, 10-14 years, 15-19 years, 20-24 years, 25-29 years, 30-34 years, 35-39 years, 40-44 years, 45-49 years, 50-54 years, 55-59 years, 60-64 years, 65-69 years, 70-74 years, 75-79 years, 80-84 years, 85+ years
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Pima
# Data Grouped By	Age Group, Sex

# read data
pima_incidence_by_age <- read_csv("data/raw/AZDHS/query_pima_incidence_2013-2017_by_age.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Age_Group",
    "Sex",
    "Case_Count"
  ),
  col_types = cols(
    "Age_Group" = col_factor(ordered = TRUE),
    "Sex" = col_factor(ordered = TRUE),
    "Case_Count" = col_number()
  ),
)

# add variables to define dataset
pima_incidence_by_age <- pima_incidence_by_age %>%
  mutate(
    Year = "2013-2017",
    Cancer = "All Cancers Combined"
  )

pima_incidence_by_age$Sex <- fct_recode(pima_incidence_by_age$Sex, "Male and Female" = "All")

# save dataset to file
write_rds(pima_incidence_by_age, "data/tidy/azdhs_pima_2013-2017_incidence_by_age.rds")


# pima county incidence rates over time ----
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Thu, Jul 9, 2020 9:38 AM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013, 2012, 2011, 2010, 2009, 2008, 2007, 2006, 2005, 2004, 2003, 2002, 2001, 2000, 1999, 1998, 1997, 1996, 1995
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Breast In Situ, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander
# County Filter	County, Pima
# Data Grouped By	Year, Sex

# read data
pima_incidence_by_year <- read_csv("data/raw/AZDHS/query_pima_incidence_1995-2017_by_year.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Year",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Year" = col_factor(ordered = TRUE),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

# add variables to define dataset
pima_incidence_by_year <- pima_incidence_by_year %>%
  filter(Year != "All") %>%
  mutate(
    Cancer = "All Cancers Combined",
    Race = "All Races Combined"
  )

pima_incidence_by_year$Sex <- fct_recode(pima_incidence_by_year$Sex, "Male and Female" = "All")

# save dataset to file
write_rds(pima_incidence_by_year, "data/tidy/azdhs_pima_1995-2017_incidence_by_year.rds")

# Incidence AZ 2016 ----
# Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Wed, Jul 29, 2020 2:56 PM, MST
# 2016, 2015, 2014, 2013, 2012
# Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma
# White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County, Apache, Cochise, Coconino, Gila, Graham, Greenlee, La Paz, Maricopa, Mohave, Navajo, Pima, Pinal, Santa Cruz, Yavapai, Yuma
# Cancer Sites, Sex

incidence_az <- read_csv("data/raw/AZDHS/query_incidence_az_2012-2016.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "AZ_Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Cancer" = col_factor(),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "AZ_Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  )
)

incidence_az <- incidence_az %>%
  drop_na() %>%
  filter(Sex == "All") %>%
  arrange(desc(AZ_Age_Adj_Rate)) %>%
  select(Cancer, AZ_Age_Adj_Rate)

# Incidence AZ 2017 ----
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 4:34 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Apache, Cochise, Coconino, Gila, Graham, Greenlee, La Paz, Maricopa, Mohave, Navajo, Pima, Pinal, Santa Cruz, Yavapai, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_az <- read_csv("data/raw/AZDHS/query_incidence_az_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "AZ_Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Cancer" = col_factor(),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "AZ_Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  )
)

write_rds(incidence_az, "data/tidy/incidence_az_azdhs_2013-2017_by_cancer.rds")

incidence_az <- incidence_az %>%
  filter(
    Sex == "All",
    Cancer != "Breast Invasive",
    Cancer != "Other Invasive"
  ) %>%
  arrange(desc(AZ_Age_Adj_Rate)) %>%
  mutate(
    area = "AZ",
    race = "All"
  ) %>%
  select(area,
    race,
    cancer = Cancer,
    rate = AZ_Age_Adj_Rate
  )

# incidence catchment ----
incidence_catch <- azdhs_catch_incidence_2016 %>%
  filter(Sex == "All") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  drop_na() %>%
  select(Cancer, catch_Age_Adj_Rate = Age_Adj_Rate)

# incidence rates for catchment by cancer 2017 ----
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 11:22 AM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

# read data
# downloaded data as excel from query module
# copied table to new spreadsheet
# saved as csv
azdhs_catch_incidence_2017 <- read_csv("data/raw/AZDHS/query_catchment_incidence_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    Cancer = col_character(),
    Sex = col_factor(),
    Case_Count = col_number(),
    Population = col_number(),
    Age_Adj_Rate = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

write_rds(azdhs_catch_incidence_2017, "data/tidy/azdhs_catchment_2013-2017_incidence_by_cancer.rds")

incidence_catchment <- azdhs_catch_incidence_2017 %>%
  filter(
    Sex == "All",
    Cancer != "Breast Invasive",
    Cancer != "Other Invasive"
  ) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  mutate(
    race = "All",
    area = "Catchment"
  ) %>%
  select(area,
    race,
    cancer = Cancer,
    rate = Age_Adj_Rate
  )

# Incidence catchment non-hispanic white 2016 ----
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Wed, Jul 29, 2020 10:23 AM, MST
# Year Filter	2016, 2015, 2014, 2013, 2012
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma
# Race Filter	White, Non Hispanic
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_white <- read_csv("data/raw/AZDHS/query_incidence_catch_white_2012-2016.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "catch_white_Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Cancer" = col_factor(),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "catch_white_Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

incidence_catch_white <- incidence_catch_white %>%
  filter(Sex == "All") %>%
  arrange(desc(catch_white_Age_Adj_Rate)) %>%
  drop_na() %>%
  select(Cancer, catch_white_Age_Adj_Rate)

# Incidence catchment non-hispanic white 2017 ----


incidence_catch_white <- incidence_catch_white %>%
  filter(
    Sex == "All",
    Cancer != "Breast Invasive",
    Cancer != "Other Invasive"
  ) %>%
  mutate(
    race = "Non-Hispanic White",
    sex = "All",
    area = "Catchment"
  ) %>%
  select(area,
    race,
    cancer = Cancer,
    rate = catch_white_Age_Adj_Rate
  )

# Incidence catchment hispanic 2016 ----
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Wed, Jul 29, 2020 10:42 AM, MST
# Year Filter	2016, 2015, 2014, 2013, 2012
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma
# Race Filter	White, Hispanic
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_hispanic <- read_csv("data/raw/AZDHS/query_catchment_incidence_2012_2016_hisp.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "catch_hisp_Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Cancer" = col_factor(),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "catch_hisp_Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

incidence_catch_hispanic <- incidence_catch_hispanic %>%
  filter(Sex == "All") %>%
  arrange(desc(catch_hisp_Age_Adj_Rate)) %>%
  drop_na() %>%
  select(Cancer, catch_hisp_Age_Adj_Rate)

# Incidence catchment hispanic 2017 ----


# Incidence catchment American Indian 2016 ----
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Wed, Jul 29, 2020 10:50 AM, MST
# Year Filter	2016, 2015, 2014, 2013, 2012
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma
# Race Filter	American Indian
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_ai <- read_csv("data/raw/AZDHS/query_incidence_catch_amer_ind_2012-2016.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "catch_ai_Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Cancer" = col_factor(),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "catch_ai_Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

incidence_catch_ai <- incidence_catch_ai %>%
  filter(Sex == "All") %>%
  arrange(desc(catch_ai_Age_Adj_Rate)) %>%
  drop_na() %>%
  select(Cancer, catch_ai_Age_Adj_Rate)

# Incidence catchment American Indian 2017 ----


# Incidence catchment Black 2016 ----
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Wed, Jul 29, 2020 11:03 AM, MST
# Year Filter	2016, 2015, 2014, 2013, 2012
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma
# Race Filter	Black
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_black <- read_csv("data/raw/AZDHS/query_incidence_catch_black_2012-2016.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "catch_black_Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Cancer" = col_factor(),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "catch_black_Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

incidence_catch_black <- incidence_catch_black %>%
  filter(Sex == "All") %>%
  arrange(desc(catch_black_Age_Adj_Rate)) %>%
  drop_na() %>%
  select(Cancer, catch_black_Age_Adj_Rate)

# Incidence catchment Black 2017 ----
# Query Definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (04/28/2020)
# Time of Query	Mon, Aug 17, 2020 3:33 PM, MST
# Year Filter	2017, 2016, 2015, 2014, 2013
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	Black
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

incidence_catch_black <- read_csv("data/raw/AZDHS/query_incidence_catch_black_2013-2017.csv",
  na = c("", "NA", "**", "*"),
  skip = 1,
  col_names = c(
    "Cancer",
    "Sex",
    "Case_Count",
    "Population",
    "catch_black_Age_Adj_Rate",
    "95CI_min",
    "95CI_max"
  ),
  col_types = cols(
    "Cancer" = col_factor(),
    "Sex" = col_factor(),
    "Case_Count" = col_number(),
    "Population" = col_number(),
    "catch_black_Age_Adj_Rate" = col_number(),
    "95CI_min" = col_number(),
    "95CI_max" = col_number()
  ),
)

incidence_catch_black <- incidence_catch_black %>%
  filter(
    Sex == "All",
    Cancer != "Breast Invasive",
    Cancer != "Other Invasive"
  ) %>%
  mutate(
    race = "Black",
    sex = "All",
    area = "Catchment"
  ) %>%
  select(area,
    race,
    cancer = Cancer,
    rate = catch_black_Age_Adj_Rate
  )

# combine az, catch, white, hisp, ai, black ----
incidence_table <- bind_rows(
  incidence_az,
  incidence_catchment,
  incidence_catch_white,
  incidence_catch_hispanic,
  incidence_catch_ai,
  incidence_catch_black
)

write_rds(incidence_table, "data/tidy/incidence_az_catchment_azdhs_2013-2017_by_cancer.rds")

catchment_incidence <- incidence_table %>%
  filter(area == "Catchment") %>%
  spread(key = race, value = rate) %>%
  arrange(desc(All))

write_rds(catchment_incidence, "data/tidy/incidence_azdhs_2013-2017_by_cancer_all_sex_all_race.rds")

# combine AZ and catch ----
incidence_az_catch <- full_join(incidence_az, incidence_catch) %>%
  arrange(desc(catch_Age_Adj_Rate, AZ_Age_Adj_Rate))

# combine race to one
# first white and hisp
incidence_catch_white_hisp <- full_join(incidence_catch_white, incidence_catch_hispanic)

# then white, hisp, and American Indian
incidence_catch_white_hisp_AI <- full_join(incidence_catch_white_hisp, incidence_catch_ai)

# then white, hisp, American Indian, and Black
incidence_catch_white_hisp_AI_black <- full_join(incidence_catch_white_hisp_AI, incidence_catch_black)

# combine az, catch, and race
incidence_az_catch_race <- full_join(azdhs_catch_incidence_2017, incidence_catch_white_hisp_AI_black) %>%
  filter(Cancer != "Other Invasive")

write_rds(incidence_az_catch_race, "data/tidy/incidence_azdhs_az_catch_race_2013-2017.rds")
