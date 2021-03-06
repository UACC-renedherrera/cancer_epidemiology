# seer stat exports

# set up ----
# load packages
library(here)
library(tidyverse)
library(knitr)

#### MORTALITY USA ####
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
                                        "sex",
                                        "usa_age_adjusted_rate",
                                        "case_count",
                                        "population"
                                      ),
                                      col_types = cols(
                                        "cancer" = col_factor(),
                                        "sex" = col_factor(),
                                        "usa_age_adjusted_rate" = col_number(),
                                        "case_count" = col_number(),
                                        "population" = col_number()
                                      ),
                                      na = c("", "^", "NA")
)

mortality_usa_by_cancer <- mortality_usa_by_cancer %>%
  drop_na()

# write_csv(mortality_usa_by_cancer, "data/raw/seer_stat/mortality_usa_all_race_all_sex_2014-2018_by_cancer.csv")

mortality_usa_by_cancer <- read_csv("data/raw/seer_stat/mortality_usa_all_race_all_sex_2014-2018_by_cancer.csv",
                                    skip = 1,
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
                                    na = c("", "^", "NA")
)

mortality_usa_by_cancer <- mortality_usa_by_cancer %>%
  drop_na()

write_rds(mortality_usa_by_cancer, "data/tidy/seer_mortality_usa_by_cancer_2014-2018_all_race_all_sex.rds")

#### MORTALITY AZ ####
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native','Asian or Pacific Islander'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Origin recode 1990+ (Hispanic, Non-Hisp)} = 'Non-Spanish-Hispanic-Latino','Spanish-Hispanic-Latino'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2014-2018'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# {Site and Morphology.Cause of death recode} = '  All Malignant Cancers','    Oral Cavity and Pharynx','      Lip','      Tongue','      Salivary Gland','      Floor of Mouth','      Gum and Other Mouth','      Nasopharynx','      Tonsil','      Oropharynx','      Hypopharynx','      Other Oral Cavity and Pharynx','    Digestive System','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','        Colon excluding Rectum','        Rectum and Rectosigmoid Junction','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','        Liver','        Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Other Digestive Organs','    Respiratory System','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','    Bones and Joints','    Soft Tissue including Heart','    Skin','      Melanoma of the Skin','      Non-Melanoma Skin','    Breast','    Female Genital System','      Cervix Uteri','      Corpus and Uterus, NOS','        Corpus Uteri','        Uterus, NOS','      Ovary','      Vagina','      Vulva','      Other Female Genital Organs','    Male Genital System','      Prostate','      Testis','      Penis','      Other Male Genital Organs','    Urinary System','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','      Other Urinary Organs','    Eye and Orbit','    Brain and Other Nervous System','    Endocrine System','      Thyroid','      Other Endocrine including Thymus','    Lymphoma','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','    Myeloma','    Leukemia','      Lymphocytic Leukemia','        Acute Lymphocytic Leukemia','        Chronic Lymphocytic Leukemia','        Other Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia','        Acute Myeloid Leukemia','        Acute Monocytic Leukemia','        Chronic Myeloid Leukemia','        Other Myeloid/Monocytic Leukemia','      Other Leukemia','        Other Acute Leukemia','        Aleukemic, Subleukemic and NOS','    Miscellaneous Malignant Cancer'

# citation:
# Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).

mortality_az_by_cancer <- read_delim("data/raw/seer_stat/mortality_az_all_race_all_sex_2014-2018_by_cancer.txt",
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
                                     na = c("", "^", "NA")
)

mortality_az_by_cancer_for_UAZCC <- mortality_az_by_cancer %>%
  drop_na() 

# write_csv(mortality_az_by_cancer_for_UAZCC, "data/raw/seer_stat/seer_mortality_AZ_all_race_all_sex_2014-2018_by_cancer.csv")

mortality_az_by_cancer_for_UAZCC <- read_csv("data/raw/seer_stat/seer_mortality_AZ_all_race_all_sex_2014-2018_by_cancer.csv")

mortality_az_by_cancer_for_UAZCC <- mortality_az_by_cancer_for_UAZCC %>%
  drop_na() 

write_rds(mortality_az_by_cancer_for_UAZCC, "data/tidy/seer_mortality_AZ_all_race_all_sex_2014-2018_by_cancer.rds")

#### MORTALITY CATCHMENT ####
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
                                           na = c("", "^", "NA")
)

mortality_az_catch_by_cancer_for_UAZCC <- mortality_az_catch_by_cancer %>%
  drop_na() 

# write_csv(mortality_az_catch_by_cancer_for_UAZCC, "data/raw/seer_stat/mortality_catchment_all_race_all_sex_2014-2018_by_cancer.csv")

mortality_az_catch_by_cancer_for_UAZCC <- read_csv("data/raw/seer_stat/mortality_catchment_all_race_all_sex_2014-2018_by_cancer.csv")

mortality_az_catch_by_cancer_for_UAZCC <- mortality_az_catch_by_cancer_for_UAZCC %>%
  drop_na() 

write_rds(mortality_az_catch_by_cancer_for_UAZCC, "data/tidy/mortality_az_catch_by_cancer_for_UAZCC_2014-2018_all_race_all_sex.rds")

