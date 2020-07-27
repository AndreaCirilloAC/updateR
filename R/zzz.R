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
  invisible()
}
