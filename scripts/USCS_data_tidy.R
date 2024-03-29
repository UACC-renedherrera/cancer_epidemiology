# this will
# 1. download cancer statistics from cdc.gov website
# 2. unzip files
# 3. read data to environment
# 4. tidy data
# 5. save data to data/tidy

# set up ----
# load packages to read and tidy data
library(here)
library(tidyverse)
library(purrr)
library(stringr)
library(janitor)
# library(dataMaid)

# source citation ----
# National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute. Released June 2019, based on the November 2018 submission. Accessed at www.cdc.gov/cancer/uscs/public-use.

# download dataset 2018 ----
# set values
url <- "https://www.cdc.gov/cancer/uscs/USCS-1999-2018-ASCII.zip"
path_zip <- "data/raw"
path_unzip <- "data/raw/USCS_1999-2018"
zip_file <- "USCS_1999-2018_ASCII.zip"
# use curl to download
curl::curl_download(url, destfile = paste(path_zip, zip_file, sep = "/"))
# set value
zipped_file <- "data/raw/USCS_1999-2018_ASCII.zip"
# unzip to folder
unzip(zipped_file, exdir = path_unzip)

# read data ----
# United States Cancer Statistics
# for years 1999-2018
# by cancer site ----

by_cancer <- read_delim("data/raw/USCS_1999-2018/BYSITE.TXT",
  delim = "|",
  na = c(" ", "", "NA", "~", "."),
  col_names = TRUE,
  col_types =
    cols(
      YEAR = col_character(),
      RACE = col_factor(),
      SEX = col_factor(),
      SITE = col_factor(),
      EVENT_TYPE = col_factor(),
      AGE_ADJUSTED_CI_LOWER = col_number(),
      AGE_ADJUSTED_CI_UPPER = col_number(),
      AGE_ADJUSTED_RATE = col_number(),
      COUNT = col_integer(),
      POPULATION = col_number(),
      CRUDE_CI_LOWER = col_number(),
      CRUDE_CI_UPPER = col_number(),
      CRUDE_RATE = col_number()
    )
)

glimpse(by_cancer)

write_rds(by_cancer, "data/tidy/uscs_usa_by_cancer_1999-2018.rds")

by_cancer <- by_cancer %>%
  filter(EVENT_TYPE == "Incidence") %>%
  mutate(area = "US",
         source = "USCS")

uscs_list_of <- distinct(by_cancer, SITE)

# save dataset
write_rds(by_cancer, "data/tidy/incidence_us_uscs_1999-2018_by_cancer.rds")

# use datamaid package to generate codebook
# makeCodebook(by_cancer, file = "data/tidy/codebook_USCS_by_cancer.Rmd")

# read data
# United States Cancer Statistics
# for years 1999-2018
# by age, race, and ethnicity ----
by_age <- read_delim("data/raw/USCS_1999-2018/BYAGE.TXT",
  delim = "|",
  na = c(" ", "", "NA", "~", ".", "+", "-"),
  col_names = TRUE,
  col_types =
    cols(
      AGE = col_factor(),
      CI_LOWER = col_number(),
      CI_UPPER = col_number(),
      COUNT = col_number(),
      EVENT_TYPE = col_factor(),
      POPULATION = col_number(),
      RACE = col_factor(),
      RATE = col_number(),
      SEX = col_factor(),
      SITE = col_factor(),
      YEAR = col_factor()
    )
)

by_age %>%
  distinct(AGE)

ped_list <- c("<1",
              "1-4",
              "5-9",
              "10-14",
              "15-19")

# save dataset
write_rds(by_age, "data/tidy/USCS_by_age.rds")

# use datamaid package to generate codebook
# makeCodebook(by_age, file = "data/tidy/codebook_USCS_by_age.Rmd")

# read data
# United States Cancer Statistics
# for years 1999-2018
# by state and region ----
by_state <- read_delim("data/raw/USCS_1999-2018/BYAREA.TXT",
  delim = "|",
  na = c(" ", "", "NA", "~", ".", "+", "-"),
  col_names = TRUE,
  col_types =
    cols(
      AREA = col_factor(),
      AGE_ADJUSTED_CI_LOWER = col_number(),
      AGE_ADJUSTED_CI_UPPER = col_number(),
      AGE_ADJUSTED_RATE = col_number(),
      COUNT = col_number(),
      EVENT_TYPE = col_factor(),
      POPULATION = col_number(),
      RACE = col_factor(),
      SEX = col_factor(),
      SITE = col_factor(),
      YEAR = col_factor(),
      CRUDE_CI_LOWER = col_number(),
      CRUDE_CI_UPPER = col_number(),
      CRUDE_RATE = col_number()
    )
)

glimpse(by_state)

by_state <- by_state %>% drop_na()

