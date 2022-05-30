library(markdown) #to resolve shinyapps errors
library(plyr) #primarily for melt function
library(tidyverse) #ggplot2, tidyr, dplyr, stringr
library(plotly) #interactive graphs
library(egg) #extended ggplot2 (mainly for ggarrange if needed)

#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

server <- function(input, output) {

}
