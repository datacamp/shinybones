# Load Libraries -----
library(shiny)
library(shinydashboard)
library(satin)

# Load Utilities -----
source_dirs('components')
source_dirs('pages')

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
      st_create_sidebar(CONFIG, DATA),
      sliderInput('num', 'Select Number', 0, 100, 50)
    ),

    # Body -----
    dashboardBody(
      st_create_tab_items(CONFIG, DATA)
    )
  )
}

# Server -----
server <- function(input, output, session){
  st_call_all_modules(CONFIG, DATA, input_global = input)
}

# Run App ----
shinyApp(ui = ui, server = server)
