# server.R

# Things to do: add widget for month; implement widget for hours
#               use leafletProxy() to prevent the map from completely redrawing every time
#                 input changes

library(leaflet)
library(dplyr)
library(sp)
library(rgdal)

crime15 <- read.csv("../output/crime15_nta.csv")
crime15 <- tbl_df(crime15)
crime15$Occurren_3 <- crime15$Occurren_3 / 100 # occurrence hour
crime15$Occurrence_Date <- unlist((lapply(strsplit(as.character(crime15$Occurrence), split = " "), "[[", 1)))
crime15$Occurrence_Date <- as.Date(crime15$Occurrence_Date) # convert to Date class

# NYC Neighborhood Tabulation Areas read as SpatialPolygonsDataFrame
nynta <- readOGR(dsn = "../data/nynta_15d", layer = "nynta_projected") 
nynta <- spTransform(nynta, CRS("+proj=longlat +datum=WGS84")) # transform lat/lng for leaflet

# Population data per NTA read as .csv file
pop_nta <- read.csv("../data/New_York_City_Population_by_Neighborhood_Tabulation_Areas.csv")
pop_nta <- filter(pop_nta, Year == 2010, Population != 0)

shinyServer(function(input, output) {
  
  # reads in subsets of the crime data
  crimeInput <- reactive({
    if (input$min_hour <= input$max_hour) {
      crime15 <- filter(crime15, Occurren_3 >= input$min_hour & Occurren_3 <= input$max_hour)
    }
    else {
      crime15 <- filter(crime15, Occurren_3 >= input$min_hour | Occurren_3 <= input$max_hour)
    }
    crime_density <- filter(crime15, Offense %in% input$offense, Day.of.Wee %in% input$day_of_week,
                                     Occurrence_Date %in% input$date) %>%
                     group_by(NTACode) %>%
                     summarize(num_crimes = n()) %>%
                     inner_join(pop_nta, by = c("NTACode" = "NTA.Code")) %>%
                     mutate(crime_density_per_1K = num_crimes / (Population / 1000)) %>%
                     arrange(NTACode)
    nynta_crime <- subset(nynta, NTACode %in% crime_density$NTACode)
    nynta_crime <- nynta_crime[order(nynta_crime$NTACode), ]
    nynta_crime <- cbind(nynta_crime, crime_density$crime_density_per_1K)
    names(nynta_crime)[8] <- "crime_density_per_1K"
    nynta_crime
  })
  
  # defines color ramp for crime density
  colorInput <- reactive({
    colorQuantile(palette = "Reds", domain = crimeInput()@data$crime_density_per_1K, n = 7)
  })
  
  # draws the basic map
  leafletInput <- reactive({
    leaflet() %>% addProviderTiles("CartoDB.Positron") %>%
                  setView(lat = 40.74196, lng = -73.86483, zoom = 10)
  })
  
  # adds colors if any offense is checked
  choroplethInput <- reactive({
    if (is.null(input$offense) | is.null(input$day_of_week)) return(leafletInput()) 
    leafletInput() %>% addPolygons(data = crimeInput(), weight = 2, fillOpacity = 0.7,
                                   color = ~colorInput()(crime_density_per_1K))
                                 
  })
  
  # renders the map
  output$map <- renderLeaflet({
    choroplethInput()
  })
  }
)
