crime.data <- read.csv("crime15_nta.csv", header = T)
bar.data <- read.csv("nyc_bars_nta.csv", header = T)

# Clean data
bar.data <- bar.data[!is.na(bar.data$Doing.Busi),]

# calculate the distance
distance <- function(object_loc, neibor_loc){
    object_loc.x1 <- as.numeric(object_loc['coords.x1'])
    object_loc.x2 <- as.numeric(object_loc['coords.x2'])
    neibor_loc.x1 <- as.numeric(neibor_loc['coords.x1'])
    neibor_loc.x2 <- as.numeric(neibor_loc['coords.x2'])
    dist <- sqrt((object_loc.x1 - neibor_loc.x1) ^ 2 + (object_loc.x2 - neibor_loc.x2) ^ 2)
    return(dist)
}

# select the bars near the object bar
select_bar <- function(object_bar){
    alpha <- 100 # tuning parameter, control the region near the object bar
    object_neibors <- c()
    apply(bar.data, 1, function(x){
        if((distance(object_bar, x) < alpha) && (x['Doing.Busi'] != object_bar['Doing.Busi'])){
            object_neibors <<- union(object_neibors, x['Doing.Busi'])
        }
    })
    return(object_neibors)
} 

# Build the dataframe for each bar and its neighbors
bars <- as.list(bar.data$Doing.Busi)
neibors <- list()
apply(bar.data, 1, function(x){
    neibors[x['Doing.Busi']] <<- select_bar(x)
})

