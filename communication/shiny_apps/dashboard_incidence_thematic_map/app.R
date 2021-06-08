# load packages 
library(tidyverse)
library(shiny)
library(leaflet)
library(sf)

# load data 
incidence_spatial <- read_rds("data/incidence_spatial.rds")

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

# User inteface 
ui <- fluidPage(
    titlePanel("Cancer Incidence"),
    leafletOutput("mymap"),
    p()
)

# server
server <- function(input, output, session) {
    
    points <- eventReactive(input$recalc, {
        cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
    
    output$mymap <- renderLeaflet({
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
    })
}

# run app 
shinyApp(ui, server)