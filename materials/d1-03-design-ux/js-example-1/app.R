library(shiny)

ui <- fluidPage(
  tags$head(
    # Listen for background-color messages
    tags$script("
      Shiny.addCustomMessageHandler('say-hi', function(msg) {
        alert('Hello user! Your message is ' + msg)
      });
    ")
  ),
  fluidRow(
    column(
      width = 12,
      textInput("msg", "Enter a message", value = "Shiny is fun!"),
      actionButton("btn", "Say Hi")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$btn, {
    # Send the next color to the browser
    session$sendCustomMessage("say-hi", input$msg)
  })
}

shinyApp(ui, server)