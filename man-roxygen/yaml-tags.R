#' @details A site configuration file supports the following tags:
#'
#' \describe{
#'   \item{\code{!expr}}{Provide arbitrary R code to be evaluated}
#'   \item{\code{!pin}}{Provide a pin name that can be retrieved, or
#'   a string of the form \code{board:pin_name}}
#'   \item{\code{!global}}{An accessor for an object in \code{data_global}.}
#' }
