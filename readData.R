library(leaflet)
library(dplyr)
library(sp)
library(rgdal)

# Crime data
crime15<-read.csv("C:/Users/Eve/Documents/GitHub/project2-group7/output/crime15_nta.csv")
crime15 <- tbl_df(crime15)
crime15$Occurren_3 <- crime15$Occurren_3 / 100 # occurrence hour
crime15$Occurrence_Date <- unlist((lapply(strsplit(as.character(crime15$Occurrence), split = " "), "[[", 1)))
crime15$Occurrence_Date <- as.Date(crime15$Occurrence_Date) # convert to Date class
crime15<-crime15[,-(1:2)]
crime15<-crime15[,-(7:9)]
crime15$NTAName<-toupper(crime15$NTAName)
save(crime15,file="crime15.RData")


load("crime15.RData")
# NYC Neighborhood Tabulation Areas read as SpatialPolygonsDataFrame
nynta <- readOGR(dsn = "C:/Users/Eve/Documents/GitHub/project2-group7/data/nynta_15d", layer = "nynta_projected") 
nynta <- spTransform(nynta, CRS("+proj=longlat +datum=WGS84")) # transform lat/lng for leaflet
save(nynta,file="nynta.RData")

load("nynta.RData")

# Population data per NTA read as .csv file
pop_nta <- read.csv("C:/Users/Eve/Documents/GitHub/project2-group7/data/New_York_City_Population_by_Neighborhood_Tabulation_Areas.csv")
pop_nta <- filter(pop_nta, Year == 2010, Population >= 10000)
pop_nta<-pop_nta[,-3]
pop_nta$NTA.Name<-toupper(pop_nta$NTA.Name)
save(pop_nta,file="pop_nta.RData")

load("crime15.RData")
load("nynta.RData")
load("pop_nta.RData")

data<-read.csv("C:/Users/Eve/Documents/GitHub/project2-group7/output/nyc_bars_nta.csv")
nyc_bars<- tbl_df(data)
nyc_bars<-na.omit(nyc_bars[,c(9:10,14,19,20,25,26)])
nyc_bars$NTAName<-toupper(nyc_bars$NTAName)
save(nyc_bars,file="nyc_bars_clean.RData")

load("nyc_bars_clean.RData")

library(R.utils)
library(base)
