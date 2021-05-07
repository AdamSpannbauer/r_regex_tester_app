build_save_url = function(session, input) {
  encoded_pattern = URLencode(input$pattern)
  encoded_test_str = URLencode(input$test_str)

  query_string = paste0(
    "?pattern=", encoded_pattern,
    "&test_str=", encoded_test_str
  )

  shiny::updateQueryString(query_string, mode = "replace")

  full_url = paste0(
    session$clientData$url_protocol,
    "//",
    session$clientData$url_hostname,
    ":",
    session$clientData$url_port,
    query_string
  )

  return(full_url)
}
