#' Add a page module
#'
#' @export
sb_add_page <- function(module, text = module_name, ...){
  snippet_page <- system.file(
    'rstudio', 'snippets', 'sbcomponent.txt', package = 'shinybones'
  )
  f <- file.path('pages', paste0(module, '.R'))
  snippet_page %>%
    readLines(warn = FALSE) %>%
    paste(collapse = "\n") %>%
    gsub("${1:name}", module, ., fixed = TRUE) %>%
    gsub("\\$", "$", ., fixed = TRUE) %>%
    cat(file = f)

  usethis::edit_file(f)

  config <- yaml::read_yaml('_site.yml')
  config$sidebar <- append(config$sidebar, list(list(
    text = text,
    module = module,
    ...
  )))
  yaml::write_yaml(config, '_site.yml')
}
