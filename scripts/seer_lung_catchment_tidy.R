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
    plot.caption = element_text(size = 10),
    # plot.subtitle = element_text(size = 12),
    # plot.title = element_text(size = 14),
    strip.background = element_rect(fill = "#EcE9EB")
  )


# this needs to be rates not cases; 
# get the correct data 

#### lung MORTALITY UAZCC Catchment ####
# {Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years','Unknown'
# {Race, Sex, Year Dth, State, Cnty, Reg.Race recode (White, Black, Other)} = 'All races','  White','  Black','  Other (American Indian/AK Native, Asian/Pacific Islander)','  Other unspecified (1978-1991)'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2015-2019'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
# AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
# {Site and Morphology.Cause of death recode} = '      Lung and Bronchus'

#
# citation: underlying mortality data by NCHS 
# Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1969-2019) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2019 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released April 2021.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).

lung_mort <- read_delim("data/raw/seer_stat/mortality_lung_catchment_2014-2018_by_race.txt",
                                      delim = ",",
                                      col_names = c(
                                        "race",
                                        "sex",
                                        "rate",
                                        "count",
                                        "population"
                                      ),
                                      col_types = cols(
                                        "race" = col_factor(),
                                        "sex" = col_factor(),
                                        "rate" = col_number(),
                                        "count" = col_number(),
                                        "population" = col_number()),
                                      na = c("", "^", "NA")
)

lung_mort

# plot 
lung_mort %>%
  filter(race != "All races",
         sex != "Male and female") %>%
  drop_na() %>%
  ggplot(mapping = aes(x = race, y = rate)) +
  geom_col(mapping = aes(fill = sex), position = "dodge") +
  labs(title = "Lung Cancer Mortality in the UA Catchment",
       subtitle = "Years 2015-2019",
       x = "Race",
       y = "Age Adjusted Rate per 100,000",
       fill = "Sex",
       caption = "Source: SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1969-2019). 
       Underlying mortality data provided by NCHS (www.cdc.gov/nchs).") +
  scale_fill_brewer(palette = "Dark2") +
  theme_uazcc_brand

ggsave("figures/charts/uazcc_lung_mortality_2015-2019_by_race.png",
       width = 16,
       height = 9)
