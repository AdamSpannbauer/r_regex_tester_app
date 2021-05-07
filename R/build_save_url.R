build_save_url = function(session, input) {
  encoded_pattern = URLencode(input$pattern)
  encoded_test_str = URLencode(input$test_str)

  query_string = paste0(
    "?pattern=", encoded_pattern,
    "&test_str=", encoded_test_str
  )

  shiny::updateQueryString(query_string, mode = "replace")

  port = session$clientData$url_port
  port = if (shiny::isTruthy(port)) paste0(":", port) else ""

  full_url = sprintf(
    "%s%s%s%s",
    session$clientData$url_hostname,
    port,
    session$clientData$url_pathname,
    query_string
  )

  return(full_url)
}
