library(ggplot2)
library(ggmap)
library(digest)
library(glue)
library(maps)
library(rjson)
library(curl)
library(stringr)
library(dplyr)
library(tidyverse)



# plot cities by lat / lon 
cities <- read.csv("data/cities.csv")
png("plots/cities.png")

map <- ggplot() + borders('world', xlim = c(-225, -60), ylim = c(15, 75), color ='black', fill='lightblue')
map <- map + geom_point(data = cities, mapping = aes(x=LON, y=LAT))
print(map)
dev.off()



model_points <- read.csv("data/model_points.csv")

# plot model points and color by koppen classification
png("plots/model_koppen.png")
map <- ggplot() + borders('world', xlim = c(-125,-65), ylim = c(20, 50), color ='black', fill='lightblue')
map <- map + geom_point(data = model_points, mapping = aes(x=LON, y=LAT, color=factor(koppen)))
print(map)
dev.off()


val_model <- read.csv('data/validated_model_points.csv')
# plot model points and color by elevation
png("plots/wind_plot.png")
map <- ggplot() + borders('world', xlim = c(-125,-65), ylim = c(20, 50), color ='black', fill='lightblue')
map <- map + geom_point(data = val_model, mapping = aes(x=lon, y=lat, color=wind)) +
             scale_color_gradientn(colours = c("blue", "green", "yellow", "orange", "red"))
map
dev.off()



library(ggplot2)
library(usmap)
library(ggthemes)
library(tibble)
library(viridis)
library(dplyr)
library(rgeos)
library(mapproj)


#' this part removes excess gradient over water
#' not too important for changing with other data

#bottom half

usa <- map_data("usa")

pol1 = Polygon(usa[,c("long","lat")])
p1 <- SpatialPoints(usa[,c("long","lat")])

a = c(38, -70.58713866470633)
b = c(38, -124.73458425264569)
c = c(24.5, -124.73458425264569)
d = c(24.5, -72.58713866470633)

temp = data.frame(x = c(a[2],b[2],c[2],d[2]), y = c(a[1],b[1],c[1],d[1]))
temp = rbind(temp,temp[1,])
pol2 = Polygon(temp[,c("x","y")])
p2 <- SpatialPoints(temp[,c("x","y")])

library(rgeos)
p1 <- SpatialPolygons(list(Polygons(list(pol1), "p1")))
p2 <- SpatialPolygons(list(Polygons(list(pol2), "p2")))
res <- gDifference(  gBuffer(p2, byid=TRUE, width=0),gBuffer(p1, byid=TRUE, width=0))
plot(res)
a=res@polygons
dat = as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
plot(dat)
dat2 = as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
plot(dat2)

usa <- map_data("usa")
pol1 = Polygon(usa[,c("long","lat")])
p1 <- SpatialPoints(usa[,c("long","lat")])

a = c(49.48709157805013, -126.0292411544105)
b = c(49.372767456697055, -97.20111573305981)
c = c(35.01791506999891, -96.9813892040004)
d = c(34.36753597096922, -124.97455433158129)
temp = data.frame(x = c(a[2],b[2],c[2],d[2]), y = c(a[1],b[1],c[1],d[1]))
temp = rbind(temp,temp[1,])
pol2 = Polygon(temp[,c("x","y")])
p2 <- SpatialPoints(temp[,c("x","y")])

p1 <- SpatialPolygons(list(Polygons(list(pol1), "p1")))
p2 <- SpatialPolygons(list(Polygons(list(pol2), "p2")))
res <- gDifference(  gBuffer(p2, byid=TRUE, width=0),gBuffer(p1, byid=TRUE, width=0))
plot(res)
a=res@polygons

dat2 = as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
# plot(dat2)

dat3 = as.data.frame(a[1][[1]]@Polygons[2][[1]]@coords)
plot(dat3)

usa2 = usa[usa$order>4950 & usa$order<5050,]
ggplot()+
  geom_polygon(data = usa2, aes(x=usa2$long,y=usa2$lat), fill = "lightblue") 

# lake michigan
usa <- map_data("usa")


pol1 = Polygon(usa2[,c("long","lat")])
p1 <- SpatialPoints(usa2[,c("long","lat")])

a = c(44.19517160437166, -88.03181425992327)
b = c(44.17748599794071, -84.77623582388959)
c = c(41.056774105291225, -84.97354360789164)
d = c(41.1311228986116, -89.28965138293627)
temp = data.frame(x = c(a[2],b[2],c[2],d[2]), y = c(a[1],b[1],c[1],d[1]))
temp = rbind(temp,temp[1,])
pol2 = Polygon(temp[,c("x","y")])
p2 <- SpatialPoints(temp[,c("x","y")])

