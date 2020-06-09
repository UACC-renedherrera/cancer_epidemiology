# set up ---- 
# load packages 
library(here)
library(tidyverse)
library(knitr)
library(ggthemes)

# load data to environment 
azdhs_catch_2016 <- read_rds("data/tidy/azdhs_catchment_2012-2016_incidence_by_cancer.rds")
azdhs_catch_2017 <- read_rds("data/tidy/azdhs_catchment_2013-2017_incidence_by_cancer.rds")


azdhs <- bind_rows(azdhs_catch_2016, azdhs_catch_2017)

azdhs %>% 
  group_by(Year, Sex) %>%
  filter(Cancer != "All") %>%
  arrange(desc(Age_Adj_Rate)) %>%
  slice(1:5) %>%
  ggplot(mapping = aes(x = Cancer, y = Age_Adj_Rate, fill = Year)) +
  geom_col(position = "dodge") +
  coord_flip() +
  facet_wrap("Sex")
