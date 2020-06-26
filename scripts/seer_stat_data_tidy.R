# seer stat exports

# set up ----
# load packages
library(here)
library(tidyverse)

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
                                col_names = c("cancer",
                                              "sex",
                                              "age_adjusted_rate",
                                              "case_count",
                                              "population"),
                                col_types = cols("cancer" = col_factor(),
                                                 "sex" = col_factor(),
                                                 "age_adjusted_rate" = col_number(),
                                                 "case_count" = col_number(),
                                                 "population" = col_number()),
                                na = c("", "^"))

catchment_mortality <- drop_na(catchment_mortality)

#save dataset
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
                                  col_names = c("cancer",
                                                "sex",
                                                "age_adjusted_rate",
                                                "standard_error",
                                                "lower_ci",
                                                "upper_ci",
                                                "case_count",
                                                "population"),
                                  col_types = cols("cancer" = col_factor(),
                                                   "sex" = col_factor(),
                                                   "age_adjusted_rate" = col_number(),
                                                   "standard_error" = col_number(),
                                                   "lower_ci" = col_number(),
                                                   "upper_ci" = col_number(),
                                                   "case_count" = col_number(),
                                                   "population" = col_number()),
                                  na = c("", "^"))

catchment_mortality_hispanic <- drop_na(catchment_mortality_hispanic)

#save dataset
write_rds(catchment_mortality_hispanic, "data/tidy/seer_stat_catchment_mortality_hispanic_2013-2017.rds")

# examine data set 
glimpse(catchment_mortality_hispanic)
str(catchment_mortality_hispanic$cancer)
unique(catchment_mortality_hispanic$cancer)

# pima county mortality ---- 
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
                                           col_names = c("cancer",
                                                         "sex",
                                                         "age_adjusted_rate",
                                                         "standard_error",
                                                         "lower_ci",
                                                         "upper_ci",
                                                         "case_count",
                                                         "population"),
                                           col_types = cols("cancer" = col_factor(),
                                                            "sex" = col_factor(),
                                                            "age_adjusted_rate" = col_number(),
                                                            "standard_error" = col_number(),
                                                            "lower_ci" = col_number(),
                                                            "upper_ci" = col_number(),
                                                            "case_count" = col_number(),
                                                            "population" = col_number()),
                                           na = c("", "^", "NA"))

pima_mortality_by_cancer <- drop_na(pima_mortality_by_cancer)

#save dataset
write_rds(pima_mortality_by_cancer, "data/tidy/seer_stat_pima_mortality_2013-2017.rds")
