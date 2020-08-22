# seer stat exports

#### set up ####
# load packages
library(here)
library(tidyverse)

#### Mortality USA ####

mortality_usa_by_cancer <- read_rds("data/tidy/seer_mortality_usa_by_cancer_2014-2018_all_race_all_sex.rds")

mortality_usa <- mortality_usa_by_cancer %>%
  drop_na() %>%
  filter(sex == "Male and female") %>%
  mutate(
    area = "US",
    race = "All Races"
  ) %>%
  select(area,
    race,
    cancer,
    rate = age_adjusted_rate
  ) %>%
  arrange(desc(rate))

#### Mortality AZ ####

mortality_az_by_cancer_for_UAZCC <- read_rds("data/tidy/seer_mortality_AZ_all_race_all_sex_2014-2018_by_cancer.rds")

mortality_az <- mortality_az_by_cancer_for_UAZCC %>%
  drop_na() %>%
  filter(sex == "Male and female") %>%
  mutate(
    area = "AZ",
    race = "All Races"
  ) %>%
  select(area,
    race,
    cancer,
    rate = age_adjusted_rate
  ) %>%
  arrange(desc(rate))

#### Mortality Catchment ####

mortality_az_catch_by_cancer_for_UAZCC <- read_rds("data/tidy/mortality_az_catch_by_cancer_for_UAZCC_2014-2018_all_race_all_sex.rds")

mortality_catch <- mortality_az_catch_by_cancer_for_UAZCC %>%
  drop_na() %>%
  filter(sex == "Male and female") %>%
  mutate(
    area = "Catchment",
    race = "All Races"
  ) %>%
  select(area,
    race,
    cancer,
    rate = age_adjusted_rate
  ) %>%
  arrange(desc(rate))

#### Mortality Non Hispanic White, American Indian and Black ####

mortality_az_catch_by_race_not_hisp <- read_rds("data/tidy/seer_mortality_catch_cancer_by_race_not_hispanic.rds")

mortality_catch_by_race_not_hisp <- mortality_az_catch_by_race_not_hisp %>%
  drop_na() %>%
  filter(Sex == "Male and female") %>%
  mutate(area = "Catchment") %>%
  select(area,
    race = Race,
    cancer = Cancer,
    rate = Age_Adjusted_Rate
  ) %>%
  arrange(desc(rate))

#### Mortality Hispanic ####

mortality_catch_by_race_hisp <- read_rds("data/tidy/seer_mortality_catch_cancer_by_race_hispanic.rds")

mortality_catch_by_race_hisp <- mortality_catch_by_race_hisp %>%
  drop_na() %>%
  filter(Sex == "Male and female") %>%
  select(area,
    race,
    cancer = Cancer,
    rate = Age_Adjusted_Rate
  ) %>%
  arrange(desc(rate))

#### combine all mortality to one table ####
mortality_table <- bind_rows(
  mortality_usa,
  mortality_az,
  mortality_catch,
  mortality_catch_by_race_not_hisp,
  mortality_catch_by_race_hisp
)

mortality_table <- mortality_table %>%
  filter(!(cancer %in% c(
    "All Causes of Death",
    "Digestive System",
    "Respiratory System",
    "Male Genital System",
    "Urinary System",
    "Female Genital System",
    "Miscellaneous Malignant Cancer",
    "Colon excluding Rectum",
    "Male Genital System",
    "Skin",
    "Penis",
    "Vagina",
    "Testis",
    "Male Genital System (Male)",
    "Female Genital System (Female)",
    "Breast",
    "Prostate",
    "Liver",
    "Ovary",
    "Corpus and Uterus, NOS",
    "Corpus Uteri",
    "Intrahepatic Bile Duct",
    "Uterus, NOS",
    "Vulva",
    "Other Male Genital Organs",
    "Other Female Genital Organs"
  )))

# save rds
write_rds(mortality_table, "data/tidy/mortality_seer_area_race_cancer_rate.rds")





#### Mortality American Indian ####



#### Mortality Black ####




# read dataset mortality ----
catchment_mortality <- read_rds("data/tidy/seer_stat_catchment_mortality_2013-2017.rds")

# determine top five cancers for each sex grouping
# table
catchment_mortality %>%
  group_by(sex) %>%
  filter(cancer != "All Causes of Death" & cancer != "All Malignant Cancers") %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  kable(
    caption = "Age adjusted mortality rate per 100,000 for five county catchment, for all races combined, for all sexes, and all cancer, year 2013-2017",
    col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000")
  )

# plot
catchment_mortality %>%
  group_by(sex) %>%
  filter(cancer != "All Causes of Death" & cancer != "All Malignant Cancers") %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(
    title = "Top 5 Cancer Deaths in Catchment for years 2013-2017",
    subtitle = "all sexes, all races",
    x = "Age Adjusted Rate per 100,000",
    y = "",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  facet_wrap("sex") +
  theme_solarized()

# read dataset hispanic mortality ----
catchment_mortality_hispanic <- read_rds("data/tidy/seer_stat_catchment_mortality_hispanic_2013-2017.rds")

# determine top five cancers for each sex grouping
# table
catchment_mortality_hispanic %>%
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
    cancer != "Colon excluding Rectum" &
    cancer != "All Causes of Death" &
    cancer != "All Malignant Cancers" &
    !(cancer %in% cancer_to_exclude)) %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  kable(
    caption = "Age adjusted mortality rate per 100,000 for five county catchment, for all Hispanic only, all races combined, for all sexes, and all cancer, year 2013-2017",
    col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000")
  )

