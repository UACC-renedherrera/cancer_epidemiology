# prepare USCS data for use in R Studio Connect 
# prepare SEER data for use in R STudio Connect 
# prepare AZ cancer registry data for use in R Studio Connect 
# René Dario Herrera 
# Univ of AZ Cancer Center
# renedherrera at email dot arizona dot edu 
# 21 Sep 2021 

# set up ----
# packages 
library(here)
library(tidyverse)
library(janitor)

# USCS ----
# read uscs data by cancer site for USA area 
by_cancer_usa <- read_rds("data/tidy/uscs_usa_by_cancer_1999-2018.rds") %>%
  clean_names() %>%
  mutate(area = "US",
         source = "USCS",
         race = as.character(race)) %>% # label the geography
filter(year == "2014-2018") # most recent five year average 

glimpse(by_cancer_usa)

# read uscs data by cancer site for AZ area 
by_cancer_az <- read_rds("data/tidy/uscs_by_state_az.rds") %>%
  clean_names() %>%
  filter(year == "2014-2018") %>% # most recent five year average 
  mutate(source = "USCS",
         race = as.character(race))

glimpse(by_cancer_az)

# read uscs data by cancer site for each az county 
by_cancer_az_county <- read_rds("data/tidy/USCS_by_az_county.rds") %>%
  clean_names() %>%
  mutate(race = as.character(race))

by_cancer_az_county %>%
  distinct(year)

glimpse(by_cancer_az_county)

# join all uscs data together 
uscs_data <- full_join(x = by_cancer_usa,
                        y = by_cancer_az) 
uscs_data <- full_join(x = uscs_data,
                       y = by_cancer_az_county)

glimpse(uscs_data)

# sex
uscs_data %>%
  distinct(sex)

# create lists for site groupings 
uscs_data %>%
  distinct(site) %>%
  as.list()

list_head_and_neck <- c("Oral Cavity and Pharynx", 
                        "Hypopharynx",
                        "Nasopharynx",
                        "Oropharynx",
                        "Larynx",
                        "Other Oral Cavity and Pharynx",
                        "Nose, Nasal Cavity and Middle Ear",
                        "Salivary Gland",
                        "Lip",
                        "Tongue",
                        "Floor of Mouth",
                        "Gum and Other Mouth",
                        "Tonsil",
                        "")

list_gyn <- c("Cervix", 
              "Corpus and Uterus, NOS",
              "Female Genital System",
              "Other Female Genital Organs",
              "Uterus, NOS",
              "Vulva",
              "Corpus",
              "Ovary",
              "Vagina")

list_gi <- c("Esophagus",
             "Stomach",
             "Colon excluding Rectum",
             "Colon and Rectum",
             "Pancreas",
             "Liver and Intrahepatic Bile Duct",
             "Other Digestive Organs",
             "Small Intestine",
             "Rectum and Rectosigmoid Junction",
             "Anus, Anal Canal and Anorectum",
             "Gallbladder",
             "Retroperitoneum",
             "Peritoneum, Omentum and Mesentery"
             )

list_skin <- c("Skin excluding Basal and Squamous",
               "Melanomas of the Skin")

list_lymphoma <- c("Hodgkin Lymphoma",
                   "Lymphomas",
                   "Non-Hodgkin Lymphoma")

# create new variable coding a cancer site group 
uscs_data <- uscs_data %>%
  mutate(
    site_group = if_else(
      site %in% list_head_and_neck, "head and neck", if_else(
        site %in% list_gyn, "gynecologic", if_else(
          site == "Female Breast", "breast", if_else(
            site == "Lung and Bronchus", "lung", if_else(
              site %in% list_lymphoma, "lymphoma", if_else(
                site %in% list_skin, "melanoma", if_else(
                  site == "Kaposi Sarcoma", "sarcoma", if_else(
                    site == "Leukemias", "leukemia", if_else(
                      site %in% list_gi, "GI", NULL
                      )
                    )
                  )
                ) 
              )
            )
          )
        )
      ))

# SEER ----
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years','Unknown'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (White, Black, Other)} = 'All races','  White','  Black','  Other (American Indian/AK Native, Asian/Pacific Islander)'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2015-2019'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# {Site and Morphology.Cause of death recode} = '      Lip','      Tongue','      Salivary Gland','      Floor of Mouth','      Gum and Other Mouth','      Nasopharynx','      Tonsil','      Oropharynx','      Hypopharynx','      Other Oral Cavity and Pharynx','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Other Digestive Organs','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','      Melanoma of the Skin','      Non-Melanoma Skin','      Cervix Uteri','      Corpus and Uterus, NOS','      Ovary','      Vagina','      Vulva','      Other Female Genital Organs','      Prostate','      Testis','      Penis','      Other Male Genital Organs','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','      Other Urinary Organs','      Thyroid','      Other Endocrine including Thymus','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','      Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia','      Other Leukemia'
seer_data <- read_delim(file = "data/raw/seer_stat/mortality_catchment_2015-2019_by_cancer.txt",
                        col_names = c("site",
                                      "race",
                                      "sex",
                                      "age_adjusted_rate",
                                      "count",
                                      "population"),
                        col_types = "cccnnn") %>%
  mutate(year = "2015-2019",
         event_type = "Mortality",
         area = "Catchment",
         source = "NCHS via SEER",
         state = "Arizona")

