library(markdown)
library(plyr)
library(tidyverse)
library(ggplot2)
library(plotly)
library(dplyr)
library(egg)

#Loading data
co2 <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

server <- function(input, output) {

  output$climate_plot <- renderPlotly({
    #Making a reactive dataframe to be graphed from UI selections
    co2_svr <- co2 %>% 
      select(country, year, co2) %>% #Making dataset faster to graph
      filter(country %in% input$country_select) %>% #Filter by country
      filter(year >= input$year_select[1] & year <= input$year_select[2]) #Filter by year
    
    #Plotting data
    co2_plot <- ggplot(data = co2_svr) + #Pulling in smaller dataset
      geom_line(mapping = aes(x = year, y = co2, color = country)) +
      xlab("Year (from 1750 to 2020)") + #X-axis label
      ylab("Production-based CO2 (in millions of tons)") #Y-axis label

    return(co2_plot) #Actually providing a plot to serve as the output
    
  })

}
