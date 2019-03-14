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
