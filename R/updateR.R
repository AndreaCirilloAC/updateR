updateR <- function(admin_password = NULL, 
                    page_source = "https://cran.rstudio.com/bin/macosx/" ){
  suppressMessages(library(dplyr)) 
  
  # first test for on OS
  stopifnot(.Platform$OS.type == "unix")
  # test for password
  if(is.null(admin_password)){
    stop("User system password is missing"))
    }
  
  # we scrape CRAN page to retrieve the last R version and compose dowloading URL
  page <- xml2::read_html(page_source)
  version_block <- rvest::html_nodes(page, "h1+ p a+ a , table:nth-child(8) tr:nth-child(1) td > a")
  filename <- rvest::html_text(version_block) %>% strsplit("\n", fixed = TRUE) 
  # the resulting value is a list
  filename <- filename[[2]] # we take the second element, containing the name of the file
  filename_quoted <- paste0("'", filename, "'")
  
  # everything went right?
  stopifnot(grepl(".pkg", version) == FALSE)
  url <- paste0(page_source, filename)
  
  # download package, set folder for download
  download.file(url, filename)
  
  #install .pkg file
  command <- paste("echo ", admin_password, "| sudo -S installer -pkg ", 
                 filename_quoted, " -target / -verbose")
  system2(command, stdout = NULL, stderr = NULL)
  
  x <- system2("R", args= "--version", stdout = TRUE)
  x <- x[1]
  message(paste0("R was updated to ", x))
  # congratulate with the reader
  message("Everything went smoothly, please restart R.")
}

