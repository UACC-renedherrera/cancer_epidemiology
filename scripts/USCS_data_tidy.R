# set up
# load packages to read and tidy data
library(here)
library(tidyverse)
library(purrr)

# source citation
# National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute. Released June 2019, based on the November 2018 submission. Accessed at www.cdc.gov/cancer/uscs/public-use.

# download data from source
# download dataset
# set values
url <- "https://www.cdc.gov/cancer/uscs/USCS-1999-2016-ASCII.zip"
path_zip <- "data/raw"
path_unzip <- "data/raw/USCS_1999-2016"
zip_file <- "USCS_1999-2016_ASCII.zip"
# use curl to download 
curl::curl_download(url, destfile = paste(path_zip, zip_file, sep = "/"))
#set value
zipped_file <- "data/raw/USCS_1999-2016_ASCII.zip"
# unzip to folder
unzip(zipped_file, exdir = path_unzip)

# read data ----
# United States Cancer Statistics
# for years 1999-2016
# by cancer site ----

by_cancer <- read_delim("data/raw/USCS_1999-2016/BYSITE.TXT",
  delim = "|",
  na = c(" ", "", "NA", "~", "."),
  col_names = TRUE,
  col_types =
    cols(
      YEAR = col_factor(),
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

write_rds(by_cancer, "data/tidy/USCS_by_cancer.rds")

# read data
# United States Cancer Statistics
# for years 1999-2016
# by age, race, and ethnicity ----
by_age <- read_delim("data/raw/USCS_1999-2016/BYAGE.TXT",
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

write_rds(by_age, "data/tidy/USCS_by_age.rds")

# read data
# United States Cancer Statistics
# for years 1999-2016
# by state and region ----
by_state <- read_delim("data/raw/USCS_1999-2016/BYAREA.TXT",
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

write_rds(by_state, "data/tidy/USCS_by_state.rds")

# read data
# United States Cancer Statistics
# for years 1999-2016
# by state and county ----
by_county <- read_delim("data/raw/USCS_1999-2016/BYAREA_COUNTY.TXT",
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
)

by_az_county <- by_county %>%
  filter(STATE == "AZ")

write_rds(by_az_county, "data/tidy/USCS_by_az_county.rds")

# explore by_age ----

str(by_age)

# incidence
by_age %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2012-2016"
  ) %>%
  ggplot(mapping = aes(x = RATE, y = reorder(AGE, RATE))) +
  geom_errorbarh(aes(xmin = CI_LOWER, xmax = CI_UPPER)) +
  geom_bar(aes(x = RATE), stat = "identity") +
  labs(
    title = "crude rate of new cancers for USA by age group",
    subtitle = "years 2012-2016"
  )

# mortality
by_age %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2012-2016"
  ) %>%
  ggplot(mapping = aes(x = RATE, y = reorder(AGE, RATE))) +
  geom_errorbarh(aes(xmin = CI_LOWER, xmax = CI_UPPER)) +
  geom_bar(aes(x = RATE), stat = "identity") +
  labs(
    title = "crude rate of cancer deaths for USA by age group",
    subtitle = "years 2012-2016"
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
    YEAR == "2012-2016"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:20) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity") +
  labs(
    title = "age adjusted rate of new cancers for USA",
    subtitle = "years 2012-2016, 20 most common cancers"
  )

# mortality
by_cancer %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE != "All Cancer Sites Combined" & SITE != "All Sites (comparable to ICD-O-2)",
    YEAR == "2012-2016"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:20) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity") +
  labs(
    title = "age adjusted rate of new cancer deaths for USA",
    subtitle = "years 2012-2016, 20 most common cancers"
  )

# explore by_az_county ----
str(by_az_county)
# incidence
by_az_county %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2012-2016"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of new cancers for AZ Counties",
    subtitle = "years 2012-2016"
  )

# mortality
by_az_county %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2012-2016"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of cancer deaths for AZ Counties",
    subtitle = "years 2012-2016"
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
    YEAR == "2012-2016"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of new cancers for each USA state",
    subtitle = "years 2012-2016"
  )

# mortality
by_state %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined",
    YEAR == "2012-2016"
  ) %>%
  drop_na() %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_bar(aes(x = AGE_ADJUSTED_RATE), stat = "identity", alpha = 0.5) +
  labs(
    title = "age adjusted rate of cancer deaths for each USA state",
    subtitle = "years 2012-2016"
  )

