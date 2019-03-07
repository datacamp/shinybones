#' Source R files from multiple directories recursively
#'
#' @export
#' @importFrom purrr walk
#' @importFrom htmltools span
source_dirs <- function(..., recursive = FALSE){
  list(...) %>%
    purrr::walk(~ {
      dir(.x, full.names = TRUE, pattern = '\\.[r|R]$',
        recursive = recursive
      ) %>%
      purrr::walk(source)
    })
}

# Make tab name
make_tab_name <- function(.){
  if (!is.null(.$tabName)){
    .$tabName
  } else {
    make_html_id(.$text)
  }
}

# Make html id
make_html_id <- function(x){
  x <- gsub(".", "-", make.names(x), fixed = TRUE)
  x <- gsub("_", "-", x, fixed = TRUE)
  tolower(x)
}

# Default placeholder UI
default_placeholder_ui <- function(title, text, quietly = FALSE) {
  if (!quietly){
    warning(text, call. = FALSE)
  }
  function(id, ...) {
    ns <- NS(id)
    shiny::fluidRow(
      shinydashboard::box(width = 12,
        title = title,
        span(class = "text-danger", text),
        solidHeader = TRUE
      )
    )
  }
}

placeholder_ui <-  function(id, title){
  ns <- shiny::NS(id)
  shiny::fluidRow(
    shinydashboard::box(width = 12,
      title = title,
      span(class = 'text-muted', 'This is a placeholder'),
      solidHeader = TRUE
    )
  )
}


#' Create an Rstudio Project bootstraping a shinybones dashboard.
#'
#' @param path path to create
#' @param ... not used
#' @export
sb_create_project <- function(path, ...) {
  params <- list(...)
  dir.create(path = path, showWarnings = FALSE, recursive = TRUE)
  from <- system.file(params$scaffold_type, package = "shinybones")
  ll <- list.files(path = from, full.names = TRUE)
  file.copy(from = ll, to = path, overwrite = TRUE, recursive = TRUE)
}
