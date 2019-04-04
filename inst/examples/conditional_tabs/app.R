# Load Libraries -----
library(shiny)
library(shinydashboard)
library(shinybones)

# Load Utilities -----
shinybones::source_dirs('utils')
shinybones::source_dirs('components')
shinybones::source_dirs('pages')

dc_env <- function(){
  is_shiny_server <- Sys.getenv("SHINY_SERVER") == "1"
  is_staging <- grepl("datacamp/dashboards", getwd())
  if (is_shiny_server) {
    if (is_staging){
      'staging'
    } else {
      'prod'
    }
  } else {
    'local'
  }
}


display_tab <- function(text){
  if (is_staging()){
    text != "Data"
  } else {
    TRUE
  }
}

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
      sb_create_tab_items(CONFIG, DATA, display_tab = display_tab)
    )
  )
}

# Server -----
server <- function(input, output, session){
  sb_call_modules(CONFIG, DATA)
}

# Run App ----
shinyApp(ui = ui, server = server)
