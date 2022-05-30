library(plotly)
library(bslib)

######### READ THIS PLEASE #########
#Other than lib_df, this is all my code from a4; it *will not work* since it's
#referencing an entirely different dataset. Use this as a template or guide
#for how to build out your pages, but don't try to run it or you'll be sad.
#GL on the project! <3 - J


#Loading data 
##(setwd to source file location and have checkouts_by_title_2020 there)
lib_df <- read.csv("checkouts_by_title_2020.csv", stringsAsFactors = FALSE)

#Creating an empty theme to fill with bs_theme_update
shiny_theme <- bs_theme(bg = "black",
                     fg = "white",
                     primary = "white")
shiny_theme <- bs_theme_update(shiny_theme, bootswatch = "sandstone")


# # Intro tab
# intro_tab <- tabPanel(
#   "Intro",
#   fluidPage(
#     # Pulling in markdown file to display
#     includeMarkdown("a4_analysis.md"),
#   )
# )
# 
# # Making sidebar widgets for country selection from a fill/dropdown
# # and year selection from a range slider
# sidebar_widget <- sidebarPanel(
#   selectInput(
#     inputId = "country_select",
#     label = "Country Selection",
#     choices = co2$country,
#     multiple = TRUE
#   ),
#   sliderInput(inputId = "year_select",
#               label = "Year Selection",
#               min = min(co2$year),
#               max = max(co2$year),
#               value = c(1920, 2010)
#   )
# )
# 
# 
# # Displaying interactive plot from co2_svr, built with Plotly
# plot_display <- mainPanel(
#   plotlyOutput(outputId = "climate_plot")
# )
# 
# # building second tab
# emis_by_cty <- tabPanel(
#   "Emissions by Country",
#   sidebarLayout(
#     sidebar_widget,
#     plot_display
#   )
# )
# 
# ui <- navbarPage(
#   theme = shiny_theme,
#   "INFO 201 A4",
#   intro_tab,
#   emis_by_cty
# )
# 
