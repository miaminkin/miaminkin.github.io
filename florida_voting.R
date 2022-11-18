#Packages
library(tidycensus)
library(tigris)
library(tidyverse)
install.packages("plotly")
library(plotly)

#Loading in data
turnout_rates<-read.csv("florida_turnout.csv")
turnout_rates[13,1]="DeSoto"

#Pulling boundaries
florida_counties<-counties(state="Florida")
florida_counties<-florida_counties%>%
  mutate(COUNTY=NAME)

#Join
joined_data<-left_join(florida_counties,turnout_rates,by="COUNTY")
joined_data$DIFF.IN.TURNOUT = as.numeric(gsub("[\\%,]", "", joined_data$DIFF.IN.TURNOUT ))
my_breaks<-c(-20,-15,-10,0,5,10,15)
joined_data<-joined_data%>%
  mutate(turnout_difference=DIFF.IN.TURNOUT)

florida_turnout_map<-
  joined_data%>%
  ggplot()+
  geom_sf(aes(fill=turnout_difference,
              text=paste("County: ",COUNTY)),
          color="white",size=0.2)+
  scale_fill_gradient2(low="#EC1E1E",
                       mid="white",
                       high="#167A00", 
                       breaks=my_breaks,
                       labels=my_breaks)+
  theme_void()

ggplotly(florida_turnout_map)%>%
  style(hoveron="fills")

