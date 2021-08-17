# seer stat exports

# set up ----
# load packages
library(here)
library(tidyverse)
# library(knitr)

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
