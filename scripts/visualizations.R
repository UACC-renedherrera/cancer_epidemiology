# set up ----
# packages

library(here)
library(tidyverse)
library(ggthemes)
library(gt)


# blue palette
uaz_blues3 <- c("#deebf7", "#9ecae1", "#3182bd")
uaz_blues4 <- c("#eff3ff", "#bdd7e7", "#6baed6", "#2171b5")

# red palette
uaz_reds3 <- c("#fee0d2", "#fc9272", "#de2d26")
uaz_reds4 <- c("#fee5d9", "#fcae91", "#fb6a4a", "#cb181d")

# red and blue palette
uaz_red_blue <- c("#AB0520", "#0C234B")

# theme ####
# set consistent theme for graphics & data visualizations
theme_uazcc_brand <- theme_clean(base_size = 18) +
  theme(
    text = element_text(
      family = "sans",
      # face = "bold",
      color = "#001C48",
      # size = rel(1.5)
    ),
    panel.background = element_rect(fill = "white"),
    panel.grid = element_line(color = "#1E5288"),
    #plot.background = element_rect(fill = "#EcE9EB"),
    aspect.ratio = 9 / 16,
    legend.background = element_rect(fill = "white"),
    legend.position = "right",
    plot.caption = element_text(size = 8),
    # plot.subtitle = element_text(size = 12),
    # plot.title = element_text(size = 14),
    strip.background = element_rect(fill = "#EcE9EB")
  )

# spatial
theme_uazcc_brand_spatial <- theme_map(base_size = 14) +
  theme(
    text = element_text(
      family = "sans",
      # face = "bold",
      color = "#001C48"
    ),
    # panel.background = element_rect(fill = "white"),
    # panel.grid = element_line(color = "#1E5288"),
    # plot.background = element_rect(fill = "#EcE9EB"),
    # legend.background = element_rect(fill = "white"),
    legend.position = "right",
    plot.caption = element_text(size = 8),
    # plot.subtitle = element_text(size = 14),
    plot.title = element_text(face = "bold"),
    strip.background = element_rect(fill = "#EcE9EB")
  )


# read incidence data for 2013-2017
incidence <- read_rds("data/tidy/incidence_usa_az_catch_2013-2017_by_cancer.rds")

# OVERVIEW ----

# Map of Rate of New Cancers catchment ----
# Cancer Incidence for each AZ county
# All Types of Cancer, All Ages, All Races/Ethnicities, Male and Female
# Rate per 100,000 people
# highlight catchment






# Chart of Rate of New Cancers catchment ----
# Cancer Incidence for each AZ county
# highlight catchment
# show vertical line for US Rate
# show vertical line for AZ Rate



# Chart of Top 10 Cancers by Rates of New Cancer Cases ----
# Cancer incidence for catchment
# 2013-2017, All Races/Ethnicities, Male and Female

# read data
incidence_catchment_by_cancer <- read_rds("data/tidy/azdhs_catchment_2013-2017_incidence_by_cancer.rds")

# subset and visualize
# top 10 most incident cancer catchment
# catchment only
incidence_catchment_by_cancer %>%
  filter(
    Sex == "All",
    Cancer != "All",
    Cancer != "Breast Invasive",
    Cancer != "Other Invasive"
  ) %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = Age_Adj_Rate, y = reorder(Cancer, Age_Adj_Rate))) +
  geom_bar(stat = "identity", fill = "#0C234B") +
  geom_label(aes(label = Age_Adj_Rate)) +
  labs(
    title = "Top 10 Cancers for the Catchment by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment 2013-2017, All Races/Ethnicities, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: The Arizona Department of Health Services (ADHS) Indicator Based Information System for Public Health (IBIS-PH)"
  ) +
  theme_clean()

# save plot to file
ggsave("incidence_top_10_cancer_catchment.svg",
  width = 20,
  height = 11.25,
  device = svg,
  path = "figures/graphics/",
  scale = .5
)

# comparing usa / az / catchment
# top 10 catchment
# get list of cancer

