library(data.table)
library(dplyr)

#data manipulation
crime.data <- read.csv("crime15_nta.csv", header = T)
bar.data <- read.csv("nyc_bars_nta.csv", header = T)
bar.data <- bar.data[!is.na(bar.data$Doing.Busi),]

#This function is able to select all crimes that happen near the specific bar during a designited time
barcrimeswithtime <- function(bar,starttime,endtime){
    objectbar_crimestime<- matrix(,ncol=1)
    colnames(objectbar_crimestime) <- c("CRIME TYPE")
    df<-as.data.frame(crimes)
    tempcrimes<-subset(df, df$Bar %in% bar)
        apply(tempcrimes, 1, function(x){
            if(x['BURGLARY']!= 0){
                if((x['BURGLARYHOUR']>=starttime) &&(x['BURGLARYHOUR']<=endtime)){
                    objectbar_crimestime<<-rbind(objectbar_crimestime,'BURGLARY')
                }
            }
            else if(x['GRAND_LARCENY']!=0){
                if((x['GRAND_LARCENY_HOUR']>=starttime) &&(x['GRAND_LARCENY_HOUR']<=endtime)){
                    objectbar_crimestime<<-rbind(objectbar_crimestime,'GRAND_LARCENY')
                }
            }
            else if(x['RAPE']!=0){
                if((x['RAPEHOUR']>=starttime) &&(x['RAPEHOUR']<=endtime)){
                      objectbar_crimestime<<-rbind(objectbar_crimestime,'RAPE')
            }
                }
            else if(x['FELONY_ASSAULT']!=0){
                if((x['FELONY_ASSAULT_HOUR']>=starttime) &&(x['FELONY_ASSAULT_HOUR']<=endtime)){
                    objectbar_crimestime<<-rbind(objectbar_crimestime,'FELONY_ASSAULT')
                     }
                 }
            else if(x['ROBBERY']!=0){
                if((x['ROBBERYHOUR']>=starttime) &&(x['ROBBERYHOUR']<=endtime)){
                      objectbar_crimestime<<-rbind(objectbar_crimestime,'ROBBERY')
                      }
                 }
             else if(x['GRAND_LARCENY_OF_MOTOR_VEHICLE']!=0){
                 if((x['GLMVHOUR']>=starttime) &&(x['GLMVHOUR']<=endtime)){
                     objectbar_crimestime<<-rbind(objectbar_crimestime,'GRAND_LARCENY_OF_MOTOR_VEHICLE')
                     }
                      }
            else {
                if((x['MURDERHOUR']>=starttime) &&(x['MURDERHOUR']<=endtime)){
                     objectbar_crimestime<<-rbind(objectbar_crimestime,'MURDER')
                      }
                }
            } )
                      
    return (objectbar_crimestime)
    }

#result<-barcrimeswithtime('LA VUE','02','10')
#result<-na.omit(result)

    
