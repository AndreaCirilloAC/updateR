#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes
#' @importFrom rvest html_text
#' @importFrom utils download.file
#' @importFrom stringr str_extract_all
#' @importFrom getPass getPass
#' @title Downloads and installs the latest version of R for Mac OS X.
#' @description Update your version of R from inside R itself (Mac OS X only). Only works in interactive mode
#' @param admin_password \code{character}. The system-wide password of the user. The parameter will be only employed to execute commands gaining administrator privileges on the computer and will not be stored anywhere.
#' @param file The name of the pkg file from which R is installed (only advanced users should use this)
#' @author Andrea Cirillo, Robert Myles McDonnell
#' @examples
#' updateR()
#' @export
updateR <- function(file = NA){

  # first test for on OS
  # Excludes Windows
  stopifnot(.Platform$OS.type == "unix")
  # Excludes Linux
  stopifnot(system('uname',intern=TRUE)=='Darwin')
  # and then whether we run in interactive mode
  stopifnot(interactive())

  # Ask for password (the input is hidden)
  admin_password=getPass(msg='Enter admin password')
  tmp <- installed.packages()
  # The base and recommended packages are installed by default anyway,
  # so we only need to bother installing the ones without any assigned
  # priority
  needed_packages <- as.vector(tmp[is.na(tmp[,"Priority"]), 1])
  save(needed_packages, file = "/tmp/needed_packages.RData")

  page_source = "https://cran.rstudio.com/bin/macosx/"

  css <- "body > table"
if (is.na(file)){
  file <- xml2::read_html(page_source) %>%
    rvest::html_nodes(css) %>%
    rvest::html_text() %>%
    stringr::str_extract_all(pattern = "^[:print:]*\\.pkg") %>%
    .[[1]]
}

  stopifnot(grepl(".pkg", file) == TRUE)

  latest_version <- as.numeric(paste(stringr::str_extract_all(pattern = "[:digit:]{1}",file)[[1]],collapse=""))
  installed_version <- as.numeric(paste(stringr::str_extract_all(pattern = "[:digit:]{1}",paste(version$major,version$minor))[[1]],collapse=""))
  if (installed_version >= latest_version) {
    message(paste("Update not necessary. Latest version ====",version$version.string,"==== already installed."))
    return()
  }

  url <- paste0(page_source, file)

  destpath <- paste(getwd(),"/",sep = "")
  fullpath <- paste(destpath,file,sep = "")
  # download package, set folder for download
  download.file(url, fullpath)

  #install .pkg file
  pkg <- gsub("\\.pkg" , "", file)
  message(paste0("Installing ", pkg, "...please wait"))

  command <- paste0("echo ", admin_password, " | sudo -S installer -pkg ",
                "'", fullpath, "'", " -target /")
  system(command, ignore.stdout = TRUE)

  arg <- paste0("--check-signature ", fullpath)
  system2("pkgutil", arg)

  # install back the packages saved at the beginning of the process
  load("/tmp/needed_packages.RData", verbose = TRUE)
  message("list of packages loaded")
  needed_packages
  tmp <- installed.packages()
  current_packages <- as.vector(tmp[is.na(tmp[,"Priority"]), 1])
  missing <- setdiff(needed_packages, current_packages)
  if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
  BiocManager::install(missing)
  BiocManager::update.packages()

  # store version of R
  x <- system2("R", args = "--version", stdout = TRUE)
  x <- x[1]

  message(paste0("Everything went smoothly, R was updated to ", x))
  message(paste0("Also the packages installed on your previous version of R were restored"))
}

