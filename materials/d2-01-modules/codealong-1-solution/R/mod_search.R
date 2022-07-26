art_search_UI <- function(id, dept_choices) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 4,
        textInput(
          ns("search_box"),
          "Search Query",
          placeholder = "enter single word"
        )
      ),
      column(
        width = 6,
        selectInput(
          ns("dept"),
          "Select Department",
          choices = dept_choices,
          selectize = FALSE
        )
      )
    ),
    fluidRow(
      column(
        width = 4,
        actionButton(
          ns("search_btn"),
          label = "Search",
          icon = icon("keyboard")
        )
      )
    )
  )
}

art_search_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      search_results <- reactive({
        if (!shiny::isTruthy(input$search_box)) {
          shinyWidgets::show_toast(
            "Enter a search term",
            type = "error",
            position = "top"
          )
          return(NULL)
        }
        
        search_test <- search_dept_data(q = input$search_box, departmentId = input$dept)
        if (is.null(search_test)) {
          message("I got nothing")
          shinyWidgets::show_toast(
            "I got nothing",
            type = "error",
            position = "center"
          )
          return(NULL)
        }
        
        search_test
        
      }) %>% bindEvent(input$search_btn, ignoreInit = TRUE)

      search_results
    }
  )
}