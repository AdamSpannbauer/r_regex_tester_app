rm(list=ls())
options(shiny.trace=FALSE)

library(shiny)
library(shinyBS)
library(data.table)
library(stringr)
library(purrr)
library(tidyr)
library(htmltools)

source("helper_functions.R")
source("regexplainer.R")

safe_slashes                <- purrr::possibly(half_slashes, otherwise = NULL, quiet=FALSE)
safe_highlight_test_str     <- purrr::possibly(highlight_test_str, otherwise = NULL, quiet=FALSE)
safe_html_format_match_list <- purrr::possibly(html_format_match_list, otherwise = NULL, quiet=FALSE)
safe_get_match_list         <- purrr::possibly(get_match_list, otherwise = NULL, quiet=FALSE)
safe_regexplain             <- purrr::possibly(regexplain, otherwise = NULL, quiet=FALSE)

highlight_color_pallete <- "Set3"

mgsub = function (pattern, replacement, text.var, leadspace = FALSE, trailspace = FALSE, 
                  fixed = TRUE, trim = TRUE, order.pattern = fixed, ...) {
  if (leadspace | trailspace)
    replacement <- spaste(replacement, trailing = trailspace, leading = leadspace)
  
  if (fixed && order.pattern) {
    ord <- rev(order(nchar(pattern)))
    pattern <- pattern[ord]
    if (length(replacement) != 1)
      replacement <- replacement[ord]
  }
  if (length(replacement) == 1)
    replacement <- rep(replacement, length(pattern))
  
  for (i in seq_along(pattern)) {
    text.var <- gsub(pattern[i], replacement[i], text.var, fixed = fixed, ...)
  }
  
  if (trim)
    text.var <-
      gsub("\\s+", " ", gsub("^\\s+|\\s+$", "", text.var, perl = TRUE), perl = TRUE)
  text.var
}
