library(gsubfn)
library(sqldf)
crime.data <- read.csv("crime15_nta.csv", header = T)
bar.data <- read.csv("nyc_bars_nta.csv", header = T)
bar.data <- bar.data[!is.na(bar.data$Doing.Busi),]

# calculate the distance
distance <- function(object_loc, neibor_loc){
    object_loc.Latitude <- as.numeric(object_loc['Latitude'])
    object_loc.Longitude <- as.numeric(object_loc['Longitude'])
    neibor_loc.Latitude <- as.numeric(neibor_loc['lat'])
    neibor_loc.Longitude <- as.numeric(neibor_loc['lng'])
    dist <- sqrt((object_loc.Latitude - neibor_loc.Latitude) ^ 2 + (object_loc.Longitude - neibor_loc.Longitude) ^ 2)
    return(dist)
}

select_crimes <- function(object_bar){
    alpha <-  0.03 # tuning parameter, control the region near the object bar
    #object_crimes<-c()
    object_crimes<<-matrix(0,ncol=7)
    colnames(object_crimes) <- c("BURGLARY","GRAND_LARCENY","RAPE","FELONY_ASSAULT","ROBBERY","GRAND_LARCENY_OF_MOTOR_VEHICLE","MURDER")
    #object_bar<-bar.data[3,]
    apply(crime.data, 1, function(x){
        if((distance(object_bar, x) < alpha)){
            switch(x['Offense'],
                   'BURGLARY'={
                       object_crimes[,"BURGLARY"]<<-object_crimes[,"BURGLARY"]+1
                   },
                   'GRAND LARCENY'={
                       object_crimes[,"GRAND_LARCENY"]<<-object_crimes[,"GRAND_LARCENY"]+1
                                                  
                   },
                   'RAPE'={
                       object_crimes[,"RAPE"]<<-object_crimes[,"RAPE"]+1
                   },
                   'FELONY ASSAULT'={
                       object_crimes[,"FELONY_ASSAULT"]<<-object_crimes[,"FELONY_ASSAULT"]+1
                   },
                   'ROBBERY'={
                       object_crimes[,"ROBBERY"]<<-object_crimes[,"ROBBERY"]+1
                   },
                   'GRAND LARCENY OF MOTOR VEHICLE'={
                       object_crimes[,"GRAND_LARCENY_OF_MOTOR_VEHICLE"]<<-object_crimes[,"GRAND_LARCENY_OF_MOTOR_VEHICLE"]+1
                   },
                   'MURDER'={
                       object_crimes[,"MURDER"]<<-object_crimes[,"MURDER"]+1
                   }
            )   
        }
    })
    names(object_crimes) <- c()
    return(object_crimes)
} 
crimes<-list()
# crimes <- matrix(,ncol=8)
# crimes<-data.frame(crimes)
#x<-bar.data[1,]
apply(bar.data, 1, function(x){
    object_crimes<<-select_crimes(x)
    crimeswithbar<<-cbind(x['Doing.Busi'],object_crimes)
    colnames(crimeswithbar) <- c("Bar","BURGLARY","GRAND_LARCENY","RAPE","FELONY_ASSAULT","ROBBERY","GRAND_LARCENY_OF_MOTOR_VEHICLE","MURDER")
    #crimeswithbar<-unname(crimeswithbar)
    crimes <<- rbind(crimes,crimeswithbar)
} )
crimes<-na.omit(crimes)