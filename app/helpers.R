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
