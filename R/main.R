#' Create tab items
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data passed to all modules
#' @export
#' @importFrom purrr map
#' @importFrom shiny NS tabPanel tabsetPanel
create_tab_items <- function(config, data_global, display_tab = function(x){TRUE}){
  modules <- get_modules(config)
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
call_all_modules <- function(config, data_global, display_tab = function(x){FALSE}){
  modules <- get_modules(config)
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


