# server.R

# Things to do: add widget for month; implement widget for hours
#               explore other mapping options that allow spatial analysis
#               combine with coordinates for places like bars/pubs/clubs, etc.
#               use leafletProxy() to prevent the map from completely redrawing every time
#                 input changes

library(leaflet)
library(dplyr)
crime15 <- read.csv("../output/crime15.csv")
crime15 <- tbl_df(crime15)

shinyServer(function(input, output) {
  
  # reads in subsets of the data
  dataInput <- reactive({
    filter(crime15, Offense %in% input$offense, Day.of.Week %in% input$day_of_week)
  })
  
  # draws the basic map
  leafletInput <- reactive({
    leaflet() %>% addProviderTiles("CartoDB.DarkMatter") %>%
                  setView(lat = 40.74196, lng = -73.86483, zoom = 11)
  })
  
  # adds markers if any offense is checked
  markersInput <- reactive({
    if (is.null(input$offense) | is.null(input$day_of_week)) return(leafletInput()) 
    leafletInput() %>% addMarkers(data = dataInput())
                                 
  })
  
  # renders the map
  output$map <- renderLeaflet({
    markersInput()
  })
  }
)
