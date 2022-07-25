# load packages ----
library(shiny)
library(dplyr)

# import data ----
art_sub <- readRDS("data/art_random.rds")

# derive key variables used inside application ----
department_choices <- art_sub %>%
  select(department) %>%
  distinct() %>%
  arrange(department) %>%
  pull(department)

# define application user interface ----
ui <- fluidPage(
  h2("The MET Art Viewer!"),
  fluidRow(
    column(
      width = 4,
      selectInput(
        "dept",
        "Select Department",
        choices = c("Any", department_choices),
        multiple = FALSE
      )
    )
  ),
  
  # Viewing the art image and metadata
  fluidRow(
    column(
      width = 8,
      # TODO: Populate this with image view
      h3("TODO: Add Image View")
    ),
    column(
      width = 4,
      # TODO: Populate this with image metadata
      h3("TODO: Add Metadata Display")
    )
  ),
  
  # Recording art approval/rejection
  fluidRow(
    actionButton(
      "like",
      label = NULL,
      icon = icon("thumbs-up")
    ),
    actionButton(
      "dislike",
      label = NULL,
      icon = icon("thumbs-down")
    )
  )
)

# define application server logic ----
server <- function(input, output, session) {
  # TODO: Define reactive for current data view
  
  # TODO: Render image and metadata
}

# run the application ----
shinyApp(ui = ui, server = server)