list_of_cancer_to_chart <- c(
  "Breast Invasive (Female)",
  "Prostate (Male)",
  "Lung and Bronchus",
  "Colorectal",
  "Cutaneous Melanoma",
  "Corpus Uteri and Uterus, NOS (Female)",
  "Urinary Bladder",
  "Kidney/Renal Pelvis",
  "Non-Hodgkins Lymphoma",
  "Thyroid"
)

# convert to factor
incidence$area <- as.factor(incidence$area)

# order
incidence$area <- ordered(incidence$area, levels = c("USA", "AZ", "Catchment"))

# check
levels(incidence$area)

# plot incidence top 10 for catchment vs us and az
incidence %>%
  filter(
    cancer %in% list_of_cancer_to_chart,
    race == "All"
  ) %>%
  group_by(area) %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate), fill = area)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(
    title = "Top 10 Cancers by Rates of New Cancer Cases",
    subtitle = "Comparing, USA, AZ, & UAZCC Catchment 2013-2017,
    All Races/Ethnicities, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_blues3)

# save to file
ggsave("incidence_top_10_cancer_usa_az_catchment.svg",
  width = 20,
  height = 11.25,
  device = svg,
  path = "figures/graphics/",
  scale = .5
)

# top 10 for white in catchment
# plot
incidence %>%
  filter(area == "Catchment",
         race == "Non-Hispanic White",
         cancer != "Overall") %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(stat = "identity", position = "dodge", fill = "#0C234B") +
  geom_label(aes(label = rate)) +
  labs(
    title = "Top 10 Cancers for Non-Hispanic White by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment, 2013-2017, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom")

