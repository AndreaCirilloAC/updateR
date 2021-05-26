#' @noRd
latest_r_version <- function() {
        cran <- "http://cran.rstudio.com/bin/macosx/"
        version_regex <- "(\\d+)?\\.(\\d+)?\\.(\\d+)?"
        page <- read_html(cran)
        file_url <- page %>%
                html_nodes(xpath = "//td/a") %>% .[1] %>%
                html_attr("href") %>%
                paste(cran, ., sep = "")
        minimal <- page %>%
                html_nodes(xpath = '//table[1]//tr[1]//td[2]') %>%
                html_text() %>%
                trimws() %>%
                regmatches(., regexpr("macOS.*higher.", .)) %>%
                regmatches(., regexpr("\\d+.\\d+", .))
        r_latest <- regmatches(file_url, regexpr(version_regex, file_url))
        r_current <- paste(version$major, version$minor, sep = ".")
        r_latest_numeric <- as.numeric(sub("^(\\d)\\.", "\\1", r_latest))
        r_current_numeric <- as.numeric(sub("^(\\d)\\.", "\\1", r_current))

        structure(
                list(update_avail = ifelse(r_latest_numeric > r_current_numeric, T, F),
                     latest = r_latest,
                     url = file_url),
                current = paste(version$major, version$minor, sep = "."),
                OS_minimal = as.numeric(minimal)
        )
}

#' @noRd
ask_password <- function() {
        whoami <- system2("whoami", stdout = TRUE)
        readline(sprintf("Enter password for %s: ", whoami))
}

#' @noRd
check_compactability <- function(status = latest_r_version()) {
        e <- "Latest R Version %s requires macOS at least 10.13 or higher,
        but %.2f is running. Consider upgrading macOS or install legacy R binaries from
        http://cran.rstudio.com/bin/macosx/"
        ver_major_minor <- as.numeric(sub("\\.", "",
                                          sub("^(.\\..).*$", "\\1", status$latest)))
        macOS <- sessionInfo()$running %>%
                regmatches(., regexpr("(\\d+)\\.(\\d+)\\.(\\d+)$", .)) %>%
                sub("^(.+\\.(.+)?)\\..+", "\\1", x = .) %>%
                as.numeric()
        if (length(macOS) == 0) {
        macOS <- sessionInfo()$running %>%
                regmatches(., regexpr("(\\d+)\\.(\\d+)$", .)) %>%
                sub("^(.+\\.(.+)?)\\..+", "\\1", x = .) %>%
                as.numeric()
        }

        if(isTRUE(status$update_avail) && ver_major_minor >= 40) {
                compactible <- macOS >= attr(status, "OS_minimal")
        }

        if(!compactible) stop(sprintf(e, status$latest, macOS), call. = FALSE)
}


#' @noRd
package_exists <- function(status = latest_r_version()) {
        pkg_name <- regmatches(status$url, regexpr("R.*$", status$url))
        download.path <- sprintf("/Users/%s/Downloads/",
                                 system2("whoami", stdout = TRUE))
        pkg_name %in% list.files(download.path)
}

#' @noRd
check_auto <- function(r_prof = NULL) {
        filenames <- list.files("~/", all.files = TRUE)
        exists_rprofile <- ".Rprofile" %in% filenames
        conn <- ifelse(is.null(r_prof), "~/.Rprofile", r_prof)
        if(!exists_rprofile) {
                file.create(conn)
                message("Created ~/.Rprofile")
        } else {
                rprofile <- readLines(conn)
                exists_line <- any(grepl("(library\\(updateR\\))", rprofile))
                if(exists_line) {
                        rprofile[which(exists_line)] <- ""
                        rprofile[which(exists_line)] <- "library(updateR)\n"
                        writeLines(rprofile, conn)
                } else {
                        append("library(updateR)\n", rprofile)
                        writeLines(rprofile, conn)
                }
                message("Updated ~/.Rprofile")
        }
}

#' @noRd
replace_libpath_profile <- function(old_path, new_path) {

  filenames <- list.files("~/", all.files = TRUE)
  exists_rprofile <- ".Rprofile" %in% filenames
  f <- "~/.Rprofile"

  if (!exists_rprofile) {
    rprofile <- character(0)
  } else {
    rprofile <- readLines(f)
  }
  if (length(rprofile) == 0) {
    rprofile <- ""
  }

  exists_line <- any(grepl(old_path, rprofile))
  if (!exists_line) {
    rprofile <- append(sprintf(".libPaths('%s')", new_path), rprofile)
    message(sprintf("Added %s to ~/.Rprofile", new_path))
  } else {
    rprofile <- str_replace(rprofile, old_path, new_path)
    message(sprintf("Replaced %s with %s ~/.Rprofile", old_path, new_path))
  }

  writeLines(rprofile, f)

}
