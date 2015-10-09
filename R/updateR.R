library(rvest)
library(dplyr)
library(assertthat)

warning("updateR is available only for OSX operating systems ",
        expr = .Platform$OS.type == "unix",
        call. = FALSE)
stopifnot(.Platform$OS.type == "unix")

#we scrape CRAN page to retrieve the last R version and compose dowloading URL

page_source       <- read_html("https://cran.rstudio.com/bin/macosx/")
version_block     <- html_nodes(page_source,"table:nth-child(7) tr:nth-child(1) td:nth-child(1)")
filename          <- html_text(version_block) %>% strsplit("/") # the resulting value is a list
filename          <- filename[1] # we take the first element, containing the name of the file
filename          <- paste("'",filename,"'",sep = "")
#everything went right?
stopifnot(grepl(".pkg",version) == FALSE)
url               <- paste('https://cran.rstudio.com/bin/macosx/R-3.2.2.pkg',filename, sep = "")

#download package, set folder for download
command           <- paste("curl - o ", filename , " '",url,"'", sep = "")
system(command)
#install .pkg file

command           <- paste("installer -pkg ", filename , " -target / -verbose")
system(command)

message("everything went smoothly")
message("open a Terminal session and run 'R' to assert that last version was installed")

