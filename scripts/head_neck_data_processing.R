# Head and neck cancers
# oral cavity
# throat (pharynx): nasopharynx, oropharynx, hypopharanx
# voicebox (larynx)
# paranasal sinuses and nasal cavity 
# salivary glands 
# rene dario herrera 
# university of arizona cancer center
# 10 Sep 2021 
# renedherrera at email dot arizona dot edu 

# set up ####
# packages 
library(here)
library(tidyverse)
library(janitor)

# read data
# from AZ IBIS
# Query Definition	
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (03/23/2021)
# Time of Query	Fri, Sep 10, 2021 12:58 PM, MST
# Year Filter	2018, 2017, 2016, 2015, 2014
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Larynx
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex
catchment_inc_by_cancer <- read_csv("data/raw/AZDHS/query_catchment_head_neck_incidence_2014-2018_by_cancer.csv") %>%
  clean_names()

# for catchment ####
# most recent five year incidence rate #### 
# filter and save to csv data table
catchment_inc_by_cancer_all_race_both_sex <- catchment_inc_by_cancer %>%
  filter(cancer_sites != "All",
         sex == "All") %>%
  mutate(source = "AZDHS IBIS",
         area = "Catchment",
         year = "2014-2018",
         race = "All Races",
         event_type = "Incidence") %>%
  rename(site = cancer_sites,
         age_adjusted_rate = age_adjusted_cancer_incidence_rates_incidence_per_100_000_population_03_23_2021,
         count = number_of_cancer_incidents,
         population = number_in_the_population,
         age_adjusted_ci_lower = x95_percent_ci_ll,
         age_adjusted_ci_upper = x95_percent_ci_ul)

catchment_inc_by_cancer_all_race_both_sex %>%
  write_csv("data/tidy/tables/head_neck_catchment_incidence_2014-2018_all_race_both_sex.csv")

# most recent five year mortality rate ####
# seer
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years','Unknown'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (White, Black, Other)} = 'All races'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2015-2019'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# {Site and Morphology.Cause of death recode} = '    Oral Cavity and Pharynx','      Nose, Nasal Cavity and Middle Ear','      Larynx'
catchment_mort_by_cancer <- read_delim(
  file = "data/raw/seer_stat/mortality_catchment_head_neck_2015-2019_both_sex_all_race.txt",
  col_names = c("site", "age_adjusted_rate", "count", "population"),
  na = c("", "^") 
)

# filter and save to disk as csv data table
catchment_mort_by_cancer_all_race_both_sex <- catchment_mort_by_cancer %>%
  filter(site != "All Causes of Death",
         site != "All Malignant Cancers") %>%
  arrange(desc(age_adjusted_rate)) %>%
  drop_na() %>%
  mutate(source = "SEER",
         area = "Catchment",
         year = "2015-2019",
         event_type = "Mortality",
         sex = "Male and female",
         race = "All races")

catchment_mort_by_cancer_all_race_both_sex %>%
  write_csv("data/tidy/tables/head_neck_catchment_mortality_2015-2019_all_race_both_sex.csv")

# USCS incidence and mortality 
# for united states ####
uscs_usa_by_cancer <- read_rds("data/tidy/uscs_usa_by_cancer_1999-2018.rds") %>%
  clean_names()

# filter to cancer sites of interest 
# show me the entire list
uscs_usa_by_cancer %>%
  distinct(site) %>%
  as.list()

# look through list and look for head and neck
# list from: https://www.cancer.gov/types/head-and-neck/head-neck-fact-sheet 
head_and_neck <- c("Oral Cavity and Pharynx", 
                   "Hypopharynx",
                   "Nasopharynx",
                   "Oropharynx",
                   "Larynx",
                   "Other Oral Cavity and Pharynx",
                   "Nose, Nasal Cavity and Middle Ear",
                   "Salivary Gland")

# apply the filter
# and save
uscs_usa_head_and_neck <- uscs_usa_by_cancer %>%
  filter(site %in% head_and_neck) %>%
  mutate(source = "USCS",
         area = "United States")

# what years are available?
uscs_usa_head_and_neck %>%
  distinct(year) %>%
  as.list()

# what choices for sex are available?
uscs_usa_head_and_neck %>%
  distinct(sex) %>%
  as.list()

# most recent five year incidence rate of head and neck cancer in USA ####
# for all races
# plot
uscs_usa_head_and_neck %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Male and Female",
         event_type == "Incidence") %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year incidence rate",
    subtitle = "United States. 2014-2018. All races. Male and female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

# save to disk
usa_inc_all_race_both_sex <- uscs_usa_head_and_neck %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Male and Female",
         event_type == "Incidence") %>%
  arrange(desc(age_adjusted_rate))

usa_inc_all_race_both_sex %>%
  write_csv("data/tidy/tables/head_neck_usa_incidence_2014-2018_uscs.csv")

# most recent five year mortality rate of head and neck cancer in USA ####
# for all races
# plot
uscs_usa_head_and_neck %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Male and Female",
         event_type == "Mortality") %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year mortality rate",
    subtitle = "United States. 2014-2018. All races. Male and female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

# save to disk
usa_mort_all_race_both_sex <- uscs_usa_head_and_neck %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Male and Female",
         event_type == "Mortality") %>%
  arrange(desc(age_adjusted_rate)) 

usa_mort_all_race_both_sex %>%
  write_csv("data/tidy/tables/head_neck_usa_mortality_2014-2018_uscs.csv")

# for arizona ####
# read data 
uscs_az <- read_rds("data/tidy/USCS_by_state.rds") %>%
  clean_names()

# inspect
glimpse(uscs_az)

# filter to AZ, head and neck
uscs_az <- uscs_az %>%
  filter(area == "Arizona",
         site %in% head_and_neck) %>%
  mutate(source = "USCS")

# most recent five year incidence rate for arizona ####
uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Male and Female",
    event_type == "Incidence"
  ) %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year incidence rate",
    subtitle = "Arizona. 2014-2018. All races. Male and female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

# save table to csv
az_inc_all_race_both_sex <- uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Male and Female",
    event_type == "Incidence"
  ) %>%
  arrange(desc(age_adjusted_rate)) 

az_inc_all_race_both_sex %>%
  write_csv("data/tidy/tables/head_neck_az_incidence_2014-2018_uscs.csv")

# most recent five year mortality rate for arizona ####
uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Male and Female",
    event_type == "Mortality"
  ) %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year mortality rate",
    subtitle = "Arizona. 2014-2018. All races. Male and female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

# save table to csv
az_mort_all_race_both_sex <- uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Male and Female",
    event_type == "Mortality"
  ) %>%
  arrange(desc(age_adjusted_rate)) 

az_mort_all_race_both_sex %>%
  write_csv("data/tidy/tables/head_neck_az_mortality_2014-2018_uscs.csv")

# I want one table for both incidence and mortality with all geographies and years
head_neck_data <- catchment_inc_by_cancer_all_race_both_sex %>%
  full_join(catchment_mort_by_cancer_all_race_both_sex) %>%
  full_join(az_inc_all_race_both_sex) %>%
  full_join(az_mort_all_race_both_sex) %>%
  full_join(usa_inc_all_race_both_sex) %>%
  full_join(usa_mort_all_race_both_sex)

# save to disk as csv data table 
write_csv(head_neck_data,
          file = "data/tidy/tables/head_neck_incidence_mortality_data_table.csv")
