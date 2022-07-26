timevis_UI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        uiOutput(ns("title")),
        timevisOutput(ns("timevis"))
      )
    )
  )
}

timevis_Server <- function(id, search_results, object_lifespan = FALSE) {
  moduleServer(
    id,
    function(input, output, session) {
      
      timevis_data <- reactive({
        req(search_results())
        df <- search_results() %>%
          filter(!is.na(accessionYear)) %>%
          select(department, content = title, accessionYear, objectID, objectBeginDate, objectEndDate, primaryImageSmall)
        
        return(df)
      })
      
      output$title <- renderUI({
        req(timevis_data())
        glue::glue("{nrow(timevis_data())} results. Please click an entry to view the picture")
      })
      
      output$timevis <- renderTimevis({
        req(timevis_data())
        if (object_lifespan) {
          df <- timevis_data() %>%
            mutate(start = purrr::map_chr(accessionYear, ~process_time(.x)))
        } else {
          df <- timevis_data() %>%
            mutate(start = purrr::map_chr(objectBeginDate, ~process_time(.x)),
                   end = purrr::map_chr(objectEndDate, ~process_time(.x)))
        }
        timevis(
          data = df,
          fit = TRUE
        )
      })
      
      # reactive data frame of metadata for selected object
      item_df <- reactive({
        req(timevis_data())
        req(input$timevis_data)
        req(input$timevis_selected)
        objectID <- input$timevis_data %>%
          filter(id == input$timevis_selected) %>%
          pull(objectID)
        
        if (length(objectID) < 1) {
          return(NULL)
        }
        
        df <- dplyr::filter(search_results(), objectID == !!objectID)
        
        
        df
      })
      
      item_df
    }
  )
}