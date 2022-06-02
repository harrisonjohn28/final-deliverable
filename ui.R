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
format_data$format_code <- as.character(format_data$format_code)


# Setting our default theme to flatly and adding css
shiny_theme <- bs_theme(bootswatch = "flatly") %>% 
  bs_add_rules(sass::sass_file("style.scss"))

# Intro tab
intro_tab <- tabPanel(
  "Intro",
   fluidPage(
      includeHTML("introduction.html")
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
  ),
  p(`class` = "ben",
    "We chose this chart to analyze the public's interest in specific genres over the course of the year, as a worldwide pandemic may affect the topics people are interested in checking out. As we can see, the most popular genres stay fairly regular relative to one another, with the exception of Juvenile Fiction (YA novel), which began being checked out at an incredible rate as quarantine set in. A likely explanation for this finding is that when school was canceled for middle and high schoolers, many of them choose to check out their favorite books to read while stuck at home. Young Adult is a very popular genre with this age group and this would explain the sudden boom in checkouts."
),
p(`class` = "ben",
  "Many of the books' primary genres were labeled as fiction/nonfiction, which would've been the most popular \"genres\" by far had they been included on the graph. Because splitting up books into these two labels is vague and inconsistent (not every book had this distinction, and some had them elsewhere in their list of subjects), we chose to replace these labels with their secondary, more specific genre. \"Literature\" refers to the books that were labeled as fiction but had no other listed genre.")

)

summary_tab <- tabPanel(
  "Summary",
  fluidPage(
    includeHTML("summary.html")
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
    choices = list("Book", "eBook", "Audio", "Video", "Other")
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