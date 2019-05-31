#' Create tab items
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data passed automatically from app.R
#' @param display_tab A function that returns a boolean indicating whether a tab
#'   is to be displayed in the UI
#' @importFrom purrr map
#' @importFrom shiny NS tabPanel tabsetPanel
#' @export
sb_create_tab_items <- function(config,
                                data_global,
                                display_tab = function(x){TRUE},
                                quietly = getOption('sb.quietly', FALSE)){
  message("Creating tab items ...")
  config %>%
    get_modules() %>%
    purrr::map(function(m){
      if (!quietly){
        message('Processing the page for ', m$text, " ...")
      }
      tabName = make_tab_name(m)
      if (!is.null(m$ui)){
        return(shinydashboard::tabItem(tabName, m$ui))
      }
      mod_ui <- if (!is.null(m$tabs)){
        m$tabs <- map(m$tabs, .process_module)
        module_tabs_ui(.process_module(m$tabs), display_tab)
      } else {
        get_module_ui(m, quietly = quietly)
      }
      l <- append(list(id = tabName, data_global = data_global), m$module_params)
      shinydashboard::tabItem(tabName, do.call(mod_ui, l))
    }) %>%
    do.call(tabItems, .)
}


#' Call all modules
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data passed to all page modules
#' @param input_global Global input passed to page module server functions
#' @param display_tab A function that returns a boolean indicating if a tab is
#'   to be displayed or not.
#' @export
sb_call_modules <- function(config,
                            data_global = list(),
                            input_global = list(),
                            display_tab = function(x){TRUE}){
  modules <- get_modules(config)
  modules %>%
    walk(~ {
      tabName = make_tab_name(.)
      .fun <- get_module(.)
      if (is.null(.fun) && !is.null(.$tabs)){
        .$tabs <- map(.$tabs, .process_module)
        .fun <- module_tabs(.$tabs, display_tab)
      }
      if (!is.null(.fun)){
        l <- list(
          .fun, tabName, data_global = data_global, input_global = input_global
        )
        l <- append(l, .$module_params)
        do.call(callModule, l)
      }
    })
}

#' @export
#' @rdname sb_call_modules
sb_call_all_modules <- function(config, data_global,
  display_tab = function(x){TRUE}){
  .Deprecated("sb_call_modules")
  sb_call_modules(config, data_global, display_tab)
}

