### BODY COMPOSITION APP

library(shiny)

# Create dummy data
date <- seq(as.Date("2017/1/1"), as.Date("2017/1/10"), "days")
weight <- 180:171
bf <- seq(23, 22.1, -0.1)
sm <- seq(37, 37.9, 0.1)
data <- data.frame(date = as.Date(date, origin="1970-01-01"), weight, bf, sm)

# Define server logic
shinyServer(function(input, output) {
    values <- reactiveValues(df_data = data)
    
    observeEvent(input$submit, {
        tmp <- data.frame(date = as.Date(input$date, origin="1970-01-01"), 
                          weight = input$weight, bf = input$bf, sm = input$sm)
        values$df_data <- rbind(values$df_data, tmp)
    })    
    
    calculate <- reactive({
        values$df_data$bodycomp <- values$df_data$sm / values$df_data$bf
        values$df_data$weight_7ma <- SMA(values$df_data$weight, 7)
        values$df_data$bf_7ma <- SMA(values$df_data$bf, 7)
        values$df_data$sm_7ma <- SMA(values$df_data$sm, 7)
        values$df_data$bc_7ma <- SMA(values$df_data$bodycomp, 7)
    })
    
    # view table
    output$datatable = renderDataTable({
        values$df_data
    })
    
    # weight plot
    output$weightplot = renderPlotly({
        calculate()
        plot_ly(values$df_data, x = ~date, y = ~weight, 
                type = "scatter", mode = "lines") %>%
        add_trace(y = ~weight_7ma, name = 'MA7', mode = 'lines')
    })
    
    # bodyfat plot
    output$bfplot = renderPlotly({
        calculate()
        plot_ly(values$df_data, x = ~date, y = ~bf, 
                type = "scatter", mode = "lines") %>%
            add_trace(y = ~bf_7ma, name = 'MA7', mode = 'lines')
    })
    
    # skeletal muscle plot
    output$smplot = renderPlotly({
        calculate()
        plot_ly(values$df_data, x = ~date, y = ~sm, 
                type = "scatter", mode = "lines") %>%
            add_trace(y = ~sm_7ma, name = 'MA7', mode = 'lines')
    })
    
    # bodycomp plot
    output$bcplot = renderPlotly({
        calculate()
        plot_ly(values$df_data, x = ~date, y = ~bodycomp, 
                type = "scatter", mode = "lines") %>%
            add_trace(y = ~bc_7ma, name = 'MA7', mode = 'lines')
    })
    
})