# save to file
ggsave("incidence_top_10_cancer_catchment_white.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# top 10 for hispanic in catchment
# plot
incidence %>%
  filter(area == "Catchment",
         race == "White Hispanic",
         cancer != "Overall") %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(stat = "identity", position = "dodge", fill = "#0C234B") +
  geom_label(aes(label = rate)) +
  labs(
    title = "Top 10 Cancers for Hispanic by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment, 2013-2017, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom")

# save to file
ggsave("incidence_top_10_cancer_catchment_hispanic.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# top 10 for hispanic in catchment
# plot
incidence %>%
  filter(area == "Catchment",
         race == "American Indian",
         cancer != "Overall") %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(stat = "identity", position = "dodge", fill = "#0C234B") +
  geom_label(aes(label = rate)) +
  labs(
    title = "Top 10 Cancers for American Indian by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment, 2013-2017, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom")

# save to file
ggsave("incidence_top_10_cancer_catchment_ai.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# comparing USA AZ Catchment
# disparities vs USA
# read file
incidence_catchment_disparate <- read_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities.rds")

# convert to factor
incidence_catchment_disparate$area <- as.factor(incidence_catchment_disparate$area)

# order factor
incidence_catchment_disparate$area <- ordered(incidence_catchment_disparate$area, levels = c("US", "AZ", "Catchment"))

# check
levels(incidence_catchment_disparate$area)

# plot disparity in catchment vs us and az
incidence_catchment_disparate %>%
  arrange(desc(area)) %>%
  ggplot(data = incidence_catchment_disparate, mapping = aes(x = rate, y = reorder(SITE, rate), group = area)) +
  geom_bar(aes(fill = area), stat = "identity", position = "dodge", color = "black") +
  labs(
    title = "Cancers in Catchment with Incidence Greater than US",
    subtitle = "Comparing, USA, AZ, & UAZCC Catchment 2013-2017,
    All Races/Ethnicities, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_blues3)

# save
ggsave("incidence_disparate_usa_az_catchment.svg",
  width = 20,
  height = 11.25,
  device = svg,
  path = "figures/graphics/",
  scale = .5
)

# disparity white in catchment
# read file
incidence_catchment_disparate_white <- read_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities_white.rds")

# set as factor
incidence_catchment_disparate_white$area <- as.factor(incidence_catchment_disparate_white$area)

# order
incidence_catchment_disparate_white$area <- ordered(incidence_catchment_disparate_white$area, levels = c("US", "AZ", "Catchment", "White Non-Hispanic"))

# check
levels(incidence_catchment_disparate_white$area)

# plot disparity of white in catchment
incidence_catchment_disparate_white %>%
  arrange(desc(area)) %>%
  ggplot(data = incidence_catchment_disparate_white, mapping = aes(x = rate, y = reorder(SITE, rate), group = area)) +
  geom_bar(aes(fill = area), stat = "identity", position = "dodge", color = "black") +
  labs(
    title = "Cancers for White Non Hispanic in Catchment with Incidence Greater than US",
    subtitle = "Comparing, USA, AZ, & UAZCC Catchment 2013-2017,
    White Non-Hispanic only, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_blues4)

# save to file
ggsave("incidence_disparate_usa_az_catchment_white.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# disparity hispanic in catchment
# read file
incidence_catchment_disparate_hispanic <- read_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities_hispanic.rds")

# set as factor
incidence_catchment_disparate_hispanic$area <- as.factor(incidence_catchment_disparate_hispanic$area)

# order
incidence_catchment_disparate_hispanic$area <- ordered(incidence_catchment_disparate_hispanic$area, levels = c("US", "AZ", "Catchment", "White Hispanic"))

# check
levels(incidence_catchment_disparate_hispanic$area)

# plot of hispanic in catchment disparity
incidence_catchment_disparate_hispanic %>%
  arrange(desc(area)) %>%
  ggplot(data = incidence_catchment_disparate_hispanic, mapping = aes(x = rate, y = reorder(SITE, rate), group = area)) +
  geom_bar(aes(fill = area), stat = "identity", position = "dodge", color = "black") +
  labs(
    title = "Cancers for Hispanic in Catchment with Incidence Greater than US",
    subtitle = "Comparing, USA, AZ, & UAZCC Catchment 2013-2017,
    Hispanic only, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_blues4)

# save to file
ggsave("incidence_disparate_usa_az_catchment_hispanic.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# disparity american indian in catchment
# read file
incidence_catchment_disparate_ai <- read_rds("data/tidy/uazcc_incidence_table_2013-2017_disparities_ai.rds")

# set as factor
incidence_catchment_disparate_ai$area <- as.factor(incidence_catchment_disparate_ai$area)

# order
incidence_catchment_disparate_ai$area <- ordered(incidence_catchment_disparate_ai$area, levels = c("US", "AZ", "Catchment", "American Indian"))

# check
levels(incidence_catchment_disparate_ai$area)

# plot of american indian in catchment disparity
incidence_catchment_disparate_ai %>%
  arrange(desc(area)) %>%
  ggplot(data = incidence_catchment_disparate_ai, mapping = aes(x = rate, y = reorder(SITE, rate), group = area)) +
  geom_bar(aes(fill = area), stat = "identity", position = "dodge", color = "black") +
  labs(
    title = "Cancers for American Indian in Catchment with Incidence Greater than US",
    subtitle = "Comparing, USA, AZ, & UAZCC Catchment 2013-2017,
    American Indian only, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_blues4)

# save to file
ggsave("incidence_disparate_usa_az_catchment_ai.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# Chart of Top 10 Cancers by Rates of Cancer Deaths ----
# Cancer mortality for catchment
# 2014-2018, All Races/Ethnicities, Male and Female

# read data
mortality <- read_rds("data/tidy/mortality_seer_area_race_cancer_rate.rds")

mortality$area <- as.factor(mortality$area)

mortality$area <- ordered(mortality$area, levels = c("US", "AZ", "Catchment"))

levels(mortality$area)

# subset and visualize
mortality %>%
  filter(
    area == "Catchment",
    race == "All Races",
    cancer != "All Malignant Cancers") %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(stat = "identity", fill = "#AB0520") +
  geom_label(aes(label = rate)) +
  labs(
    title = "Top 10 Cancers for the Catchment by Rates of Cancer Deaths",
    subtitle = "UAZCC Catchment 2014-2018, All Races/Ethnicities, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  theme_clean() +
  theme(legend.position = "bottom")

ggsave("mortality_top_10_cancer_catchment.svg",
  width = 20,
  height = 11.25,
  device = svg,
  path = "figures/graphics/",
  scale = .5
)

# compare top 10 catchment with usa and az
mortality %>%
  filter(
    area %in% c("US", "AZ", "Catchment"),
    race == "All Races",
    cancer != "All Malignant Cancers") %>%
  group_by(area) %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(aes(fill = area), stat = "identity", position = "dodge", color = "black") +
  labs(
    title = "Top 10 Cancers by Rates of Cancer Deaths",
    subtitle = "Comparing US, AZ, UAZCC Catchment 2014-2018,
    All Races/Ethnicities, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_reds3)

ggsave("mortality_top_10_cancer_usa_az_catchment.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# top 10 for white in catchment
# plot
mortality %>%
  filter(area == "Catchment",
         race == "White",
         cancer != "All Malignant Cancers") %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(stat = "identity", position = "dodge", fill = "#AB0520") +
  geom_label(aes(label = rate)) +
  labs(
    title = "Top 10 Cancers for Non-Hispanic White by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment, 2013-2017, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom")

# save to file
ggsave("mortality_top_10_cancer_catchment_white.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# top 10 for hispanic in catchment
# plot
mortality %>%
  filter(area == "Catchment",
         race == "Hispanic",
         cancer != "All Malignant Cancers") %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(stat = "identity", position = "dodge", fill = "#AB0520") +
  geom_label(aes(label = rate)) +
  labs(
    title = "Top 10 Cancers for Hispanic by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment, 2013-2017, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom")

# save to file
ggsave("mortality_top_10_cancer_catchment_hispanic.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# top 10 for american indian in catchment
# plot
mortality %>%
  filter(area == "Catchment",
         race == "American Indian/Alaska Native",
         cancer != "All Malignant Cancers") %>%
  arrange(desc(rate)) %>%
  slice(1:10) %>%
  ggplot(mapping = aes(x = rate, y = reorder(cancer, rate))) +
  geom_bar(stat = "identity", position = "dodge", fill = "#AB0520") +
  geom_label(aes(label = rate)) +
  labs(
    title = "Top 10 Cancers for American Indian by Rates of New Cancer Cases",
    subtitle = "UAZCC Catchment, 2013-2017, Male and Female Combined",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2017)
    ADHS IBIS-PH"
  ) +
  theme_clean() +
  theme(legend.position = "bottom")

# save to file
ggsave("mortality_top_10_cancer_catchment_ai.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# disparities catchment
mortality_catch_disp <- read_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities.rds")

mortality_catch_disp$area <- as.factor(mortality_catch_disp$area)

mortality_catch_disp$area <- ordered(mortality_catch_disp$area, levels = c("US", "AZ", "Catchment"))

levels(mortality_catch_disp$area)

ggplot(data = mortality_catch_disp, mapping = aes(x = rate, y = reorder(cancer, rate), fill = area)) +
  geom_bar(position = "dodge", stat = "identity", color = "black") +
  labs(
    title = "Top 10 Cancers in Catchment with Incidence Greater than US",
    subtitle = "Comparing US, AZ, UAZCC Catchment 2014-2018,
    All Races/Ethnicities, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_reds3)

ggsave("mortality_disparity_usa_az_catchment.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# mortality disparities for white in catchment
mortality_catch_disp_white <- read_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities_white.rds")

mortality_catch_disp_white$area <- as.factor(mortality_catch_disp_white$area)

mortality_catch_disp_white$area <- ordered(mortality_catch_disp_white$area, levels = c("US", "AZ", "Catchment", "White"))

levels(mortality_catch_disp_white$area)

ggplot(data = mortality_catch_disp_white, mapping = aes(x = rate, y = reorder(cancer, rate), fill = area)) +
  geom_bar(position = "dodge", stat = "identity", color = "black") +
  labs(
    title = "Cancers for Non Hispanic White in Catchment with Mortality Greater than US",
    subtitle = "Comparing US, AZ, UAZCC Catchment 2014-2018,
    White Non Hispanic only, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_reds4)

ggsave("mortality_disparity_usa_az_catchment_white.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# mortality disparities for hispanic in catchment
mortality_catch_disp_hisp <- read_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities_hispanic.rds")

mortality_catch_disp_hisp$area <- as.factor(mortality_catch_disp_hisp$area)

mortality_catch_disp_hisp$area <- ordered(mortality_catch_disp_hisp$area, levels = c("US", "AZ", "Catchment", "Hispanic"))

levels(mortality_catch_disp_hisp$area)

ggplot(data = mortality_catch_disp_hisp, mapping = aes(x = rate, y = reorder(cancer, rate), fill = area)) +
  geom_bar(position = "dodge", stat = "identity", color = "black") +
  labs(
    title = "Cancers for Hispanic in Catchment with Mortality Greater than US",
    subtitle = "Comparing US, AZ, UAZCC Catchment 2014-2018,
    Hispanic only, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_reds4)

ggsave("mortality_disparity_usa_az_catchment_hisp.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)

# mortality disparities for American Indian in catchment
mortality_catch_disp_ai <- read_rds("data/tidy/uazcc_mortality_table_2014-2018_disparities_ai.rds")

mortality_catch_disp_ai$area <- as.factor(mortality_catch_disp_ai$area)

mortality_catch_disp_ai$area <- ordered(mortality_catch_disp_ai$area, levels = c("US", "AZ", "Catchment", "American_Indian"))

levels(mortality_catch_disp_ai$area)

ggplot(data = mortality_catch_disp_ai, mapping = aes(x = rate, y = reorder(cancer, rate), fill = area)) +
  geom_bar(position = "dodge", stat = "identity", color = "black") +
  labs(
    title = "Cancers for American Indian in Catchment with Mortality Greater than US",
    subtitle = "Comparing US, AZ, UAZCC Catchment 2014-2018,
    American Indian only, Male and Female",
    y = "",
    x = "Age Adjusted Rate per 100,000",
    caption = "Source: Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov)"
  ) +
  theme_clean() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = uaz_reds4)

ggsave("mortality_disparity_usa_az_catchment_ai.svg",
       width = 20,
       height = 11.25,
       device = svg,
       path = "figures/graphics/",
       scale = .5
)






# DEMOGRAPHICS ----

# Chart of Rate of New Cancers, All Races/Ethnicities, Both Sexes ----
# All Types of Cancer, catchment, 2013-2017

# read data




# Chart of Rate of New Cancers by Race/Ethnicity, Both Sexes ----
# All Types of Cancer, United States, 2013-2017



# Chart of Rate of New Cancers by Age Group (years), All Races, Both Sexes ----
# All Types of Cancer, United States, 2013-2017



# Chart of Rate of New Cancers by Sex and Race/Ethnicity ----
# All Types of Cancer, United States, 2013-2017



# TRENDS ----

# trend line chart Annual Rates of New Cancers, 1999-2017 ----
# Changes Over Time: All Types of Cancer
# New Cancers, All Ages, All Races/Ethnicities, Both Sexes




# bar chart Annual Number of New Cancers, 1999-2017 ----
# Changes Over Time: All Types of Cancer
# New Cancers, All Ages, All Races/Ethnicities, Both Sexes


# Map of Nationwide Changes in Rates of New Cancers, 1999-2017 ----
# Changes Over Time: All Types of Cancer
# New Cancers, All Ages, All Races/Ethnicities, Both Sexes


# RISK FACTORS alcohol ----

# Rate of New Alcohol-associated Cancers by Cancer Type
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# Rate of New Alcohol-associated Cancers by State
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# Rate of New Alcohol-associated Cancers by Race/Ethnicity
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# Rate of New Alcohol-associated Cancers by Age Group (years)
# Alcohol-associated Cancers
# All Alcohol-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS HPV ----

# Rate of New HPV-associated Cancers by Cancer Type
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# Rate of New HPV-associated Cancers by State
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# Rate of New HPV-associated Cancers by Race/Ethnicity
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# Rate of New HPV-associated Cancers by Age Group (years)
# HPV-associated Cancers
# All HPV-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS obesity  ----

# Rate of New obesity-associated Cancers by Cancer Type
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# Rate of New obesity-associated Cancers by State
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# Rate of New obesity-associated Cancers by Race/Ethnicity
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# Rate of New obesity-associated Cancers by Age Group (years)
# obesity-associated Cancers
# All obesity-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS physical inactivity  ----

# Rate of New physical inactivity-associated Cancers by Cancer Type
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# Rate of New physical inactivity-associated Cancers by State
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# Rate of New physical inactivity-associated Cancers by Race/Ethnicity
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# Rate of New physical inactivity-associated Cancers by Age Group (years)
# physical inactivity-associated Cancers
# All physical inactivity-associated Cancers, Male and Female, United States, 2017



# RISK FACTORS tobacco   ----

# Rate of New tobacco -associated Cancers by Cancer Type
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017



# Rate of New tobacco -associated Cancers by State
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017



# Rate of New tobacco -associated Cancers by Race/Ethnicity
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017



# Rate of New tobacco -associated Cancers by Age Group (years)
# tobacco -associated Cancers
# All tobacco -associated Cancers, Male and Female, United States, 2017

# Cancer incidence and death rates by race & ethnicity, both sexes, all types of cancer ####
uscs_az <- read_rds("data/tidy/uscs_by_state_az.rds")

glimpse(uscs_az)

# bar chart
uscs_az %>%
  filter(year == "2014-2018",
         sex == "Male and Female",
         site == "All Cancer Sites Combined") %>%
  ggplot(mapping = aes(x = race, y = age_adjusted_rate, fill = event_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(mapping = aes(ymin = age_adjusted_ci_lower, ymax = age_adjusted_ci_upper), position = "dodge", color = "#70B865") +
  coord_flip() +
  labs(title = "Arizona Cancer Incidence and Death Rates",
       subtitle = "2014-2018, By Race and Ethnicity, Both Sexes",
       x = "Race and Ethnicity",
       y = "Age adjusted rate per 100,000",
       fill = "",
       caption = "Source: U.S. Cancer Statistics 2001–2018") +
  scale_fill_manual(values = uaz_red_blue) +
  theme_uazcc_brand

  ggsave(
    filename = "figures/charts/cancer_incidence_death_rates_by_race.svg",
    device = "svg"
  )

# data table
uscs_az %>%
  filter(year == "2014-2018",
         sex == "Male and Female",
         site == "All Cancer Sites Combined") %>%
  select(event_type, race, age_adjusted_rate) %>%
  arrange(event_type, race) %>%
  group_by(event_type) %>%
  gt() %>%
  tab_header(
    title = "Arizona Cancer Incidence and Death Rates",
    subtitle = "2014-2018, By Race and Ethnicity, Both Sexes"
  ) %>%
  cols_label(race = "Race",
             age_adjusted_rate = "Age adjusted rate") %>%
  tab_source_note(source_note = "Source: U.S. Cancer Statistics 2001–2018") %>%
  gtsave(
    filename = "figures/charts/cancer_incidence_death_rates_table_by_race.png",
    expand = 10
  )

# Cancer incidence and death rates by race & ethnicity, male, all types of cancer ####
# bar chart
uscs_az %>%
  filter(year == "2014-2018",
         sex == "Male",
         site == "All Cancer Sites Combined") %>%
  ggplot(mapping = aes(x = race, y = age_adjusted_rate, fill = event_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(mapping = aes(ymin = age_adjusted_ci_lower, ymax = age_adjusted_ci_upper), position = "dodge", color = "#70B865") +
  coord_flip() +
  labs(title = "Arizona Cancer Incidence and Death Rates",
       subtitle = "2014-2018, By Race and Ethnicity, Male",
       x = "Race and Ethnicity",
       y = "Age adjusted rate per 100,000",
       fill = "",
       caption = "Source: U.S. Cancer Statistics 2001–2018") +
  scale_fill_brewer(palette = "Pastel1") +
  theme_uazcc_brand

ggsave(
  filename = "figures/charts/cancer_incidence_death_rates_by_race_male.svg",
  device = "svg"
)

# data table
uscs_az %>%
  filter(year == "2014-2018",
         sex == "Male",
         site == "All Cancer Sites Combined") %>%
  select(event_type, race, age_adjusted_rate) %>%
  arrange(event_type, race) %>%
  group_by(event_type) %>%
  gt() %>%
  tab_header(
    title = "Arizona Cancer Incidence and Death Rates",
    subtitle = "2014-2018, By Race and Ethnicity, Male"
  ) %>%
  cols_label(race = "Race",
             age_adjusted_rate = "Age adjusted rate") %>%
  tab_source_note(source_note = "Source: U.S. Cancer Statistics 2001–2018") %>%
  gtsave(
    filename = "figures/charts/cancer_incidence_death_rates_table_by_race_male.png",
    expand = 10
  )

# Cancer incidence and death rates by race & ethnicity, female, all types of cancer ####
# bar chart
uscs_az %>%
  filter(year == "2014-2018",
         sex == "Female",
         site == "All Cancer Sites Combined") %>%
  ggplot(mapping = aes(x = race, y = age_adjusted_rate, fill = event_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(mapping = aes(ymin = age_adjusted_ci_lower, ymax = age_adjusted_ci_upper), position = "dodge", color = "#70B865") +
  coord_flip() +
  labs(title = "Arizona Cancer Incidence and Death Rates",
       subtitle = "2014-2018, By Race and Ethnicity, Female",
       x = "Race and Ethnicity",
       y = "Age adjusted rate per 100,000",
       fill = "",
       caption = "Source: U.S. Cancer Statistics 2001–2018") +
  scale_fill_brewer(palette = "Pastel2") +
  theme_uazcc_brand

ggsave(
  filename = "figures/charts/cancer_incidence_death_rates_by_race_female.png",
  device = "png"
)

# data table
uscs_az %>%
  filter(year == "2014-2018",
         sex == "Female",
         site == "All Cancer Sites Combined") %>%
  select(event_type, race, age_adjusted_rate) %>%
  arrange(event_type, race) %>%
  group_by(event_type) %>%
  gt() %>%
  tab_header(
    title = "Arizona Cancer Incidence and Death Rates",
    subtitle = "2014-2018, By Race and Ethnicity, Female"
  ) %>%
  cols_label(race = "Race",
             age_adjusted_rate = "Age adjusted rate") %>%
  tab_source_note(source_note = "Source: U.S. Cancer Statistics 2001–2018") %>%
  gtsave(
    filename = "figures/charts/cancer_incidence_death_rates_table_by_race_female.png",
    expand = 10
  )

# map of incidence and mortality ####
by_az_county_sf <- read_rds("data/tidy/ucsc_by_county_spatial.rds")

glimpse(by_az_county_sf)
class(by_az_county_sf)

by_az_county_sf %>%
  filter(event_type == "Incidence",
         race == "All Races",
         sex == "Male and Female",
         site == "All Cancer Sites Combined") %>%
  ggplot() +
  geom_sf(mapping = aes(fill = age_adjusted_rate)) +
  labs(title = "Arizona Cancer Incidence Rates",
       subtitle = "2014-2018, By AZ County, Both Sexes, All Races",
       x = "",
       y = "",
       fill = "Age adjusted rate per 100,000",
       caption = "Source: U.S. Cancer Statistics 2001–2018") +
  scale_fill_viridis_c() +
  theme_uazcc_brand_spatial

ggsave(
  filename = "figures/maps/uscs_incidence_by_county.svg",
  device = "svg",
  scale = 2
)

by_az_county_sf %>%
  filter(event_type == "Mortality",
         race == "All Races",
         sex == "Male and Female",
         site == "All Cancer Sites Combined") %>%
  ggplot() +
  geom_sf(mapping = aes(fill = age_adjusted_rate)) +
  labs(title = "Arizona Cancer Mortality Rates",
       subtitle = "2014-2018, By AZ County, Both Sexes, All Races",
       x = "",
       y = "",
       fill = "Age adjusted rate per 100,000",
       caption = "Source: U.S. Cancer Statistics 2001–2018") +
  scale_fill_viridis_c() +
  theme_uazcc_brand_spatial

ggsave(
  filename = "figures/maps/uscs_mortality_by_county.svg",
  device = "svg",
  scale = 2
)
