# #
# # This is a Shiny web application. You can run the application by clicking
# # the 'Run App' button above.
# #
# # Find out more about building applications with Shiny here:
# #
# #    http://shiny.rstudio.com/
# #
# 
# library(shiny)
# 
# # Define UI for application that draws a histogram
# ui <- fluidPage(
# 
#     # Application title
#     titlePanel("Old Faithful Geyser Data"),
# 
#     # Sidebar with a slider input for number of bins 
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("bins",
#                         "Number of bins:",
#                         min = 1,
#                         max = 50,
#                         value = 30)
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#            plotOutput("distPlot")
#         )
#     )
# )
# 
# # Define server logic required to draw a histogram
# server <- function(input, output) {
# 
#     output$distPlot <- renderPlot({
#         # generate bins based on input$bins from ui.R
#         x    <- faithful[, 2]
#         bins <- seq(min(x), max(x), length.out = input$bins + 1)
# 
#         # draw the histogram with the specified number of bins
#         hist(x, breaks = bins, col = 'darkgray', border = 'white')
#     })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)

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