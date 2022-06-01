# setwd("~/INFO 201 Code/exploratory-analysis-broyce24")
book_data <- read.csv("checkouts_by_title_2020.csv")
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(tools)
library(tidyverse)
library(stringr)

# Remove "(Unabridged)" from all book titles
book_data$Title <- gsub("\\(Unabridged\\)", "", book_data$Title)
book_data$Title <- gsub("\\(Abridged\\)", "", book_data$Title)
book_data$Title <- gsub("\\(unabridged\\)", "", book_data$Title)
# Remove "/author" from title column
book_data$Title <- gsub("\\/.*", "", book_data$Title)
# Trim whitespace
book_data$Title <- trimws(book_data$Title)
# Convert Title to title case for better merging
book_data$Title <- str_to_title(book_data$Title)

# Exclude classic literature from dataframe entries
exclude_classic_literature <- book_data %>%
  separate("Subjects", paste("Subjects", 1:3, sep="_"), sep=",", extra="drop") %>%
  filter(Subjects_1 != "Classic Literature") %>%
  filter(Subjects_2 != "Classic Literature") %>%
  filter(Subjects_3 != "Classic Literature")

# Remove the unneccessary columns, especially MaterialType because some books
# were checked out in ebook and audiobook formats
short_title <- subset(exclude_classic_literature, select = -c(UsageClass, 
                    CheckoutType, MaterialType, CheckoutYear, Publisher))

# Sum checkouts by title, across all material types
sum_title <- short_title %>%
  group_by(CheckoutMonth, Title) %>%
  dplyr::summarise(Checkouts = sum(Checkouts), "Title" = Title,
                   "Creator" = Creator, "Subjects_1" = Subjects_1) %>% 
  as.data.frame()

# Sum checkouts by month
sorted_by_title <- sum_title %>%
  # Arrange in descending order
  arrange(CheckoutMonth, desc(Checkouts)) %>%
  group_by(CheckoutMonth) %>% 
  # Remove duplicate rows
  distinct(Title, .keep_all = TRUE)

# Take the top n entries
sorted_by_title_short <- sorted_by_title %>%
  slice_max(Checkouts, n = 5)

# Separate title column by colon to shorten titles
short_title <- sorted_by_title_short %>%
  separate("Title", paste("Title", 1:2, sep="_"), sep=":", extra="drop")

# Remove everything after 2nd comma in Creator column
short_title$Creator <- sub("^([^,]*,[^,]*),.*", "\\1",
                               short_title$Creator)

# Add Month (name) column
added_month_names <- short_title %>%
  mutate("Month" = month.name[CheckoutMonth])

# Convert cleaned dataframe to a csv
write.csv(added_month_names, file = "clean_book_data.csv")

# # Read in clean csv file for bubble chart
# clean_book_data <- read.csv("clean_book_data.csv")
# 
# # Filter by title- based on user input
# filter_by_title <- clean_book_data %>%
#   filter(Title_1 %in% input$title)
# 
# # Create scatter plot
# most_pop_titles <- ggplot(data = filter_by_title) +
#   geom_point(aes(x = CheckoutMonth, 
#                  y = Checkouts,
#                  colour = Title_1,
#                  label = Creator,
#                  # Make it a bubble plot
#                  size = Checkouts,
#                  # text attribute for tooltip didn't work
#                  text = paste("Title:", Title_1,
#                               "\nAuthor/Creator:", Creator, "\nMonth:", Month,
#                               "\nNumber of checkouts:", Checkouts),
#                  # Remind graph to group by title
#                  group = Title_1)) +
#   labs(title = "Most Checked Out Titles of 2020, Excluding Classic Literature", 
#        # Set legend title
#        color = "Titles", size = "", x = "Month", y = "Total Monthly Checkouts")
# 
# # Make interactive
# scatter_titles <- ggplotly(p = most_pop_titles,
#                            dynamicTicks = TRUE,
#                            # group = Title_1,
#                            # Call the custom text for the tooltip
#                            tooltip = c("text"))


# Filter by title- based on user input
# filter_by_title <- added_month_names %>%
# filter(Title_1 %in% "input$title")

# Create scatter plot
# most_pop_titles <- ggplot(data = filter_by_title, 
  # text attribute for tooltip didn't work
#  text = paste("Title:", c(Title_1,": ", Title_2), "<br>", "Author/Creator:",
             #  Creator, "<br>", "Month:", Month, "<br>",
            #  "Number of checkouts:", Checkouts)) +
 # geom_point(aes(x = CheckoutMonth, 
             #  y = Checkouts,
             #  colour = Title_1,
#                label = Creator,
#                # Make it a bubble plot
#                size = Checkouts,
#                # Remind graph to group by title
#                group = Title_1)) +
#   labs(title = "Most Checked Out Titles of 2020, Excluding Classic Literature", 
#        # Set legend title
#        color = "Titles", size = "", x = "Month", y = "Total Monthly Checkouts")
# 
# # Make interactive
# scatter_titles <- ggplotly(p = most_pop_titles,
#                            dynamicTicks = TRUE,
#                            group = Title_1,
#                            # Call the custom text for the tooltip
#                            tooltip = c("Month" = "x", "Number of checkouts" =
#                            "y", "Title" = "colour", "Creator" = "label"))