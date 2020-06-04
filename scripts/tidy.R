library(here)
library(tidyverse)


# read data ----
# United States Cancer Statistics
# for years 1999-2016
# by cancer site ----

by_cancer <- read_delim("../Cancer_Data_Sources/data_raw/USCS/BYSITE.TXT",
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

# by age, race, and ethnicity ----
by_age <- read_delim("../Cancer_Data_Sources/data_raw/USCS/BYAGE.TXT",
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

# by state and region ----
by_state <- read_delim("../Cancer_Data_Sources/data_raw/USCS/BYAREA.TXT",
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

# by state and county ----
by_county <- read_delim("../Cancer_Data_Sources/data_raw/USCS/BYAREA_COUNTY.TXT",
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
    title = "age adjusted rate of new cancers for USA",
    subtitle = "years 2012-2016, 20 most common cancers"
  )

# mortality
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
    title = "age adjusted rate of new cancer deaths for USA",
    subtitle = "years 2012-2016, 20 most common cancers"
  )

levels(by_cancer$SITE)
