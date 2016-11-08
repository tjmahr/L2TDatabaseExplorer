# This file is run before the Shiny app is run. It defines global objects for
# the app's session.

message("Reading globals...")

# Connect to database
library(flexdashboard)
library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(L2TDatabase)

l2t <- l2t_connect("../l2t_db.cnf", "l2t")

query_set <- list(
  TimePoint1 = "q_Scores_TimePoint1",
  TimePoint2 = "q_Scores_TimePoint2",
  TimePoint3 = "q_Scores_TimePoint3")


# Hmm. Shiny/RStudio are being really unpredictable about this database stuff.
# Just download what we need into memory for now.
download_query <- . %>%
  tbl(l2t, .) %>%
  collect %>%
  mutate(DateCompiled = format(Sys.Date())) %>%
  select(Study, DateCompiled, everything()) %>%
  select(-ChildStudyID)

downloaded_queries <- Map(download_query, query_set)
