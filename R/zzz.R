#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

.onLoad <- function(libname = find.package("updateR"),
                    pkgname = "updateR"){

  # CRAN Note avoidance for "."
  if(getRversion() >= "2.15.1")
    utils::globalVariables(c(".", "Package", "Priority", "installing"))

  # startup message
  latest <- latest_r_version()
  msg <- paste(sprintf("A new version R of %s is available for update!", latest$latest),
               "run updateR() to get the latest R on your macOS!", sep = "\n")
  if(latest$update_avail)
    packageStartupMessage(msg)
}
