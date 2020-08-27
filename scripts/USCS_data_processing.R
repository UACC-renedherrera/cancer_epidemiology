# set up ----
# packages
library(here)
library(tidyverse)
# library(purrr)
library(ggthemes)
library(knitr)

# use data to replicate State Cancer Profiles but for first Arizona and then five county catchment only
# incidence ----
# 1. by cancer
# 2. by race
# 3. by sex
# 4. by age not available at az/county level
# 5. by year

# for Arizona ----
# by cancer ----
# read data
by_state <- read_rds("data/tidy/USCS_by_state.rds")

# for all races
# for all sexes
# years 2012-2016
# all cancers in descending order
# data table
by_state %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
    col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# data table
# top five incidence cancers only
# and show all cancer site combined
by_state %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:6) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
    col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# data table
# top five incidence cancers only
# grouped by cancer, sex
by_state %>%
  drop_na() %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    YEAR == "2012-2016",
    SITE != "All Cancer Sites Combined"
  ) %>%
  group_by(SEX) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  select(SEX, SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
    col.names = c("Sex", "Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# bar chart
by_state %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    YEAR == "2012-2016",
    SITE != "All Cancer Sites Combined",
    SEX == "Male and Female"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SITE), alpha = 0.5) +
  labs(
    title = "Top 10 New Cancers in Arizona for Year 2012-2016",
    subtitle = "for all races and sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# save character string of top 10
# filter and slice to top ten
az_top_ten_incidence <- by_state %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016",
    SITE != "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:10) %>%
  mutate(SITE = as.character(SITE))

# save string to value
az_top_ten_incidence <- unique(az_top_ten_incidence$SITE)

# for each race ----
# all sexes
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(RACE) %>%
  filter(
    SEX == "Male and Female",
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age Adjusted Incidence Rates by Race for Arizona; Year 2012-2016",
    col.names = c("Race", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# bar chart
by_state %>%
  group_by(RACE) %>%
  filter(
    SEX == "Male and Female",
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(RACE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = RACE), alpha = 0.5) +
  labs(
    title = "Age Adjusted Incidence Rates by Race",
    subtitle = "Arizona; Year 2012-2016; all sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# for each sex ----
# all races
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(SEX) %>%
  filter(
    RACE == "All Races",
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age Adjusted Incidence Rates by Sex for Arizona; Year 2012-2016",
    col.names = c("Sex", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# bar chart
by_state %>%
  group_by(SEX) %>%
  filter(
    RACE == "All Races",
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SEX, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SEX), alpha = 0.5) +
  labs(
    title = "Age Adjusted Incidence Rates by Sex",
    subtitle = "Arizona; Year 2012-2016; all sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# by age ----
# data is not provided at the Arizona geography

# by AZ county ----
# read data to environment
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds")

str(by_az_county)
unique(by_az_county$RACE)
unique(by_az_county$AREA)

by_az_county$RACE <- ordered(by_az_county$RACE, levels = c("All Races",
                                                           "White",
                                                           "Hispanic",
                                                           "American Indian/Alaska Native",
                                                           "Black",
                                                           "Asian/Pacific Islander"))
# data table
by_az_county %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined"
  ) %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age adjusted incidence rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
    col.names = c("County", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL")
  )

# bar chart
by_az_county %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined"
  ) %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = AREA), alpha = 0.5) +
  labs(
    title = "Age Adjusted Incidence Rates by County",
    subtitle = "Arizona; Year 2012-2016; all races and sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# incidence for catchment counties in descending order of rate
incidence_catch_counties <- by_az_county %>%
  mutate(SITE = 
           case_when( #variable == old ~ new,
             SITE == "All Cancer Sites Combined" ~ "All",
             SITE == "Female Breast" ~ "Breast Invasive (Female)",
             SITE == "Male and Female Breast" ~ "Breast Invasive (Female)",
             SITE == "Cervix" ~ "Cervix Uteri (Female)",
             SITE == "Colon and Rectum" ~ "Colorectal",
             SITE == "Corpus and Uterus, NOS" ~ "Corpus Uteri and Uterus, NOS (Female)",
             SITE == "Corpus" ~ "Corpus (Female)",
             SITE == "Melanomas of the Skin" ~ "Cutaneous Melanoma",
             SITE == "Gallbladder" ~ "Gallbladder and Other Biliary",
             SITE == "Kidney and Renal Pelvis" ~ "Kidney/Renal Pelvis",
             SITE == "Leukemias" ~ "Leukemia",
             SITE == "Non-Hodgkin Lymphoma" ~ "Non-Hodgkins Lymphoma",
             SITE == "Ovary" ~ "Ovary (Female)",
             SITE == "Prostate" ~ "Prostate (Male)",
             SITE == "Testis" ~ "Testis (Male)",
             SITE == "Oral Cavity and Pharynx" ~ "Oral Cavity",
             SITE == "Hodgkin Lymphoma" ~ "Hodgkins Lymphoma",
             TRUE ~ as.character(SITE)))%>%
  filter(EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         AREA %in% c("Cochise", "Pima", "Pinal", "Santa Cruz", "Yuma")) %>%
  select(AREA, AGE_ADJUSTED_RATE, SITE) %>%
  spread(key = AREA, 
         value = AGE_ADJUSTED_RATE) %>%
  arrange(desc(Pima))

incidence_catch_counties <- write_csv("data/tidy/incidence_az_counties_uscs_2013-2017.csv")

testing <- full_join(incidence_table_uazcc, incidence_catch_counties) %>%
  slice(2:4) %>%
  gather(AZ, Catchment, `White Non-Hispanic`, `American Indian`, Black, Cochise, Pima, Pinal, `Santa Cruz`, Yuma,
         key = "area",
         value = "rate"
         )

ggplot(data = testing, mapping = aes(x = area, y = rate, fill = SITE)) +
  geom_bar(stat = "identity", position = "dodge")

# mortality for catchment counties in descending order of rate
mortality_catch_counties <- by_az_county %>%
  mutate(SITE = 
           case_when( #variable == old ~ new,
               SITE == "All Cancer Sites Combined" ~ "All",
               SITE == "Female Breast" ~ "Breast Invasive (Female)",
               SITE == "Male and Female Breast" ~ "Breast Invasive (Female)",
               SITE == "Cervix" ~ "Cervix Uteri (Female)",
               SITE == "Colon and Rectum" ~ "Colorectal",
               SITE == "Corpus and Uterus, NOS" ~ "Corpus Uteri and Uterus, NOS (Female)",
               SITE == "Corpus" ~ "Corpus (Female)",
               SITE == "Melanomas of the Skin" ~ "Cutaneous Melanoma",
               SITE == "Gallbladder" ~ "Gallbladder and Other Biliary",
               SITE == "Kidney and Renal Pelvis" ~ "Kidney/Renal Pelvis",
               SITE == "Leukemias" ~ "Leukemia",
               SITE == "Non-Hodgkin Lymphoma" ~ "Non-Hodgkins Lymphoma",
               SITE == "Ovary" ~ "Ovary (Female)",
               SITE == "Prostate" ~ "Prostate (Male)",
               SITE == "Testis" ~ "Testis (Male)",
               SITE == "Oral Cavity and Pharynx" ~ "Oral Cavity",
               SITE == "Hodgkin Lymphoma" ~ "Hodgkins Lymphoma",
             TRUE ~ as.character(SITE)))%>%
  filter(EVENT_TYPE == "Mortality",
         RACE == "All Races",
         SEX == "Male and Female",
         AREA %in% c("Cochise", "Pima", "Pinal", "Santa Cruz", "Yuma")) %>%
  select(AREA, AGE_ADJUSTED_RATE, SITE) %>%
  spread(key = AREA, 
         value = AGE_ADJUSTED_RATE) %>%
  arrange(desc(Pima)) 

mortality_catch_counties <- write_csv("data/tidy/mortality_az_counties_uscs_2013-2017.csv")

# for southern arizona ----
# 1. by cancer
# 2. by race
# 3. by sex
# 4. by age not available at az/county level
# 5. by year

# save value
south_az <- c("Cochise", "Pima", "Pinal", "Santa Cruz", "Yuma")

# by cancer ----

# for all races
# for all sexes
# years 2012-2016
# all cancers in descending order
# data table
# unsure if the following crude rate calculation is statistically valid
by_az_county %>%
  drop_na() %>%
  group_by(SITE) %>%
  filter(
    AREA %in% south_az,
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016"
  ) %>%
  summarise(
    COUNT = sum(COUNT),
    POPULATION = sum(POPULATION)
  ) %>%
  mutate(crude_rate = round(((COUNT / POPULATION) * 100000), digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  select(SITE, crude_rate) %>%
  kable(
    caption = "For southern arizona only, Crude Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined",
    col.names = c("Cancer Site", "Crude Rate per 100,000")
  )

# bar chart
by_az_county %>%
  drop_na() %>%
  group_by(SITE) %>%
  filter(
    AREA %in% south_az,
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016",
    SITE != "All Cancer Sites Combined"
  ) %>%
  summarise(
    COUNT = sum(COUNT),
    POPULATION = sum(POPULATION)
  ) %>%
  mutate(crude_rate = round(((COUNT / POPULATION) * 100000), digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  slice(1:5) %>%
  ggplot() +
  geom_col(mapping = aes(x = crude_rate, y = reorder(SITE, crude_rate)), alpha = 0.5) +
  labs(
    title = "Top 10 New Cancers in Southern AZ for Year 2012-2016",
    subtitle = "for all races and sexes combined",
    x = "Crude Incidence Rate per 100,000",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# for each race ----
# all sexes
# all cancer sites combined
# years 2012-2016
# data table
by_az_county %>%
  drop_na() %>%
  group_by(RACE) %>%
  filter(
    SEX == "Male and Female",
    AREA %in% south_az,
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  summarise(
    COUNT = sum(COUNT),
    POPULATION = sum(POPULATION)
  ) %>%
  mutate(crude_rate = round((COUNT / POPULATION) * 100000, digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  select(RACE, crude_rate) %>%
  kable(
    caption = "Crude Rates by Race for Arizona; Year 2012-2016",
    col.names = c("Race", "Crude Rate per 100,000")
  )

# bar chart
by_az_county %>%
  drop_na() %>%
  group_by(RACE) %>%
  filter(
    SEX == "Male and Female",
    AREA %in% south_az,
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  summarise(
    COUNT = sum(COUNT),
    POPULATION = sum(POPULATION)
  ) %>%
  mutate(crude_rate = round((COUNT / POPULATION) * 100000, digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  ggplot() +
  geom_col(aes(x = crude_rate, y = reorder(RACE, crude_rate)), alpha = 0.5) +
  labs(
    title = "Incidence Rates by Race",
    subtitle = "Southern Arizona; Year 2012-2016; all sexes combined",
    x = "Crude Rate per 100,000",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()


# start here
# still need to change from "for az" to "southern az"



# for each sex ----
# all races
# all cancer sites combined
# years 2012-2016
# data table
by_az_county %>%
  group_by(SEX) %>%
  filter(
    RACE == "All Races",
    AREA %in% south_az,
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age Adjusted Incidence Rates by Sex for Arizona; Year 2012-2016",
    col.names = c("Sex", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# bar chart
by_state %>%
  group_by(SEX) %>%
  filter(
    RACE == "All Races",
    AREA == "Arizona",
    EVENT_TYPE == "Incidence",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SEX, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SEX), alpha = 0.5) +
  labs(
    title = "Age Adjusted Incidence Rates by Sex",
    subtitle = "Arizona; Year 2012-2016; all sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# by age ----
# data is not provided at the Arizona geography

# by AZ county ----

# data table
by_az_county %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined"
  ) %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age adjusted incidence rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
    col.names = c("County", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL")
  )

# bar chart
by_az_county %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Incidence",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined"
  ) %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = AREA), alpha = 0.5) +
  labs(
    title = "Age Adjusted Incidence Rates by County",
    subtitle = "Arizona; Year 2012-2016; all races and sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# mortality ----
# 1. by cancer
# 2. by race
# 3. by sex
# 4. by age not available at az/county level
# 5. by year

# for Arizona ----
# by cancer ----

# for all races
# for all sexes
# years 2012-2016
# all cancers in descending order
# data table
by_state %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age-Adjusted Mortality Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
    col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# bar chart
by_state %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016",
    SITE != "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:10) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SITE), alpha = 0.5) +
  labs(
    title = "Top 10 Cancer Deaths in Arizona for Year 2012-2016",
    subtitle = "for all races and sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# save character string of top 10
# filter and slice to top ten
az_top_ten_mortality <- by_state %>%
  filter(
    AREA == "Arizona",
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    YEAR == "2012-2016",
    SITE != "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:10) %>%
  mutate(SITE = as.character(SITE))

# save string to value
az_top_ten_mortality <- unique(az_top_ten_mortality$SITE)

# for each race ----
# all sexes
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(RACE) %>%
  filter(
    SEX == "Male and Female",
    AREA == "Arizona",
    EVENT_TYPE == "Mortality",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age Adjusted Incidence Rates by Race for Arizona; Year 2012-2016",
    col.names = c("Race", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# bar chart
by_state %>%
  group_by(RACE) %>%
  filter(
    SEX == "Male and Female",
    AREA == "Arizona",
    EVENT_TYPE == "Mortality",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(RACE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = RACE), alpha = 0.5) +
  labs(
    title = "Age Adjusted Mortality Rates by Race",
    subtitle = "Arizona; Year 2012-2016; all sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# for each sex ----
# all races
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(SEX) %>%
  filter(
    RACE == "All Races",
    AREA == "Arizona",
    EVENT_TYPE == "Mortality",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age Adjusted Mortality Rates by Sex for Arizona; Year 2012-2016",
    col.names = c("Sex", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper")
  )

# bar chart
by_state %>%
  group_by(SEX) %>%
  filter(
    RACE == "All Races",
    AREA == "Arizona",
    EVENT_TYPE == "Mortality",
    YEAR == "2012-2016",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SEX, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SEX), alpha = 0.5) +
  labs(
    title = "Age Adjusted Mortality Rates by Sex",
    subtitle = "Arizona; Year 2012-2016; all sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# by age ----
# data is not provided at the Arizona geography

# by AZ county ----

# data table
by_az_county %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age adjusted mortality rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
    col.names = c("County", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL")
  )

# bar chart
by_az_county %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined"
  ) %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = AREA), alpha = 0.5) +
  labs(
    title = "Age Adjusted Mortality Rates by County",
    subtitle = "Arizona; Year 2012-2016; all races and sexes combined",
    x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# for southern arizona ----
# 1. by cancer
# 2. by race
# 3. by sex
# 4. by age not available at az/county level
# 5. by year

# mortality ----

# by cancer ----
# save value
south_az <- c("Cochise", "Pima", "Pinal", "Santa Cruz", "Yuma")

# by AZ county ----
# read data to environment
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds")
# data table
# age adjusted mortality rate, all cancers, all races, all sexes
by_az_county %>%
  drop_na() %>%
  group_by(AREA) %>%
  filter(
    AREA %in% south_az,
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SEX == "Male and Female",
    SITE == "All Cancer Sites Combined"
  ) %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age adjusted mortality rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
    col.names = c("County", "Age Adjusted Rate per 100,000", "95% Confidence Interval LL", "95% Confidence Interval UL")
  )

# plot
by_az_county %>%
  drop_na() %>%
  group_by(AREA) %>%
  filter(
    AREA %in% south_az,
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SITE == "All Cancer Sites Combined"
  ) %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE), fill = SEX)) +
  geom_col(position = "dodge", alpha = 0.75) +
  labs(
    title = "Age Adjusted Mortality Rates",
    subtitle = "Catchment; Year 2012-2016; all races combined; grouped by county and sex",
    x = "Age Adjusted Rate per 100,000",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# data table
# age adjusted mortality rate, grouped by county then sex, all cancers, all races
by_az_county %>%
  drop_na() %>%
  group_by(AREA, SEX) %>%
  filter(
    AREA %in% south_az,
    EVENT_TYPE == "Mortality",
    RACE == "All Races",
    SITE == "All Cancer Sites Combined"
  ) %>%
  select(AREA, SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age adjusted mortality rates by Arizona county for years 2012-2016; grouped by sex, all races and cancer sites combined",
    col.names = c("County", "Sex", "Age Adjusted Rate per 100,000", "95% Confidence Interval LL", "95% Confidence Interval UL")
  )

# top 5 mortality cancer
# five counties, group by sex, all races combined
# data table
by_az_county %>%
  drop_na() %>%
  group_by(AREA, SEX) %>%
  filter(
    EVENT_TYPE == "Mortality",
    AREA %in% south_az,
    SITE != "All Cancer Sites Combined",
    RACE == "All Races"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  select(AREA, SEX, SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age adjusted mortality rates by Arizona county for years 2012-2016; all sexes, races",
    col.names = c("County", "Sex", "Cancer", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL")
  )

# bar chart
# group by sex
# top 5 cancer
by_az_county %>%
  drop_na() %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Mortality",
    AREA %in% south_az,
    SITE != "All Cancer Sites Combined",
    RACE == "All Races",
    SEX == "Male and Female"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE), fill = AREA)) +
  geom_col(position = "dodge", alpha = 0.75) +
  labs(
    title = "Age Adjusted Mortality Rates",
    subtitle = "Catchment; Year 2012-2016; all races and sexes combined; grouped by county",
    x = "Age Adjusted Rate per 100,000",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# top five mortality cancer for each county and sex
# hispanic only
# data table
by_az_county %>%
  drop_na() %>%
  group_by(AREA, SEX) %>%
  filter(
    EVENT_TYPE == "Mortality",
    AREA %in% south_az,
    SITE != "All Cancer Sites Combined",
    RACE == "Hispanic"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  select(AREA, SEX, SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(
    caption = "Age adjusted mortality rates by Arizona county for years 2012-2016; all sexes, Hispanic only",
    col.names = c("County", "Sex", "Cancer", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL")
  )

# bar chart
# top 5 cancer
# hispanic
by_az_county %>%
  drop_na() %>%
  group_by(AREA) %>%
  filter(
    EVENT_TYPE == "Mortality",
    AREA %in% south_az,
    SITE != "All Cancer Sites Combined",
    RACE == "Hispanic",
    SEX == "Male and Female"
  ) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE), fill = AREA)) +
  geom_col(position = "dodge", alpha = 0.75) +
  labs(
    title = "Age Adjusted Mortality Rates",
    subtitle = "Catchment; Year 2012-2016; All sexes combined; Hispanic only",
    x = "Age Adjusted Rate per 100,000",
    y = "",
    caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute."
  ) +
  theme_solarized()

# pima county ----
# white ----

by_az_county %>% select(RACE) %>% distinct()

by_az_county %>%
  filter(AREA == "Pima",
         EVENT_TYPE == "Incidence",
         SEX == "Male and Female",
         SITE != "All Cancer Sites Combined",
         SITE != "Male and Female Breast, <i>in situ</i>",
         RACE == "White") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(y = reorder(SITE, AGE_ADJUSTED_RATE), x = AGE_ADJUSTED_RATE)) +
  geom_col() +
  geom_label(aes(label = AGE_ADJUSTED_RATE), nudge_x = 5) +
  xlim(c(0,150)) +
  theme_calc() +
  labs(title = "Incident Cancer for White Race Only",
       subtitle = "2013-2017; Both sexes combined",
       x = "Age Adjusted Incidence Rate per 100,000",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics Public Use Research Database, 2019 submission (2001–2017), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute. Released June 2020. Available at www.cdc.gov/cancer/uscs/public-use.")
  
# Incidence for UAZCC Characterization USA ----
incidence_USA <- read_rds("data/tidy/USCS_by_cancer.rds")

incidence_USA_for_UAZCC <- incidence_USA %>%
  drop_na() %>%
  filter(YEAR == "2012-2016",
         SEX == "Male and Female",
         RACE == "All Races",
         EVENT_TYPE == "Incidence",
         SITE != "All Sites (comparable to ICD-O-2)",
         SITE != "Male and Female Breast",
         SITE != "Male and Female Breast, <i>in situ</i>",
         SITE != "Female Breast, <i>in situ</i>") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, "USA_AGE_ADJUSTED_RATE" = AGE_ADJUSTED_RATE)

incidence_USA_for_UAZCC %>%
  kable(col.names = c("Cancer Type", "Age Adjusted Rate per 100,000"),
        caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute. Released June 2019, based on the November 2018 submission. Accessed at www.cdc.gov/cancer/uscs/public-use.",
        lable = "Cancer Incidence, USA, 2012-2016")

# Incidence for UAZCC Characterization AZ ----
incidence_AZ <- read_rds("data/tidy/USCS_by_state.rds")

incidence_AZ_for_UAZCC <- incidence_AZ %>%
  drop_na() %>%
  filter(AREA == "Arizona",
         YEAR == "2012-2016",
         RACE == "All Races",
         SEX == "Male and Female",
         EVENT_TYPE == "Incidence",
         SITE != "All Sites (comparable to ICD-O-2)",
         SITE != "Male and Female Breast",
         SITE != "Male and Female Breast, <i>in situ</i>",
         SITE != "Female Breast, <i>in situ</i>") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, "AZ_AGE_ADJUSTED_RATE" = AGE_ADJUSTED_RATE)

incidence_AZ_for_UAZCC %>%
  kable(col.names = c("Cancer Type", "Age Adjusted Rate per 100,000"),
        caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute. Released June 2019, based on the November 2018 submission. Accessed at www.cdc.gov/cancer/uscs/public-use.",
        lable = "Cancer Incidence, AZ, 2012-2016")

# combine both USA and AZ age adjusted rate tables 
combined_incidence_USA_AZ_for_UAZCC <- full_join(incidence_USA_for_UAZCC, incidence_AZ_for_UAZCC) %>% 
  arrange(desc(AZ_AGE_ADJUSTED_RATE, USA_AGE_ADJUSTED_RATE)) 

write_rds(combined_incidence_USA_AZ_for_UAZCC, "data/tidy/USCS_incidence_2012_2016_USA_AZ.rds")

combined_incidence_USA_AZ_for_UAZCC %>% kable()
