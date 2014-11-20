
# packages
library("raster")

# read data
load("df_npp_month.RData")

# ImageMagick execution example (turn individual pngs to animated gif)
# convert -delay 80 *.png tere.gif

# head
str(df_npp_month)

# n of dates
n <- length(unique(df_npp_month$date))


# set output images (files)
png(file="D:/Julian/59_animacion_tere/frame%03d.png",width=1500,height=1000)

# write loop
for (i in 1:n){
  
  sub_date <- df_npp_month[df_npp_month$date==unique(df_npp_month$date)[i],]
  
  data_frame_state <- data.frame(x=sub_date$x,y=sub_date$y,state=sub_date$state)
  
  data_frame_mean_npp <- data.frame(x=sub_date$x,y=sub_date$y,state=sub_date$mean_npp)
  
  par(mfrow=c(1,2))
  
  # to raster
  
  coordinates(data_frame_state)<-~x+y
  gridded(data_frame_state)=TRUE
  data_frame_state<-raster(data_frame_state)
  
  coordinates(data_frame_mean_npp)<-~x+y
  gridded(data_frame_mean_npp)=TRUE
  data_frame_mean_npp<-raster(data_frame_mean_npp)
  
  porcentaje <- (100-i)
  txts <- paste("Date: ",toString(unique(df_npp_month$date)[i]),sep="")
  #plot(whuz3,zlim=c(0,1),main=txts,cex=4)
  
  # plot state layers
  plot(data_frame_state,main=txts)
  
  # plot mean npp layers
  plot(data_frame_mean_npp,zlim=c(0,650),)
}

max(df_npp_month$mean_npp)
