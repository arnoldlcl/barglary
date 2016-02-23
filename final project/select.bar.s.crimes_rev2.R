library(plyr)

crime.data <- read.csv("C:/Users/Administrator/Documents/GitHub/project2-group7/output/crime15_nta.csv", header = T)
bar.data <- read.csv("C:/Users/Administrator/Documents/GitHub/project2-group7/output/nyc_bars_nta.csv", header = T)
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

# select the crimes near the object bar
select_crimes <- function(object_bar){
    alpha <-  0.001 # tuning parameter, control the region near the object bar
    #object_crimes<-c()
    object_crimes<-matrix(,ncol=14)
    colnames(object_crimes) <- c("BURGLARY","BURGLARYHOUR","GRAND_LARCENY","GRAND_LARCENY_HOUR","RAPE","RAPEHOUR","FELONY_ASSAULT","FELONY_ASSAULT_HOUR","ROBBERY","ROBBERYHOUR","GRAND_LARCENY_OF_MOTOR_VEHICLE","GLMVHOUR","MURDER","MURDERHOUR")
    #object_bar<-bar.data[3,]
    apply(crime.data, 1, function(x){
        if((distance(object_bar, x) < alpha)){
            crimehour<- t(sapply(x['Occurrence'], function(x) substring(x, first=c(12), last=c(13))))
            switch(x['Offense'],
                   'BURGLARY'={
                       addcrime<<-as.matrix(cbind(x['Occurrence'],crimehour,0,0,0,0,0,0,0,0,0,0,0,0))
                       object_crimes<<-rbind(object_crimes,addcrime)
                   },
                   'GRAND LARCENY'={
                       addcrime<<-as.matrix(cbind(0,0,x['Occurrence'],crimehour,0,0,0,0,0,0,0,0,0,0))
                       object_crimes<<-rbind(object_crimes,addcrime)
                   },
                   'RAPE'={
                       addcrime<<-as.matrix(cbind(0,0,0,0,x['Occurrence'],crimehour,0,0,0,0,0,0,0,0))
                       object_crimes<<-rbind(object_crimes,addcrime)
                   },
                   'FELONY ASSAULT'={
                       addcrime<<-as.matrix(cbind(0,0,0,0,0,0,x['Occurrence'],crimehour,0,0,0,0,0,0))
                       object_crimes<<-rbind(object_crimes,addcrime)
                   },
                   'ROBBERY'={
                       addcrime<<-as.matrix(cbind(0,0,0,0,0,0,0,0,x['Occurrence'],crimehour,0,0,0,0))
                       object_crimes<<-rbind(object_crimes,addcrime)
                   },
                   'GRAND LARCENY OF MOTOR VEHICLE'={
                       addcrime<<-as.matrix(cbind(0,0,0,0,0,0,0,0,0,0,x['Occurrence'],crimehour,0,0))
                       object_crimes<<-rbind(object_crimes,addcrime)
                   },
                   'MURDER'={
                       addcrime<<-as.matrix(cbind(0,0,0,0,0,0,0,0,0,0,0,0,x['Occurrence'],crimehour))
                       object_crimes<<-rbind(object_crimes,addcrime)
                   }
            )   
        }
    })
    names(object_crimes) <- c()
    return(object_crimes)
} 


# Build the dataframe for each bar and crimes near it
#bars <- as.list(bar.data$Doing.Busi)
crimes <- matrix(,ncol=15)
colnames(crimes) <- c("Bar","BURGLARY","BURGLARYHOUR","GRAND_LARCENY","GRAND_LARCENY_HOUR","RAPE","RAPEHOUR","FELONY_ASSAULT","FELONY_ASSAULT_HOUR","ROBBERY","ROBBERYHOUR","GRAND_LARCENY_OF_MOTOR_VEHICLE","GLMVHOUR","MURDER","MURDERHOUR")

#crimes<-list()
apply(bar.data, 1, function(x){
    object_crimes<<-select_crimes(x)
    crimeswithbar<<-cbind(x['Doing.Busi'],select_crimes(x))
    crimes <<- rbind(crimes,crimeswithbar)
} )

crimes<-na.omit(crimes)
crimes2<-data.frame(crimes[,c(1,2,4,6,8,10,12,14)])
row=nrow(crimes2);col=ncol(crimes2)
crimesum<-data.frame(matrix(rep(0,row*col),nrow=row,ncol=col))
crimesum[,1]=crimes2[,1]
colnames(crimesum)=c("Bar","BURGLARY","GRAND_LARCENY","RAPE","FELONY_ASSAULT","ROBBERY","GRAND_LARCENY_OF_MOTOR_VEHICLE","MURDER")
for(i in 1:row){
  for(j in 2:col){
    as.numeric(as.character.factor(crimes2[i,j]))
    if(crimes2[i,j]!=0){
      crimesum[i,j]=1
    }
    else if(crimes2[i,j]==0){
      crimesum[i,j]=0
    }
  }
}
crimesum=ddply(crimesum,~Bar,summarise,BURGLARY=sum(BURGLARY),GRAND_LARCENY=sum(GRAND_LARCENY),RAPE=sum(RAPE),FELONY_ASSAULT=sum(FELONY_ASSAULT),ROBBERY=sum(ROBBERY),GRAND_LARCENY_OF_MOTOR_VEHICLE=sum(GRAND_LARCENY_OF_MOTOR_VEHICLE),MURDER=sum(MURDER))
  
  
