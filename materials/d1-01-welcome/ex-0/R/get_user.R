get_user <- function(session) {
  user <- session$user
  if (is.null(user)) user <- Sys.getenv("USER")
  return(user)
}