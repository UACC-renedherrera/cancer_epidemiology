# compare incidence USA vs AZ vs catchment
# usa is seer
# az is azdhs
# catchment is azdhs
# catchment race is azdhs

# set up ----
# packages
library(here)
library(tidyverse)
library(ggthemes)

# load USA data ----
incidence_usa <- read_rds("data/tidy/USCS_by_cancer.rds")

incidence_usa <- incidence_usa %>%
  drop_na() %>%
  filter(YEAR == "2013-2017",
         SEX == "Male and Female",
         RACE == "All Races",
         EVENT_TYPE == "Incidence",
         SITE != "All Sites (comparable to ICD-O-2)",
         SITE != "Male and Female Breast",
         SITE != "Male and Female Breast, <i>in situ</i>",
         SITE != "Female Breast, <i>in situ</i>",
       SITE != "Brain",
     ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  mutate(area = "USA",
         race = "All") %>%
select(area,
       race,
       cancer = SITE,
       rate = AGE_ADJUSTED_RATE)

incidence_usa <- incidence_usa %>%
  mutate(cancer = case_when( #variable == old ~ new,
    cancer == "All Cancer Sites Combined" ~ "Overall",
    cancer == "Female Breast" ~ "Breast Invasive (Female)",
    cancer == "Cervix" ~ "Cervix Uteri (Female)",
    cancer == "Colon and Rectum" ~ "Colorectal",
    cancer == "Corpus and Uterus, NOS" ~ "Corpus Uteri and Uterus, NOS (Female)",
    cancer == "Melanomas of the Skin" ~ "Cutaneous Melanoma",
    cancer == "Gallbladder" ~ "Gallbladder and Other Biliary",
    cancer == "Kidney and Renal Pelvis" ~ "Kidney/Renal Pelvis",
    cancer == "Leukemias" ~ "Leukemia",
    cancer == "Non-Hodgkin Lymphoma" ~ "Non-Hodgkins Lymphoma",
    cancer == "Ovary" ~ "Ovary (Female)",
    cancer == "Prostate" ~ "Prostate (Male)",
    cancer == "Testis" ~ "Testis (Male)",
    TRUE ~ as.character(cancer)
  ))

# load AZ data ----
incidence_az <- read_rds("data/tidy/incidence_az_catchment_azdhs_2013-2017_by_cancer.rds")

incidence_az <- incidence_az %>%
  mutate(cancer = case_when(
    cancer == "All" ~ "Overall", #old ~ new
    cancer == "Oral Cavity" ~ "Oral Cavity and Pharynx",
    TRUE ~ as.character(cancer)
  ))

# combine usa, az, catchment, race
incidence_table <- bind_rows(incidence_usa, incidence_az)

incidence_table <- incidence_table %>%
  mutate(
  area = as.ordered(incidence_table$area)
)

write_rds(incidence_table, "data/tidy/incidence_usa_az_catch_2013-2017_by_cancer.rds")

# generate a table for the uazcc attribute table
# | cancer | US | AZ | catch | white | hispanic | AI | black | AZ:US | catch:US | white:US | hispanic:US | AI:US | black:US |

# prep usa
incidence_usa <- incidence_table %>%
  filter(area == "USA") %>%
  arrange(desc(rate)) %>%
  select(cancer,
         "USA" = rate)

# prep az
incidence_az <- incidence_table %>%
  filter(area == "AZ") %>%
  arrange(desc(rate)) %>%
  select(cancer,
         "AZ" = rate)

# prep catchment
incidence_catch <- incidence_table %>%
  filter(area == "Catchment") %>%
  spread(key = race,
         value = rate) %>%
  select(cancer, 
         "Catchment" = All,
         "Non-Hispanic White",
         "White Hispanic",
         "American Indian",
         "Black") %>%
  arrange(desc(Catchment))

# join usa and az to start uazcc
uazcc_incidence_table <- full_join(incidence_usa, incidence_az)

# join uazcc to catchment
uazcc_incidence_table <- full_join(uazcc_incidence_table, incidence_catch)

# tidy table
uazcc_incidence_table <- uazcc_incidence_table %>%
  arrange(desc(Catchment))

# and calculate rate ratios
uazcc_incidence_table <- uazcc_incidence_table %>%
  mutate(IRR = AZ/USA,
         IRR_catchment = Catchment/USA,
         IRR_White = `Non-Hispanic White` /USA,
         IRR_Hispanic = `White Hispanic` /USA,
         IRR_AI = `American Indian` /USA,
         IRR_Black = Black /USA) %>%
  arrange(desc(Catchment))

# save to csv to paste into uazcc attribute table
write_csv(uazcc_incidence_table, "data/tidy/uazcc_incidence_table.csv")
