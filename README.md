
<!-- README.md is generated from README.Rmd. Please edit that file -->
L2TDatabaseExplorer
===================

The goal of L2TDatabaseExplorer is to ...

Getting started - RStudio
-------------------------

...

Getting started - Programmatically
----------------------------------

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

The app looks for a file called `l2t_db.cnf` in this folder. If there is no such file, create one using the function `L2TDatabase::make_cnf_file()` and valid user credentials and the network address of the database. These can be found on the L2T wiki page about the database.

Now, you can launch the app. It should work if you have a connection to the UMN VPN and valid credentials saved for the database.

``` bash
Rscript run.R
```
