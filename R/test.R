#' Add a test for a shiny module
#'
#' TODO: Automatically add a test file as testthat/test-shiny-modules.R
#' @param module_name Name of the module.
#' @export
#' @importFrom glue glue
sb_add_test <- function(module_name){
  tpl <- system.file('templates', 'test_module.R', package = 'shinybones')
  if (!dir.exists('tests')){
    stop("Please run usethis::use_testthat() to bootstrap tests", call. = FALSE)
  }
  test_dir <- file.path('tests', 'testthat', 'apps', module_name)
  if (!dir.exists(test_dir)){
    dir.create(test_dir, recursive = TRUE)
  }
  readLines(tpl, warn = FALSE) %>%
    paste(collapse = "\n") %>%
    glue::glue() %>%
    cat(file = file.path(test_dir, 'app.R'))
}
