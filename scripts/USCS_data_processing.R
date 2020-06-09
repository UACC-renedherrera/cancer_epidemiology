# set up ----
# packages 
library(here)
library(tidyverse)
#library(purrr)
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
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
        col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# data table
# top five incidence cancers only
by_state %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:6) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
        col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# data table
# top five incidence cancers only
# grouped by cancer, sex
by_state %>%
  drop_na() %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
  group_by(SEX) %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  select(SITE, SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
        col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:5) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SITE), alpha = 0.5) +
  labs(title = "Top 10 New Cancers in Arizona for Year 2012-2016",
       subtitle = "for all races and sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# save character string of top 10
# filter and slice to top ten
az_top_ten_incidence <- by_state %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
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
  filter(SEX == "Male and Female",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age Adjusted Incidence Rates by Race for Arizona; Year 2012-2016",
        col.names = c("Race", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  group_by(RACE) %>%
  filter(SEX == "Male and Female",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(RACE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = RACE), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by Race",
       subtitle = "Arizona; Year 2012-2016; all sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# for each sex ----
# all races 
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(SEX) %>%
  filter(RACE == "All Races",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age Adjusted Incidence Rates by Sex for Arizona; Year 2012-2016",
        col.names = c("Sex", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  group_by(SEX) %>%
  filter(RACE == "All Races",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SEX, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SEX), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by Sex",
       subtitle = "Arizona; Year 2012-2016; all sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# by age ----
# data is not provided at the Arizona geography

# by AZ county ----
# read data to environment
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds")
# data table
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age adjusted incidence rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
        col.names = c("County", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL"))

# bar chart
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = AREA), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by County",
       subtitle = "Arizona; Year 2012-2016; all races and sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
    theme_solarized()

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
  filter(AREA %in% south_az,
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016") %>%
  summarise(COUNT = sum(COUNT),
            POPULATION = sum(POPULATION)) %>%
  mutate(crude_rate = round(((COUNT/POPULATION)*100000), digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  select(SITE, crude_rate) %>%
  kable(caption = "For southern arizona only, Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined",
        col.names = c("Cancer Site", "Crude Rate per 100,000"))

# bar chart
by_az_county %>%
  drop_na() %>%
  group_by(SITE) %>%
  filter(AREA %in% south_az,
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
  summarise(COUNT = sum(COUNT),
            POPULATION = sum(POPULATION)) %>%
  mutate(crude_rate = round(((COUNT/POPULATION)*100000), digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  slice(1:5) %>%
  ggplot() +
  geom_col(mapping = aes(x = crude_rate, y = reorder(SITE, crude_rate)), alpha = 0.5) +
  labs(title = "Top 10 New Cancers in Southern AZ for Year 2012-2016",
       subtitle = "for all races and sexes combined",
       x = "Crude Rate per 100,000",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# for each race ----
# all sexes
# all cancer sites combined
# years 2012-2016
# data table
by_az_county %>%
  drop_na() %>%
  group_by(RACE) %>%
  filter(SEX == "Male and Female",
         AREA %in% south_az,
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  summarise(COUNT = sum(COUNT),
            POPULATION = sum(POPULATION)) %>%
  mutate(crude_rate = round((COUNT/POPULATION)*100000, digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  select(RACE, crude_rate) %>%
  kable(caption = "Age Adjusted Incidence Rates by Race for Arizona; Year 2012-2016",
        col.names = c("Race", "Crude Rate per 100,000"))

# bar chart
by_az_county %>%
  drop_na() %>%
  group_by(RACE) %>%
  filter(SEX == "Male and Female",
         AREA %in% south_az,
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  summarise(COUNT = sum(COUNT),
            POPULATION = sum(POPULATION)) %>%
  mutate(crude_rate = round((COUNT/POPULATION)*100000, digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  ggplot() +
  geom_col(aes(x = crude_rate, y = reorder(RACE, crude_rate)), alpha = 0.5) +
  labs(title = "Incidence Rates by Race",
       subtitle = "Southern Arizona; Year 2012-2016; all sexes combined",
       x = "Crude Rate per 100,000",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
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
  filter(RACE == "All Races",
         AREA %in% south_az,
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age Adjusted Incidence Rates by Sex for Arizona; Year 2012-2016",
        col.names = c("Sex", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  group_by(SEX) %>%
  filter(RACE == "All Races",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SEX, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SEX), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by Sex",
       subtitle = "Arizona; Year 2012-2016; all sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# by age ----
# data is not provided at the Arizona geography

# by AZ county ----

# data table
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age adjusted incidence rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
        col.names = c("County", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL"))

# bar chart
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = AREA), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by County",
       subtitle = "Arizona; Year 2012-2016; all races and sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
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
  filter(AREA == "Arizona",
         EVENT_TYPE == "Mortality",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age-Adjusted Mortality Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
        col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Mortality",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:10) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SITE), alpha = 0.5) +
  labs(title = "Top 10 Cancer Deaths in Arizona for Year 2012-2016",
       subtitle = "for all races and sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# save character string of top 10
# filter and slice to top ten
az_top_ten_mortality <- by_state %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Mortality",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
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
  filter(SEX == "Male and Female",
         AREA == "Arizona",
         EVENT_TYPE == "Mortality",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age Adjusted Incidence Rates by Race for Arizona; Year 2012-2016",
        col.names = c("Race", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  group_by(RACE) %>%
  filter(SEX == "Male and Female",
         AREA == "Arizona",
         EVENT_TYPE == "Mortality",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(RACE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = RACE), alpha = 0.5) +
  labs(title = "Age Adjusted Mortality Rates by Race",
       subtitle = "Arizona; Year 2012-2016; all sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# for each sex ----
# all races 
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(SEX) %>%
  filter(RACE == "All Races",
         AREA == "Arizona",
         EVENT_TYPE == "Mortality",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age Adjusted Mortality Rates by Sex for Arizona; Year 2012-2016",
        col.names = c("Sex", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  group_by(SEX) %>%
  filter(RACE == "All Races",
         AREA == "Arizona",
         EVENT_TYPE == "Mortality",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SEX, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SEX), alpha = 0.5) +
  labs(title = "Age Adjusted Mortality Rates by Sex",
       subtitle = "Arizona; Year 2012-2016; all sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# by age ----
# data is not provided at the Arizona geography

# by AZ county ----

# data table
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Mortality",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age adjusted mortality rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
        col.names = c("County", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL"))

# bar chart
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Mortality",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = AREA), alpha = 0.5) +
  labs(title = "Age Adjusted Mortality Rates by County",
       subtitle = "Arizona; Year 2012-2016; all races and sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# for southern arizona ----
# 1. by cancer
# 2. by race
# 3. by sex
# 4. by age not available at az/county level 
# 5. by year

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
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age-Adjusted Incidence Rates by Cancer Site, Years 2012-2016, All Races and Sexes Combined)",
        col.names = c("Cancer Site", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:10) %>%
  select(SITE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SITE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SITE), alpha = 0.5) +
  labs(title = "Top 10 New Cancers in Arizona for Year 2012-2016",
       subtitle = "for all races and sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# save character string of top 10
# filter and slice to top ten
az_top_ten <- by_state %>%
  filter(AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  slice(1:10) %>%
  mutate(SITE = as.character(SITE))

# save string to value
az_top_ten <- unique(az_top_ten$SITE)

# for each race ----
# all sexes
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(RACE) %>%
  filter(SEX == "Male and Female",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age Adjusted Incidence Rates by Race for Arizona; Year 2012-2016",
        col.names = c("Race", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  group_by(RACE) %>%
  filter(SEX == "Male and Female",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(RACE, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(RACE, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = RACE), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by Race",
       subtitle = "Arizona; Year 2012-2016; all sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# for each sex ----
# all races 
# all cancer sites combined
# years 2012-2016
# data table
by_state %>%
  group_by(SEX) %>%
  filter(RACE == "All Races",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  select(SEX, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age Adjusted Incidence Rates by Sex for Arizona; Year 2012-2016",
        col.names = c("Sex", "Age Adjusted Rate", "95% CI Lower", "95% CI Upper"))

# bar chart
by_state %>%
  group_by(SEX) %>%
  filter(RACE == "All Races",
         AREA == "Arizona",
         EVENT_TYPE == "Incidence",
         YEAR == "2012-2016",
         SITE == "All Cancer Sites Combined") %>%
  arrange(desc(AGE_ADJUSTED_RATE)) %>%
  ggplot(mapping = aes(x = AGE_ADJUSTED_RATE, y = reorder(SEX, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = SEX), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by Sex",
       subtitle = "Arizona; Year 2012-2016; all sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

# by age ----
# data is not provided at the Arizona geography

# by AZ county ----
# read data to environment
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds")
# data table
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  select(AREA, AGE_ADJUSTED_RATE, AGE_ADJUSTED_CI_LOWER, AGE_ADJUSTED_CI_UPPER) %>%
  kable(caption = "Age adjusted incidence rates by Arizona county for years 2012-2016; all sexes, races, and cancer sites combined",
        col.names = c("County", "Age Adjusted Rate", "95% Confidence Interval LL", "95% Confidence Interval UL"))

# bar chart
by_az_county %>%
  group_by(AREA) %>%
  filter(EVENT_TYPE == "Incidence",
         RACE == "All Races",
         SEX == "Male and Female",
         SITE == "All Cancer Sites Combined") %>%
  ggplot(aes(x = AGE_ADJUSTED_RATE, y = reorder(AREA, AGE_ADJUSTED_RATE))) +
  geom_errorbarh(aes(xmin = AGE_ADJUSTED_CI_LOWER, xmax = AGE_ADJUSTED_CI_UPPER)) +
  geom_col(aes(x = AGE_ADJUSTED_RATE, y = AREA), alpha = 0.5) +
  labs(title = "Age Adjusted Incidence Rates by County",
       subtitle = "Arizona; Year 2012-2016; all races and sexes combined",
       x = "Age Adjusted Rate per 100,000 (95% Confidence Interval",
       y = "",
       caption = "Source: National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute.") +
  theme_solarized()

