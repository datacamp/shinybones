# Load Libraries -----
library(shiny)
library(shinydashboard)
library(shinybones)

# Load Utilities -----
shinybones::source_dirs('utils')
shinybones::source_dirs('components')
shinybones::source_dirs('pages')

# Global Data ----
# This is passed to all page modules as an argument named data_global
DATA <- list(
  my_data = mtcars
)

# Configuration
CONFIG <- yaml::read_yaml('_site.yml')

# UI ----
ui <- function(request){
  dashboardPage(
    # Header ----
    dashboardHeader(title = CONFIG$name),

    # Sidebar ----
    dashboardSidebar(
      sb_create_sidebar(CONFIG, DATA),
      sliderInput('num', 'Select Number', 0, 100, 50)
    ),

    # Body -----
    dashboardBody(
      sb_create_tab_items(CONFIG, DATA)
    )
  )
}

# Server -----
server <- function(input, output, session){
  sb_call_modules(CONFIG, DATA, input_global = input)
}

# Run App ----
shinyApp(ui = ui, server = server)
