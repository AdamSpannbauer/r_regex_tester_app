mgsub = function(pattern, replacement, text.var, fixed = TRUE, trim = TRUE,
                 order.pattern = fixed, ...) {
  #' Multi gsub
  #'
  #' @description I wanted qdap::mgsub() w/o having to have full qdap package.
  #'              qdap has had issues related to deploying a shinyapp.
  #'
  #' @param pattern Character string to be matched in the given character
  #'                vector.
  #' @param replacement Character string equal in length to pattern or of length
  #'                    one which are a replacement for matched pattern.
  #' @param text.var The text variable.
  #' @param fixed logical. If TRUE, pattern is a string to be matched as is.
  #'              Overrides all conflicting arguments.
  #' @param trim logical. If TRUE leading and trailing white spaces are removed
  #'             and multiple white spaces are reduced to a single white space.
  #' @param order.pattern logical. If TRUE and fixed = TRUE, the pattern string
  #'                      is sorted by number of characters to prevent
  #'                      substrings replacing meta strings
  #'                      (e.g., pattern = c("the", "then") resorts to search
  #'                      for "then" first).
  #' @param ... Additional arguments passed to gsub.
  #'
  #' @return text.var with substitutions applied
  #' @keywords internal

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
