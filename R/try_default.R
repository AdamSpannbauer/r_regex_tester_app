try_default = function(fun, default = NULL, silent = FALSE) {
  #' Create a 'safe' version of a function with a default return value
  #'
  #' @param fun function to add try logic to
  #' @param default default value to return if fun errors
  #' @param silent should error be printed to console?
  #'
  #' @return either output of fun or default value in case of error
  #' @keywords internal
  #' @noRd

  function(...) {
    out = default
    try({
      out = fun(...)
    }, silent = silent)

    return(out)
  }
}
