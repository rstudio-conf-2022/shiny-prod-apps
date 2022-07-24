library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(script = "script.js", functions = "say_hi"),
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
    js$say_hi(input$msg)
  })
}

shinyApp(ui, server)