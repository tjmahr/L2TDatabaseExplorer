install.packages("curl", repos = "https://cran.rstudio.com/")
install.packages("devtools", repos = "https://cran.rstudio.com/")

packages <- c("tidyverse", "yaml", "knitr", "rmarkdown",
              "flexdashboard", "withr", "arm")
install.packages(packages, repos = "https://cran.rstudio.com/")

devtools::install_github("LearningToTalk/L2TDatabase")

message("\nCreating configuration file `l2t_db.cnf`...")
invisible(L2TDatabase::make_cnf_file(dest = "./l2t_db.cnf", db = "l2t"))
message("...please complete `l2t-db.cnf` with database address and credentials")
