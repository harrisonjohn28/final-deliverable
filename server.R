library(markdown) #to resolve shinyapps errors
# library(plyr) #primarily for melt function
library(tidyverse) #ggplot2, tidyr, dplyr, stringr
library(plotly) #interactive graphs
library(egg) #extended ggplot2 (mainly for ggarrange if needed)

#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
# lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

# Read in clean csv file for bubble chart
clean_book_data <- read.csv("clean_book_data.csv")

server <- function(input, output) {
  output$bubble_plot <- renderPlotly({
    # Filter by title- based on user input
    filter_by_title <- clean_book_data %>%
      filter(Title_1 %in% input$title)
    
    # Create scatter plot
    most_pop_titles <- ggplot(data = filter_by_title) +
      geom_point(aes(x = CheckoutMonth, 
                     y = Checkouts,
                     colour = Title_1,
                     label = Creator,
                     # Make it a bubble plot
                     size = Checkouts,
                     # text attribute for tooltip didn't work
                     text = paste("Title:", Title_1,
                        "\nAuthor/Creator:", Creator, "\nMonth:", Month,
                        "\nNumber of checkouts:", Checkouts),
                     # Remind graph to group by title
                     group = Title_1,
                     # Create partially opaque points
                     alpha = 0.25)) +
      labs(title = "Most Checked Out Titles of 2020,
    Excluding Classic Literature", 
           # Set legend title
           color = "Titles", size = "", alpha = "", x = "Month",
           y = "Total Monthly Checkouts")
    
    # Make interactive
    scatter_titles <- ggplotly(p = most_pop_titles,
                               dynamicTicks = TRUE,
                               # group = Title_1,
                               # Call the custom text for the tooltip
                               tooltip = c("text"))
    return(scatter_titles)
    })
}