### BODY COMPOSITION APP

library(shiny); library(TTR)

setwd("C:/Users/MT84249/Desktop/personal/coursera/data_products/body_composition")
data <- read.csv("weight_data.csv")
data$date <- as.Date(data$date, format = "%m/%d/%Y")

# Define server logic
shinyServer(function(input, output) {
    values <- reactiveValues(df_data = data)
    values <- reactiveValues(df_data_analysis = data)
    
    observeEvent(input$submit, {
        tmp <- data.frame(date = as.Date(input$date, origin="1970-01-01"), 
                          weight = input$weight, bf = input$bf, sm = input$sm,
                          vf = input$vf)
        values$df_data <- rbind(values$df_data, tmp)
        values$df_data_analysis <- values$df_data
        calculate()
    })    
    
    calculate <- reactive({
        values$df_data_analysis$bodycomp <- values$df_data_analysis$sm / values$df_data_analysis$bf
        values$df_data_analysis$weight_7ma <- SMA(values$df_data_analysis$weight, 7)
        values$df_data_analysis$bf_7ma <- SMA(values$df_data_analysis$bf, 7)
        values$df_data_analysis$sm_7ma <- SMA(values$df_data_analysis$sm, 7)
        values$df_data_analysis$bc_7ma <- SMA(values$df_data_analysis$bodycomp, 7)
    })
    
    # view table
    output$datatable = renderDataTable({
        calculate()
        values$df_data_analysis
    })
    
    # weight plot
    output$weightplot = renderPlotly({
        calculate()
        plot_ly(values$df_data_analysis, x = date, y = weight, 
                type = "scatter", mode = "lines") %>%
        add_trace(x = date, y = weight_7ma, name = 'MA7', mode = 'lines')
    })
    
    # bodyfat plot
    output$bfplot = renderPlotly({
        calculate()
        plot_ly(values$df_data_analysis, x = date, y = bf, 
                type = "scatter", mode = "lines") %>%
            add_trace(x = date, y = bf_7ma, name = 'MA7', mode = 'lines')
    })
    
    # skeletal muscle plot
    output$smplot = renderPlotly({
        calculate()
        plot_ly(values$df_data_analysis, x = date, y = sm, 
                type = "scatter", mode = "lines") %>%
            add_trace(x = date, y = sm_7ma, name = 'MA7', mode = 'lines')
    })
    
    # bodycomp plot
    output$bcplot = renderPlotly({
        calculate()
        plot_ly(values$df_data_analysis, x = date, y = bodycomp, 
                type = "scatter", mode = "lines") %>%
            add_trace(x = date, y = bc_7ma, name = 'MA7', mode = 'lines')
    })
    
})

class(data$date)
