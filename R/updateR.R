library(rvest)
library(dplyr)
library(assertthat)
#first test for on OS
warning("updateR is available only for OSX operating systems ",
        expr = .Platform$OS.type == "unix",
        call. = FALSE)
stopifnot(.Platform$OS.type == "unix")

#we scrape CRAN page to retrieve the last R version and compose dowloading URL

page_source       <- read_html("https://cran.rstudio.com/bin/macosx/")
version_block     <- html_nodes(page_source,"table:nth-child(7) tr:nth-child(1) td:nth-child(1)")
filename          <- html_text(version_block) %>% strsplit("\n", fixed = TRUE) # the resulting value is a list
filename          <- filename[[1]]
filename          <- filename[[1]] # we take the first element, containing the name of the file
filename_quoted          <- paste("'",filename,"'",sep = "")
#everything went right?
stopifnot(grepl(".pkg",version) == FALSE)
url               <- paste('https://cran.rstudio.com/bin/macosx/',filename, sep = "")

#download package, set folder for download
command           <- paste("curl -o ", filename_quoted , " '",url,"'", sep = "")
system(command)
#install .pkg file

command           <- paste("sudo installer -pkg ", filename_quoted , " -target / -verbose")
system(command)

message("everything went smoothly")
message("open a Terminal session and run 'R' to assert that last version was installed")
