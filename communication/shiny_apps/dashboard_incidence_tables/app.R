# Load packages ----
library(shiny)
library(tidyverse)

# Load data ---- 
# incidence_table_usa_az <- read_rds("communication/shiny_apps/dashboard_incidence_tables/data/incidence_az_catch_2013-2017_table.rds")
incidence_table_usa_az <- read_rds("data/incidence_az_catch_2013-2017_table.rds")

# Source helper functions ---- 
# source("communication/shiny_apps/dashboard_incidence_tables/dashboard_prep_data_incidence.R")

# User interface ---- 
ui <- fluidPage(
    titlePanel("Incidence Table"),

    # Create a new Row in the UI for selectInputs
    fluidRow(
        column(4,
               selectInput("RACE",
                           "Race:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$RACE))))
        ),
        column(4,
               selectInput("SEX",
                           "Sex:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$SEX))))
        ),
        column(4,
               selectInput("SITE",
                           "Cancer Site:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$SITE))))
        ),
        column(4,
               selectInput("AREA",
                           "Geography:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$AREA))))
        )
    ),
    # Create a new row for the table.
    DT::dataTableOutput("table")
)


# Server logic ---- 
server <- function(input, output) {

    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        data <- incidence_table_usa_az
        if (input$RACE != "All") {
            data <- data[data$RACE == input$RACE, ]
        }
        if (input$SEX != "All") {
            data <- data[data$SEX == input$SEX, ]
        }
        if (input$SITE != "All") {
            data <- data[data$SITE == input$SITE, ]
        }
        if (input$AREA != "All") {
            data <- data[data$AREA == input$AREA, ]
        }
        data
    },
    rownames = FALSE))

}


# Run app ---- 
shinyApp(ui = ui, server = server)
