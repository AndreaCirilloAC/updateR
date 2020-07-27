#' @noRd
list_packages <- function() {
  all_pkg <- installed.packages() %>%
    as.data.frame() %>%
    pull(Package)
  base_pkg <- installed.packages() %>%
    as.data.frame() %>%
    filter(Priority == "base") %>%
    pull(Package)
  all_pkg[!all_pkg %in% base_pkg]
}

#' @noRd
restore_packages <- function(status = latest_r_version()) {
  # detect update type
  versions <- c(status$latest, attr(status, "current"))
  versions_numeric <- as.numeric(sub("^(\\d)\\.", "\\1", versions))
  versions_change <- abs(diff(floor(versions_numeric / 10)))
  update_type <- ifelse(versions_change > 0, "major",
                        ifelse(abs(diff(versions_numeric)) >= 1,
                               "minor", "patch")
  )

  # prompt restore options
  prompt_msg <- paste(c("This is a %s update.",
                        "Choose one of the following options to restore your packages:",
                        "%s\n"),
                      collapse = "\n")
  prompt_options <- switch(update_type,
                           "major" = "1. Reinstall all the packages\n",
                           "minor" = paste(
                             c("1. Reinstall all the packages",
                               "2. Copy all packages"),
                             collapse = "\n"),
                           "patch" = paste(
                             c("Restoring packages is NOT necessary.",
                               "Press [Enter] to continue"),
                             collapse = "\n"))
  prompt_msg <- sprintf(prompt_msg, update_type, prompt_options)
  lib <- "/Library/Frameworks/R.framework/Versions/%.1f/Resources/library"
  choice <- as.numeric(readline(prompt_msg))

  # handling options
  while(!choice %in% c(1, 2, "")) {
    message("!Invalid option. Please try again\n")
    choice <- as.numeric(readline(prompt_msg))
  }

  if(choice == 1) {
    # reinstall
    message("list of packages loaded")
    cat(sprintf("%s,", installing))
    install.packages(installing)
  } else if(update_type == "minor" & choice == 2) {
    # copy
    old <- sprintf(lib, floor(min(versions_numeric)) / 10)
    new <- sprintf(lib, floor(max(versions_numeric)) / 10)
    message(sprintf("Copying from old LibPath\n%s/\nto new LibPath\n%s/\n...",
                    old, new))
    system(sprintf("cp -R %s/ %s/", old, new))
    message("Complete.")
  } else if(update_type == "patch") {
    message("\n")
  }
}
