# packages
library(shiny)
library(tidyverse)

# load data 
cancer_rate_data <- read_rds("data/rate_data_table.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
    title = "Incidence and Mortality Age Adjusted Rates",
    titlePanel(title = "Incidence and Mortality Age Adjusted Rates for the University of Arizona Cancer Center",
               windowTitle = "Incidence and Mortality Age Adjusted Rates for the University of Arizona Cancer Center"),
    h1("Data Table"),
    
    fluidRow(
        
        column(4,
               selectInput(inputId = "event_type",
                           label = "Choose an event type",
                           choices = c("All",
                                       unique(as.character(cancer_rate_data$event_type))))),
        
        column(4,
               selectInput(inputId = "area",
                    label = "Choose an area to display",
                    choices = c("All",
                                unique(as.character(cancer_rate_data$area))))),
        
        column(4,
               selectInput(inputId = "source",
                           label = "Choose a data source",
                           choices = c("All",
                                       unique(as.character(cancer_rate_data$source))))),
        
        column(4,
               selectInput(inputId = "race",
                           label = "Choose a race category to display",
                           choices = c("All",
                                       unique(as.character(cancer_rate_data$race))))),
        
        column(4,
               selectInput(inputId = "sex",
                           label = "Choose a sex category to display",
                           choices = c("All",
                                       unique(as.character(cancer_rate_data$sex))))),
        
        column(4,
               selectInput(inputId = "site",
                           label = "Choose a cancer site to display",
                           choices = c("All",
                                       unique(as.character(cancer_rate_data$site))))),
        
        column(4,
               selectInput(inputId = "site_group",
                           label = "Choose a cancer site group to display",
                           choices = c("All",
                                       unique(as.character(cancer_rate_data$site_group))))),
        
        ),
    
    DT::dataTableOutput("table"),
    
    h1("Map")
    
        )


# Define server logic required to draw a histogram
server <- function(input, output) {

    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        
        data <- cancer_rate_data
        
        if (input$event_type != "All") {
            data <- data[data$event_type == input$event_type, ]
        }
        if (input$area != "All") {
            data <- data[data$area == input$area, ]
        }
        if (input$source != "All") {
            data <- data[data$source == input$source, ]
        }
        if (input$race != "All") {
            data <- data[data$race == input$race, ]
        }
        if (input$sex != "All") {
            data <- data[data$sex == input$sex, ]
        }
        if (input$site != "All") {
            data <- data[data$site == input$site, ]
        }
        if (input$site_group != "All") {
            data <- data[data$site_group == input$site_group, ]
            data <- data %>% drop_na(site_group)
        }
        
        data
    },
    
    rownames = FALSE))
    
    
}


# Run the application 
shinyApp(ui = ui, server = server)
