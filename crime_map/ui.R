library(shiny)
shinyUI(fluidPage(
  titlePanel(h1("Crime Explorer",align="center")),
  sidebarPanel(
     
             selectInput("crime_type", label = h3("Crime Type"), 
                         choices = list("ROBBERY" = "ROBBERY", "GRAND LARCENY" = "GRAND LARCENY",
                                        "FELONY ASSAULT" = "FELONY ASSAULT","MURDER" ="MURDER",
                                        "RAPE" = "RAPE","BURGLARY" = "BURGLARY",
                                        "GRAND LARCENY OF MOTOR VEHICLE" = "GRAND LARCENY OF MOTOR VEHICLE","ALL" ="ALL"), selected = "ALL"),
      
       
             sliderInput("time", label = h3("Occurance Time"),
                         min = 0, max = 100, value = c(0,100)),
             
             selectInput("month", label = h3("Month"), 
                         choices = list("Jan" = "Jan", "Feb" = "Feb",
                                        "Mar" = "Mar","Apr" = "Apr",
                                        "May" = "May","Jun" = "Jun",
                                        "Jul" = "Jul","Aug" = "Aug",
                                        "Sep" = "Sep","Oct" = "Oct",
                                        "Nov" = "Nov","Dec" = "Dec",
                                        "All"= "All"), selected = "All"),
             
             selectInput("weekday", label = h3("Day of Week"), 
                         choices = list("Mon" = "Mon", "Tue" = "Tue",
                                        "Wed" = "Wed","Thur" = "Thur",
                                        "Fri" = "Fri","Sat" = "Sat",
                                        "Sun" = "Sun","All" = "All"), selected = "All")
         
      ),
  mainPanel(
     textOutput("m"),
     plotOutput("map")
  )
))