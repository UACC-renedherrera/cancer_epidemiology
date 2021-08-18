# summarize lung cancer data from USCS 
# University of Arizona Cancer Center
# Rene Dario Herrera 
# renedherrera at email dot arizona dot edu 
# 16 August 2021

# set up ####
library(here)
library(tidyverse)
library(janitor)
library(ggthemes)
library(RColorBrewer)
library(tigris)

# get ready for spatial ####
options(tigris_use_cache = TRUE)
az_counties_spatial <- counties(state = "AZ")

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

# spatial
theme_uazcc_brand_spatial <- theme_map(base_size = 16) +
  theme(
    text = element_text(
      family = "sans",
      # face = "bold",
      color = "#001C48"
    ),
    panel.background = element_rect(fill = "white"),
    # panel.grid = element_line(color = "#1E5288"),
    plot.background = element_rect(fill = "#EcE9EB"),
    legend.background = element_rect(fill = "white"),
    legend.position = "right",
    # plot.caption = element_text(size = 8),
    # plot.subtitle = element_text(size = 14),
    plot.title = element_text(face = "bold"),
    strip.background = element_rect(fill = "#EcE9EB")
  )

# specify catchment counties
uazcc_catchment <- c("Cochise", "Pima", "Pinal", "Santa Cruz", "Yuma")

# by AZ county ----
# read data to environment
by_az_county <- read_rds("data/tidy/USCS_by_az_county.rds") %>%
  clean_names()

# examine the data 
str(by_az_county)
glimpse(by_az_county)
unique(by_az_county$race)
unique(by_az_county$area)
unique(by_az_county$site)
unique(by_az_county$sex)
unique(by_az_county$event_type)
unique(by_az_county$year) # this has only 2014-2018?

# subset to lung cancer in uazcc catchment
uazcc_lung <- by_az_county %>%
  filter(site == "Lung and Bronchus",
         area %in% uazcc_catchment)

# create spatial data 
uazcc_lung_spatial <- geo_join(spatial_data = az_counties_spatial,
         data_frame = uazcc_lung,
         by_sp = "GEOID", 
         by_df = "fips",
         how = "inner")

# incidence 
# plot spatial 
uazcc_lung_spatial %>%
  filter(event_type == "Incidence",
         race == "All Races",
         sex == "Male and Female") %>%
  ggplot() +
  geom_sf(mapping = aes(fill = age_adjusted_rate)) +
  scale_fill_viridis_c() +
  theme_uazcc_brand_spatial +
  labs(title = "Lung Cancer Incidence",
       subtitle = "Year 2014-2018; All Races; Male and Female",
       fill = "Age Adjusted Rate per 100,000",
       caption = "Source: US Cancer Statistics")

ggsave("figures/maps/uscs_uazcc_lung_incidence.png",
       width = 16,
       height = 9)

# mortality
# plot spatial 
uazcc_lung_spatial %>%
  filter(event_type == "Mortality",
         race == "All Races",
         sex == "Male and Female") %>%
  ggplot() +
  geom_sf(mapping = aes(fill = age_adjusted_rate)) +
  scale_fill_viridis_c() +
  theme_uazcc_brand_spatial +
  labs(title = "Lung Cancer Mortality",
       subtitle = "Year 2014-2018; All Races; Male and Female",
       fill = "Age Adjusted Rate per 100,000",
       caption = "Source: US Cancer Statistics")

ggsave("figures/maps/uscs_uazcc_lung_mortality.png",
       width = 16,
       height = 9)

# ####
# # this doesn't work because I can't aggregate the collective of counties
# # incidence and mortality by race 
# uazcc_lung %>%
#   filter(race != "All Races",
#          sex != "Male and Female") %>%
#   ggplot(mapping = aes(x = race, y = age_adjusted_rate)) +
#   geom_col(mapping = aes(fill = event_type), position = "dodge") +
#   coord_flip() +
#   labs(title = "Lung Cancer Incidence and Mortality",
#        subtitle = "Years 2014-2018, Catchment Counties, Both Sexes",
#        x = "Race",
#        y = "Age Adjusted Rate per 100,000",
#        fill = "") +
#   scale_fill_brewer(palette = "Set3") +
#   theme_uazcc_brand
# 
# ggsave("figures/charts/uazcc_lung_incidence_mortality.png",
#        width = 16,
#        height = 9)
