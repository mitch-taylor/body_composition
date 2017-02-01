# BODY COMPOSITION APP
# TO ADD:
# Where criteria on plots
# Saving to file
# Ability to edit data in table

library(shiny); library(plotly)

# Define UI for application models titanic data using CART
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Body Composition Tracking"),
    
    # Sidebar with user input for date and weight
    sidebarLayout(
        sidebarPanel(
            dateInput("date", "Date:", Sys.Date()),
            numericInput("weight", "Weight:", 180),
            numericInput("bf", "Body Fat %:", 0.23),
            numericInput("sm", "Skeletal Muscle %:", 0.38),
            numericInput("vf", "Visceral Fat:", 7),
            actionButton("submit", "Submit")
        ),
        # Plot Weight
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Data", dataTableOutput('datatable')), 
                        tabPanel("Weight", plotlyOutput('weightplot')),
                        tabPanel("Body Fat", plotlyOutput('bfplot')),
                        tabPanel("Skeletal Muscle", plotlyOutput('smplot')),
                        tabPanel("Body Composition", plotlyOutput('bcplot'))
            )
        )
    )
))
