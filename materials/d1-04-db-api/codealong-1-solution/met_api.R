# demonstration of httr2 for calling APIs
library(dplyr)
library(tidyr)
library(purrr)
library(httr2)

# refer to https://metmuseum.github.io/ for documentation of API endpoints
base_url <- "https://collectionapi.metmuseum.org/public/collection/v1"

# How many artwork pieces have been updated in the museum database since July 1st, 022?
req <- request(base_url) %>%
  req_url_path_append("objects") %>%
  # add query parameter metadataDate
  req_url_query(metadataDate = "2022-07-01")


resp <- req_perform(req)

resp_status(resp)

objects_updated <- resp %>%
  resp_body_json()

# What are the departments contained in the museum?
req <- request(base_url) %>%
  req_url_path_append("departments")

resp <- req_perform(req)

resp_status(resp)

departments <- resp %>%
  resp_body_json() %>%
  purrr::pluck("departments") %>%
  transpose() %>%
  tibble::as_tibble() %>%
  tidyr::unnest(cols = c("departmentId", "displayName"))

# How many art pieces contain a shield in the Arms and Armor department?
dep_id <- departments %>%
  filter(displayName == "Arms and Armor") %>%
  pull(departmentId)


req <- request(base_url) %>%
  req_url_path_append("search") %>%
  req_url_query(q = "shield", departmentId = dep_id)

resp <- req_perform(req)
resp_status(resp)

objects <- resp %>%
  resp_body_json() %>%
  purrr::pluck("objectIDs") %>%
  purrr::as_vector()

# use the objects above to grab metadata for each of them
req <- request(base_url) %>%
  req_url_path_append(glue::glue("objects/{objects[1]}"))



resp_total <- purrr::map(objects, ~{
  req <- request(base_url) %>%
    req_url_path_append(glue::glue("objects/{.x}"))
  resp <- req_perform(req)
  
  result <- resp %>%
    resp_body_json()
  
  return(result)
})