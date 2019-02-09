#' Preview a shiny module in a shiny dashboard
#'
#' @param module_name Name of the module
#' @param name Namespace to call the module
#' @param ... Additional parameters to pass to the module
#' @import shinydashboard
#' @importFrom purrr possibly
#' @export
#' @examples
#' slider_text_ui <- function(id){
#'   ns <- NS(id)
#'   tagList(
#'     sliderInput(ns('num'), 'Enter Number', 0, 1, 0.5),
#'     textOutput(ns('num_text'))
#'   )
#' }
#' slider_text <- function(input, output, session){
#'    output$num_text <- renderText({input$num})
#' }
#' preview_module('slider_text')
preview_module <- function(module_name, name = 'module', use_box = FALSE, ...){
  ui_fun <- match.fun(paste(module_name, 'ui', sep = "_"))
  my_ui <- if (use_box){
    shiny::fluidRow(
      shinydashboard::box(
        ui_fun(name, ...)
      )
    )
  } else {
    ui_fun(name, ...)
  }
  sidebar_ui_fun <- purrr::possibly(match.fun, function(x){NULL})(
    paste0(module_name, '_ui_sidebar')
  )
  mod_fun <- match.fun(module_name)
  ui <- shinydashboard::dashboardPage(skin = 'purple',
    shinydashboard::dashboardHeader(
      title = name
    ),
    shinydashboard::dashboardSidebar(
      sidebar_ui_fun(name)
    ),
    shinydashboard::dashboardBody(
      my_ui
    )
  )
  server <- function(input, output, session){
    module_output <- shiny::callModule(
      mod_fun, name, ...
    )
  }
  shiny::shinyApp(ui = ui, server = server)
}


#' Preview a component in a satin shinydashboard
#' @export
preview_component <- function (x, title = "Preview", use_box = TRUE, ...){
  module_ui <- function(id) {
    ns <- shiny::NS(id)
    fluidRow(if (use_box) {
      box(width = 12, title = title, x)
    }
    else {
      x
    })
  }
  module <- function(input, output, session, ...){

  }
  preview_module('module', use_box = use_box, ...)
}
