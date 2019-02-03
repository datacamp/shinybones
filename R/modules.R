get_module <- function(.){
  purrr::possibly(match.fun, NULL)(.$module)
}

#' Get the ui function for a module
#'
#' @keywords internal
#' It handles three use cases:
#' 1. No module has been specified -> Placeholder UI with Message
#' 2. Module UI function cannot be found -> Placeholder UI with Message
#' 3. Module is found
#' @importFrom purrr safely
get_module_ui <- function(.){
  if (is.null(.$module)){
    msg <- sprintf('No module for %s has been specified.', .$text)
    not_specified <- default_placeholder_ui(.$text, msg)
  } else {
    module_ui_name <- paste0(.$module, "_ui")
    msg <- sprintf("No function named %s can be found", module_ui_name)
    f <- purrr:::safely(match.fun)(module_ui_name)
    if (is.null(f$result)){
      return(default_placeholder_ui(.$text, msg))
    } else {
      return(f$result)
    }
  }
}

#' @keywords internal
#' @importFrom rlang flatten
get_modules <- function(config){
  b1 <- config$sidebar %>%
    purrr::map('menu') %>%
    purrr::compact() %>%
    rlang::flatten()
  b2 <- config$sidebar %>%
    purrr:::map(~ {.$menu <- NULL; .})
  append(b1, b2)
}
