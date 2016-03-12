updateR <- function(admin_password = "", page_source = "https://cran.rstudio.com/bin/macosx/" ){

library(rvest)
library(dplyr)

#first test for on OS

stopifnot(.Platform$OS.type == "unix")

#we scrape CRAN page to retrieve the last R version and compose dowloading URL

page              <- read_html(page_source)
version_block     <- rvest::html_nodes(page,"table:nth-child(7) tr:nth-child(1) td:nth-child(1)")
filename          <- rvest::html_text(version_block) %>% strsplit("\n", fixed = TRUE) # the resulting value is a list
filename          <- filename[[1]]
filename          <- filename[[1]] # we take the first element, containing the name of the file
filename_quoted          <- paste("'",filename,"'",sep = "")
#everything went right?

stopifnot(grepl(".pkg",version) == FALSE)
url               <- paste(page_source,filename, sep = "")

#download package, set folder for download
command           <- paste("curl -o -v ", filename_quoted , " '",url,"'", sep = "")
system(command)
#install .pkg file

command           <- paste("echo " , admin_password, "| sudo -S installer -pkg ", filename_quoted , " -target / -verbose")
system(command)

message("everything went smoothly")
message("open a Terminal session and run 'R' to verify that latest version was installed")
}

