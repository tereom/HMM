library(lubridate)
library(stringr)
library(raster)
library(plyr)
library(dplyr)
library(tidyr)
library(Hmisc)
library(ggplot2)
library(fda)

paths <- list.files(path = "../data/gpp", pattern = "\\PsnNet_1km.tif$",
                    full.names = TRUE)

## Aislaremos una región del mapa
image_1 <- raster(paths[1])
plot(image_1)
ext <- drawExtent()
# save(ext, file = "../data/map_subset.Rdata")
load(file = "../data/map_subset.Rdata")



## layer to kml
cropped <- crop(image_1,ext)
plot(cropped)
projection(cropped)
rlatlong <- projectRaster(cropped, crs=CRS('+proj=longlat'))
KML(rlatlong, filename='browse_cuadrito_ultima.kml')


## Brick (each time step is a layer)
brick_npp <- brick()
for (i in 1:length(paths)){
  image <-raster(paths[i])
  image <- crop(image, ext)
  brick_npp <- addLayer(brick_npp, image)
}

# missings to NA
brick_npp[brick_npp > 32760] <- NA

# save(brick_npp, file = "../data/brick_npp.RData")
load("data/brick_npp.RData")

# convert to matrix
matrix_npp <- rasterToPoints(brick_npp)

# convert to data.frame
df_npp <- matrix_npp %>%
  data.frame() %>%
  gather(file, npp, -x, -y) %>%
  mutate(
    date = as.Date(substr(file, 9, 18), format='%Y.%m.%d'),
    year = year(date),
    month = month(date),
    week = week(date),
    day = day(date),
    week2 = mapvalues(week, from = 1:52, to = rep(1:26, each = 2)),
    .id = paste(x, y, sep = "_"), 
    x_cat = cut2(x, g = 5),
    y_cat = cut2(y, g = 5)
  )

# save(df_npp, file = "data/df_npp.RData")


#####################################################################
## Select rectangle in the North
image_1 <- raster(paths[1])
plot(image_1)
ext <- drawExtent()
# save(ext, file = "../data/map_subset_N.Rdata")
load(file = "../data/map_subset_N.Rdata")



## layer to kml
cropped <- crop(image_1,ext)
plot(cropped)
projection(cropped)
rlatlong <- projectRaster(cropped, crs=CRS('+proj=longlat'))
KML(rlatlong, filename='../data/cuadro_N.kml')


## Brick (each time step is a layer)
brick_npp <- brick()
for (i in 1:length(paths)){
  image <-raster(paths[i])
  image <- crop(image, ext)
  brick_npp <- addLayer(brick_npp, image)
}

# missings to NA
brick_npp[brick_npp > 32760] <- NA

# save(brick_npp, file = "../data/brick_npp_N.RData")
load("../data/brick_npp_N.RData")

# convert to matrix
matrix_npp <- rasterToPoints(brick_npp)

# convert to data.frame
df_npp <- matrix_npp %>%
  data.frame() %>%
  gather(file, npp, -x, -y) %>%
  mutate(
    date = as.Date(substr(file, 9, 18), format='%Y.%m.%d'),
    year = year(date),
    month = month(date),
    week = week(date),
    day = day(date),
    week2 = mapvalues(week, from = 1:52, to = rep(1:26, each = 2)),
    .id = paste(x, y, sep = "_"), 
    x_cat = cut2(x, g = 5),
    y_cat = cut2(y, g = 5)
  )

# save(df_npp, file = "../data/df_npp_N.RData")