glimpse(seer_data)

# sex 
seer_data %>%
  distinct(sex)

# create lists for site groupings 
seer_data %>%
  distinct(site) %>%
  as.list()

list_head_and_neck <- c("Oral Cavity and Pharynx", 
                        "Hypopharynx",
                        "Nasopharynx",
                        "Oropharynx",
                        "Larynx",
                        "Other Oral Cavity and Pharynx",
                        "Nose, Nasal Cavity and Middle Ear",
                        "Salivary Gland",
                        "Lip",
                        "Tongue",
                        "Floor of Mouth",
                        "Gum and Other Mouth",
                        "Tonsil",
                        "")

list_gyn <- c("Cervix", 
              "Corpus and Uterus, NOS",
              "Female Genital System",
              "Other Female Genital Organs",
              "Uterus, NOS",
              "Vulva",
              "Corpus",
              "Ovary",
              "Vagina")

list_gi <- c("Esophagus",
             "Stomach",
             "Colon excluding Rectum",
             "Colon and Rectum",
             "Pancreas",
             "Liver and Intrahepatic Bile Duct",
             "Other Digestive Organs",
             "Small Intestine",
             "Rectum and Rectosigmoid Junction",
             "Anus, Anal Canal and Anorectum",
             "Gallbladder",
             "Retroperitoneum",
             "Peritoneum, Omentum and Mesentery"
)

list_skin <- c("Skin excluding Basal and Squamous",
               "Melanomas of the Skin")

list_lymphoma <- c("Hodgkin Lymphoma",
                   "Lymphomas",
                   "Non-Hodgkin Lymphoma")

seer_data <- seer_data %>%
  mutate(
    site_group = if_else(
      site %in% list_head_and_neck, "head and neck", if_else(
        site %in% list_gyn, "gynecologic", if_else(
          site == "Female Breast", "breast", if_else(
            site == "Lung and Bronchus", "lung", if_else(
              site %in% list_lymphoma, "lymphoma", if_else(
                site %in% list_skin, "melanoma", if_else(
                  site == "Kaposi Sarcoma", "sarcoma", if_else(
                    site == "Leukemias", "leukemia", if_else(
                      site %in% list_gi, "GI", NULL
                    )
                  )
                )
              ) 
            )
          )
        )
      )
    ),
    race = if_else(race == "All races", "All Races", as.character(race)),
    sex = if_else(sex == "Male and female", "Male and Female", as.character(sex)))

# AZDHS IBIS ---- 
# Query Definition	
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (03/23/2021)
# Time of Query	Tue, Sep 21, 2021 1:45 PM, MST
# Year Filter	2018, 2017, 2016, 2015, 2014
# Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Cancer Sites, Sex

azdhs_data <- read_csv("data/raw/AZDHS/query_catchment_incidence_2014-2018_by_cancer.csv",
                  col_names = c("site",
                                "sex",
                                "count",
                                "population",
                                "age_adjusted_rate",
                                "age_adjusted_ci_lower",
                                "age_adjusted_ci_upper"),
                  skip = 1,
                  col_types = "ccnnnnn") %>%
  clean_names() %>%
  mutate(year = "2014-2018",
         race = "All Races",
         event_type = "Incidence",
         area = "Catchment",
         source = "AZ Cancer Registry")

glimpse(azdhs_data)

# race 
azdhs_data %>%
  distinct(race) 

# sex
azdhs_data %>%
  distinct(sex) %>%
  as.list()

# recode sex to match SEER 
azdhs_data <- azdhs_data %>%
  mutate(sex = if_else(sex == "All", "Male and Female", as.character(sex)))

# cancer site
azdhs_data %>%
  distinct(site) %>%
  as.list()

list_head_and_neck <- c("Oral Cavity and Pharynx", 
                        "Oral Cavity",
                        "Hypopharynx",
                        "Nasopharynx",
                        "Oropharynx",
                        "Larynx",
                        "Other Oral Cavity and Pharynx",
                        "Nose, Nasal Cavity and Middle Ear",
                        "Salivary Gland")

