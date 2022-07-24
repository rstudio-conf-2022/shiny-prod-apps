library(shiny)
library(shinipsum)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(),
  fluidRow(
    column(
      width = 4,
      selectInput(
        "dept",
        "Select Department",
        choices = lorem_words[1:10]
      )
    )
  ),
  fluidRow(
    column(
      width = 8,
      plotOutput("image")
    ),
    column(
      width = 4,
      textOutput("metadata")
    )
  ),
  fluidRow(
    column(
      width = 12,
      DT::DTOutput("choices")
    )
  )
)

server <- function(input, output, session) {
  # TODO: add server-side processing
  bs_themer()
  
  output$image <- renderImage({
    random_image()
  }, deleteFile = TRUE)
  
  output$metadata <- renderText({
    random_text(nwords = 20)
  })
  
  output$choices <- DT::renderDT({
    random_DT(10, 5)
  })
}

# run the application ----
shinyApp(ui = ui, server = server)