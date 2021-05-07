#' Repeat tags$br
#'
#' @param times the number of br to return
#'
#' @return the number of br specified in times
#' @noRd
#'
#' @importFrom htmltools HTML
rep_br <- function(times = 1) {
  HTML(rep("<br/>", times = times))
}


#' Columns wrappers
#'
#' These are convenient wrappers around
#' `column(12, ...)`, `column(6, ...)`, `column(4, ...)`...
#'
#' @noRd
#'
#' @importFrom shiny column
col_12 <- function(...) {
  column(12, ...)
}


#' @importFrom shiny column
#' @noRd
col_10 <- function(...) {
  column(10, ...)
}


#' @importFrom shiny column
#' @noRd
col_5 <- function(...) {
  column(5, ...)
}


#' @importFrom shiny column
#' @noRd
col_4 <- function(...) {
  column(4, ...)
}