p1 <- SpatialPolygons(list(Polygons(list(pol1), "p1")))
p2 <- SpatialPolygons(list(Polygons(list(pol2), "p2")))
res <- gIntersection(  gBuffer(p1, byid=TRUE, width=0),gBuffer(p2, byid=TRUE, width=0))
plot(res)
# res <- gDifference(  gBuffer(p2, byid=T, width=0),gBuffer(p1, byid=T, width=0))
plot(res)
a=res@polygons

dat4 = as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
plot(dat4)

usa3 = usa[usa$order>4400 & usa$order<4750,]
ggplot()+
  geom_map(data=usa, map=usa,
           aes(x=long,y= lat, map_id=region),
           color="black", fill="black", size=.1)+
  geom_polygon(data = usa3, aes(x=long,y=lat), fill = "lightblue") 

# lake erie


pol1 = Polygon(usa3[,c("long","lat")])
p1 <- SpatialPoints(usa3[,c("long","lat")])

a = c(43.528281172791125, -81.87143003643087)
b = c(43.723199406399075, -78.89256679347217)
c = c(41.411998034650495, -78.24462197355422)
d = c(41.39703243933011, -84.08310879021084)
temp = data.frame(x = c(a[2],b[2],c[2],d[2]), y = c(a[1],b[1],c[1],d[1]))
temp = rbind(temp,temp[1,])
pol2 = Polygon(temp[,c("x","y")])
p2 <- SpatialPoints(temp[,c("x","y")])

p1 <- SpatialPolygons(list(Polygons(list(pol1), "p1")))
p2 <- SpatialPolygons(list(Polygons(list(pol2), "p2")))
res <- gIntersection(  gBuffer(p1, byid=TRUE, width=0),gBuffer(p2, byid=TRUE, width=0))
# res <- gDifference(  gBuffer(p2, byid=T, width=0),gBuffer(p1, byid=T, width=0))
plot(res)
a=res@polygons

dat9 = as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
plot(dat9)
# 41.63111,-87.34742	

func2 <- function(a,b,c,d){
  usa <- map_data("usa")
  
  pol1 = Polygon(usa[,c("long","lat")])
  p1 <- SpatialPoints(usa[,c("long","lat")])
  
  temp = data.frame(x = c(a[2],b[2],c[2],d[2]), y = c(a[1],b[1],c[1],d[1]))
  temp = rbind(temp,temp[1,])
  pol2 = Polygon(temp[,c("x","y")])
  p2 <- SpatialPoints(temp[,c("x","y")])
  
  p1 <- SpatialPolygons(list(Polygons(list(pol1), "p1")))
  p2 <- SpatialPolygons(list(Polygons(list(pol2), "p2")))
  res <- gDifference(  gBuffer(p2, byid=TRUE, width=0),gBuffer(p1, byid=TRUE, width=0))
  # res <- gDifference(  gBuffer(p2, byid=T, width=0),gBuffer(p1, byid=T, width=0))
  plot(res)
  a=res@polygons
  
  dat4 = as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
  # plot(dat4)
  dat4
  a
}
# mroe michigan
a = c(49.8482220461071, -97.47405904039569)
b = c(49.08579769843062, -75.6525557263955)
c = c(40.84810428427789, -75.18327608523421)
d = c(41.6858225737601, -94.42374137284726)
a = func2(a,b,c,d)
dat5=as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)

# NE
a = c(41.246257873632096, -79.64143297087567)
b = c(40.08947370526088, -68.25584014764978)
c = c(37.15714268482833, -68.78377974395625)
d = c(36.73521516453001, -83.39567010016603)
a = func2(a,b,c,d)
dat6=as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)

a = c(49.32343518715469, -76.47379539303692)
b = c(49.67143801942952, -64.80046431914974)
c = c(38.27080937015975, -66.26696319777878)
d = c(40.40288869611612, -78.64421373340791)
a = func2(a,b,c,d)
dat7=as.data.frame(a[1][[1]]@Polygons[2][[1]]@coords)
plot(dat7)# NE region, MA
dat12=as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
plot(dat12)#candaian region

a = c(43.21797785315606, -76.7594230482479)
b = c(40.94788604781764, -73.82577204501558)
c = c(48.70403470082143, -66.58205863585866)
d = c(45.03637007559224, -67.87033261211045)
a = func2(a,b,c,d)
dat10=as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)
plot(dat10)

usa4 = usa[usa$region == "long island",]
ggplot()+
  
  geom_polygon(data = usa4, aes(x=long,y=lat), fill = "lightblue")

#ny
pol1 = Polygon(usa4[,c("long","lat")])
p1 <- SpatialPoints(usa4[,c("long","lat")])

