#' Page: module_data
#'
#' This is a page module ...
#' @param input The input object
#' @param output The output object
#' @param session The session object
#' @param data_global Global data passed on by app.R
#' @param input_global Global input passed on by app.R
#' @param ... Any additional parameters passed to the module
#' @examples
#' shinybones::preview_module(module_data)
#' @export
#' @importFrom shiny NS fluidRow
#' @importFrom shinydashboard box
module_data <- function(input, output, session, data_global = list(),
    input_global = list(), ...){
  ns <- session$ns

}


#' @rdname module_data
module_data_ui <- function(id, data_global, ...){
  ns <- shiny::NS(id)
  shiny::fluidRow(
    shinydashboard::box(
      title = "Data Module"
    )
  )
}

#' @rdname module_data
# module_data_ui_sidebar <- function(id, data_global, ...){
#  ns <- shiny::NS(id)
# }
