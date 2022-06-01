library(markdown) #to resolve shinyapps errors
# library(plyr) #primarily for melt function
library(tidyverse) #ggplot2, tidyr, dplyr, stringr
library(plotly) #interactive graphs
# library(egg) #extended ggplot2 (mainly for ggarrange if needed)
library(scales)

#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
# lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

# Read in clean csv file for bubble chart
clean_book_data <- read.csv("clean_book_data.csv")
# Read in clean csv file for line chart
genre_data <- read.csv("top_10_genres_per_month.csv")
# Read in clean csv file for bar chart
format_data <- read.csv("format_trunc.csv") 
format_data$format_code <- as.character(format_data$format_code)


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
  
  output$line_chart <- renderPlotly({
    genres <- genre_data %>%
      group_by(CheckoutMonth) %>%
      slice(1:input$numGenres) %>% 
      rename(Month = CheckoutMonth,
             Checkouts = total,
             Genre = genre1 
             )
    a <- ggplot(data = genres) +
      geom_line(mapping = aes(x = Month, 
                              y = Checkouts, 
                              color = Genre),

                size = 1) +
      scale_x_continuous(breaks = c(1:12),
                         labels = month.name,
                         name = "Month") +
      scale_y_continuous(name = "Total Checkouts") +
      labs(title = "Top Genres Throughout 2020", color = "Genre") +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 45))
    return(ggplotly(a))
  })
  
  output$format_chart <- renderPlotly({
    server_df <- format_data %>% 
      filter(CheckoutMonth >= input$barMonths[1] & CheckoutMonth <= input$barMonths[2]) %>% 
      filter(format_code %in% input$barFormat)
    
    cool <- ggplot(server_df, aes(fill = format_code, x=CheckoutMonth)) +
      geom_bar(position="stack") +
      ggtitle("Monthly Check Out Volume by Media Format") +
      xlab("Checkout Month (January to December 2020)") + ylab("Total Titles Checked Out") +
      scale_x_continuous(breaks = pretty_breaks()) +
      scale_fill_discrete(name = "Format", labels = c("Book", "eBook", "Audio", "Visual", "Other"))
    
    return(ggplotly(cool))
  })
  
}