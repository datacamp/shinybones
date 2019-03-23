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
    purrr::map(~ {
      if (!display_page(.$text)){
        return(NULL)
      }
      if (length(.$menu) >= 1){
          .text <- .x$text
          .startExpanded <- if (is.null(.x$startExpanded)) {
              FALSE
           } else {
             .x$startExpanded
           }
          .icon=   icon(.x$icon)
          .$menu %>%
             map(~ {
               if (!display_page(.$text)) {
                 return(NULL)
               }
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
             }) %>%
             append(list(text = .text, icon = .icon, startExpanded = .startExpanded)) %>%
             do.call(menuItem, .)
      } else {
        if (!is.null(.$href)) {
          menuItem(.$text, href = .$href, icon = icon(.$icon))
        } else {
          menuItem(.$text, tabName = make_tab_name(.), icon = icon(.$icon))
        }
      }
    }) %>%
    append(list(id = 'smenu')) %>%
    do.call(sidebarMenu, .)
  # UNCOMMENT OUT CONDITIONAL PANELS FOR NOW ---
  s2 <- sb_create_sidebar_conditional_panels(
    config, data_global = data_global
  )
  tagList(s1, s2)
}

#' Create conditional panels
#'
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
    tagList()
}
