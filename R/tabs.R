module_tabs_ui <- function(tabs, display_tab){
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

module_tabs <- function(tabs, display_tab){
  function(input, output, session, data_global, ...){
    ns <- session$ns
    tabs %>%
      purrr::walk(~ {
        tabName <- make_tab_name(.)
        if (!is.null(.$module)){
          .fun <- get_module(.)
          if (!is.null(.fun)){
            callModule(.fun, tabName, data_global = data_global)
          }
        }
        print(.$text)
        if (!display_tab(.$text)){
          print("Appending tab...")
          appendTab('tab', tabPanel(.$text))
        }
      })
  }
}