a = c(41.001751527727585, -74.04773493362443)
b = c(41.143187833020214, -72.67103648349567)
c = c(40.08815292379516, -72.58119433974234)
d = c(40.46715040724515, -74.34632789397413)
temp = data.frame(x = c(a[2],b[2],c[2],d[2]), y = c(a[1],b[1],c[1],d[1]))
temp = rbind(temp,temp[1,])
pol2 = Polygon(temp[,c("x","y")])
p2 <- SpatialPoints(temp[,c("x","y")])

p1 <- SpatialPolygons(list(Polygons(list(pol1), "p1")))
p2 <- SpatialPolygons(list(Polygons(list(pol2), "p2")))
res <- gDifference(  gBuffer(p2, byid=TRUE, width=0),gBuffer(p1, byid=TRUE, width=0))
# res <- gDifference(  gBuffer(p2, byid=T, width=0),gBuffer(p1, byid=T, width=0))

a=res@polygons

dat11 = as.data.frame(a[1][[1]]@Polygons[1][[1]]@coords)



library(sf)
library(spData)
library(ggplot2)
library(ggmap)
library(kgc)

# spData::us_states, spData::hawaii, spData::alaska
# "Alaska" %in% spData::us_states$NAME

# check if a lat / lon point is in a state
# does not include alaska or hawaii
lonlat_to_state <- function(pointsDF,
                            states = spData::us_states,
                            name_col = "NAME") {
  
  pts <- st_as_sf(pointsDF, coords = 1:2, crs = 4326)
  states <- st_transform(states, crs = 3857)
  pts <- st_transform(pts, crs = 3857)
  
  state_names <- states[[name_col]]
  ii <- as.integer(st_intersects(pts, states))
  state_names[ii]
}


# return a grid of lat / lon points that are miles apart
latlon_grid <- function(miles) {
  
  # each mile is 1/66 of a lat / lon degree
  step <- 1/66 * miles
  
  # get a grid of lat / lon values inside the box corners
  # the distance between points is given number of miles
  # (50, -130) is top right corner
  # (20, -60) is bottom left corner
  box <- expand.grid(LON = seq(-130, -60, by=step),
                     LAT = seq(20, 50, by=step))
  
  box$STATE <- lonlat_to_state(box)
  
  # return points that are in a state
  box[!is.na(box$STATE),]
}

grid <- latlon_grid(20)
grid
can = map_data("world", c("canada"))
mex = map_data("world", c("mexico"))
state <- map_data("state")
county <- map_data("county")
usa <- map_data("usa")

model_points <- read.csv("data/model_points.csv")

png("plots/model_points_elevation_new.png")
mp = ggplot() +
  
  geom_map(data=state, map=state,
           aes(long, lat, map_id=region),
           color="black", fill="white", size=0.1)+ 
  geom_polygon(data = dat2, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat3, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat4, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat5, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat6, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat7, aes(x=x,y=y), fill = "lightblue") +
  # geom_polygon(data = dat8, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat9, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat10, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat11, aes(x=x,y=y), fill = "lightblue") +
  geom_polygon(data = dat12, aes(x=x,y=y), fill = "lightblue") +
  
  geom_polygon(data = dat, aes(x=x,y=y), fill = "lightblue") +
  geom_map(data=usa, map=usa,
           aes(x=long,y= lat, map_id=region),
           color="black", fill=NA, size=.25)+
  
  geom_map(data=can, map=can,
           aes(long, lat, map_id=region),
           color="black", fill="white", size=.25)+
  geom_map(data=mex, map=mex,
           aes(long, lat, map_id=region),
           color="black", fill="white", size=.25)+
  
  geom_point(data = model_points, aes(x = LON, y = LAT, color=ELEVATION)) +
  scale_color_gradientn(colours = c("blue", "green", "yellow", "orange", "red")) +
  
  xlab("Longitude") +
  ylab("Latitude") +
  ylim(c(24,51))+
  xlim(c(-130,-57))+
  
  theme(panel.background = element_rect(fill = 'lightblue'),
        legend.background = element_rect(fill = NA),
        legend.key = element_rect(fill = NA),
        legend.position = c(0.99, .01),
        legend.justification = c("right", "bottom") ,
        panel.grid.major = element_blank(),
        panel.grid = element_blank())

print(mp)
dev.off()



# PLOT MODEL POINTS USING NEW METHOD

library(tidyverse)
library(ggplot2)