# save dataset
write_rds(by_state, "data/tidy/USCS_by_state.rds")

# use datamaid package to generate codebook
# makeCodebook(by_state, file = "data/tidy/codebook_USCS_by_state.Rmd")

# read data
# United States Cancer Statistics
# for years 1999-2018
# by state and county ----
by_county <- read_delim("data/raw/USCS_1999-2018/BYAREA_COUNTY.TXT",
  delim = "|",
  na = c(" ", "", "NA", "~", ".", "+", "-"),
  col_names = TRUE,
  col_types =
    cols(
      STATE = col_factor(),
      AREA = col_character(),
      AGE_ADJUSTED_CI_LOWER = col_number(),
      AGE_ADJUSTED_CI_UPPER = col_number(),
      AGE_ADJUSTED_RATE = col_number(),
      COUNT = col_number(),
      EVENT_TYPE = col_factor(),
      POPULATION = col_number(),
      RACE = col_factor(),
      SEX = col_factor(),
      SITE = col_factor(),
      YEAR = col_factor(),
      CRUDE_CI_LOWER = col_number(),
      CRUDE_CI_UPPER = col_number(),
      CRUDE_RATE = col_number()
    )
) %>%
  mutate(SOURCE = "USCS")

by_county %>%
  distinct(YEAR)

# filter to only AZ counties
# remove "AZ: Unknown (04999)"
by_az_county <- by_county %>%
  filter(
    STATE == "AZ",
    AREA != "AZ: Unknown (04999)"
  )

# add column with county FIPS code
by_az_county <- by_az_county %>%
  mutate(FIPS = str_extract(by_az_county$AREA, "\\d+"))

# recode AREA variable to show only county name
by_az_county <- by_az_county %>%
  mutate(AREA = str_replace(by_az_county$AREA, "AZ: ", ""))
by_az_county <- by_az_county %>%
  mutate(AREA = str_replace(by_az_county$AREA, "\\d+", ""))
by_az_county <- by_az_county %>%
  mutate(AREA = str_replace(by_az_county$AREA, " County \\(\\)", ""))
by_az_county <- by_az_county %>%
  mutate(AREA = str_replace(by_az_county$AREA, " - 1994\\+", ""))

# set order of race levels 
by_az_county$RACE <- ordered(by_az_county$RACE, levels = c("All Races",
                                                           "White",
                                                           "Hispanic",
                                                           "American Indian/Alaska Native",
                                                           "Black",
                                                           "Asian/Pacific Islander"))

glimpse(by_az_county)

# save dataset
write_rds(by_az_county, "data/tidy/USCS_by_az_county.rds")

# use datamaid package to generate codebook
# makeCodebook(by_az_county, file = "data/tidy/codebook_USCS_by_az_county.Rmd")

# exploratory data analysis
# explore by_age ----

str(by_age)

# incidence
by_age %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2013-2017"
  ) %>%
  ggplot(mapping = aes(x = RATE, y = reorder(AGE, RATE))) +
  geom_errorbarh(aes(xmin = CI_LOWER, xmax = CI_UPPER)) +
  geom_bar(aes(x = RATE), stat = "identity") +
  labs(
    title = "crude rate of new cancers for USA by age group",
    subtitle = "years 2013-2017"
  )

# mortality
by_age %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2013-2017"
  ) %>%
  ggplot(mapping = aes(x = RATE, y = reorder(AGE, RATE))) +
  geom_errorbarh(aes(xmin = CI_LOWER, xmax = CI_UPPER)) +
  geom_bar(aes(x = RATE), stat = "identity") +
  labs(
    title = "crude rate of cancer deaths for USA by age group",
    subtitle = "years 2013-2017"
  )

# explore by_cancer ----
str(by_cancer)
# incidence
by_cancer %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE != "All Cancer Sites Combined" & SITE != "All Sites (comparable to ICD-O-2)",
    YEAR == "2013-2017"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:20) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity") +
  labs(
    title = "age adjusted rate of new cancers for USA",
    subtitle = "years 2013-2017, 20 most common cancers"
  )

# mortality
by_cancer %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE != "All Cancer Sites Combined" & SITE != "All Sites (comparable to ICD-O-2)",
    YEAR == "2013-2017"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:20) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity") +
  labs(
    title = "age adjusted rate of new cancer deaths for USA",
    subtitle = "years 2013-2017, 20 most common cancers"
  )


# mortality
by_az_county %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2013-2017"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of cancer deaths for AZ Counties",
    subtitle = "years 2013-2017"
  )

# compare USA to AZ
# explore by_state ----
str(by_state)
# incidence
by_state %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2013-2017"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of new cancers for each USA state",
    subtitle = "years 2013-2017"
  )

# mortality
by_state %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2013-2017"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of cancer deaths for each USA state",
    subtitle = "years 2013-2017"
  )

