library(markdown) #to resolve shinyapps errors
library(plyr) #primarily for melt function
library(tidyverse) #ggplot2, tidyr, dplyr, stringr
library(plotly) #interactive graphs
library(egg) #extended ggplot2 (mainly for ggarrange if needed)

#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

# Source chart files
source("bubble_chart.R")

server <- function(input, output) {
  output$bubble_plot <- renderPlotly({
    # Filter by title- based on user input
    filter_by_title <- sorted_by_title_short %>%
      filter(Title_1 %in% input$title)
    
    # Create scatter plot
    most_pop_titles <- ggplot(data = filter_by_title, 
      # text attribute for tooltip didn't work
      text = paste("Title:", c(Title_1,": ", Title_2), "<br>", "Author/Creator:",
             Creator, "<br>", "Month:", CheckoutMonth, "<br>",
             "Number of checkouts:", Checkouts)) +
      geom_point(aes(x = CheckoutMonth, 
                     y = Checkouts,
                     colour = Title_1,
                     label = Creator,
                     # Make it a bubble plot
                     size = Checkouts,
                     # Remind graph to group by title
                     group = Title_1)) +
      labs(title = "Most Checked Out Titles of 2020, Excluding Classic Literature", 
           # Set legend title
           color = "Titles", size = "", x = "Month", y = "Total Monthly Checkouts")
    
    # Make interactive
    scatter_titles <- ggplotly(p = most_pop_titles,
                               dynamicTicks = TRUE,
                               # Call the custom text for the tooltip
                               tooltip = c("Month" = "x", "Number of checkouts" =
                                "y", "Title" = "colour", "Creator" = "label"))})
  return(scatter_titles)
}
