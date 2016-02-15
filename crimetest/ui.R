# ui.R

shinyUI(fluidPage(
  titlePanel("NYC Felony Incidents Jan - Sep 2015"),
  
  sidebarLayout(
    sidebarPanel(
      # widget for offenses
      checkboxGroupInput("offense", label = "Offense",
                         choices = c("BURGLARY", "FELONY ASSAULT", "GRAND LARCENY",
                                     "GRAND LARCENY OF MOTOR VEHICLE", "MURDER", 
                                     "RAPE", "ROBBERY")),
      # widget for hours
      sliderInput("hour", label = "Hours",
                  min = 0, max = 24, value = c(0, 24), step = 1),
      # widget for day of the week
      checkboxGroupInput("day_of_week", label = "Days of the Week",
                         choices = c("Sunday", "Monday", "Tuesday", "Wednesday",
                                     "Thursday", "Friday", "Saturday"))
    ),
    
    mainPanel(leafletOutput("map"))
  )
))