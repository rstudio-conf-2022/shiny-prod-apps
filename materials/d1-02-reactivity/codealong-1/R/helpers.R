extract_var <- function(df, var) {
  dplyr::pull(df, {{ var }}) |> unique()
}

display_metadata <- function(df) {
  tagList(
    div(
      align = "center",
      h2(glue::glue("{extract_var(df, title)}")),
      br(),
      h4(glue::glue("{extract_var(df, object_date)}")),
      br(),
      h4(glue::glue("{extract_var(df, department)}")),
      br(),
      fluidRow(
        column(
          width = 6,
          p(tags$b("Creator:"), glue::glue("{extract_var(df, artist_display_name)}")),
          p(tags$b("Type:"), glue::glue("{extract_var(df, object_name)}")),
          p(tags$b("Medium:"), glue::glue("{extract_var(df, medium)}")),
          p(tags$b("Physical Dimensions:"), glue::glue("{extract_var(df, dimensions)}")),
        ),
        column(
          width = 6,
          p(tags$b("Period:"), glue::glue("{extract_var(df, period)}")),
          p(tags$b("Culture:"), glue::glue("{extract_var(df, culture)}")),
          p(tags$b("Country of Origin:"), glue::glue("{extract_var(df, country)}")),
          p(tags$b("Credit Line:"), glue::glue("{extract_var(df, credit_line)}")),
          p(tags$b("Accession Year:"), glue::glue("{extract_var(df, accession_year)}"))
        )
      ),
      fluidRow(
        column(
          width = 12,
          p(tags$b("External Link:"), tags$a(href = extract_var(df, link_resource), extract_var(df, link_resource)))
        )
      )
    )
  )
}