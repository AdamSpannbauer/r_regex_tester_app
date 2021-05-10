#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server = function(input, output, session) {
  shiny::observe({
    parse_url_and_update_inputs(session)
  })

  shiny::observeEvent(input$save_button, {
    save_url = build_save_url(session, input)

    shiny::showModal(
      shiny::modalDialog(
        title = "Saved at this URL:",
        shiny::div(
          shiny::tags$p(
            id = "save_url_copy",
            save_url,
            style = "white-space: nowrap; font-family: monospace;"
          ),
          style = "background-color: #EBEBEB; overflow-x: scroll; border-radius: 5px; padding: 5px; padding-top: 10px; border-style: solid; border-width: thin;"
        ),
        easyClose = TRUE,
        footer = shiny::div(
          shiny::fluidRow(
            shiny::actionButton(
              "copy_save_url_button",
              "Copy URL",
              icon = shiny::icon("clipboard"),
              onclick = "copySaveUrlToClipboard()"
              ),
            shiny::actionButton(
              "dismiss_modal",
              "Close",
              icon=shiny::icon("close"),
              "data-dismiss" = "modal"
              )
            )
          )
      )
    )
  })

  safe_half_slashes = try_default(half_slashes)
  safe_get_match_list = try_default(get_match_list)
  safe_html_format_match_list = try_default(html_format_match_list)
  safe_highlight_test_str = try_default(highlight_test_str)
  safe_regexplain = try_default(regexplain)


  bad_slash = shiny::reactive({
    (
      !("pattern" %in% input$auto_escape_check_group) &
        is.null(safe_half_slashes(input$pattern))
    ) | (
      !("test_str" %in% input$auto_escape_check_group) &
        is.null(safe_half_slashes(input$test_str))
    )
  })

  pattern = shiny::reactive({
    req(input$pattern)

    pattern = ifelse("pattern" %in% input$auto_escape_check_group,
                     input$pattern,
                     safe_half_slashes(input$pattern))

    pattern
  })

  test_str = shiny::reactive({
    req(input$test_str)

    test_str = ifelse("test_str" %in% input$auto_escape_check_group,
                      input$test_str,
                      safe_half_slashes(input$test_str))

    test_str
  })

  match_list = shiny::reactive({
    req(pattern(), test_str(), !bad_slash())

    ignore_case_log = "ignore_case" %in% input$additional_params
    global_log      = "global" %in% input$additional_params
    perl_log        = "perl" %in% input$additional_params
    fixed_log       = "fixed" %in% input$additional_params

    safe_get_match_list(test_str(), pattern(),
                        ignore_case_log, global_log, perl_log, fixed_log)
  })

  output$highlight_str = shiny::renderUI({
    ignore_case_log = "ignore_case" %in% input$additional_params
    global_log      = "global" %in% input$additional_params
    perl_log        = "perl" %in% input$additional_params
    fixed_log       = "fixed" %in% input$additional_params

    out = safe_highlight_test_str(
      test_str(),
      pattern(),
      ignore_case_log,
      global_log,
      perl_log,
      fixed_log
    )

    out = gsub("\n", "<br>", out)

    if (is.null(out)) {
      shiny::HTML("")
    } else {
      shiny::HTML(
        paste0(
          "<font size='1'><i>Note: nested capture groups currently not ",
          "supported for in place highlighting</i></font><div style = ",
          "'overflow-y:scroll; max-height: 300px'><h3>", out, "</h3><div><br>"
        )
      )
    }
  })

  output$match_list_html = shiny::renderUI({
    if (!bad_slash()) {
      out = safe_html_format_match_list(match_list())
    } else if (bad_slash()) {
      out = paste0("<h4 style='color:#990000'> Error with backslashes.</h4>",
                   "<font style='color:#990000'>Remember to manually escape backslashes when ",
                   "escape backslashes option isn't selected.</font>")
    }
    if (is.null(out)) {
      out = HTML("<h4>No matches found in Test String</h4>")
    } else {
      out = HTML(out)
    }

    shiny::wellPanel(
      out,
      style = "background-color: #ffffff; overflow-y:scroll; max-height: 500px"
    )
  })

  output$r_code_snippet = shiny::renderText(
    build_r_snippet(session, input, pattern())
    )

  output$explaination_dt = DT::renderDataTable({
    if (bad_slash()) {
      out = data.frame(ERROR = "there was an error retreiving explanation")
    } else if ("fixed" %in% input$additional_params) {
      out = data.frame(
        `NA` = "explanations are not applicable when using Fixed option"
      )
    } else {
      out = safe_regexplain(pattern())
      if (is.null(out)) out = data.frame(
        ERROR = "there was an error retreiving explanation"
      )
    }

    out
  })
}
