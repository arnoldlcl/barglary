library(shiny)
shinyUI(fluidPage(
   # titlePanel(h1("Crime Radar",align="center")),
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    "))
    ),
  
  titlePanel(HTML("<style>h1{font-family: 'Lobster', cursive;
                font-weight: 500; line-height: 1.1; 
                  color: #4d3a7d;}</style><h1><img src='logo.png' width='100' height='100'>  Crime Radar</h1>")
            ),

  sidebarLayout(
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
    tabsetPanel(
      tabPanel('General',textOutput("m")),
      tabPanel('Ranking',
               htmlOutput("mapped")),
      tabPanel('Map',
               plotOutput("map")),
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