# plot
catchment_mortality_hispanic %>%
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
    cancer != "Colon excluding Rectum" &
    cancer != "All Causes of Death" &
    cancer != "All Malignant Cancers" &
    !(cancer %in% cancer_to_exclude)) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(
    title = "Top 5 Cancer Deaths in Catchment for years 2013-2017",
    subtitle = "hispanic only ",
    x = "Age Adjusted Rate per 100,000",
    y = "",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  facet_wrap("sex") +
  theme_solarized()

# pima mortality by cancer ----
# read dataset
pima_mortality_by_cancer <- read_rds("data/tidy/seer_stat_pima_mortality_2013-2017.rds")

# determine top five cancers for each sex grouping
# filter out "system"
# and save to value for use later
cancer_to_exclude <- str_subset(pima_mortality_by_cancer$cancer, " System")

# table
pima_mortality_by_cancer %>%
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
    cancer != "Colon excluding Rectum" &
    cancer != "All Causes of Death" &
    cancer != "All Malignant Cancers" &
    !(cancer %in% cancer_to_exclude)) %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  kable(
    caption = "Age adjusted mortality rate per 100,000 for five county catchment, for all races combined, for all sexes, and all cancer, year 2013-2017",
    col.names = c("Sex", "Cancer", "Age Adjusted Rate per 100,000")
  )

# plot
pima_mortality_by_cancer %>%
  group_by(sex) %>%
  filter(cancer != "Miscellaneous Malignant Cancer" &
    cancer != "Colon excluding Rectum" &
    cancer != "All Causes of Death" &
    cancer != "All Malignant Cancers" &
    !(cancer %in% cancer_to_exclude)) %>%
  select(sex, cancer, age_adjusted_rate) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(cancer, age_adjusted_rate))) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(
    title = "Top 5 Cancer Deaths in Pima County, AZ",
    subtitle = "Five year average 2013-2017; All races",
    x = "Age Adjusted Mortality Rate per 100,000",
    y = "",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  facet_wrap("sex") +
  theme_solarized()

# pima mortality by race ----
# read dataset
pima_mortality_by_race <- read_rds("data/tidy/seer_stat_pima_mortality_2013-2017_by_race.rds")

# determine top five cancers for each sex grouping

# table
pima_mortality_by_race %>%
  group_by(race, sex) %>%
  select(year, cancer, race, sex, age_adjusted_rate) %>%
  kable(
    caption = "Age adjusted mortality rate per 100,000 for Pima County, AZ, for all sexes, and all cancer, year 2013-2017",
    col.names = c("Year", "Cancer", "Race", "Sex", "Age Adjusted Rate per 100,000")
  )

# plot
pima_mortality_by_race %>%
  group_by(race, sex) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(sex, age_adjusted_rate), fill = sex)) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(
    title = "Top 5 Cancer Deaths in Pima County, AZ",
    subtitle = "Five year average 2013-2017; All races",
    x = "Age Adjusted Mortality Rate per 100,000",
    y = "",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  facet_wrap("race") +
  theme_solarized() +
  theme(legend.position = "bottom")

# pima mortality by age group ----
# read dataset
pima_mortality_by_age <- read_rds("data/tidy/seer_stat_pima_mortality_2013-2017_by_age.rds")

# top 5
# table
pima_mortality_by_age %>%
  group_by(sex) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  select(year, cancer, sex, age_group, age_adjusted_rate) %>%
  kable(
    caption = "Age groups with highest mortality due to cancer for Pima County; ",
    col.names = c("Year", "Cancer", "Sex", "Age Group", "Age Adjusted Rate per 100,000")
  )

# plot
pima_mortality_by_age %>%
  group_by(sex) %>%
  arrange(desc(age_adjusted_rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = age_adjusted_rate, y = reorder(age_group, age_adjusted_rate))) +
  geom_col(position = "dodge") +
  facet_wrap("sex") +
  labs(
    title = "Age Groups with Most Cancer Deaths in Pima County, AZ",
    subtitle = "Five year average 2013-2017; All races combined",
    x = "Age Adjusted Mortality Rate per 100,000",
    y = "",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  theme_solarized() +
  theme(legend.position = "bottom")



# mortality for UAZCC Catchment non-hispanic white ----

# add to attribute table
combined_mortality_for_uazcc <- full_join(combined_mortality_for_uazcc, mortality_catch_white)

# mortality for UAZCC Catchment hispanic ----

mortality_az_catch_hispanic <- read_rds("data/tidy/seer_mortality_catch_cancer_hispanic.rds")

mortality_az_catch_hispanic <- mortality_az_catch_hispanic %>%
  filter(
    Ethnicity == "Spanish-Hispanic-Latino",
    cancer %in% cancer_to_show
  ) %>%
  arrange(desc(Age_Adjusted_Rate)) %>%
  select(cancer, hispanic_Age_Adjusted_Rate = Age_Adjusted_Rate)

mortality_az_catch_hispanic %>% kable()

# add to attribute table
combined_mortality_for_uazcc <- full_join(combined_mortality_for_uazcc, mortality_az_catch_hispanic)
