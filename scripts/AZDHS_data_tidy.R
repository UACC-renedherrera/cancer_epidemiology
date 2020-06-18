# import and tidy data from
# Arizona Cancer Registry Query Module

# set up ----
library(here)
library(tidyverse)
library(knitr)
library(dataMaid)

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
  )

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