state <- map_data("state")
model <- read.csv('SLU_Shit/Senior/weather_forecasts/data/model_points.csv')
cities <- read.csv('SLU_Shit/Senior/weather_forecasts/data/cities.csv')
email <- read.csv('SLU_Shit/Senior/weather_forecasts/data/email_data_expanded.csv')
email
email_cities <- cities[paste(cities$city, cities$state) %in% unique(paste(email$city, email$state)),]
cont_cities <- email_cities %>% filter(!(state %in% c("AK", "HI", "PR", "VI")))


model[as.character(model$koppen) == 'Climate Zone info missing',3]
model[as.character(model$koppen) == 'Climate Zone info missing',3] <- NA

model$koppen <- droplevels(model$koppen)
model$koppen <- as.factor(substring(model$koppen, 1, 1))
model <- model[!is.na(model$koppen), ]
model$koppen

cities


model %>% as.data.frame %>%
  ggplot(aes(x=lon, y=lat)) + 
  geom_tile(aes(fill=distance_to_coast)) +
  ggtitle("Distance to Coastline (miles)") + 
  labs(x ="Longitude", y = "Latitude") + 
  coord_equal() +
  #guides(fill=guide_legend(ncol=2)) + 
  # limits = c(0,8)
  scale_fill_gradient(low = "yellow", high="red") +
  geom_map(data=state, map=state,
           aes(long, lat, map_id=region),
           color="black", fill=NA, size=0.1) + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, size = 8,face = "bold"),
        legend.title = element_text(size=6),
        legend.text = element_text(size=6),
        legend.key.size = unit(.35, 'cm'), #change legend key size
        legend.key.height = unit(.35, 'cm'), #change legend key height
        legend.key.width = unit(.5, 'cm'),
        legend.position = 'bottom',
        axis.text=element_text(size=6),
        axis.title=element_text(size=6)) 
  #geom_point(data = data.frame(cont_cities), aes(x=lon, y=lat), alpha = 1/10) 

ggsave("SLU_Shit/model_distance.png")

# cities plot only for cities in email data






## PLOT ERROR AGAINST CITY VARIABLES
head(cities)
email <- read.csv('SLU_Shit/Senior/weather_forecasts/data/email_data_expanded.csv')
email <- email[email$possible_error == 'none',]
email <- email[!is.na(email$observed_temp),]
email <- email[!is.na(email$forecast_temp),]
head(email)
email$koppen <- as.factor(substring(email$koppen, 1, 1))




# average error for each city over all df
email$error <- abs(email$observed_temp - email$forecast_temp)
email <- email %>%
  group_by(city, state, high_or_low, forecast_hours_before) %>% 
  summarise_at(vars("error"), mean)

email <- left_join(email, cities, by = c("city","state"))
head(email)

library(ggplot2)

high <- email[email$high_or_low == 'high',]
high <- na.omit(high)
high_12 <- high[high$forecast_hours_before == 12,]
high_24 <- high[high$forecast_hours_before == 24,]
high_36 <- high[high$forecast_hours_before == 36,]
high_48 <- high[high$forecast_hours_before == 48,]

low <- email[email$high_or_low == 'low',]
low <- na.omit(low)
low_12 <- low[low$forecast_hours_before == 12,]
low_24 <- low[low$forecast_hours_before == 24,]
low_36 <- low[low$forecast_hours_before == 36,]
low_48 <- low[low$forecast_hours_before == 48,]

z_score <- function(x) {
  (x - mean(x)) / sd(x)
}

## HIGH PLOTS - DISTANCE TO COAST

high_12_plot <- high_12 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("High - 12 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')


high_24_plot <- high_24 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("High - 24 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')


high_36_plot <- high_36 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("High - 36 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')

high_48_plot <- high_48 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("High - 48 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        #axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')


## LOW PLOTS _ DISTANCE TO COAST

low_12_plot <- low_12 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("Low - 12 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')

low_24_plot <- low_24 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("Low - 24 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')

low_36_plot <- low_36 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("Low - 36 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')

low_48_plot <- low_48 %>% as.data.frame %>%
  ggplot(aes(x=koppen, y=z_score(error))) +
  geom_violin(alpha = .5) +
  ggtitle("Low - 48 Hours") + 
  #scale_fill_gradient(low = "yellow", high="red") + 
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        #axis.title.x = element_blank(),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        legend.position = 'none')

require(gridExtra)
pdf("SLU_Shit/Senior/weather_forecasts/plots/avg_error_vs_koppen.pdf")
grid.arrange(high_12_plot, low_12_plot, 
             high_24_plot, low_24_plot, 
             high_36_plot, low_36_plot, 
             high_48_plot, low_48_plot,
             nrow=4, ncol=2)
dev.off()
#ggsave("SLU_Shit/Senior/weather_forecasts/plots/error_vs_distance_to_coast.png")






head(high)

