# mortality catchment race not hispanic ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Origin recode 1990+ (Hispanic, Non-Hisp)} = 'Non-Spanish-Hispanic-Latino'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2014-2018'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
#  {Site and Morphology.Cause of death recode} = '  All Malignant Cancers','    Oral Cavity and Pharynx','      Lip','      Tongue','      Salivary Gland','      Floor of Mouth','      Gum and Other Mouth','      Nasopharynx','      Tonsil','      Oropharynx','      Hypopharynx','      Other Oral Cavity and Pharynx','    Digestive System','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','        Colon excluding Rectum','        Rectum and Rectosigmoid Junction','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','        Liver','        Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Other Digestive Organs','    Respiratory System','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','    Bones and Joints','    Soft Tissue including Heart','    Skin','      Melanoma of the Skin','      Non-Melanoma Skin','    Breast','    Female Genital System','      Cervix Uteri','      Corpus and Uterus, NOS','        Corpus Uteri','        Uterus, NOS','      Ovary','      Vagina','      Vulva','      Other Female Genital Organs','    Male Genital System','      Prostate','      Testis','      Penis','      Other Male Genital Organs','    Urinary System','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','      Other Urinary Organs','    Eye and Orbit','    Brain and Other Nervous System','    Endocrine System','      Thyroid','      Other Endocrine including Thymus','    Lymphoma','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','    Myeloma','    Leukemia','      Lymphocytic Leukemia','        Acute Lymphocytic Leukemia','        Chronic Lymphocytic Leukemia','        Other Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia','        Acute Myeloid Leukemia','        Acute Monocytic Leukemia','        Chronic Myeloid Leukemia','        Other Myeloid/Monocytic Leukemia','      Other Leukemia','        Other Acute Leukemia','        Aleukemic, Subleukemic and NOS','    Miscellaneous Malignant Cancer'

# Citation: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).

mortality_az_catch_not_hisp <- read_delim("data/raw/seer_stat/mortality_catchment_2014-2018_by_race_not_hispanic.txt",
                                         delim = ",",
                                         col_names = c(
                                           "Cancer",
                                           "Sex",
                                           "Race",
                                           "Age_Adjusted_Rate",
                                           "Count",
                                           "Population"
                                         ),
                                         col_types = cols(
                                           "Race" = col_factor(),
                                           "Cancer" = col_character(),
                                           "Sex" = col_factor(),
                                           "Age_Adjusted_Rate" = col_number(),
                                           "Count" = col_number(),
                                           "Population" = col_number()
                                         ),
                                         na = c("", "^", "NA")
)

mortality_az_catch_not_hisp <- mortality_az_catch_not_hisp %>%
  drop_na()

# write_csv(mortality_az_catch_not_hisp, "data/raw/seer_stat/mortality_catchment_2014-2018_by_race_not_hisp.csv")

mortality_az_catch_not_hisp <- read_csv("data/raw/seer_stat/mortality_catchment_2014-2018_by_race_not_hisp.csv")

write_rds(mortality_az_catch_not_hisp, "data/tidy/seer_mortality_catch_cancer_by_race_not_hispanic.rds")

# mortality catchment race hispanic ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (W, B, AI, API)} = 'White','Black','American Indian/Alaska Native'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Origin recode 1990+ (Hispanic, Non-Hisp)} = 'Spanish-Hispanic-Latino'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2014-2018'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
#  {Site and Morphology.Cause of death recode} = '  All Malignant Cancers','    Oral Cavity and Pharynx','      Lip','      Tongue','      Salivary Gland','      Floor of Mouth','      Gum and Other Mouth','      Nasopharynx','      Tonsil','      Oropharynx','      Hypopharynx','      Other Oral Cavity and Pharynx','    Digestive System','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','        Colon excluding Rectum','        Rectum and Rectosigmoid Junction','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','        Liver','        Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Other Digestive Organs','    Respiratory System','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','    Bones and Joints','    Soft Tissue including Heart','    Skin','      Melanoma of the Skin','      Non-Melanoma Skin','    Breast','    Female Genital System','      Cervix Uteri','      Corpus and Uterus, NOS','        Corpus Uteri','        Uterus, NOS','      Ovary','      Vagina','      Vulva','      Other Female Genital Organs','    Male Genital System','      Prostate','      Testis','      Penis','      Other Male Genital Organs','    Urinary System','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','      Other Urinary Organs','    Eye and Orbit','    Brain and Other Nervous System','    Endocrine System','      Thyroid','      Other Endocrine including Thymus','    Lymphoma','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','    Myeloma','    Leukemia','      Lymphocytic Leukemia','        Acute Lymphocytic Leukemia','        Chronic Lymphocytic Leukemia','        Other Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia','        Acute Myeloid Leukemia','        Acute Monocytic Leukemia','        Chronic Myeloid Leukemia','        Other Myeloid/Monocytic Leukemia','      Other Leukemia','        Other Acute Leukemia','        Aleukemic, Subleukemic and NOS','    Miscellaneous Malignant Cancer'

# Citation: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).

mortality_az_catch_hisp <- read_delim("data/raw/seer_stat/mortality_catchment_2014-2018_by_race_hispanic.txt",
                                          delim = ",",
                                          col_names = c(
                                            "Cancer",
                                            "Sex",
                                            "Age_Adjusted_Rate",
                                            "Count",
                                            "Population"
                                          ),
                                          col_types = cols(
                                            "Cancer" = col_character(),
                                            "Sex" = col_factor(),
                                            "Age_Adjusted_Rate" = col_number(),
                                            "Count" = col_number(),
                                            "Population" = col_number()
                                          ),
                                          na = c("", "^", "NA")
)

mortality_az_catch_hisp <- mortality_az_catch_hisp %>%
  drop_na()

# write_csv(mortality_az_catch_hisp, "data/raw/seer_stat/mortality_catchment_2014-2018_by_race_hispanic.csv")

mortality_az_catch_hisp <- read_csv("data/raw/seer_stat/mortality_catchment_2014-2018_by_race_hispanic.csv")

mortality_az_catch_hisp <- mortality_az_catch_hisp %>%
  mutate(race = "Hispanic",
         area = "Catchment")

write_rds(mortality_az_catch_hisp, "data/tidy/seer_mortality_catch_cancer_by_race_hispanic.rds")

####
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




