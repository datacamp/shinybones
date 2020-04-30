#' Internal function for retrieving a pin that may have a board
#'
#' @param pin_name Either a pin name, or a string in the form
#' \code{board:pin_name}.
sb_pin_get <- function(pin_name) {
  if (stringr::str_detect(pin_name, ":")) {
    # Pin is in the form board:pin
    pin_split <- stringr::str_split(pin_name, ":")
    pins::pin_get(pin_split[[2]], board = pin_split[[1]])
  } else {
    # Just a pin name
    pins::pin_get(pin_name)
  }
}

#' Read a YAML configuration file for a shinybones app
#'
#' Shinybones apps have custom tags that allow R objects to be
#' passed to shinybones modules. Use this to parse the
#' \code{_site.yml} file.
#'
#' @param config_path Path to YAML file, conventionally \code{_site.yml}.
#' @param data_global Global data. Variables in this can be accessed
#' with the \code{!global} tag.
#'
#' @template yaml-tags
#'
#' @return The parsed configuration file.
#'
#' @export
sb_read_yaml <- function(config_path, data_global = list()) {
  handlers <- list(global = function(x) data_global[[x]],
                   pin = sb_pin_get)

  yaml::read_yaml(config_path,
                  eval.expr = TRUE,
                  handlers = handlers)
}
