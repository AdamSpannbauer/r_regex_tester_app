#' Repeat tags$br
#'
#' @param times the number of br to return
#'
#' @return the number of br specified in times
#' @noRd
#'
#' @examples
#' rep_br(5)
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
col_10 <- function(...) {
  column(10, ...)
}


#' @importFrom shiny column
col_8 <- function(...) {
  column(8, ...)
}

#' @importFrom shiny column
col_6 <- function(...) {
  column(6, ...)
}


#' @importFrom shiny column
col_4 <- function(...) {
  column(4, ...)
}


#' @importFrom shiny column
col_3 <- function(...) {
  column(3, ...)
}


#' @importFrom shiny column
col_2 <- function(...) {
  column(2, ...)
}


#' @importFrom shiny column
col_1 <- function(...) {
  column(1, ...)
}
