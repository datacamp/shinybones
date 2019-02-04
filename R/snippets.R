#' Add snippets to your ~/.R/snippets/r.snippets
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   add_snippets()
#' }
st_add_snippets <- function(){
  # prevent snippets from being installed multiple times
  r_snippets <- readLines("~/.R/snippets/r.snippets", warn = FALSE)
  if (any(grepl("snippet stpage", r_snippets))){
    stop("You already have a snippet named stpage. Please rename or delete it to add these snippets")
  }
  # Inspired from package:shinysnippets
  message("This command will write in ~/.R/snippets/r.snippets")
  message("Do you wish to continue?")
  x <- readline("Type Y/y to confirm.")
  res <- FALSE
  if (tolower(x) == "y"){
    tf <- tempfile(fileext = ".snippets")
    make_snippets() %>%
      cat(file = tf)
    res <- file.append("~/.R/snippets/r.snippets", tf)
  }
  if (res){
    message("Done!")
    message("Restart RStudio to have access to the snippets.")
  } else {
    message("Copy not done")
  }
}

make_snippets <- function(){
  snippets <- dir(
    system.file('rstudio', 'snippets', package = 'satin'),
    pattern = '.txt', full.names = TRUE
  )
  snippets %>%
    purrr::map_chr(~ {
      sn_name <- paste('\nsnippet', tools::file_path_sans_ext(basename(.)))
      sn_code <- paste("\t", readLines(., warn = FALSE))
      paste(c(sn_name, sn_code), collapse = "\n")
    }) %>%
    paste(collapse = "\n")
}
