library(shiny)
library(dplyr)
library(reactlog)

reactlog_enable()

# TODO: Port this image_small_url to database and random subsets
art_sub <- readRDS("../assets/data/art_random.rds") %>%
  mutate(image_small_url = stringr::str_replace_all(image_url, "original", "web-large"))

# choices for art department
art_dept_choices <- c(
  "Ancient Near Eastern Art",
  "Arms and Armor",
  "Arts of Africa, Oceania, and the Americas",
  "Asian Art",
  "Costume Institute",
  "Drawings and Prints",
  "Egyptian Art",
  "European Sculpture and Decorative Arts",
  "Greek and Roman Art",
  "Islamic Art",
  "Medieval Art",
  "Musical Instruments",
  "Robert Lehman Collection",
  "The American Wing",
  "The Cloisters"
)

ui <- fluidPage(
  fluidRow(
    column(
      width = 12,
      h2("The MET Image Viewer!")
    )
  ),
  fluidRow(
    div(
      align = "center",
      selectInput(
        "dept",
        "Department",
        choices = art_dept_choices,
        multiple = FALSE
      )
    )
  ),
  fluidRow(
    div(
      align = "center",
      uiOutput("img"),
      textOutput("metadata")
    )
  )
  # fluidRow(
  #   column(
  #     width = 12,
  #     reactlog_module_ui()
  #   )
  # )
)

server <- function(input, output, session) {
  
  current_image_df <- reactive({
    df <- art_sub %>%
      filter(department == input$dept) %>%
      slice_sample(n = 1)
  })
  
  output$img <- renderUI({
    tags$img(src = pull(current_image_df(), image_small_url))
  })
  
  output$metadata <- renderText({
    glue::glue("{pull(current_image_df(), title)} from {pull(current_image_df(), department)}")
  })
  
  #reactlog_module_server()
}

shinyApp(ui = ui, server = server, options = list(display.mode = "showcase"))
