build_r_snippet <- function(session, input, pattern) {
  args <- c(
    "x = input"
  )

  if ("global" %in% input$additional_params) {
    sub_func <- "gsub"
    gexpr_func <- "gregexpr"
  } else {
    sub_func <- "sub"
    gexpr_func <- "regexpr"
  }

  if ("ignore_case" %in% input$additional_params) {
    args <- c(args, "ignore.case = TRUE")
  }

  if ("perl" %in% input$additional_params) {
    args <- c(args, "perl = TRUE")
  }

  if ("fixed" %in% input$additional_params) {
    args <- c(args, "fixed = TRUE")
  }

  sub_args_str <- paste(c(
    "pattern = pattern",
    "replacement = replacement",
    args
  ), collapse = ",\n  ")

  grep_args_str <- paste(c(
    "pattern = pattern",
    args
  ), collapse = ",\n  ")

  snippet <- sprintf(
    "pattern = '%s'

# A character vector to search for pattern in
input = ''

# If doing substitution, instances of the pattern
# that are found will be replaced with this:
replacement = ''

# Find pattern and replace it
replaced = %s(
  %s
)

# Find locations of matches in a vector
match_positions = grep(
  %s
)

# Find positional info of matches and capture groups
# (gets start index in string and match.length)
match_info_list = %s(
  %s
)
",
    pattern,
    sub_func, sub_args_str,
    grep_args_str,
    gexpr_func, grep_args_str
  )

  return(snippet)
}
