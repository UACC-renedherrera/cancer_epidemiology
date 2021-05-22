#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load the ggplot2 package which provides
# the 'mpg' dataset.
#library(ggplot2)
library(shiny)
library(tidyverse)

incidence_table_usa_az <- read_rds("data/tidy/dashboard_incidence_table_usa_az.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Incidence Table"),
    
    # Create a new Row in the UI for selectInputs
    fluidRow(
        column(4,
               selectInput("race",
                           "Race:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$RACE))))
        ),
        column(4,
               selectInput("sex",
                           "Sex:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$SEX))))
        ),
        column(4,
               selectInput("site",
                           "Cancer Site:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$SITE))))
        ),
        column(4,
               selectInput("area",
                           "Geography:",
                           c("All",
                             unique(as.character(incidence_table_usa_az$AREA))))
        )
    ),
    # Create a new row for the table.
    DT::dataTableOutput("table")
)



# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        data <- incidence_table_usa_az
        if (input$race != "All") {
            data <- data[data$RACE == input$RACE,]
        }
        if (input$sex != "All") {
            data <- data[data$SEX == input$SEX,]
        }
        if (input$site != "All") {
            data <- data[data$SITE == input$SITE,]
        }
        if (input$AREA != "All") {
            data <- data[data$AREA == input$AREA,]
        }
        data
    }))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
