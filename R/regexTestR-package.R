#' @importFrom purrr     transpose
#' @importFrom data.table     := .SD 
#' @importFrom utils     URLencode
NULL

globalVariables(c("half_slashes", "capture_text","in_match_cap_start","match_start","in_match_cap_end","capture_ind","replacements", "spaste", "half_slash", ".", "out", "buy_me_stuff_button_html","r_lookup"))

#' \pkg{regexTestR}: R Regex Tester Shiny App
#'
#' This package provides functions that allow users to test/query regular expression on a test string of their choice using a shiny application. 
#'
#' @docType package
#' @name regexTestR-pkg
#' @note