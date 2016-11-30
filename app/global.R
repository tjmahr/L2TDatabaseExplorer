# This file is run before the Shiny app is run. It defines global objects for
# the app's session.

message("Reading globals...")

# Connect to database
library(flexdashboard)
library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(L2TDatabase)
library(ggplot2)

if (interactive()) {
  l2t <- l2t_connect("./l2t_db.cnf", "l2t")
} else {
  l2t <- l2t_connect("../l2t_db.cnf", "l2t")
}

# Create a long data-frame of descriptive stats for some values
describe_col <- function(x) UseMethod("describe_col")

# Count strings
describe_col.character <- function(x) {
  data_frame(Stat = "N", Value = length(x))
}

# If type not matched (e.g., dates?), just count it
describe_col.default <- function(x) {
  data_frame(Stat = "N", Value = length(x))
}

# Count frequency of factor levels
describe_col.factor <- function(x) {
  forcats::fct_count(x) %>%
    mutate(f = paste0("N ", f)) %>%
    rename(Stat = f, Value = n)
}

# N, Mean, SD
describe_col.numeric <- function(x) {
  x_summary <- c(
    N = sum(!is.na(x)),
    Mean = mean(x, na.rm = TRUE),
    SD = sd(x, na.rm = TRUE))

  x_summary %>%
    round(2) %>%
    tibble::enframe(name = "Stat", value = "Value")
}


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

# Make a wide data-frame of all the longitudinal scores
remove_longitudinal_nondata_cols <- . %>%
  select(everything(), -ends_with("Completion"), -ends_with("Form"),
         -ends_with("Experiment"), -DateCompiled)

id_cols <- c("Study", "ResearchID", "Female", "AAE", "LateTalker", "CImplant")

fct_undummy_code <- function(x, labels) {
  factor(x, levels = c("0", "1"), labels = labels, exclude = NULL)
}

reshape_longitudinal_data <- . %>%
  tidyr::gather(Measure, Value, -one_of(id_cols)) %>%
  mutate(Study = stringr::str_replace(Study, "TimePoint", "T")) %>%
  tidyr::unite(Measure, Study, Measure)

long_comp <- downloaded_queries %>%
  lapply(remove_longitudinal_nondata_cols) %>%
  lapply(reshape_longitudinal_data) %>%
  bind_rows() %>%
  tidyr::spread(Measure, Value)

long_comp <- long_comp %>%
  readr::type_convert() %>%
  mutate(Female = fct_undummy_code(Female, c("Male", "Female")),
         AAE = fct_undummy_code(AAE, c("SAE", "AAE")),
         LateTalker = fct_undummy_code(LateTalker, c("TD", "Late Talker")),
         CImplant = fct_undummy_code(CImplant, c("TD", "C. Implant")))

