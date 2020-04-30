#' Create sidebar
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data passed to the sidebar.
#' @param display_page A function that returns a boolean indicating if a page
#'   should be displayed in the sidebar.
#' @export
sb_create_sidebar <- function(config, data_global,
    display_page = function(x){TRUE}){
  s1 <- config$sidebar %>%
    purrr::map(function(item){
      if (!display_page(item$text)){
        return(NULL)
      }
      item$icon = shiny::icon(item$icon)
      if (length(item$menu) >= 1){
        subitems <- item$menu %>%
          map(function(subitem){
            if (!display_page(subitem$text)) {
              return(NULL)
            }
            if (is.null(subitem$href)) {
              subitem$tabName = make_tab_name(subitem)
            }
            do_call_2(menuSubItem, subitem)
          })
        item <- append(item, subitems)
      } else {
        if (is.null(item$href)) {
          item$tabName = make_tab_name(item)
        }
      }
      do_call_2(menuItem, item)
    }) %>%
    sidebarMenu(.list = ., id = 'smenu')
  s2 <- sb_create_sidebar_conditional_panels(
    config, data_global = data_global
  )
  shiny::tagList(s1, s2)
}

#' Create conditional panels
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data
#'
#' @export
sb_create_sidebar_conditional_panels <- function(config,
                                                 data_global = list()){
  modules <- get_modules(config)
  modules %>%
    purrr::map(~ {
      tabName = make_tab_name(.)
      if (!is.null(.$module)){
        .fun <- purrr::possibly(match.fun, NULL)(
          paste0(.$module, "_ui_sidebar")
        )
        if (!is.null(.fun)){
          conditionalPanel(
            sprintf(
              "input.smenu == '%s'",
               tabName
            ),
            .fun(tabName, data_global = data_global)
          )
        }
      } else if (!is.null(.$tabs)){
        tabName = make_tab_name(.)
        textName = .$text
        .$tabs %>%
          map(.process_module) %>%
          map(~ {
            if (!is.null(.$module)){
              .fun <- purrr::possibly(match.fun, NULL)(
                paste0(.$module, "_ui_sidebar")
              )
              if (!is.null(.fun)){
                idName = paste(tabName, make_tab_name(.), sep = "-")
                conditionalPanel(
                  sprintf(
                    "input.smenu == '%s' && input['%s'] == '%s'",
                    tabName, paste0(tabName, '-tab'), .$text
                  ),
                  .fun(idName, data_global = data_global)
                )
              }
            }
          })
      }
    }) %>%
    shiny::tagList()
}
