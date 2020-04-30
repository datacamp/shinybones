# Load Libraries -----
library(shiny)
library(shinydashboard)
library(shinybones)

# Load Utilities -----
source_dirs('components')
source_dirs('pages')

# Global Data ----
# This is passed to all page modules as an argument named data_global
DATA <- list(
  my_data = mtcars
)

# Run the app
sb_create_app("_site.yml", DATA, enableBookmarking = 'url')
