 #' Page: test_input_global
 #'
 #' This is a page module ...
 #' @param data_global Global data passed on by app.R
 #' @param ... Additional parameters passed to the module
 #' @examples
 #' satin::preview_module("test_input_global",
 #'   data_global = list()
 #'
 #' )
 #' @export
 test_input_global <- function(input, output, session, data_global, input_global,
     ...){
   ns <- session$ns
   output$num <- renderText({
     input_global$num
   })
 }


 #' @rdname test_input_global
 test_input_global_ui <- function(id, data_global, ...){
   ns <- NS(id)
   fluidRow(
     box(
       title = "Number",
       verbatimTextOutput(ns('num'))
     )
   )
 }

 #' @rdname test_input_global
 # test_input_global_ui_sidebar <- function(id, data_global, ...){
 #  ns <- NS(id)
 # }
