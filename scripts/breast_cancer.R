# Breast Cancer Incidence & Mortality
# René Dario Herrera
# University of Arizona Cancer Center
# 11 August 2021

# this script summarizes breast cancer data from USCS for USA & AZ
# Produces two charts and two CSV files 

# setup  ####
# packages
library(here)
library(tidyverse)
library(janitor)
library(lubridate)
library(RColorBrewer)
library(ggthemes)

# theme ####
# set consistent theme for graphics & data visualizations
theme_uazcc_brand <- theme_clean(base_size = 18) +
  theme(
    text = element_text(
      family = "sans",
      face = "bold",
      color = "#001C48"
      ),
    panel.background = element_rect(fill = "white"),
    panel.grid = element_line(color = "#1E5288"),
    plot.background = element_rect(fill = "#EcE9EB"),
    aspect.ratio = 9 / 16,
    legend.background = element_rect(fill = "white"),
    legend.position = "right",
    plot.caption = element_text(size = 8),
    # plot.subtitle = element_text(size = 12),
    # plot.title = element_text(size = 14),
    strip.background = element_rect(fill = "#EcE9EB")
  )

# read data ####
# USA
uscs_by_cancer <- read_rds("data/tidy/uscs_usa_by_cancer_1999-2018.rds") %>%
  clean_names()

# change date from factor to date
uscs_by_cancer <- uscs_by_cancer %>%
  mutate(year = as_date(year, format = "%Y"))

# inspect
glimpse(uscs_by_cancer)
unique(uscs_by_cancer$site)
unique(uscs_by_cancer$year)

# Incidence USA ####
# plot
uscs_by_cancer %>%
  filter(year != "2014-2018") %>%
  mutate(year = as_date(year, format = "%Y")) %>%
  filter(site == "Female Breast",
         sex == "Female",
         event_type == "Incidence") %>%
  ggplot(mapping = aes(x = year, y = age_adjusted_rate, group = race)) +
  geom_line(mapping = aes(color = race), size = 2) +
  scale_color_brewer(name = "Race",
                     palette = "Set2") +
  labs(title = "Breast Cancer Incidence in the United States",
       subtitle = "from 1999 to 2018",
       x = "Year",
       y = "Age adjusted rate per 100,000",
       caption = "Source: US Cancer Statistics") +
  theme_uazcc_brand

ggsave(filename = "figures/charts/incidence_breast_usa_trend.png",
       units = "in",
       width = 16,
       height = 9)

# table
uscs_by_cancer %>%
  filter(year != "2014-2018") %>%
  # mutate(year = as_date(year, format = "%Y")) %>%
  filter(site == "Female Breast",
         sex == "Female",
         event_type == "Incidence") %>%
  select(year, race, age_adjusted_rate) %>%
  arrange(year, race) %>%
  write_csv("figures/tables/incidence_breast_usa_trend.csv")

# AZ
az_by_cancer <- read_rds("data/tidy/uscs_by_state_az.rds") %>%
  clean_names()

# change date from factor to date
az_by_cancer <- az_by_cancer %>%
  mutate(year = as.character(year))

# inspect
glimpse(az_by_cancer)
unique(az_by_cancer$year)

# Incidence AZ
az_by_cancer %>%
  filter(year == "2014-2018",
         site == "Female Breast",
         sex == "Female",
         event_type == "Incidence") %>%
  ggplot(mapping = aes(x = race, y = age_adjusted_rate)) +
  geom_col(fill = "#0C234B") +
  # coord_flip() +
  labs(title = "Breast Cancer Incidence in Arizona",
       subtitle = "from 2014-2018",
       x = "Race",
       y = "Age adjusted rate per 100,000",
       caption = "Source: US Cancer Statistics") +
  theme_uazcc_brand

ggsave(filename = "figures/charts/incidence_breast_az.png",
       units = "in",
       width = 16,
       height = 9)

# table
az_by_cancer %>%
  filter(year == "2014-2018",
         site == "Female Breast",
         sex == "Female",
         event_type == "Incidence") %>%
  select(race, age_adjusted_rate) %>%
  arrange(race) %>%
  write_csv("figures/tables/incidence_breast_az_by_race.csv")
