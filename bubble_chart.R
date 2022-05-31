# setwd("~/INFO 201 Code/exploratory-analysis-broyce24")
book_data <- read.csv("checkouts_by_title_2020.csv")
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(tools)
library(tidyverse)

# Remove "(Unabridged)" from all book titles
book_data$Title <- gsub("\\(Unabridged\\)", "", book_data$Title)
book_data$Title <- gsub("\\(Abridged\\)", "", book_data$Title)
book_data$Title <- gsub("\\(unabridged\\)", "", book_data$Title)
book_data$Title <- gsub("\\/.*", "", book_data$Title)
book_data$Title <- trimws(book_data$Title)
# book_data$Title <- toTitleCase(book_data$Title) -- not working

# Exclude classic literature from dataframe entries
exclude_classic_literature <- book_data %>%
  separate("Subjects", paste("Subjects", 1:3, sep="_"), sep=",", extra="drop") %>%
  filter(Subjects_1 != "Classic Literature") %>%
  filter(Subjects_2 != "Classic Literature") %>%
  filter(Subjects_3 != "Classic Literature")

#Separate title column by colon to shorten titles
short_title <- exclude_classic_literature %>%
  separate("Title", paste("Title", 1:2, sep="_"), sep=":", extra="drop")

# Remove the unneccessary columns, especially MaterialType because some books
# were checked out in ebook and audiobook formats
short_title <- subset(short_title, select = -c(UsageClass, CheckoutType,
                                   MaterialType, CheckoutYear, Publisher))

# Sum checkouts by title
sum_title <- short_title %>%
  group_by(CheckoutMonth, Title_1) %>%
  dplyr::summarise(Checkouts = sum(Checkouts), "Title_2" = Title_2,
                   "Creator" = Creator, "Subjects_1" = Subjects_1) %>% 
  as.data.frame()

# Sum checkouts by month
sorted_by_title <- sum_title %>%
  group_by(CheckoutMonth) %>%
  # Arrange in descending order
  arrange(desc(Checkouts), .by_group = TRUE) %>%
  # Remove duplicate rows
  distinct(Title_1, .keep_all = TRUE)

# Remove everything after 2nd comma in Creator column
sorted_by_title$Creator <- sub("^([^,]*,[^,]*),.*", "\\1", sorted_by_title$Creator)

# Take the top n entries
sorted_by_title_short <- sorted_by_title %>%
  slice_max(Checkouts, n = 5)

# Filter by title- this will be based on user input
# filter_by_title <- sorted_by_title_short %>%
 # filter(Title_1 == "input$title")

# Create scatter plot
most_pop_titles <- ggplot(data = sorted_by_title_short, 
  # This didn't work
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
                           "y", "Title" = "colour", "Creator" = "label"))