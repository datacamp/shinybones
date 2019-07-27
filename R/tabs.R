#' Generate a tab module
#'
#' @export
#' @param tabs A list of tabs, where each tab is a list.
#' @param display_tab A function to check if a tab should be displayed.
#' @examples
#' \dontrun{
#'   tabs <- list(
#'     list(text = 'Tab 1'),
#'     list(text = 'Tab 2')
#'   )
#'   test_mod <- module_tabs(tabs)
#'   test_mod_ui <- module_tabs_ui(tabs)
#'   preview_module(test_mod)
#' }
#' @importFrom bsplus bs_embed_tooltip
module_tabs <- function(tabs, display_tab = function(x){TRUE}){
  function(input, output, session,
           data_global = list(),
           input_global = list(),
           ...){
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
      })
  }
}

#' @export
#' @rdname module_tabs
module_tabs_ui <- function(tabs, display_tab = function(x){TRUE}){
  function(id, data_global = list(), ...){
    dots <- list(...)
    ns <- shiny::NS(id)
    tabs %>%
      purrr::keep(~ display_tab(.x$text)) %>%
      purrr::map(~ {
        tabName <- make_tab_name(.)
        .fun_ui <- get_module_ui(.)
        args_tabPanel <- append(
          list(ns(tabName), data_global = data_global),
          dots
        )
        shiny::tabPanel(
          tab_title(.x), do.call(.fun_ui, args_tabPanel)
        )
      }) %>%
      append(list(id = ns('tab'))) %>%
      do.call(shiny::tabsetPanel, .)
  }
}

tab_title <- function(.x){
  if (!is.null(.x$help_text)){
    htmltools::tags$span(.x$text) %>%
      bsplus::bs_embed_tooltip(.x$help_text, placement = 'bottom')
  } else{
    .x$text
  }
}
