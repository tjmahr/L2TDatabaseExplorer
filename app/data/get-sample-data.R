library(dplyr, warn.conflicts = FALSE)
library(L2TDatabase)

# App is in a subfolder of an RStudio project, unless it's running in
# ShinyApps.io, so look for Rproj or fail with "./"
find_app_dir <- function() {
  dir_proj <- rprojroot::find_root(rprojroot::is_rstudio_project)
  file.path(dir_proj, "app")
}

dir_app <- purrr::possibly(find_app_dir, ".", quiet = TRUE)()

l2t <- l2t_connect("../L2TDatabase/inst/l2t_db.cnf", "l2t")

vars1 <- c(
  "Study", "ResearchID", "Female", "AAE", "LateTalker", "CImplant")

vars2 <- c(
  "EVT_Age", "EVT_GSV", "PPVT_Age", "PPVT_GSV",
  "VerbalFluency_Age", "VerbalFluency_Raw", "GFTA_Age", "GFTA_Standard",
  "LENA_AWC_Hourly")
vars <- c(vars1, vars2)

# Add noise to sample data for Shiny demo
double_jitter <- function(x, factor = 1, amount = NULL, digits = 0) {
  x %>%
    jitter(factor, amount) %>%
    round(digits) %>%
    jitter(factor, amount) %>%
    round(digits)
}

get_sample_cols <- . %>%
  collect() %>%
  head(50) %>%
  select(one_of(vars))

jitter_data <- . %>%
  mutate_at(.cols = vars(one_of(vars2)), double_jitter, factor = 5)

tp1 <- tbl(l2t, "Scores_TimePoint1") %>% get_sample_cols() %>% jitter_data()
tp2 <- tbl(l2t, "Scores_TimePoint2") %>% get_sample_cols() %>% jitter_data()
tp3 <- tbl(l2t, "Scores_TimePoint3") %>% get_sample_cols() %>% jitter_data()

readr::write_csv(tp1, file.path(dir_app, "data", "tp1.csv"))
readr::write_csv(tp2, file.path(dir_app, "data", "tp2.csv"))
readr::write_csv(tp3, file.path(dir_app, "data", "tp3.csv"))
