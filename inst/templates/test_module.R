# Module: {module_name}
app <- shinybones::preview_module("{module_name}", preview = FALSE)
shiny::shinyApp(app$ui, app$server)
