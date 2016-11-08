# Run this script to launch the app in a browser window.
withr::with_dir("./app/", {
  # For some reason, updating the file seems to help
  system("touch app.Rmd")
  rmarkdown::run(
    file = normalizePath("./app.Rmd", winslash = "/"),
    default_file = "app.Rmd",
    shiny_args = list(launch.browser = TRUE))
})
