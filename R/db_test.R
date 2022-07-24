# test connecting to linode database 
library(dplyr)
library(dbplyr)

# establish connection to local container with database
con <- DBI::dbConnect(
  RPostgres::Postgres(),
  host = Sys.getenv("DB_HOST"),
  dbname = "postgres",
  port = 5432,
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASS")
)

# use this type of query as a check function in reactivePoll
DBI::dbGetQuery(con, "SELECT COUNT(*) FROM art_rolling")
