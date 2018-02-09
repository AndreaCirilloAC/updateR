#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes
#' @importFrom rvest html_text
#' @importFrom utils download.file
#' @importFrom stringr str_extract_all
#' @title Downloads and installs the latest version of R for Mac OS X.
#' @description Update your version of R from inside R itself (Mac OS X only).
#' @param admin_password \code{character}. The system-wide password of the user. The parameter will be only employed to execute commands gaining administrator privileges on the computer and will not be stored anywhere.
#' @author Andrea Cirillo, Robert Myles McDonnell
#' @examples
#' updateR(admin_password = "****")
#' @export
updateR <- function(admin_password = NULL, file = NA){

  # first test for on OS
  stopifnot(.Platform$OS.type == "unix")
  # test for password
  if ( is.null(admin_password)){
    stop("User system password is missing")
  }

  installed.packages() %>%
  as.data.frame() %>%
  select(Package) %>%
  as.vector() -> needed_packages # saving packages installed before updating R version
  needed_packages <- paste(unlist(needed_packages))

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

  latestVersion <- as.numeric(paste(stringr::str_extract_all(pattern = "[:digit:]{1}",file)[[1]],collapse=""))
  installedVersion <- as.numeric(paste(stringr::str_extract_all(pattern = "[:digit:]{1}",paste(version$major,version$minor))[[1]],collapse=""))
  if (installedVersion >= latestVersion) {
    message(paste("Update not necessary. Latest version ====",version$version.string,"==== already installed."))
    return()
  }

  url <- paste0(page_source, file)

  # download package, set folder for download
  download.file(url, file)

  #install .pkg file
  pkg <- gsub("\\.pkg" , "", file)
  message(paste0("Installing ", pkg, "...please wait"))

  command <- paste0("echo ", admin_password, " | sudo -S installer -pkg ",
                "'", file, "'", " -target /")
  system(command, ignore.stdout = TRUE)

  arg <- paste0("--check-signature ", file)
  system2("pkgutil", arg)

  # install back the packages saved at the beginning of the process
  install.packages(as.vector(needed_packages))

  # store version of R
  x <- system2("R", args = "--version", stdout = TRUE)
  x <- x[1]

  message(paste0("Everything went smoothly, R was updated to ", x))
  message(paste0("Also the packages installed on your previous version of R were restored"))
}

