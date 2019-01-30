#' Create sidebar
#'
#' @param config Dashboard configuration read from _site.yml
#' @param data_global Global data passed to the sidebar
#' @export
create_sidebar <- function(config, data_global, display_tab = function(x){TRUE}){
  s1 <- config$sidebar %>%
    purrr::map(~ {
      if (!display_tab(.$text)){
        return(NULL)
      }
      if (length(.$menu) > 1){
        menuItem(.$text, tabName = make_tab_name(.), icon = icon(.$icon),
          .$menu %>%
             map(~ {
               if (!is.null(.$href)){
                 return(menuSubItem(.$text, href = .$href))
               }
               tabName = make_tab_name(.)
               if (.$text != "") {
                   menuSubItem(.$text, tabName = tabName)
               } else {
                 fun_ui_sidebar <- match.fun(paste0(.$module, '_ui_sidebar'))
                 fun_ui_sidebar(tabName)
               }
             })
        )
      } else {
        menuItem(.$text, tabName = make_tab_name(.), icon = icon(.$icon))
      }
    }) %>%
    tagList() %>%
    sidebarMenu(id = 'smenu')
  s2 <- create_conditional_panels(config)
  tagList(s1, s2)
}

# Create conditional panels
create_conditional_panels <- function(config){
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
            sprintf("input.smenu == '%s'", tabName),
            .fun(tabName)
          )
        }
      }
    }) %>%
    tagList()
}
