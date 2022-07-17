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
      ),
      sliderInput(
        "conf",
        "Confidence Score Range",
        min = 0,
        max = 1,
        value = c(0, 1),
        step = 0.1
      )
    ),
    column(
      width = 8,
      uiOutput("conf_avg"),
      plotOutput("top_objects")
    )
  )
)

server <- function(input, output, session) {
  output$conf_avg <- renderUI({
    avg_conf <- art_random %>%
      left_join(object_annotation_df, by = "image_file") %>%
      group_by(department) %>%
      summarize(avg_conf = mean(score, na.rm = TRUE)) %>%
      ungroup() %>%
      filter(department == input$dept) %>%
      pull(avg_conf)
    
    p(glue::glue("Average score of annotations: {round(avg_conf, 3)}"))
  })
  
  output$top_objects <- renderPlot({
    df <- art_random %>%
      select(department, image_file) %>%
      left_join(object_annotation_df, by = "image_file") %>%
      filter(between(score, input$conf[1], input$conf[2])) %>%
      count(department, name) %>%
      arrange(department, desc(n)) %>%
      group_by(department) %>%
      mutate(rank = rank(-n)) %>%
      ungroup() %>%
      filter(department == input$dept) %>%
      filter(rank <= input$n_top) %>%
      select(name, n)

    ggplot(df, aes(x = name, y = n)) +
      geom_col() +
      xlab(NULL) +
      ylab("Frequency of Annotation") +
      ggtitle(glue::glue("Top {input$n_top} Objects Annotated"),
              subtitle = "Ties included")
  })
}

shinyApp(ui = ui, server = server)
