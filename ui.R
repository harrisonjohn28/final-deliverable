library(plotly)
library(bslib)
library(shiny)

######### READ THIS PLEASE #########
#Other than lib_df, this is all my code from a4; it *will not work* since it's
#referencing an entirely different dataset. Use this as a template or guide
#for how to build out your pages, but don't try to run it or you'll be sad.
#GL on the project! <3 - J

# Source charts
source("bubble_chart.R")

#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

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
    choices = sorted_by_title_short$Title_1,
    multiple = TRUE
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
  titles_page
)
