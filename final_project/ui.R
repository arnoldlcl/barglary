library(shiny)
library(maps)
library(mapproj) 
# server.R

library(leaflet)
library(dplyr)
library(sp)
library(rgdal)

shinyUI(fluidPage(
   # titlePanel(h1("Crime Radar",align="center")),
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    "))
    ),
  
  titlePanel(fluidRow(column(4,HTML("<style>h1{font-family: 'Lobster', cursive;
                font-weight: 500; line-height: 1.1; 
                  color: #4d3a7d;}</style><h1><img src='logo.png' width='100' height='100'>  Crime Radar</h1>")),
                      column(8,h3("BREAKING NEWS: ", span(" One killed, two wounded in shooting near Penn Station, witnesses say dispute started in McDonald's known as a junkie hangout.", style = "font-weight: 300"), 
                                  style = "font-family: 'Arial Black';
                                  color: #fff; text-align: center;
                                  background-image: url('texturebg.png');
                                  padding: 20px"))
                      )
            ),

  sidebarLayout(#position = "right",
  sidebarPanel(
    tags$div(HTML("<strong><h4> Step 1:if you have no specific bar</h4> </strong>") ),                 
    textInput("nta", HTML(" <h6>Input a neiborhood where you want to go</h6>"), "East Village"),
    tags$div(HTML("<strong><h4> Step 2:if you want to check whether the bar is safe </h4> </strong>") ),
    textInput("bar", HTML(" <h6>Input the bar's name</h6>"), "HARLEM TAVERN"),
    
    
    helpText(HTML("<h6>Note: Rape offenses are geocoded as occurring in the precinct in which the incident was recorded.</h6>")),
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
    tabsetPanel(
      tabPanel('General',
               fluidRow(column(7,leafletOutput("general",height=700)),
                        column(5,leafletOutput("density",height=700)))
              ),
      tabPanel('Ranking',
              textOutput("mapped")
               ),
      tabPanel('Map',
               htmlOutput("map")),
      tabPanel('Analysis',
               plotOutput("statistics")),
      tabPanel('About Crime Radar', HTML("
                                   <h4>
                                     What is TripAid
                                     </h4>
                                     <p>
                                     This web application, developed in spring 2016 at Cornell Tech, is mainly for NYC travelers who come to NYC for the first time. It's also very helpful for native residents who are not familiar with New York's medical sytem and need direct guidance to find the best hospital in NYC. Therefore, it also has several language versions.
                                     </p>
                                     <h4>
                                     Hightlight of TripAid
                                     </h4>
                                     <p>
                                     In general, the application is an HCI product developed in R studio with Shiny. The hightlight of this product is its ability to provide users the comprehensive ranking of all NYC hospitals given their health emergency and insurance status. 
                                     </p>
                                     <br/>
                                     <p>
                                     To be more specific, the features of our interest include how far awary the hospital is from the user, total expense, waiting time for an ER, historical diseases cases and number of days in hospital. 
                                     </P>
                                     <br/>
                                     <p>
                                     To make user experience much better, especially for those in emergence status, we set all settings suitable for them in default. This enables them to find the nearest as well as the top ranking hospitals in much shorter time. 
                                     </p>
                                     <br/>
                                     <p>
                                     Users could see the result in a module with google map, which shows thier location and suggests hospitals at the same time. 
                                     </p>
                                     <h4>
                                     Future Expectations
                                     </h4>
                                     <p>
                                     We are also looking forward to develop a similar iOS/Android app, which is more user friendly.
                                     </p>
                                     
                                     ")),
      
      tabPanel('Get to Know US', HTML("
                                      <h4>   About Us!  </h4>
                                      <p>
                                      We are all Master students from Statistics Department of Columbia University, expected to graduate at Dec. 2016.
                                      </p>
                                      
                                      <h4>   Team Members </h4>
                                      <p>
                                      Aoyuan Liao, Jingwei Li, Wen Ren, Yanran Wang, Ao liu, Duanhong Gao. 
                                      </p>
                                      <br/>
                                      <p>
                                      For questions or feedback, please email <a href='mailto:al3468@columbia.edu'>al3468@columbia.edu</a>.
                                      </p>
                                      "
                                      
      )))
  ))
))