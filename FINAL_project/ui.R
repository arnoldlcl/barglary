library(shiny)
library(maps)
library(mapproj) 
# server.R

library(leaflet)
library(dplyr)
library(sp)
library(rgdal)

shinyUI(fluidPage(
   
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    "))
    ),
  
  titlePanel(fluidRow(column(4,HTML("<style>h1{font-family: 'Lobster', cursive;
                font-weight: 500; line-height: 1.1; 
                  color: #4d3a7d;}</style><h1><img src='logo.png' width='100' height='100'>  Barglary</h1>")),
                      column(8,h3("BREAKING NEWS: ", span(" One killed, two wounded in shooting near Penn Station, witnesses say dispute started in McDonald's known as a junkie hangout.", style = "font-weight: 300"), 
                                  style = "font-family: 'Arial Black';
                                  color: #fff; text-align: center;
                                  background-image: url('texturebg.png');
                                  padding: 20px"))
                      )
            ),

  sidebarLayout(#position = "right",
  sidebarPanel(
    tags$div(HTML("<strong><h4> If you have no specific bar in mind,</h4> </strong>") ),                 
    textInput("nta", HTML(" <h6>Input a neighborhood where you want to go, then click the Rankings tab to see a list of all liquor-licensed establishments along with crime rates per 10,000 people based on a 100m distance buffer.</h6>"), "East Village"),
    tags$div(HTML("<strong><h4> If you want to check whether a specific bar is safe </h4> </strong>") ),
    textInput("bar", HTML(" <h6>Input the bar's name, then click the Analysis tab to view a chart of the proportion of each type of felony that has taken place within 100m of that bar, and its percentile ranking among every establishment in New York City. Click the Map tab to view the bar in Google Maps.</h6>"), "HARLEM TAVERN"),
    
    
    helpText(HTML("<h6>Adjust checkboxes and sliders as needed. You can click on individual neighborhoods in the map on the right to view that neighborhood's name and crime density.</h6>")),
    # widget for offenses
    checkboxGroupInput("offense", label = "Offense",
                       choices = c("BURGLARY", "FELONY ASSAULT", "GRAND LARCENY",
                                   "GRAND LARCENY OF MOTOR VEHICLE", "MURDER", 
                                   "RAPE", "ROBBERY"),
                       selected = c("BURGLARY", "FELONY ASSAULT", "GRAND LARCENY",
                                    "GRAND LARCENY OF MOTOR VEHICLE", "MURDER",
                                    "ROBBERY")),
    helpText(HTML("<h6>Note: Rape offenses are geocoded as occurring in the precinct in which the incident was recorded.</h6>")),
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
               dataTableOutput("table1"),
               tags$style(type="text/css", '#myTable tfoot {display:none;}')),
      tabPanel('Map',
               htmlOutput("map")),
      tabPanel('Analysis',
               fluidRow(column(1,plotOutput("pieplot")),
                        column(12,plotOutput("barplot")))
      ),
      tabPanel('About Barglary', HTML("
                                   <h4>
                                     What is Barglary?
                                     </h4>
                                     <p>
                                     This web application, developed in spring 2016 at Columbia University, is mainly for New Yorkers who want to have fun at a safe bar. Sometimes the 'most dangerous' place may be the 'safest'. If you want to know whether the bar you are going to is in a safe area, just try Barglary!   
                                     </p>
                                     <h4>
                                     How it Works
                                     </h4>
                                     <p>
                                     Our app allows an interactive visualization of crime rates across different NYC neighborhoods by type of felony, date and time of occurrence, etc.
                                     </p>
                                     <p>
                                     As for bars: If you have no idea where you want to go, we can recommend some bars for you. If you are interested in a specific bar, just input the name of the bar and we will show you which types of crimes have occurred near the bar.
                                     </p>
                                     <p>
                                     To make user experience much better, we also show specific bars on Google Maps using their API. You can read lots of additional information about the bar, such as the address and overall evaluation rate. 
                                     </p>
                                     <p>
                                     The data comes from open NYPD incident-level data of felonies from Jan to Sept 2015 and from NY State open data on establishments with on-premises liquor licenses. 
                                     </p>
                                     <p>
                                     Incident-level data and individal liquor-licensed establishments were aggregated into NYC's Neighborhood Tabulation Areas via QGIS and R. This app was developed with RStudio's Shiny package and mapped with Leaflet.
                                     </p>
                                     <h4>
                                     Future Improvements
                                     </h4>
                                     <p>
                                     Allow fuzzy matching on neighborhood and bar names rather than exact matching.
                                     </p>
                                     ")),
      
      tabPanel('Get to Know US', HTML("
                                      <h4>   About Us!  </h4>
                                      <p>
                                      We are all Master's students in Statistics or Applied Statistics at Columbia University, expected to graduate on Dec. 2016.
                                      </p>
                                      
                                      <h4>   Team Members </h4>
                                      <p>
                                      Aoyuan Liao, Arnold Lau, Haoyang Chen, Rong Wang, Yanran Wang. 
                                      </p>
                                      <br/>
                                      <p>
                                      For questions or feedback, please email <a href='mailto:arnoldlindlau@gmail.com'>arnoldlindlau@gmail.com</a>.
                                      </p>
                                      "
                                      
      )))
  ))
))