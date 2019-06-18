#' Source R files from multiple directories recursively
#'
#' @export
#' @importFrom purrr walk
#' @importFrom htmltools span
#' @importFrom clisymbols symbol
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


# Utility Functions: Copied over from usethis
done <- function(..., .envir = parent.frame()) {
  out <- glue::glue(..., .envir = .envir)
  cat_line(bulletize(out, bullet = done_bullet()))
}

todo <- function (..., .envir = parent.frame()){
  out <- glue(..., .envir = .envir)
  cat_line(bulletize(out, bullet = todo_bullet()))
}

todo_bullet <- function(){
  crayon::red(clisymbols::symbol$bullet)
}


done_bullet <- function() {
  crayon::green(clisymbols::symbol$tick)
}

bulletize <- function(line, bullet = "*") {
  paste0(bullet, " ", line)
}

cat_line <- function(...) {
  cat(..., "\n", sep = "")
}

match_fun_safely <- function(x){
  purrr::possibly(match.fun, function(...){NULL})(x)
}

#' A version of do.call that throws away extraneous arguments
#'
#' @examples
#' # do_call_2(rnorm, list(n = 10, mean = 0, foo = 'bar'))
do_call_2 <- function(what, args, ...){
  args_what <- formalArgs(what)
  args <- args[names(args) %in% c("", args_what)]
  do.call(what, args, ...)
}
