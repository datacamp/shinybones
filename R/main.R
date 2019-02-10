# Given a config dataset from _site.yml, remove cases where there's a condition field
# and the condition is FALSE. This is useful for feature flags.
#
# Note that it doesn't (yet?) work with anything dynamic, including e.g. whether a user is signed in
# or what input they've selected. That would need a different approach.
prepare_config <- function(x) {
  if (!is.list(x)) {
    return(x)
  }

  if (!is.null(x$condition) && x$condition == FALSE) {
    # don't return if the condition is false
    return(NULL)
  }
  purrr::compact(purrr::map(x, prepare_config))
}

#' Create tab items
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data passed automatically from app.R
#' @param display_tab A function that returns a boolean indicating whether a tab is
#'   to be displayed in the UI
#' @export
#' @importFrom purrr map
#' @importFrom shiny NS tabPanel tabsetPanel
st_create_tab_items <- function(config, data_global, display_tab = function(x){TRUE}){
  modules <- get_modules(prepare_config(config))
  modules %>%
    purrr::map(~ {
      message('Processing the page for ', .$text, " ...")
      tabName = make_tab_name(.)
      if (!is.null(.$ui)){
        return(shinydashboard::tabItem(tabName, .$ui))
      }
      .fun <- if (!is.null(.$module)){
        get_module_ui(.)
      } else if (!is.null(.$tabs)) {
        module_tabs_ui(.$tabs, display_tab)
      } else {
        get_module_ui(.)
      }
      shinydashboard::tabItem(
        tabName, .fun(tabName, data_global = data_global)
      )
    }) %>%
    do.call(tabItems, .)
}


#' Call all modules
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data passed to the sidebar
#' @export
st_call_all_modules <- function(config, data_global, display_tab = function(x){TRUE}){
  modules <- get_modules(prepare_config(config))
  modules %>%
    walk(~ {
      tabName = make_tab_name(.)
      .fun <- get_module(.)
      if (is.null(.fun) && !is.null(.$tabs)){
        .fun <- module_tabs(.$tabs, display_tab)
      }
      if (!is.null(.fun)){
        if (is.null(.$module_params)){
          callModule(.fun, tabName, data_global = data_global)
        } else {
          l <- list(.fun, tabName, data_global = data_global)
          l <- append(l, .$module_params)
          do.call(callModule, l)
        }
      }
    })
}


