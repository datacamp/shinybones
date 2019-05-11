#' Add snippets to your ~/.R/snippets/r.snippets
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   sb_add_snippets()
#' }
#' @importFrom purrr map map_chr
#' @importFrom rlang set_names
sb_add_snippets <- function(sn_file = "~/.R/snippets/r.snippets"){
  r_snippets <- read_snippets(sn_file)
  # Inspired from package:shinysnippets
  message("This command will write in ~/.R/snippets/r.snippets")
  message("Do you wish to continue?")
  x <- readline("Type Y/y to confirm.")
  res <- FALSE
  if (tolower(x) == "y"){
    r_snippets <- modifyList(r_snippets, make_snippets())
    res <- r_snippets %>%
      unlist() %>%
      paste(collapse = "\n") %>%
      cat(file = sn_file)
  }
  else if (res){
    message("Done!")
    message("Restart RStudio to have access to the snippets.")
  } else
    message("Copy not done")

}

# Make snippets
make_snippets <- function(){
  snippets <- dir(
    system.file('rstudio', 'snippets', package = 'shinybones'),
    pattern = '.txt', full.names = TRUE
  )
  snippets %>%
    purrr::map(~ {
      sn_name <- paste('\nsnippet', tools::file_path_sans_ext(basename(.)))
      sn_code <- paste0("\t", readLines(., warn = FALSE))
      paste0(c(sn_name, sn_code), collapse = "\n")
    }) %>%
    rlang::set_names(tools::file_path_sans_ext(basename(snippets)))
}


# Read snippets
read_snippets <- function(sn_file = "~/.R/snippets/r.snippets"){
  snippets <- readLines(sn_file, warn = FALSE)
  snippet_lines <- c(grep('^snippet', snippets), length(snippets) + 1)
  snippets_list <- seq_along(snippet_lines[-1]) %>%
    purrr::map(~ {
      lines <- snippet_lines[.x]:(snippet_lines[.x + 1] - 1)
      snippets[lines]
    })
  nms <- snippets_list %>%
    purrr::map_chr(~ gsub("^snippet\\s*(.*)$", "\\1", .x[1]))
  snippets_list %>%
    rlang::set_names(nms)
}
