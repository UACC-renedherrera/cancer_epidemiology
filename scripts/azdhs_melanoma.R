# summarize melanoma cancer data from USCS 
# University of Arizona Cancer Center
# Rene Dario Herrera 
# renedherrera at email dot arizona dot edu 
# 17 August 2021

# set up ####
library(here)
library(tidyverse)
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
    plot.caption = element_text(size = 10),
    # plot.subtitle = element_text(size = 12),
    # plot.title = element_text(size = 14),
    strip.background = element_rect(fill = "#EcE9EB")
  )

# Query Definition	
# Query Item	Description / Value
# Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
# Module	Arizona Cancer Registry Query Module
# Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (03/23/2021)
# Time of Query	Wed, Aug 18, 2021 9:00 AM, MST
# Year Filter	2018, 2017, 2016, 2015, 2014
# Cancer Sites Filter	Cancer Sites, Cutaneous Melanoma
# Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
# County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
# Data Grouped By	Race, Sex


# read data 
azdhs_mela <- read_csv("data/raw/AZDHS/query_catchment_melanoma_incidence_2014-2018_by_race.csv",
                       skip = 1,
                       col_names = c(
                         "race",
                         "sex",
                         "count",
                         "population",
                         "age_adjusted_rate",
                         "ci_95_min",
                         "ci_95_max"
                       ),
                       col_types = cols(
                         "race" = col_factor(),
                         "sex" = col_factor(),
                         "count" = col_number(),
                         "population" = col_number(),
                         "age_adjusted_rate" = col_number(),
                         "ci_95_min" = col_number(),
                         "ci_95_max" = col_number()),
                       na = c("", "^", "NA", "*"))

# plot 
azdhs_mela %>%
  filter(race != "All",
         sex != "All") %>%
  ggplot(mapping = aes(x = race, y = age_adjusted_rate)) +
  geom_col(mapping = aes(fill = sex), position = "dodge") +
  labs(title = "Cutaneous Melanoma Incidence in UA Catchment Counties",
       subtitle = "Year 2014-2018",
       x = "Race",
       y = "Age Adjusted Rate per 100,000",
       fill = "Sex",
       caption = "Source: IBIS Query of the Arizona Cancer Registry. 23 March 2021") +
  scale_fill_brewer(palette = "Set1") +
  theme_uazcc_brand

ggsave("figures/charts/uazcc_melanoma_incidence_by_race_2014-2018.png",
       width = 16,
       height = 9)
