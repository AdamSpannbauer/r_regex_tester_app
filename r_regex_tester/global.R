rm(list=ls())
options(shiny.trace=FALSE)

library(shiny)
library(shinyBS)
library(data.table)
library(stringr)
library(purrr)
library(tidyr)
library(qdap)
library(htmltools)

source("helper_functions.R")
source("regexplainer.R")

safe_slashes                <- purrr::possibly(half_slashes, otherwise = NULL, quiet=FALSE)
safe_highlight_test_str     <- purrr::possibly(highlight_test_str, otherwise = NULL, quiet=FALSE)
safe_html_format_match_list <- purrr::possibly(html_format_match_list, otherwise = NULL, quiet=FALSE)
safe_get_match_list         <- purrr::possibly(get_match_list, otherwise = NULL, quiet=FALSE)
safe_regexplain             <- purrr::possibly(regexplain, otherwise = NULL, quiet=FALSE)

highlight_color_pallete <- "Set3"