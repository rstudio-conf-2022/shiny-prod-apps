get_dept_choices <- function(res = c("df", "list"), base_url = "https://collectionapi.metmuseum.org/public/collection/v1") {
  res <- match.arg(res)
  req <- request(base_url) %>%
    req_url_path_append("departments")
  
  resp <- req_perform(req)
  
  departments <- resp %>%
    resp_body_json() %>%
    purrr::pluck("departments") %>%
    transpose() %>%
    tibble::as_tibble() %>%
    tidyr::unnest(cols = c("departmentId", "displayName"))
  
  if (res == "list") {
    dep_list <- as.list(departments$departmentId)
    names(dep_list) <- departments$displayName
    return(dep_list)
  }
  return(departments)
}

search_dept_data <- function(q, departmentId, base_url = "https://collectionapi.metmuseum.org/public/collection/v1") {
  req <- request(base_url) %>%
    req_url_path_append("search") %>%
    req_url_query(q = q, departmentId = departmentId)
  
  resp <- req_perform(req)
  
  total_objects <- resp %>%
    resp_body_json() %>%
    purrr::pluck("total")
  
  if (total_objects < 1) {
    return(NULL)
  }
  
  objects <- resp %>%
    resp_body_json() %>%
    purrr::pluck("objectIDs") %>%
    purrr::as_vector()
  
  object_df <- purrr::map_df(objects, ~{
    req <- request(base_url) %>%
      req_url_path_append(glue::glue("objects/{.x}"))
    resp <- req_perform(req)
    
    result <- resp %>%
      resp_body_json()

    df <- tibble::tibble(
      title = result$title,
      objectDate = result$objectDate,
      department = result$department,
      artistDisplayName = result$artistDisplayName,
      objectName = result$objectName,
      medium = result$medium,
      dimensions = result$dimensions,
      period = result$period,
      culture = result$culture,
      country = result$country,
      creditLine = result$creditLine,
      accessionYear = as.numeric(result$accessionYear),
      objectURL = result$objectURL,
      objectBeginDate = as.numeric(result$objectBeginDate),
      objectEndDate = as.numeric(result$objectEndDate),
      primaryImageSmall = result$primaryImageSmall,
      primaryImage = result$primaryImage,
      objectID = result$objectID
      
    )
    return(df)
  })
  
  return(object_df)
}

get_user <- function(session) {
  user <- session$user
  if (is.null(user)) user <- Sys.getenv("USER")
  return(user)
}

extract_var <- function(df, var) {
  dplyr::pull(df, {{ var }}) |> unique()
}

display_metadata <- function(df) {
  tagList(
    div(
      align = "center",
      h2(glue::glue("{extract_var(df, title)}")),
      br(),
      h4(glue::glue("{extract_var(df, objectDate)}")),
      br(),
      h4(glue::glue("{extract_var(df, department)}")),
      br(),
      fluidRow(
        column(
          width = 6,
          p(tags$b("Creator:"), glue::glue("{extract_var(df, artistDisplayName)}")),
          p(tags$b("Type:"), glue::glue("{extract_var(df, objectName)}")),
          p(tags$b("Medium:"), glue::glue("{extract_var(df, medium)}")),
          p(tags$b("Physical Dimensions:"), glue::glue("{extract_var(df, dimensions)}")),
        ),
        column(
          width = 6,
          p(tags$b("Period:"), glue::glue("{extract_var(df, period)}")),
          p(tags$b("Culture:"), glue::glue("{extract_var(df, culture)}")),
          p(tags$b("Country of Origin:"), glue::glue("{extract_var(df, country)}")),
          p(tags$b("Credit Line:"), glue::glue("{extract_var(df, creditLine)}")),
          p(tags$b("Accession Year:"), glue::glue("{extract_var(df, accessionYear)}"))
        )
      ),
      fluidRow(
        column(
          width = 12,
          p(tags$b("Object Link:"), tags$a(href = extract_var(df, objectURL), extract_var(df, objectURL)))
        )
      )
    )
  )
}


extract_var <- function(df, var) {
  dplyr::pull(df, {{ var }}) |> unique()
}

process_object_data <- function(df) {
  # Each object has 4 records in the data frame
  # - 1 record for each pair of points of the bounding box
  # - function translates the 4 rows into 1 row with 4 columns of the points
  x_vals <- dplyr::pull(df, x)
  y_vals <- dplyr::pull(df, y)
  
  new_df <- df %>%
    dplyr::select(., -x, -y, -image_gs_path) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      x_left = min(x_vals),
      x_right = max(x_vals),
      y_down = min(y_vals),
      y_up = max(y_vals)
    )
  
  return(new_df)
}

process_time <- function(x, date_portion = NA) {
  
  # if positive number, only need to check for number of digits
  # anything less than 4 digits needs to be converted to 4
  is_neg <- (x < 0)
  x_year_abs <- as.character(abs(x))
  x_year_pad <- stringr::str_pad(x_year_abs, width = 4, side = "left", pad = "0")
  if (is_neg) {
    x_year_pad <- paste0("-", x_year_pad)
  }
  
  if (is.na(date_portion)) {
    start_date <- as.Date(paste0(x_year_abs, "-01-01"))
    end_date <- as.Date(paste0(x_year_abs, "-12-30"))
    random_date <- as.Date(sample(as.numeric(start_date):as.numeric(end_date), 1, replace = TRUE), origin = "1970-01-01")
    random_char <- as.character(random_date)
    random_final <- paste(stringr::str_split(random_char, "-")[[1]][2:3], collapse = "-")
    date_suffix <- paste0("-", random_final, "T00:00:00")
  } else {
    date_suffix = paste0("-", date_portion, "T00:00:00")
  }
  
  # date_suffix = "-01-01T00:00:00
  x_final <- paste0(x_year_pad, date_suffix)
  return(x_final)
}

