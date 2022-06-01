library(tidyverse)
library(dplyr)
book_data <- read.csv("checkouts_by_title_2020.csv")
# We need to split up the Subjects columns, which is a list of the genres
#   that apply to each book.

# Finding the max number of genres for a given book. 
# +1 because a book with two genres will only have 1 comma.
ncols <- max(str_count(book_data$Subjects, ", ")) + 1

# Creating a vector of columns that will hold each genre 
new_columns <- paste0("genre", 1:ncols)

# Splitting the original column into separate genre columns
book_data_split <-
  separate(
    data = book_data,
    col = Subjects,
    sep = ", ",
    into = new_columns,
    remove = FALSE
  )

# Creating a dataframe with just the relevant info
genre_df <- book_data_split %>% 
  select(CheckoutMonth, genre1, genre2)

# Replaces Fiction/Nonfiction with the secondary, more specific, genre 
genre_df$genre1 <- ifelse(
  genre_df$genre1 == "Fiction" | genre_df$genre1 == "Nonfiction", 
  genre_df$genre2, 
  genre_df$genre1)

# Totals the genres by month and slices the top 10
top_10_genres_by_month <- genre_df %>% 
  group_by(CheckoutMonth) %>% 
  group_by(genre1, add = TRUE) %>% 
  summarize(total = n()) %>% 
  arrange(desc(total)) %>% 
  slice(1:10)

# Exporting the df to a new csv file to be read in by my page
write.csv(top_10_genres_by_month, file = "top_10_genres_per_month.csv", row.names = F)
