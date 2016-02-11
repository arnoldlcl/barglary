library(shiny)
library(maps)
library(mapproj) 
counties <- readRDS("data/counties.rds")
source("helpers.R")
shinyServer(function(input, output) {
  output$m<-renderText({
    print(input$crime_type)
    print(input$time[1])
    # ,input$month,input$weekday)
    
  })
  output$map<-renderPlot({

    data <- switch(input$crime_type, 
                   "ROBBERY" = counties$white,
                   "GRAND LARCENY" = counties$black,
                   "FELONY ASSAULT" = counties$hispanic,
                   "MURDER" = counties$asian)
    
    color <- switch(input$crime_type, 
                    "ROBBERY" = "darkgreen",
                    "GRAND LARCENY" = "black",
                    "FELONY ASSAULT" = "darkorange",
                    "MURDER" = "darkviolet")
    
    legend <- switch(input$crime_type, 
                     "ROBBERY" = "% White",
                     "GRAND LARCENY" = "% Black",
                     "FELONY ASSAULT" = "% Hispanic",
                     "MURDER" = "% Asian")
    
    percent_map(var = data, 
                color = color, 
                legend.title = legend, 
                max = input$time[2], 
                min = input$time[1])

  })
})