library(shiny)
library(dplyr)
library(timevis)
library(httr2)
library(purrr)

# process department data
dept_choices <- get_dept_choices(res = "list")

ui <- fluidPage(
  art_search_UI("artsearch", dept_choices = dept_choices),
  timevis_UI("art_timevis"),
  artviewer_UI("art_image")
)

server <- function(input, output, session) {
  search_results <- art_search_Server("artsearch")
  item_df <- timevis_Server("art_timevis", search_results, object_lifespan = TRUE)
  artviewer_Server("art_image", item_df)
}

shinyApp(ui = ui, server = server)