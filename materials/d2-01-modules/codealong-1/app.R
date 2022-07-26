library(shiny)
library(dplyr)
library(timevis)
library(httr2)
library(purrr)

# process department data
dept_choices <- get_dept_choices(res = "list")

ui <- fluidPage(
  p("add module UIs here")
)

server <- function(input, output, session) {
  # add module backend server calls here
}

shinyApp(ui = ui, server = server)