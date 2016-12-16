updateR <- function(admin_password = "", page_source = "https://cran.rstudio.com/bin/macosx/" ){

library(dplyr)
#first test for on OS
(.Platform$OS.type == "unix")

#we scrape CRAN page to retrieve the last R version and compose dowloading URL
page              <- rvest::read_html(page_source)
version_block     <- rvest::html_nodes(page,"h1+ p a+ a , table:nth-child(8) tr:nth-child(1) td > a")
filename          <- rvest::html_text(version_block) %>% strsplit("\n", fixed = TRUE) # the resulting value is a list
filename          <- filename[[2]] # we take the second element, containing the name of the file
filename_quoted          <- paste("'",filename,"'",sep = "")

#everything went right?
assertthat::stopifnot(grepl(".pkg",version) == FALSE)
url               <- paste(page_source,filename, sep = "")

#download package, set folder for download

download.file(url,filename)

#install .pkg file
command           <- paste("echo " , admin_password, "| sudo -S installer -pkg ", filename_quoted , " -target / -verbose")
system(command)

#congratulate with the reader
message("everything went smoothly")
message("open a Terminal session and run 'R' to verify that latest version was installed")
}

