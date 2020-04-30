#' Create a Shiny UI function based on configuration and data
#'
#' @param config The structure of the shinybones website. Generally
#' parsed from \code{_site.yml} using \code{\link{sb_read_yaml}}.
#' @param data_global Global data that gets passed to everything in the
#' shinybones app.
#'
#' @return A function that can be passed to the \code{ui} parameter
#' of \code{\link[shiny]{shinyApp}}.
#'
#' @export
sb_ui <- function(config, data_global = list()) {
  ui <- function(request){
    shinydashboard::dashboardPage(
      # Header ----
      shinydashboard::dashboardHeader(title = config$name),

      # Sidebar ----
      shinydashboard::dashboardSidebar(
        sb_create_sidebar(config, data_global)
      ),

      # Body -----
      shinydashboard::dashboardBody(
        sb_create_tab_items(config, data_global)
      )
    )
  }

  ui
}

#' Create a Shiny server function based on configuration and data
#'
#' @param config The structure of the shinybones website. Generally
#' parsed from \code{_site.yml} using \code{\link{sb_read_yaml}}.
#' @param data_global Global data that gets passed to everything in the
#' shinybones app.
#' @param ... Extra arguments passed to \code{\link{sb_call_modules}}.
#'
#' @return A function that can be passed to the \code{server} parameter
#' of \code{\link[shiny]{shinyApp}}.
#'
#' @export
sb_server <- function(config, data_global = list(), ...) {
  server <- function(input, output, session){
    sb_call_modules(config, data_global, ...)
  }

  server
}

#' Run a shinydashboard app created using shinybones
#'
#' A shinybones app is based on a \code{_site.yml} file that specifies
#' modules for each sidebar item or tab.
#'
#' @param app_dir Path to directory containing the \code{./_site.yml}
#' file that specifies the site's structure.
#' @param data_global The global data object that will be passed on to all
#' page modules.
#' @param ... Extra parameters passed to \code{shinyApp}
#'
#' @details The configuration file should include \code{name}
#' and \code{sidebar}, with the sidebar containing a list of the
#' dashboard's tabs.
#'
#' @template yaml-tags
#'
#' @seealso \code{\link{sb_read_yaml}} for the custom tags that can be
#' used in the configuration file.
#'
#' @export
sb_create_app <- function(app_dir = ".",
                          data_global = list(),
                          ...){
  site_yml_path <- file.path(app_dir, "_site.yml")
  config <- sb_read_yaml(site_yml_path)

  ui <- sb_ui(config, data_global)
  server <- sb_server(config, data_global)

  shiny::shinyApp(ui = ui,
                  server = server,
                  ...)
}
