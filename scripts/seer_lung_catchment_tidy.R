# seer stat exports

# set up ----
# load packages
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
    plot.caption = element_text(size = 8),
    # plot.subtitle = element_text(size = 12),
    # plot.title = element_text(size = 14),
    strip.background = element_rect(fill = "#EcE9EB")
  )


# this needs to be rates not cases; 
# get the correct data 

#### MORTALITY UAZCC Catchment ####
#
# citation: 

lung_mort <- read_delim("data/raw/seer_stat/mortality_catchment_lung_cancer.txt",
                                      delim = ",",
                                      col_names = c(
                                        "race",
                                        "sex",
                                        "estimate"
                                      ),
                                      col_types = cols(
                                        "race" = col_factor(),
                                        "sex" = col_factor(),
                                        "estimate" = col_number()
                                      ),
                                      na = c("", "^", "NA")
)

lung_mort

# plot 
lung_mort %>%
  filter(race != "All races",
         sex != "Male and female") %>%
  drop_na() %>%
  ggplot(mapping = aes(x = race, y = estimate)) %>%
  geom_bar(mapping = aes(fill = sex), position = "dodge")
