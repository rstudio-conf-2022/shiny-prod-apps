library(shiny)
library(dplyr)
library(ggplot2)

art_random <- readRDS("data/art_random.rds")
object_annotation_df <-readRDS("data/object_annotation_df.rds")

dept_choices <- sort(unique(art_random$department))

ui <- fluidPage(
  fluidRow(
    column(
      width = 12,
      h2("Explore the MET Collection!")
    )
  ),
  fluidRow(
    column(
      width = 4,
      selectInput(
        "dept",
        "Select Department",
        choices = dept_choices,
        selected = dept_choices[1],
        multiple = FALSE
      ),
      sliderInput(
        "n_top",
        "Top Annotations",
        min = 1,
        max = 10,
        value = 5,
        step = 1
      )
    ),
    column(
      width = 8,
      plotOutput("top_objects")
    )
  )
)

server <- function(input, output, session) {
  output$top_objects <- renderPlot({
    df <- art_random %>%
      filter(department == input$dept) %>%
      left_join(object_annotation_df, by = "image_file") %>%
      count(name, sort = TRUE) %>%
      mutate(name_f = forcats::fct_reorder(name, n, max, .desc = TRUE)) %>%
      slice(1:input$n_top)
    
    ggplot(df, aes(x = name_f, y = n)) +
      geom_col() +
      xlab(NULL) +
      ylab("Frequency of Annotation") +
      ggtitle(glue::glue("Top {input$n_top} Objects Annotated"))
  })
}

shinyApp(ui = ui, server = server)
