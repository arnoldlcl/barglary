library(shiny)
library(maps)
library(mapproj) 
# server.R

library(leaflet)
library(dplyr)
library(sp)
library(rgdal)
library(R.utils)
library(base)
library(shiny)
library(data.table)
library(googleVis)
library(ggplot2)
library(ggmap)
library(RCurl)
suppressPackageStartupMessages(library(googleVis));

load("crime15.RData")
load("nynta.RData")
load("pop_nta.RData")
load("nyc_bars_clean.RData")
load("nynta_bar.RData")

nyc_bars<-as.data.frame(nyc_bars)
nyc_bars$Doing.Busi<-as.character(nyc_bars$Doing.Busi)
nyc_bars$Actual.Add<-as.character(nyc_bars$Actual.Add)

shinyServer(function(input, output) {
  
  barsnta<-reactive({filter(nyc_bars,nyc_bars$NTAName==toupper(input$nta))})
  bar<-reactive({filter(nyc_bars,nyc_bars$Doing.Busi==toupper(input$bar))})
  
  
  # subsets the crime data depending on user input in the Shiny app
  crimeInput <- reactive({
    if (input$min_hour <= input$max_hour) {
      crime15 <- filter(crime15, Occurren_3 >= input$min_hour & Occurren_3 <= input$max_hour)
    }
    else {
      crime15 <- filter(crime15, Occurren_3 >= input$min_hour | Occurren_3 <= input$max_hour)
    }
    crime_density <- filter(crime15, Offense %in% input$offense, Day.of.Wee %in% input$day_of_week) %>%
      group_by(NTACode) %>%
      summarize(num_crimes = n()) %>%
      inner_join(pop_nta, by = c("NTACode" = "NTA.Code")) %>%
      mutate(crime_density_per_1K = num_crimes / (Population / 1000)) %>%
      arrange(NTACode)
    nynta_crime <- subset(nynta, NTACode %in% crime_density$NTACode)
    nynta_crime_not <- subset(nynta, !(NTACode %in% crime_density$NTACode))
    nynta_crime_not$crime_density_per_1K <- 0 # set NTAs with no crime density to 0
    nynta_crime <- nynta_crime[order(nynta_crime$NTACode), ]
    nynta_crime <- cbind(nynta_crime, crime_density$crime_density_per_1K)
    names(nynta_crime)[8] <- "crime_density_per_1K"
    nynta_crime <- rbind(nynta_crime, nynta_crime_not)
    nynta_crime <- nynta_crime[-grep("park-cemetery", nynta_crime@data$NTAName), ] # remove parks, cemeteries, etc.
  })
  
  # defines color ramp for crime density
  colorInput <- reactive({
    colorQuantile(palette = "Reds", domain = unique(crimeInput()@data$crime_density_per_1K), n = 7)
  })
  
  # draws the basic map
  leafletInput <- reactive({
    leaflet() %>% addProviderTiles("CartoDB.DarkMatter") %>%
      setView(lat=40.69196, lng = -73.96483, zoom = 10)
  })
  
  # adds colors (except if no offenses or days of the week are checked, then just display the basemap)
  choroplethInput <- reactive({
    if (is.null(input$offense) | is.null(input$day_of_week)) return(leafletInput()) 
      leafletInput() %>% addPolygons(data = crimeInput(), weight = 2, fillOpacity = 0.7,
                                   color = ~colorInput()(crime_density_per_1K),
                                   popup = paste(crimeInput()$NTAName, 
                                                 round(crimeInput()$crime_density_per_1K, digits = 2), sep = " "))%>%
                          addMarkers(lng=barsnta()$Longitude,lat=barsnta()$Latitude,popup=barsnta()$Doing.Busi,clusterOptions = markerClusterOptions())%>%
                          addCircleMarkers(lng=bar()$Longitude,lat=bar()$Latitude,popup=bar()$Doing.Busi,radius=2)
    
  })
  
  # renders the map
  output$map_guidelines <- renderText("Click on a neighborhood to view its name and crime density per 1000 people.")
  output$general <- renderLeaflet({
    choroplethInput()
  })
  
  # choropleth map of bar density per 1K, equal quantiles (7 divisions), superimposed onto street basemap
  output$density <- renderLeaflet({
    pal_bar <- colorQuantile(palette = "Purples", domain = nynta_bar$bar_density_per_1K, n = 7)
    leaflet() %>%setView(lat=40.69196, lng = -73.96483, zoom = 10)%>%
              addProviderTiles("CartoDB.Positron") %>% 
              addPolygons(data = nynta_bar, weight = 2, fillOpacity = 0.7, color = ~pal_bar(bar_density_per_1K))
  })
  
  

  
  output$map<- renderGvis({   
    #printgooglemap
    thebar<-bar()
    thebar$Actual.Add<-paste(thebar$Actual.Add,"New York, NY")
    gvisMap(thebar,"Actual.Add", c("Doing.Busi"), 
            options=list(showTip=TRUE, 
                         showLine=TRUE, 
                         enableScrollWheel=TRUE,
                         mapType='normal', 
                         useMapTypeControl=TRUE))

  })
})