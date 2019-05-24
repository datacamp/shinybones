#' Preview a html component, a shiny module, or a datatable in a shinydashboard
#'
#' @param module The server function of a module or its name.
#' @param name The id to pass to callModule while calling it.
#' @param use_box A boolean indicating if the ui should be wrapped in a
#'   box
#' @param title The dashboard title to display.
#' @param titleWidth The width of the dashboard title.
#' @param preview A boolean indicating if the return value should be a shinyApp
#'   object (default) or a named list with ui and server.
#' @param ... Additional parameters to pass to the module
#' @import shinydashboard
#' @importFrom purrr possibly
#' @export
#' @examples
#' library(shiny)
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
#' preview_module(slider_text, title = 'Slider Text')
#' preview_module(slider_text, title = 'Slider Text', use_box = TRUE)
preview_module <- function(module, name = 'module', use_box = FALSE,
    title = name, titleWidth = NULL,
    preview = TRUE, ...){
  if (is.character(module)){
    name <- module
    module_name <- module
    module <- match.fun(name)
  } else {
    module_name <- deparse(substitute(module))
  }
  ui_name <- paste(module_name, 'ui', sep = "_")
  ui_fun <- get(ui_name, mode = "function", envir = environment(module))
  sidebar_ui_fun <- purrr::possibly(match.fun, function(x, ...){NULL})(
    paste0(module_name, '_ui_sidebar')
  )
  # ui_fun <- match.fun(paste(module_name, 'ui', sep = "_"))
  my_ui <- if (use_box){
    shiny::fluidRow(
      shinydashboard::box(width = 12,
        ui_fun(name, ...)
      )
    )
  } else {
    ui_fun(name, ...)
  }
  mod_fun <- match.fun(module_name)
  ui <- shinydashboard::dashboardPage(skin = 'purple',
    shinydashboard::dashboardHeader(
      title = title,
      titleWidth = titleWidth
    ),
    shinydashboard::dashboardSidebar(
      width = titleWidth,
      sidebar_ui_fun(name, ...)
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
  if (!preview){
    list(ui = ui, server = server)
  } else {
    shiny::shinyApp(ui = ui, server = server)
  }

}


#' @export
#' @rdname preview_module
#' @examples
#' ui <- DT::datatable(mtcars, width = '100%', extension = 'Responsive')
#' preview_component(ui)
preview_component <- function (x, title = "Preview", use_box = TRUE, ...){
  module_ui <- function(id){x}
  module <- function(input, output, session, ...){}
  preview_module('module', title = title, use_box = use_box, ...)
}

#' @export
#' @rdname preview_module
#' @examples
#' preview_datatable(mtcars,
#'   style = 'bootstrap',
#'   width = '100%',
#'   extension = 'Responsive'
#' )
preview_datatable <- function(data, ...){
  mod_ui <- function(id){
    ns <- shiny::NS(id)
    shiny::fluidRow(box(
      width = 12,
      DT::DTOutput(ns('dt'))
    ))
  }

  mod <- function(input, output, session){
    output$dt <- DT::renderDT({
      DT::datatable(data, ...)
    })
  }
  preview_module(mod)
}
