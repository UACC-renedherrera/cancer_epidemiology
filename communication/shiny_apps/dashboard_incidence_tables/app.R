# Load packages ----
library(shiny)
library(tidyverse)

# Load data ---- 
incidence_table <- read_rds("data/incidence_table.rds")

# Source helper functions ---- 
# source("communication/shiny_apps/dashboard_incidence_tables/dashboard_prep_data_incidence.R")

# User interface ---- 
ui <- fluidPage(
    titlePanel("Incidence Table"),

    # Create a new Row in the UI for selectInputs
    fluidRow(
        column(4,
               selectInput("race",
                           "Race:",
                           c("All",
                             unique(as.character(incidence_table$race))))
        ),
        column(4,
               selectInput("sex",
                           "Sex:",
                           c("All",
                             unique(as.character(incidence_table$sex))))
        ),
        column(4,
               selectInput("site",
                           "Cancer Site:",
                           c("All",
                             unique(as.character(incidence_table$site))))
        ),
        column(4,
               selectInput("area",
                           "Geography:",
                           c("All",
                             unique(as.character(incidence_table$area))))
        )
    ),
    # Create a new row for the table.
    DT::dataTableOutput("table")
)


# Server logic ---- 
server <- function(input, output) {

    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        data <- incidence_table
        if (input$race != "All") {
            data <- data[data$race == input$race, ]
        }
        if (input$sex != "All") {
            data <- data[data$sex == input$sex, ]
        }
        if (input$site != "All") {
            data <- data[data$site == input$site, ]
        }
        if (input$area != "All") {
            data <- data[data$area == input$area, ]
        }
        data
    },
    rownames = FALSE))

}


# Run app ---- 
shinyApp(ui = ui, server = server)
