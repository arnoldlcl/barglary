# ui.R

library(leaflet)
library(dplyr)
library(sp)
library(rgdal)

shinyUI(fluidPage(
  titlePanel("NYC Felony Incidents Jan - Sep 2015"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Note: Rape offenses are geocoded as occurring in the precinct in which the incident was recorded."),
      # widget for offenses
      checkboxGroupInput("offense", label = "Offense",
                         choices = c("BURGLARY", "FELONY ASSAULT", "GRAND LARCENY",
                                     "GRAND LARCENY OF MOTOR VEHICLE", "MURDER", 
                                     "RAPE", "ROBBERY"),
                         selected = c("BURGLARY", "FELONY ASSAULT", "GRAND LARCENY",
                                      "GRAND LARCENY OF MOTOR VEHICLE", "MURDER",
                                      "ROBBERY")),
      # widgets for hours
      sliderInput("min_hour", label = "From this hour:",
                  min = 0, max = 23, value = 0, step = 1),
      sliderInput("max_hour", label = "To this hour:",
                  min = 0, max = 23, value = 23, step = 1),
      # widget for date range
      dateRangeInput("date", label = "Select dates:",
                     start = "2015-01-01", end = "2015-09-30",
                     min = "2015-01-01", max = "2015-09-30",
                     separator = "until"),
      # widget for day of the week
      checkboxGroupInput("day_of_week", label = "Days of the Week",
                         choices = c("Sunday", "Monday", "Tuesday", "Wednesday",
                                     "Thursday", "Friday", "Saturday"),
                         selected = c("Sunday", "Monday", "Tuesday", "Wednesday",
                                      "Thursday", "Friday", "Saturday"))
    ),
    
    mainPanel(
      textOutput("map_guidelines"),
      leafletOutput("map"))
  )
))