# load packages ----
library(shiny)
library(dplyr)
library(dbplyr)
library(pool)
library(DBI)

# import data ----
pool <- dbPool(
  drv = RSQLite::SQLite(),
  dbname = "data/db_small.sqlite"
)

art_sub <- tbl(pool, "art")

# derive key variables used inside application ----
department_choices <- art_sub %>%
  select(department) %>%
  distinct() %>%
  collect() %>%
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
      uiOutput("img")
    ),
    column(
      width = 4,
      uiOutput("metadata")
    )
  ),
  
  # Recording art approval/rejection
  fluidRow(
    column(
      width = 12,
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
  ),
  
  # show table of liked / disliked art pieces
  tableOutput("choice_table")
)

# define application server logic ----
server <- function(input, output, session) {
  
  # establish key reactive values
  image_views <- reactiveVal(NULL)
  image_likes <- reactiveVal(NULL)
  image_rejects <- reactiveVal(NULL)
  
  # assemble data based on department selected
  current_data <- reactive({
    if (input$dept == "Any") {
     df <- art_sub %>%
       collect()
    } else {
      dplyr::filter(art_sub, department %in% input$dept) %>% collect()
    }
  })
  
  # reactive for the data of the current image evaluation
  current_image_df <- reactive({
    req(current_data())
    if (!is.null(image_views())) {
      df <- current_data() %>%
        filter(!image_file %in% image_views())
    } else {
      df <- current_data()
    }
    
    image_files <- dplyr::pull(df, image_file)
    image_selected <- sample(image_files, 1)
    
    dplyr::filter(df, image_file == image_selected)
  })
  
  # render image
  output$img <- renderUI({
    image_url <- dplyr::pull(current_image_df(), image_small_url)
    tags$img(src = image_url)
  })
  
  # render metadata
  output$metadata <- renderUI({
    display_metadata(current_image_df())
  })
  
  # process approval click
  observeEvent(input$like, {
    image_file <- dplyr::pull(current_image_df(), image_file)
    image_views(c(image_views(), image_file))
    image_likes(c(image_likes(), image_file))
  })
  
  # process rejection click
  observeEvent(input$dislike, {
    image_file <- dplyr::pull(current_image_df(), image_file)
    image_views(c(image_views(), image_file))
    image_rejects(c(image_rejects(), image_file))
  })
  
  # reactive data set of liked and disliked images
  choice_data <- reactive({
    req(image_views())
    # filter for images evaluated
    browser()
    df <- art_sub %>%
      filter(image_file %in% !!image_views()) %>%
      collect() %>%
      mutate(decision = case_when(
        image_file %in% image_likes() ~ "like",
        image_file %in% image_rejects() ~ "reject",
        TRUE ~ "unknown"
      )) %>%
      mutate(time = Sys.time(),
             user = get_user(session)) 
  })
  
  # display user choices
  output$choice_table <- renderTable({
    req(choice_data())
    choice_data() %>%
      select(user, title, department, decision, time)
  })
  
  observeEvent(choice_data(), {
    df <- choice_data() %>%
      select(image_file, user, decision, time)
    
    DBI::dbAppendTable(pool, "user_choice", df)
    
  })
}

# run the application ----
shinyApp(ui = ui, server = server)