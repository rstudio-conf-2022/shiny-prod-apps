artviewer_UI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 8,
        uiOutput(ns("img")),
      ),
      column(
        width = 4,
        uiOutput(ns("metadata")),
      )
    )
  )
}

artviewer_Server <- function(id, item_df) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      
      # render image
      output$img <- renderUI({
        req(item_df())
        image_url <- dplyr::pull(item_df(), primaryImageSmall)
        
        if (!shiny::isTruthy(image_url)) {
          p("No Image URL available")
        } else {
          tags$img(
            src = image_url,
            id = "imgid", 
            alt = glue::glue("{dplyr::pull(item_df(), title)}"), 
            class = "borderedpicture3"
          )
        }
        
      })
      
      # render metadata
      output$metadata <- renderUI({
        req(item_df())
        display_metadata(item_df())
      })
    }
  )
}