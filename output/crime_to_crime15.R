library(dplyr)
library(lubridate)
library(leaflet)

crime <- read.csv("data/NYPD_7_Major_Felony_Incidents.csv")
str(crime)

crime15 <- crime[crime$Occurrence.Year == 2015, ]
crime15 <- tbl_df(crime15)
crime15$Occurrence.Date <- mdy_hms(crime15$Occurrence.Date)
crime15 <- arrange(crime15, Occurrence.Date, Offense) %>% 
           select(OBJECTID, Occurrence.Date, Day.of.Week, Occurrence.Month, Occurrence.Day,
                  Occurrence.Hour, Offense, Sector, Precinct, Borough, Location.1)
# separate out Location.1 into latitude and longitude
crime15$lat <- sapply(crime15$Location.1, 
                      FUN = function(x) as.double(strsplit(gsub("[^0-9. -]", "", x), " ")[[1]][1]))
crime15$lng <- sapply(crime15$Location.1, 
                      FUN = function(x) as.double(strsplit(gsub("[^0-9. -]", "", x), " ")[[1]][2]))

m <- leaflet() %>% addProviderTiles("CartoDB.DarkMatter") %>% 
                   setView(lat = 40.741958, lng = -73.864827, zoom = 11) %>%
                   addCircleMarkers(data = crime15, clusterOptions = markerClusterOptions())
m

