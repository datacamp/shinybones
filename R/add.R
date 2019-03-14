#' Add a page module
#'
#' @export
#' @importFrom crayon green
sb_add_page <- function(module, text = module, dir_pages =
   getOption('SB_DIR_PAGES', 'pages'), ...){
  snippet_page <- system.file(
    'rstudio', 'snippets', 'sbpage.txt', package = 'shinybones'
  )
  f <- file.path(dir_pages, paste0(module, '.R'))
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
  done("Added module {module} to _site.yml", module = module)
}

#' Add a component module
#'
#' @export
sb_add_component <- function(module, text = module, dir_pages =
    getOption('SB_DIR_COMPONENTS', 'components'), ...){
  snippet <- system.file(
    'rstudio', 'snippets', 'sbcomponent.txt', package = 'shinybones'
  )
  f <- file.path(dir_pages, paste0(module, '.R'))
  if (!dir.exists(dirname(f))){
    dir.create(dirname(f), recursive = TRUE)
  }
  snippet %>%
    readLines(warn = FALSE) %>%
    paste(collapse = "\n") %>%
    gsub("${1:name}", basename(module), ., fixed = TRUE) %>%
    gsub("\\$", "$", ., fixed = TRUE) %>%
    cat(file = f)

  usethis::edit_file(f)
}
