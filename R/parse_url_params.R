parse_url_and_update_inputs <- function(session) {
  parsed <- shiny::parseQueryString(session$clientData$url_search)

  if ("pattern" %in% names(parsed)) {
    pattern <- URLdecode(parsed[["pattern"]])
    shiny::updateTextInput(session, "pattern", value = pattern)
  }

  if ("test_str" %in% names(parsed)) {
    test_str <- URLdecode(parsed[["test_str"]])
    shiny::updateTextAreaInput(session, "test_str", value = test_str)
  }

  # Update check boxes
  auto_escape_check_group <- character(0)
  additional_params <- character(0)

  if (shiny::isTruthy(parsed[["aeb_pattern"]] == "TRUE")) {
    auto_escape_check_group <- c(auto_escape_check_group, "pattern")
  }

  if (!shiny::isTruthy(parsed[["aeb_test_str"]] == "FALSE")) {
    auto_escape_check_group <- c(auto_escape_check_group, "test_str")
  }

  if (!shiny::isTruthy(parsed[["ignore_case"]] == "FALSE")) {
    additional_params <- c(additional_params, "ignore_case")
  }

  if (!shiny::isTruthy(parsed[["global"]] == "FALSE")) {
    additional_params <- c(additional_params, "global")
  }

  if (!shiny::isTruthy(parsed[["perl"]] == "FALSE")) {
    additional_params <- c(additional_params, "perl")
  }

  if (shiny::isTruthy(parsed[["fixed"]] == "TRUE")) {
    additional_params <- c(additional_params, "fixed")
  }

  shiny::updateCheckboxGroupInput(
    session,
    "auto_escape_check_group",
    selected = auto_escape_check_group
  )

  shiny::updateCheckboxGroupInput(
    session,
    "additional_params",
    selected = additional_params
  )
}
