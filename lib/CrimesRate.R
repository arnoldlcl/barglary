library(gtools)
load("pop_nta.rdata")
load("barcrimes3.RData")
write.csv(crimes,"barcrimes3.csv")

crimes<-na.omit(crimes)

findNTACodewithBar<-function(bar){
    # bar<-'KAIA WINE BAR'
    bar<-as.list(bar)
    x<-subset(bar.data, bar.data$Doing.Busi==bar)
    NTACode<-x['NTACode']
    return (NTACode[1,1])
}
findPOPwithNTACode<-function(NTACode){
    NTACode<-as.list(NTACode)
    x<-subset(pop_nta, pop_nta$NTA.Code %in% NTACode)
    pop<-x['Population']
    return (pop)
}

# findPOPwithNTACode('MN32')
# findNTACodewithBar('KAIA WINE BAR')
FinalCrimes<-matrix(,ncol=10)
#y<-newcrimes[1,]
#FinalCrimes<-list()
apply(crimes,1,function(y){
    NTACode<-findNTACodewithBar(as.matrix(y['Bar']))
    pop<-findPOPwithNTACode(as.matrix(NTACode))
    pop<-as.numeric(pop)
    sumcrimes<-0
    for(i in 3:9){
       sumcrimes<- sumcrimes+as.numeric(y[i])
    }
    
    CrimeRate<-sumcrimes*100000/pop
    addrecord<-cbind(y[2],y[3],y[4],y[5],y[6],y[7],y[8],y[9],pop,CrimeRate)
    #as.vector(addrecord)
    FinalCrimes<<-rbind(FinalCrimes,addrecord)
})

FinalCrimes<-na.omit(FinalCrimes)
FinalCrimes<-unname(FinalCrimes)
colnames(FinalCrimes)<-c("Bar","BURGLARY","GRAND_LARCENY","RAPE","FELONY_ASSAULT","ROBBERY","GRAND_LARCENY_OF_MOTOR_VEHICLE","MURDER","Population","CrimeRate")
load("Finalcrimes3.RData")
FinalCrimes<-0

m<-matrix(0,nrow=nrow(FinalCrimes),ncol=ncol(FinalCrimes),byrow=T)
data<-as.data.frame(m)

 for(i in 1:nrow(FinalCrimes)){
     data[i,1]<-FinalCrimes[i,1]
     for (j in 2:ncol(FinalCrimes)){
         rate<-FinalCrimes[i,j]
         rate<-as.numeric(rate)
         data[i,j]<-rate
     }
 }

names(data)<-c("Bar","BURGLARY","GRAND_LARCENY","RAPE","FELONY_ASSAULT","ROBBERY","GRAND_LARCENY_OF_MOTOR_VEHICLE","MURDER","Population","CrimeRate")
data[,2:8]<-data[,2:8]/data[,9]*100000
data[,2:8]<-round(data[,2:8],2)
save(data,file="bars_crime_rate.RData")

load("bars_crime_rate1.RData")
nyc_bars1<-data
load("bars_crime_rate3.RData")
nyc_bars3<-data
