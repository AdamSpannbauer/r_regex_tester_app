build_save_url <- function(session, input) {
  encoded_pattern <- paste0("pattern=", URLencode(input$pattern))
  encoded_test_str <- paste0("test_str=", URLencode(input$test_str))

  param_strs <- c(encoded_pattern, encoded_test_str)

  # Only append remaining parameters if they differ from the defaults
  # -----------------------
  if ("pattern" %in% input$auto_escape_check_group) {
    param_strs <- c(param_strs, "aeb_pattern=TRUE")
  }

  if (!("test_str" %in% input$auto_escape_check_group)) {
    param_strs <- c(param_strs, "aeb_test_str=FALSE")
  }

  if (!("ignore_case" %in% input$additional_params)) {
    param_strs <- c(param_strs, "ignore_case=FALSE")
  }

  if (!("global" %in% input$additional_params)) {
    param_strs <- c(param_strs, "global=FALSE")
  }

  if (!("perl" %in% input$additional_params)) {
    param_strs <- c(param_strs, "perl=FALSE")
  }

  if ("fixed" %in% input$additional_params) {
    param_strs <- c(param_strs, "fixed=TRUE")
  }

  query_string <- paste0("?", paste(param_strs, collapse = "&"))

  shiny::updateQueryString(query_string, mode = "replace")

  port <- session$clientData$url_port
  port <- if (shiny::isTruthy(port)) paste0(":", port) else ""

  full_url <- paste0(
    session$clientData$url_hostname,
    port,
    session$clientData$url_pathname,
    query_string
  )

  return(full_url)
}
