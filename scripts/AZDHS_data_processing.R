# set up ---- 
# load packages 
library(here)
library(tidyverse)
library(knitr)
library(ggthemes)

# all races ----
# check the difference between 2012-2016 & 2013-2017
# load data to environment 
azdhs_catch_incidence_2016 <- read_rds("data/tidy/azdhs_catchment_2012-2016_incidence_by_cancer.rds")
azdhs_catch_incidence_2017 <- read_rds("data/tidy/azdhs_catchment_2013-2017_incidence_by_cancer.rds")

# combine data to one
azdhs <- bind_rows(azdhs_catch_incidence_2016, azdhs_catch_incidence_2017)

# 2016 & 2017 ----
# group by year, sex; filter cancer; arrange by rate; choose top five for each year and sex
# visualize 
azdhs %>% 
  group_by(Year, Sex) %>%
  filter(Cancer != "All" & Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(y = reorder(Cancer, Age_Adj_Rate), x = Age_Adj_Rate, fill = Year)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap("Sex") +
  theme_solarized() +
  theme(legend.position = "bottom") +
  labs(title = "Top 5 Incident Cancer for Catchment",
       subtitle = "All Races",
       x = "Age Adjusted Rate per 100,000",
       y = "",
       caption = "Source: Arizona Cancer Registry Query Module")

# 2012-2016 & 2013-2017
# all sexes; all races
# table 
azdhs %>% 
  group_by(Year, Sex) %>%
  filter(Cancer != "All" & Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  select(Year, Sex, Cancer, Age_Adj_Rate) %>%
  kable(col.names = c("Year", "Sex", "Cancer", "Age Adjusted Rate per 100,000"),
        caption = "Source: Arizona Cancer Registry Query Module")

# hispanic only ----
# check the difference between 2012-2016 & 2013-2017
# load data to environment 
azdhs_catch_incidence_2016_hisp <- read_rds("data/tidy/azdhs_catchment_2012-2016_hispanic_incidence_by_cancer.rds")
azdhs_catch_incidence_2017_hisp <- read_rds("data/tidy/azdhs_catchment_2013-2017_hispanic_incidence_by_cancer.rds")

# combine data to one
azdhs_hisp <- bind_rows(azdhs_catch_incidence_2016_hisp, azdhs_catch_incidence_2017_hisp)

# 2016-2017 ----
# group by year, sex; filter cancer; arrange by rate; choose top five for each year and sex
# visualize 
azdhs_hisp %>% 
  group_by(Year, Sex) %>%
  filter(Cancer != "All" & Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(y = reorder(Cancer, Age_Adj_Rate), x = Age_Adj_Rate, fill = Year)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap("Sex") +
  theme_solarized() +
  theme(legend.position = "bottom") +
  labs(title = "Top 5 Incident Cancer for Catchment",
       subtitle = "Hispanic only",
       x = "Age Adjusted Rate per 100,000",
       caption = "Source: Arizona Cancer Registry Query Module")

# 2012-2016 & 2013-2017
# all sexes; hispanic only 
# table 
azdhs_hisp %>% 
  group_by(Year, Sex) %>%
  filter(Cancer != "All" & Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  select(Year, Sex, Cancer, Age_Adj_Rate) %>%
  kable(col.names = c("Year", "Sex", "Cancer", "Age Adjusted Rate per 100,000"),
        caption = "Source: Arizona Cancer Registry Query Module")

# all races 2016 ----
# top 5 incidence for each sex
# grouped by sex
azdhs_catch_incidence_2016_top_5 <- azdhs_catch_incidence_2016 %>%
  group_by(Sex) %>%
  filter(
    Cancer != "All",
    Cancer != "Other Invasive"
  ) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5)

# view as table
azdhs_catch_incidence_2016_top_5 %>%
  select(Sex, Cancer, Age_Adj_Rate) %>%
  kable(
    col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000"),
    caption = "Top 5 Incident Cancer in Five County Catchment for Year 2012-2016; All Races"
  )

# all races 2017 ----
# top 5 incidence for each sex
# grouped by sex
azdhs_catch_incidence_2017_top_5 <- azdhs_catch_incidence_2017 %>%
  group_by(Sex) %>%
  filter(
    Cancer != "All",
    Cancer != "Other Invasive"
  ) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5)

# top five incidence
# 2013-2017
# all sexes, hispanic only 
# view as table
azdhs_catch_incidence_2017_top_5 %>%
  select(Sex, Cancer, Age_Adj_Rate) %>%
  kable(
    col.names = c("Sex", "Cancer", "Age Adjusted Incidence Rate per 100,000"),
    caption = "5 Most Common New Cancers in Five County Catchment. Source: Arizona Cancer Registry Module (2013-2017"
  )

# view as plot 
azdhs_catch_incidence_2017_top_5 %>%
  ggplot(aes(y = reorder(Cancer, Age_Adj_Rate), x = Age_Adj_Rate)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap("Sex") +
  theme_solarized() +
  labs(title = "5 Most Common New Cancers",
       subtitle = "in Five County Catchment, for 2013-2017, All Races",
       y = "",
       x = "Age Adjusted Rate per 100,000",
       caption = "Source: Arizona Cancer Registry Query Module (2013-2017)")

# hispanic only 2016 ---- 
# top 5 incidence for each sex
# grouped by sex
azdhs_catch_incidence_2016_hisp_top_5 <- azdhs_catch_incidence_2016_hisp %>%
  group_by(Sex) %>%
  filter(
    Cancer != "All",
    Cancer != "Other Invasive"
  ) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5)

# 2012-2016
# all sexes; hispanic only 
# view as table
azdhs_catch_incidence_2016_hisp_top_5 %>%
  select(Sex, Cancer, Age_Adj_Rate) %>%
  kable(col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000"))

# hispanic only 2017 ---- 
# top 5 incidence for each sex
# group by sex
azdhs_catch_incidence_2017_hisp_top_5 <- azdhs_catch_incidence_2017_hisp %>%
  group_by(Sex) %>%
  filter(
    Cancer != "All",
    Cancer != "Other Invasive"
  ) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5)

# 2013-2017
# all sexes; hispanic only 
# view as table
azdhs_catch_incidence_2017_hisp_top_5 %>%
  select(Sex, Cancer, Age_Adj_Rate) %>%
  kable(col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000"))

# compare with uscs crude rate ----
# combine azdhs and uscs on one chart to compare difference in rates for catchment
# read uscs data
uscs <- read_rds("data/tidy/USCS_by_az_county.rds")

# save value to filter to southern az
south_az <- c("Cochise", "Pima", "Pinal", "Santa Cruz", "Yuma")

# filter to catchment area
uscs <- uscs %>%
  drop_na() %>%
  group_by(SITE, SEX) %>%
  filter(AREA %in% south_az,
         EVENT_TYPE == "Incidence",
         RACE == "All Races",
         YEAR == "2012-2016",
         SITE != "All Cancer Sites Combined") %>%
  summarise(COUNT = sum(COUNT),
            POPULATION = sum(POPULATION)) %>%
  mutate(crude_rate = round(((COUNT/POPULATION)*100000), digits = 2)) %>%
  arrange(desc(crude_rate)) %>%
  select("Sex" = SEX, "Cancer" = SITE, "Age_Adj_Rate" = crude_rate)

# recode to match azdhs
uscs <- uscs %>%
  ungroup() %>%
  mutate(Sex = case_when(
    Sex == "Male and Female" ~ "All",
    TRUE ~ as.character(Sex))) %>%
  mutate(Cancer = case_when(
    Cancer == "Male and Female Breast" ~ "Breast Invasive",
    Cancer == "Female Breast" ~ "Breast Invasive",
    Cancer == "Colon and Rectum" ~ "Colorectal",
    Cancer == "Melanomas of the Skin" ~ "Cutaneous Melanoma",
    Cancer == "Corpus and Uterus, NOS" ~ "Corpus Uteri and Uterus, NOS",
    Cancer == "Female Breast, <i>in situ</i>" ~ "Breast In Situ",
    Cancer == "Breast in Situ" ~ "Breast In Situ",
    TRUE ~ as.character(Cancer)
  ))

# set as factor
uscs$Sex <- as_factor(uscs$Sex)

# add variable to identify dataset
uscs <- uscs %>%
  mutate(Year = "USCS*")

# merge azdhs and uscs data
combined <- bind_rows(azdhs, uscs)

# plot bar chart to show difference 
combined %>% 
  group_by(Year, Sex) %>%
  filter(Cancer != "All" & Cancer != "Other Invasive") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(y = reorder(Cancer, Age_Adj_Rate), x = Age_Adj_Rate, fill = Year)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap("Sex") +
  theme_solarized() +
  theme(legend.position = "bottom") +
  labs(title = "Top 5 Incident Cancer for Catchment",
       subtitle = "All Races",
       x = "Age Adjusted Rate per 100,000",
       y = "",
       caption = "Source: Arizona Cancer Registry Query Module;
       *United States Cancer Statistics Crude Rate")

# pima incidence by cancer ----
# read data
pima_incidence_by_cancer <- read_rds("data/tidy/azdhs_pima_2013-2017_incidence_by_cancer.rds")

# show top 5 as table
pima_incidence_by_cancer %>%
  group_by(Sex) %>%
  filter(Cancer != "All") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  select(Year, Race, Sex, Cancer, Age_Adj_Rate) %>%
  kable(col.names = c("Year", "Race", "Sex", "Cancer", "Age Adjusted Incidence Rate per 100K"),
        caption = "Age adjusted incidence rate for Pima County, AZ; Most recent five year average (2013-2017); All races; 5 most incident cancers grouped by sex")

# show top five as plot 
pima_incidence_by_cancer %>%
  group_by(Sex) %>%
  filter(Cancer != "All") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(y = reorder(Cancer, Age_Adj_Rate), x = Age_Adj_Rate)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap("Sex") +
  theme_solarized() +
  theme(legend.position = "bottom") +
  labs(title = "Top 5 Incident Cancer for Pima County, AZ",
       subtitle = "2013-2017; All races; Grouped by sex",
       x = "Age Adjusted Rate per 100,000",
       y = "",
       caption = "Source: Arizona Cancer Registry Query Module")

# pima incidence by race ----
# read data
pima_incidence_by_race <- read_rds("data/tidy/azdhs_pima_2013-2017_incidence_by_race.rds")

# show top 5 as table
pima_incidence_by_race %>%
  group_by(Race, Sex) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  select(Year, Cancer, Race, Sex, Age_Adj_Rate) %>%
  kable(col.names = c("Year", "Cancer", "Race", "Sex", "Age Adjusted Incidence Rate per 100K"),
        caption = "Age adjusted incidence rate for Pima County, AZ; Most recent five year average (2013-2017); All races; 5 most incident cancers grouped by sex")

# show top five as plot 
pima_incidence_by_race %>%
  group_by(Race, Sex) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(y = reorder(Sex, Age_Adj_Rate), x = Age_Adj_Rate, fill = Sex)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap("Race") +
  theme_solarized() +
  theme(legend.position = "bottom") +
  labs(title = "Top 5 Incident Cancer for Pima County, AZ",
       subtitle = "2013-2017; All races; Grouped by race and sex",
       x = "Age Adjusted Incidence Rate per 100,000",
       y = "",
       caption = "Source: Arizona Cancer Registry Query Module")

# pima incidence by age ----
# read data
pima_incidence_by_age <- read_rds("data/tidy/azdhs_pima_2013-2017_incidence_by_age.rds")

# show top five by table
pima_incidence_by_age %>%
  filter(Age_Group != "All") %>%
  group_by(Sex) %>%
  arrange(desc(Case_Count)) %>%
  slice(1:5) %>%
  select(Year, Cancer, Age_Group, Sex, Case_Count) %>%
  kable(col.names = c("Year", "Cancer", "Age Group", "Sex", "Cases"),
        caption = "Highest number of cases for each age group; grouped by sex; for Pima County, AZ; Most recent five year average (2013-2017); All races")

# show top five as plot 
pima_incidence_by_age %>%
  filter(Age_Group != "All") %>%
  group_by(Sex) %>%
  arrange(desc(Case_Count)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(y = reorder(Age_Group, Case_Count), x = Case_Count)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap("Sex") +
  theme_solarized() +
  theme(legend.position = "bottom") +
  labs(title = "Age Groups with Highest Number of New Cancer Cases",
       subtitle = "2013-2017; All races; Grouped by sex",
       x = "New Cases",
       y = "",
       caption = "Source: Arizona Cancer Registry Query Module")
