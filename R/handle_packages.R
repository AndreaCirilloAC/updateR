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
  versions_split <- strsplit(versions, ".", fixed = TRUE)
  names(versions_split) <- c("latest", "current")

  if (versions_split$latest[3] != versions_split$current[3]) {
    update_type <- "patch"
  }
  if (versions_split$latest[2] != versions_split$current[2]) {
    update_type <- "minor"
  }
  if (versions_split$latest[1] != versions_split$current[1]) {
    update_type <- "major"
  }

  # prompt restore options
  prompt_msg <- paste(
    c("This is a %s update.",
      "Choose one of the following options to restore your packages:",
      "%s\n"),
    collapse = "\n"
  )
  prompt_options <- switch(update_type,
                           "major" = "1. Reinstall all the packages\n",
                           "minor" = paste(
                             c("1. Reinstall all the packages",
                               "2. Copy all packages"),
                             collapse = "\n"),
                           "patch" = paste(
                             c("Restoring packages is NOT necessary.",
                               "Press [Enter] to continue (this is the only option in the list)"),
                             collapse = "\n"))
  prompt_msg <- sprintf(prompt_msg, update_type, prompt_options)

  choice <- as.numeric(readline(prompt_msg))

  # handling options
  while(!choice %in% c(1, 2, "", NA)) {
    message("!Invalid option. Please try again\n")
    choice <- as.numeric(readline(prompt_msg))
  }

  if(choice %in% 1) {
    # reinstall
    message("list of packages loaded")
    cat(sprintf("%s,", list_packages))
    install.packages(list_packages)
  } else if (update_type == "minor" & choice %in% 2) {
    # copy

    old_version_path <- paste0(versions_split$current[1:2], collapse = ".")
    new_version_path <- paste0(versions_split$latest[1:2], collapse = ".")

    for (l in .libPaths()) {
      old_lib_path <- l
      new_lib_path <- str_replace(l, old_version_path, new_version_path)
      message(sprintf(
        "Copying from old LibPath\n%s/\nto new LibPath\n%s/\n...",
        old_lib_path, new_lib_path
      ))
      system(sprintf("mkdir -p %s", new_lib_path))
      system(sprintf("cp -R %s/ %s/", old_lib_path, new_lib_path))
      replace_libpath_profile(old_lib_path, new_lib_path)
    }

    message("Complete.")

  } else if(update_type == "patch") {
    message("\n")
  }
}
