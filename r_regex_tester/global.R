rm(list = ls())
options(shiny.trace = FALSE)

library(shiny)
library(shinyBS)
library(data.table)
library(stringr)
library(purrr)
library(tidyr)
library(htmltools)

source("helper_functions.R")
source("regexplainer.R")

buy_me_stuff_button_html = sample(c("www/buy_me_coffee_button.html",
                                     "www/buy_me_beer_button.html"),
                                   size = 1)

purr_possibly = function(.f, otherwise = NULL, quiet=FALSE) {
  purrr::possibly(.f, otherwise = otherwise, quiet = quiet)
}

safe_slashes = purr_possibly(half_slashes)
safe_highlight_test_str = purr_possibly(highlight_test_str)
safe_html_format_match_list = purr_possibly(html_format_match_list)
safe_get_match_list = purr_possibly(get_match_list)
safe_regexplain = purr_possibly(regexplain)

highlight_color_pallete = "Set3"


mgsub = function(pattern, replacement, text.var, leadspace = FALSE,
                  trailspace = FALSE, fixed = TRUE, trim = TRUE,
                  order.pattern = fixed, ...) {
  #' @description I wanted qdap::mgsub() w/o having to have full qdap package.
  #'              qdap has had issues related to deploying a shinyapp.

  if (leadspace | trailspace)
    replacement = spaste(replacement,
                         trailing = trailspace,
                         leading = leadspace)

  if (fixed && order.pattern) {
    ord = rev(order(nchar(pattern)))
    pattern = pattern[ord]
    if (length(replacement) != 1)
      replacement = replacement[ord]
  }
  if (length(replacement) == 1)
    replacement = rep(replacement, length(pattern))

  for (i in seq_along(pattern)) {
    text.var = gsub(pattern[i], replacement[i], text.var, fixed = fixed, ...)
  }

  if (trim)
    text.var = gsub(
      "\\s+",
      " ",
      gsub("^\\s+|\\s+$", "", text.var, perl = TRUE),
      perl = TRUE
    )
  text.var
}
