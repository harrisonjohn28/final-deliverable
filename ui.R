library(plotly)
library(bslib)
library(shiny)

#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
# lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

# Creating an empty theme to fill with bs_theme_update
shiny_theme <- bs_theme(bg = "black",
                     fg = "white",
                     primary = "white")
shiny_theme <- bs_theme_update(shiny_theme, bootswatch = "sandstone")

# Intro tab
intro_tab <- tabPanel(
  "Intro",
   fluidPage(
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

ui <- navbarPage(
  theme = shiny_theme,
  "INFO 201",
  intro_tab,
  titles_page,
)
