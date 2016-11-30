# Download the latest code updates from GitHub
curr_repo <- git2r::repository("./")
git2r::pull(curr_repo)
