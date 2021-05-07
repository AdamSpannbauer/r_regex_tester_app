parse_url_and_update_inputs = function(session) {
  parsed = shiny::parseQueryString(session$clientData$url_search)

  if ("pattern" %in% names(parsed)) {
    pattern = URLdecode(parsed[["pattern"]])
    shiny::updateTextInput(session, "pattern", value = pattern)
  }

  if ("test_str" %in% names(parsed)) {
    test_str = URLdecode(parsed[["test_str"]])
    shiny::updateTextAreaInput(session, "test_str", value = test_str)
  }
}
