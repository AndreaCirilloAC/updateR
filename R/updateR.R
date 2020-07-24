#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_text html_attr
#' @importFrom utils download.file installed.packages install.packages
#' @importFrom utils sessionInfo
#' @importFrom dplyr select filter pull
#' @title Downloads and installs the latest version of R for Mac OS X.
#' @description Update your version of R from inside R itself (Mac OS X only).
#' @author Andrea Cirillo, Robert Myles McDonnell
#' @examples
#' \dontrun{
#' ## NOT RUN
#' updateR()
#' ## END NOT RUN
#' }
#' @export
updateR <- function(){

  # first test for on OS
  stopifnot(.Platform$OS.type == "unix")

  latest <- latest_r_version()
  if(!latest$update_avail) {
    message(paste("Update not necessary. Latest version ====",
                  version$version.string, "==== already installed."))
    return()
  }
  check_compactability(status = latest)
  installing <- list_packages()

  folderpath <- sprintf("/Users/%s/Downloads/",
                      system2("whoami", stdout = TRUE))
  pkgfile <- regmatches(latest$url, regexpr("R.*$", latest$url))
  fullpath <- sprintf("%s%s", folderpath, pkgfile)
  # download package, set folder for download
  if(!package_exists(status = latest))
    download.file(latest$url, fullpath)

  #install .pkg file
  admin_password <- ask_password()
  message(paste0("Installing R-", latest$latest, "...please wait"))

  command <- paste0("echo ", admin_password, " | sudo -S installer -pkg ",
                "'", fullpath, "'", " -target /")
  system(command, ignore.stdout = TRUE)

  arg <- paste0("--check-signature ", fullpath)
  system2("pkgutil", arg)

  # restore packages
  restore_packages(status = latest)

  # store version of R
  x <- system2("R", args = "--version", stdout = TRUE)
  x <- x[1]

  message(paste0("Everything went smoothly, R was updated to ", x))
  message(paste0("Also the packages installed on your previous version of R were restored"))
}

