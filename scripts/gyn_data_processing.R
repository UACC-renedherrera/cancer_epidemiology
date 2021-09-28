# gynecologic cancers
# cervical
# ovarian
# uterine
# vaginal and vulvar
# rene dario herrera 
# university of arizona cancer center
# 20 Sep 2021 
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
# Time of Query	Tue, Sep 21, 2021 9:29 AM, MST
# Year Filter	2018, 2017, 2016, 2015, 2014
# Cancer Sites Filter	Cancer Sites, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex
catchment_inc_by_cancer <- read_csv("data/raw/AZDHS/query_catchment_gyn_incidence_2014-2018_by_cancer.csv") %>%
  clean_names()

# for catchment ####
# most recent five year incidence rate #### 
# filter and save to csv data table
catchment_inc_by_cancer_all_race_female <- catchment_inc_by_cancer %>%
  filter(cancer_sites != "All",
         sex == "Female") %>%
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

catchment_inc_by_cancer_all_race_female %>%
  write_csv("data/tidy/tables/gyn_catchment_incidence_2014-2018_all_race_female.csv")

# most recent five year mortality rate ####
# seer
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years','Unknown'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (White, Black, Other)} = 'All races'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = '  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2015-2019'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# {Site and Morphology.Cause of death recode} = '    Female Genital System','      Cervix Uteri','      Corpus and Uterus, NOS','        Corpus Uteri','        Uterus, NOS','      Ovary','      Vagina','      Vulva','      Other Female Genital Organs'
catchment_mort_by_cancer <- read_delim(
  file = "data/raw/seer_stat/mortality_catchment_gyn_2015-2019_female_all_race.txt",
  col_names = c("site", "age_adjusted_rate", "count", "population"),
  na = c("", "^") 
)

# filter and save to disk as csv data table
catchment_mort_by_cancer_all_race_female <- catchment_mort_by_cancer %>%
  filter(site != "All Causes of Death",
         site != "All Malignant Cancers") %>%
  arrange(desc(age_adjusted_rate)) %>%
  drop_na() %>%
  mutate(source = "SEER",
         area = "Catchment",
         year = "2015-2019",
         event_type = "Mortality",
         sex = "Female",
         race = "All races")

catchment_mort_by_cancer_all_race_female %>%
  write_csv("data/tidy/tables/gyn_catchment_mortality_2015-2019_all_race_female.csv")

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
gyn_list <- c("Cervix", 
                   "Corpus and Uterus, NOS",
                   "Female Genital System",
                   "Other Female Genital Organs",
                   "Uterus, NOS",
                   "Vulva",
                   "Corpus",
                   "Ovary",
                   "Vagina")

# apply the filter
# and save
uscs_usa_gyn <- uscs_usa_by_cancer %>%
  filter(site %in% gyn_list) %>%
  mutate(source = "USCS",
         area = "United States")

# what years are available?
uscs_usa_gyn %>%
  distinct(year) %>%
  as.list()

# what choices for sex are available?
uscs_usa_gyn %>%
  distinct(sex) %>%
  as.list()

# most recent five year incidence rate of head and neck cancer in USA ####
# for all races
# plot
uscs_usa_gyn %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Female",
         event_type == "Incidence") %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year incidence rate",
    subtitle = "United States. 2014-2018. All races. Female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

ggsave(filename = "figures/charts/incidence_gyn_usa_2014-2018_all_races_female.png")

# save to disk
usa_inc_all_race_female <- uscs_usa_gyn %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Female",
         event_type == "Incidence") %>%
  arrange(desc(age_adjusted_rate))

usa_inc_all_race_female %>%
  write_csv("data/tidy/tables/gyn_usa_incidence_2014-2018_uscs.csv")

# most recent five year mortality rate of head and neck cancer in USA ####
# for all races
# plot
uscs_usa_gyn %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Female",
         event_type == "Mortality") %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year mortality rate",
    subtitle = "United States. 2014-2018. All races. Female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

ggsave(filename = "figures/charts/mortality_gyn_usa_2014-2018_all_races_female.png")

# save to disk
usa_mort_all_race_female <- uscs_usa_gyn %>%
  filter(year == "2014-2018",
         race == "All Races",
         sex == "Female",
         event_type == "Mortality") %>%
  arrange(desc(age_adjusted_rate)) 

usa_mort_all_race_female %>%
  write_csv("data/tidy/tables/gyn_usa_mortality_2014-2018_uscs.csv")

# for arizona ####
# read data 
uscs_az <- read_rds("data/tidy/USCS_by_state.rds") %>%
  clean_names()

# inspect
glimpse(uscs_az)

# filter to AZ, head and neck
uscs_az <- uscs_az %>%
  filter(area == "Arizona",
         site %in% gyn_list) %>%
  mutate(source = "USCS")

# most recent five year incidence rate for arizona ####
uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Female",
    event_type == "Incidence"
  ) %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year incidence rate",
    subtitle = "Arizona. 2014-2018. All races. Female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

ggsave(filename = "figures/charts/incidence_gyn_az_2014-2018_all_races_female.png")

# save table to csv
az_inc_all_race_female <- uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Female",
    event_type == "Incidence"
  ) %>%
  arrange(desc(age_adjusted_rate)) 

az_inc_all_race_female %>%
  write_csv("data/tidy/tables/gyn_az_incidence_2014-2018_uscs.csv")

# most recent five year mortality rate for arizona ####
uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Female",
    event_type == "Mortality"
  ) %>%
  ggplot() +
  geom_col(mapping = aes(x = reorder(site, age_adjusted_rate), y = age_adjusted_rate)) +
  coord_flip() +
  labs(
    title = "Most recent five year mortality rate",
    subtitle = "Arizona. 2014-2018. All races. Female.",
    caption = "Source: US Cancer Statistics",
    x = "Cancer Site",
    y = "Age adjusted rate per 100,000"
  )

ggsave(filename = "figures/charts/mortality_gyn_az_2014-2018_all_races_female.png")

# save table to csv
az_mort_all_race_female <- uscs_az %>%
  filter(
    year == "2014-2018",
    race == "All Races",
    sex == "Female",
    event_type == "Mortality"
  ) %>%
  arrange(desc(age_adjusted_rate)) 

az_mort_all_race_female %>%
  write_csv("data/tidy/tables/gyn_az_mortality_2014-2018_uscs.csv")

# I want one table for both incidence and mortality with all geographies and years
gyn_data <- catchment_inc_by_cancer_all_race_female %>%
  full_join(catchment_mort_by_cancer_all_race_female) %>%
  full_join(az_inc_all_race_female) %>%
  full_join(az_mort_all_race_female) %>%
  full_join(usa_inc_all_race_female) %>%
  full_join(usa_mort_all_race_female)

# save to disk as csv data table 
write_csv(gyn_data,
          file = "data/tidy/tables/gyn_incidence_mortality_data_table.csv")
