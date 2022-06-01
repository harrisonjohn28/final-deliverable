library(shiny)

source("server.R")
source("ui.R")

library(rsconnect)

shinyApp(ui = ui, server = server)