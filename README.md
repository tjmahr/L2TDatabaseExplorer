
<!-- README.md is generated from README.Rmd. Please edit that file -->
L2TDatabaseExplorer
===================

The goal of L2TDatabaseExplorer is to provide some interactive tools for exploring our database.

Getting started - RStudio
-------------------------

Connect to the University of Minnesota VPN.

Make sure you have [Git](https://git-scm.com/downloads) installed.

Clone the repository to your computer in RStudio. Go to File &gt; New Project &gt; Version Control &gt; Git. Use <https://github.com/LearningToTalk/L2TDatabaseExplorer.git> as the URL.

Run the script in the file `setup.R` to install the needed packages.

The app looks for a file called `l2t_db.cnf` in this folder. If there is no such file, create one using the function `L2TDatabase::make_cnf_file()` and valid user credentials and the network address of the database. These can be found on the L2T wiki page about the database.

Run `run.R` from RStudio to launch the app in a browser.

Run `update.R` to pull the latest changes from GitHub. This should work if you have not edited any of the files in the repository.

Getting started - Programmatically
----------------------------------

If you can use the command line, and have R/git/pandoc on your system path, and have an `R_LIBS_USER` system environment variable--you probably do not--you can launch the app from the command line.

Connect to the University of Minnesota VPN.

Clone this repository.

``` bash
git clone https://github.com/LearningToTalk/L2TDatabaseExplorer.git
cd L2TDatabaseExplorer
```

Run setup script. This will install the packages required to use the app.

``` bash
Rscript setup.R
```

Create the `.cnf` as described above.

Now, you can launch the app. It should work if you have a connection to the UMN VPN and valid credentials saved for the database.

``` bash
Rscript run.R
```
