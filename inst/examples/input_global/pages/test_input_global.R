#' Page: test_input_global
#'
#' This is a page module ...
#' @param input The input object
#' @param output The output object
#' @param session The session object
#' @param data_global Global data passed on by app.R
#' @param input_global Global input passed on by app.R
#' @param ... Any additional parameters passed to the module
#' @examples
#' shinybones::preview_module(test_input_global)
#' @export
#' @importFrom shiny NS fluidRow
#' @importFrom shinydashboard box
test_input_global <- function(input, output, session, data_global = list(),
    input_global = list(), ...){
  ns <- session$ns
  output$num <- renderText({
    input_global$num
  })

}


#' @rdname test_input_global
test_input_global_ui <- function(id, data_global, ...){
  ns <- shiny::NS(id)
  shiny::fluidRow(
    shinydashboard::box(
      title = "Number",
      verbatimTextOutput(ns("num"))
    )
  )
}
