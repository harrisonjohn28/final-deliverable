library(plotly)
library(bslib)
library(shiny)
library(thematic)
library(showtext)

#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
# lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

# Read in clean csv file for bubble chart
clean_book_data <- read.csv("clean_book_data.csv")
# Read in clean csv file for line chart
genre_data <- read.csv("top_10_genres_per_month.csv")
# Read in clean csv file for bar chart
format_data <- read.csv("format_trunc.csv")


# Creating an empty theme to fill with bs_theme_update
shiny_theme <- bs_theme(bg = "black",
                     fg = "white",
                     primary = "white")
shiny_theme <- bs_theme_update(shiny_theme, bootswatch = "sandstone")
# Updated theme to flatly
shiny_theme <- bs_theme_update(shiny_theme, bootswatch = "flatly") %>% 
  bs_add_rules(sass::sass_file("style.scss"))

# Intro tab
intro_tab <- tabPanel(
  "Intro",
   fluidPage(
     mainPanel(
       includeHTML("introduction.html")
     )
   # Pulling in markdown file to display
   # includeMarkdown("a4_analysis.md"),
  )
)

# Making sidebar widgets for title selection from a fill/dropdown
title_widget <- sidebarPanel(
  selectInput(
    inputId = "title",
    label = "Select Title(s)",
    choices = clean_book_data$Title_1,
    multiple = TRUE,
    selected = "So You Want To Talk About Race"
    )
#,
)
# Year selection from a range slider
#   sliderInput(inputId = "year_select",
#               label = "Year Selection",
#               min = min(co2$year),
#               max = max(co2$year),
#               value = c(1920, 2010)
#   )
# )
# 
# 
# Displaying interactive plot, built with Plotly
bubble_plot <- mainPanel(
  plotlyOutput(outputId = "bubble_plot")
)

# Building second tab
titles_page <- tabPanel(
  "Most Popular Titles",
  sidebarLayout(
    title_widget,
    bubble_plot
   )
)


# Ben's line chart page
genres_sidebar <- sidebarPanel(
  sliderInput(
    inputId = "numGenres",
    label = "Select the number of genres per month you'd like to display:",
    min = 1,
    max = 10,
    value = 6
  )
)
genre_chart <- mainPanel(
  plotlyOutput(outputId = "line_chart")
)
genres_page <- tabPanel(
  "Top Genres",
  sidebarLayout(
    genres_sidebar,
    genre_chart
  )
)
summary_tab <- tabPanel(
  "Summary",
  fluidPage(
    mainPanel(
      includeHTML("summary.html")
    )
  )
)

###Bar chart
chart_sidebar <- sidebarPanel(
  sliderInput(
    inputId = "barMonths",
    label = "Time Period in 2020",
    min = 1, 
    max = 12, 
    value = c(1, 12)
    ),
  checkboxGroupInput(
    "barFormat", 
    label = h3("Formats of Interest"), 
    choices = list("Book" = 1, "eBook" = 2, "Audio" = 3, "Video" = 4, "Other" = 5),
    selected = c(1:5)
    )
)

format_chart <- mainPanel(
  plotlyOutput(outputId = "format_chart")
)

format_page <- tabPanel(
  "Format Checkouts",
  sidebarLayout(
    chart_sidebar,
    format_chart
  )
)

ui <- navbarPage(
  theme = shiny_theme,
  "INFO 201",
  intro_tab,
  titles_page,
  genres_page,
  format_page,
  summary_tab
)