list_gyn <- c("Cervix", 
              "Corpus and Uterus, NOS",
              "Corpus Uteri and Uterus, NOS",
              "Female Genital System",
              "Other Female Genital Organs",
              "Uterus, NOS",
              "Vulva",
              "Corpus",
              "Ovary",
              "Vagina",
              "Cervix Uteri")

list_gi <- c("Esophagus",
             "Stomach",
             "Colon excluding Rectum",
             "Colon and Rectum",
             "Pancreas",
             "Liver and Intrahepatic Bile Duct",
             "Other Digestive Organs",
             "Small Intestine",
             "Rectum and Rectosigmoid Junction",
             "Colorectal",
             "Anus, Anal Canal and Anorectum"
)

list_skin <- c("Skin excluding Basal and Squamous",
               "Melanomas of the Skin",
               "Cutaneous Melanoma")

list_breast <- c("Female Breast", "Breast Invasive")
  
list_leuk <- c("Leukemias", "Leukemia")

list_lymphoma <- c("Hodgkin Lymphoma",
                   "Lymphomas",
                   "Non-Hodgkin Lymphoma",
                   "Hodgkins Lymphoma",
                   "Non-Hodgkins Lymphoma")

azdhs_data <- azdhs_data %>%
  mutate(
    site_group = if_else(
      site %in% list_head_and_neck, "head and neck", if_else(
        site %in% list_gyn, "gynecologic", if_else(
          site %in% list_breast, "breast", if_else(
            site == "Lung and Bronchus", "lung", if_else(
              site %in% list_lymphoma, "lymphoma", if_else(
                site %in% list_skin, "melanoma", if_else(
                  site == "Kaposi Sarcoma", "sarcoma", if_else(
                    site %in% list_leuk, "leukemia", if_else(
                      site %in% list_gi, "GI", NULL
                    )
                  )
                ) 
              )
            )
          )
        )
      ))
  )

# join uscs, seer, and azdhs data 
cancer_epi_data <- full_join(
  x = uscs_data,
  y = seer_data
)

cancer_epi_data <- full_join(
  x = cancer_epi_data,
  y = azdhs_data
)

glimpse(cancer_epi_data)

# reduce variables, remove state and fips 
cancer_epi_data <- cancer_epi_data %>%
  select(!(state)) %>%
  select(!(fips))

# year
cancer_epi_data %>%
  distinct(year)

# race
cancer_epi_data %>%
  distinct(race)

# sex
cancer_epi_data %>%
  distinct(sex)

cancer_epi_data %>%
  filter(sex == "Male and female") %>%
  select(source)

# site
cancer_epi_data %>%
  distinct(site) %>%
  arrange(site) %>%
  as.list()

# bladder
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "ladder")) %>%
  distinct() %>%
  as.list()

# breast
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "reast")) %>%
  distinct() %>%
  as.list()

# cervical
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "ervi")) %>%
  distinct() %>%
  as.list()

# colorectal
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "olo")) %>%
  distinct() %>%
  as.list()

# ovarian
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "var")) %>%
  distinct() %>%
  as.list()

# uterine
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "teri")) %>%
  distinct() %>%
  as.list()

# vaginal
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "agin")) %>%
  distinct() %>%
  as.list()

# vulvar
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "ulva")) %>%
  distinct() %>%
  as.list()

# oral cavity
cancer_epi_data %>%
  select(site) %>%
  filter(str_detect(cancer_epi_data$site, "avity")) %>%
  distinct() %>%
  as.list()

# area
cancer_epi_data %>%
  select(area) %>%
  distinct()

# source 
cancer_epi_data %>%
  select(source) %>%
  distinct() 
  
# coded site group 
cancer_epi_data %>%
  group_by(site_group) %>%
  select(site_group) %>%
  count() 

# align cancer site names and labels
cancer_epi_data <- cancer_epi_data %>%
  mutate(site = if_else(site == "Acute Lymphocytic", "Acute Lymphocytic Leukemia", as.character(site)),
         site = if_else(site == "Acute Myeloid", "Acute Myeloid Leukemia", as.character(site)),
         site = if_else(site == "All", "All Cancer Sites Combined", as.character(site)),
         site = if_else(site == "Breast Invasive", "Female Breast", as.character(site)),
         site = if_else(site == "Chronic Lymphocytic", "Chronic Lymphocytic Leukemia", as.character(site)),
         site = if_else(site == "Chronic Myeloid", "Chronic Lymphocytic Leukemia", as.character(site)),
         site = if_else(site == "Kidney/Renal Pelvis", "Kidney and Renal Pelvis", as.character(site)),
         site = if_else(site == "Cervix Uteri", "Cervix", as.character(site)),
         site = if_else(site == "Colon and Rectum", "Colorectal", as.character(site))
  )

# save rds to file 
write_rds(x = cancer_epi_data,
          file = "communication/shiny_apps/cancer_incidence_mortality_rates/data/rate_data_table.rds")
