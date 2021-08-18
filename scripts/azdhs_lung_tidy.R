# summarize lung cancer data from USCS 
# University of Arizona Cancer Center
# Rene Dario Herrera 
# renedherrera at email dot arizona dot edu 
# 16 August 2021

# set up ####
library(here)
library(tidyverse)
library(janitor)
library(RColorBrewer)
library(ggthemes)

# theme ####
# set consistent theme for graphics & data visualizations
theme_uazcc_brand <- theme_clean(base_size = 16) +
  theme(
    text = element_text(
      family = "sans",
      # face = "bold",
      color = "#001C48",
      # size = rel(1.5)
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

# query definition
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (03/23/2021)
# Time of Query	Tue, Aug 17, 2021 5:29 PM, MST
# Year Filter	2018, 2017, 2016, 2015, 2014
# Cancer Sites Filter	Cancer Sites, Lung and Bronchus
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Race, Sex

# read data 
azdhs_lung <- read_csv("data/raw/AZDHS/query_catchment_lung_incidence_2014-2018_by_race.csv") %>%
  clean_names()

# plot 
azdhs_lung %>%
  filter(race != "All",
         sex != "All") %>%
  ggplot(mapping = aes(x = race, y = age_adjusted_cancer_incidence_rates_incidence_per_100_000_population_03_23_2021)) +
  geom_col(mapping = aes(fill = sex), position = "dodge") +
  labs(title = "Lung Cancer Incidence in UA Catchment Counties",
       subtitle = "Year 2014-2018",
       x = "Race",
       y = "Age Adjusted Rate per 100,000",
       fill = "") +
  scale_fill_brewer(palette = "Set1") +
  theme_uazcc_brand

ggsave("figures/charts/uazcc_lung_incidence_by_race.png",
       width = 16,
       height = 9)
