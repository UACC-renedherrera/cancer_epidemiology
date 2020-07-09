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
