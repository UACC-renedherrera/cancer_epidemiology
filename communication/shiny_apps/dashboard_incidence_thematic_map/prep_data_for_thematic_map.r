# Prepare data for display on data table 
# data table must display age adjusted cancer incidence rates of most recent 5 year average 
# René Dario Herrera 
# University of Arizona Cancer Center
# renedherrera at email dot arizona dot edu 
# May 2021

# set up ---- 
# load packages ----
library(here)
library(tidyverse)
library(leaflet)
library(tigris)
library(sf)
library(ggplot2)

# load county shapefiles for AZ ----
county_spatial <- counties(
  state = "04"
)

# inspect 
glimpse(county_spatial)
class(county_spatial)
st_crs(county_spatial)

# read data ---- 
incidence_table <- read_rds("communication/shiny_apps/dashboard_incidence_thematic_map/data/incidence_table.rds")

# inspect 
glimpse(incidence_table)

# filter incidence table to show only counties 
incidence_table <- incidence_table %>%
  filter(!(area == "US" | area == "Catchment" | area == "Arizona"),
         site == "All Cancer Sites Combined",
         sex == "Male and Female",
         race == "All Races")

# merge 
incidence_spatial <- geo_join(
  spatial_data = county_spatial,
  data_frame = incidence_table,
  by_sp = "NAME",
  by_df = "area"
)

#inspect
class(incidence_spatial)
glimpse(incidence_spatial)
st_crs(incidence_spatial)

# transform CRS for use with Leaflet 
incidence_spatial <- st_transform(incidence_spatial, '+proj=longlat +datum=WGS84')

# save to disk for use in shiny app 
write_rds(incidence_spatial, "communication/shiny_apps/dashboard_incidence_thematic_map/data/incidence_spatial.rds")

# need to know bins to set color palette for leaflet choropleth 
ggplot(data = incidence_table) +
  geom_histogram(mapping = aes(x = age_adjusted_rate), bins = 5)

# bins from histogram plot 
bins <- c(0, 250, 300, 350, 400, 450)

# set palette 
pal <- colorBin("viridis",
                domain = incidence_spatial$age_adjusted_rate,
                bins = bins)

# set labels 
labels <- sprintf(
  "<strong>%s</strong><br/>%g per 100,000",
  incidence_spatial$NAME, incidence_spatial$age_adjusted_rate
) %>% lapply(htmltools::HTML)

# generate leaflet visualization 
leaflet(data = incidence_spatial) %>%
  addProviderTiles("Stamen.TonerLite") %>%
  addPolygons(fillColor = ~pal(age_adjusted_rate),
              color = "white",
              fillOpacity = .7,
              weight = 1,
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "16px",
                direction = "auto"
              )) %>%
  addLegend(pal = pal, values = ~age_adjusted_rate, opacity = 0.7, title = NULL,
            position = "bottomright")
