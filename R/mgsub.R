mgsub = function(pattern, replacement, text.var, fixed = TRUE, ...) {
  #' Multi gsub
  #'
  #' @description I wanted qdap::mgsub() w/o having to have full qdap package.
  #'              qdap has had issues related to deploying a shinyapp.  So this
  #'              is a trimmed down version of qdap::mgsub()
  #'
  #' @param pattern Character string to be matched in the given character
  #'                vector.
  #' @param replacement Character string equal in length to pattern or of length
  #'                    one which are a replacement for matched pattern.
  #' @param text.var The text variable.
  #' @param fixed logical. If TRUE, pattern is a string to be matched as is.
  #'              Overrides all conflicting arguments.
  #' @param ... Additional arguments passed to gsub.
  #'
  #' @return text.var with substitutions applied
  #' @keywords internal

  if (length(replacement) == 1) {
    replacement = rep(replacement, length(pattern))
  }

  for (i in seq_along(pattern)) {
    text.var = gsub(pattern[i], replacement[i], text.var, fixed = fixed, ...)
  }

  text.var
}
