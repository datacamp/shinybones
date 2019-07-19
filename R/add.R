#' Add a page module
#'
#' @param module name of the module
#' @param text text to add to _site.yml
#' @param dir_pages directory to save the module to
#' @param add_to_yaml logical indicating if module should be added to _site.yml
#' @param ... additional parameters to add to _site.yml
#' @export
#' @importFrom crayon green
sb_add_page <- function(module,
                        text = module,
                        dir_pages = getOption('SB_DIR_PAGES', 'pages'),
                        add_to_yaml = FALSE,
                        ...){
  check_rstudio()
  snippet_page <- system.file(
    'rstudio', 'snippets', 'sbpage.txt', package = 'shinybones'
  )
  if (missing(module)){
    module <- rstudioapi::showPrompt('Enter Module Name', 'Module Name')
  }
  f <- file.path(dir_pages, paste0(module, '.R'))
  if (!dir.exists(dirname(f))){
    dir.create(dirname(f), recursive = TRUE)
  }
  snippet_page %>%
    readLines(warn = FALSE) %>%
    paste(collapse = "\n") %>%
    gsub("${1:name}", basename(module), ., fixed = TRUE) %>%
    gsub("\\$", "$", ., fixed = TRUE) %>%
    cat(file = f)

  usethis::edit_file(f)

  if (add_to_yaml){
    config <- yaml::read_yaml('_site.yml')
    config$sidebar <- append(config$sidebar, list(list(
      text = text,
      module = module,
      ...
    )))
    yaml::write_yaml(config, '_site.yml')
    done("Added module {module} to _site.yml", module = module)
  } else {
    todo("Add module {module} to _site.yml", module = module)
  }
}

#' Add a component module
#'
#' @export
#' @rdname sb_add_page
sb_add_component <- function(module,
                             dir_pages = getOption('SB_DIR_COMPONENTS', 'components'),
                             ...){
  snippet <- system.file(
    'rstudio', 'snippets', 'sbcomponent.txt', package = 'shinybones'
  )
  if (missing(module)){
    module <- rstudioapi::showPrompt('Enter Module Name', 'Module Name')
  }
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
