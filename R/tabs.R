# Generate Tab Modules
# This is worth exporting
module_tabs <- function(tabs, display_tab = function(x){TRUE}){
  function(input, output, session, data_global, input_global, ...){
    ns <- session$ns
    tabs %>%
      purrr::walk(~ {
        tabName <- make_tab_name(.)
        if (!is.null(.$module)){
          .fun <- get_module(.)
          if (!is.null(.fun)){

            l <- list(
              .fun, tabName,
              data_global = data_global, input_global = input_global
            )
            l <- append(l, .$module_params)
            do.call(callModule, l)
          }
        }
        if (!display_tab(.$text)){
          appendTab('tab', tabPanel(.$text))
        }
      })
  }
}

module_tabs_ui <- function(tabs, display_tab = function(x){TRUE}){
  function(id, data_global){
    ns <- shiny::NS(id)
    tabs %>%
      purrr::keep(~ display_tab(.$text)) %>%
      purrr::map(~ {
        tabName <- make_tab_name(.)
        .fun_ui <- get_module_ui(.)
        shiny::tabPanel(
          .$text, .fun_ui(ns(tabName), data_global = data_global)
        )
      }) %>%
      append(list(id = ns('tab'))) %>%
      do.call(shiny::tabsetPanel, .)
  }
}
