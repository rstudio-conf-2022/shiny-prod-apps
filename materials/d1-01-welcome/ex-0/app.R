library(shiny)
library(dplyr)

sample_data <- readRDS("data/sample_data.rds")
dept_choices <- sort(unique(sample_data$department))

ui <- fluidPage(
  titlePanel("Welcome to Building Production-Quality Shiny Applications!"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("app_viewer"),
      selectInput(
        "dept",
        "Select Department",
        choices = dept_choices,
        multiple = FALSE
      ),
      sliderInput(
        "bins",
        "Number of bins:",
        min = 1,
        max = 50,
        value = 10
      )
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output, session) {
  output$app_viewer <- renderUI({
    user <- get_user(session)
    p(glue::glue("Current viewer of app: {user}"))
  })
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    df <- dplyr::filter(sample_data, department == input$dept)
    x    <- dplyr::pull(df, n_objects)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}

shinyApp(ui = ui, server = server)
