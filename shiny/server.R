shinyServer(function(input, output, session){
  
  bad_slash <- reactive({
    (!input$escape_slashes_pattern & is.null(safe_slashes(input$pattern))) |
      (!input$escape_slashes_test_str & is.null(safe_slashes(input$test_str)))
  })
  
  pattern <- reactive({
    req(input$pattern, !is.null(input$escape_slashes_pattern))
    
    ifelse(input$escape_slashes_pattern, 
           input$pattern, 
           safe_slashes(input$pattern))
  })
  
  test_str <- reactive({
    req(input$test_str, !is.null(input$escape_slashes_test_str))
    
    ifelse(input$escape_slashes_test_str, 
           input$test_str, 
           safe_slashes(input$test_str))
  })
  
  match_list <- reactive({
    req(pattern(), test_str(), !bad_slash())
    
    ignore_case_log <- "ignore_case" %in% input$additional_params
    global_log      <- "global" %in% input$additional_params
    perl_log        <- "perl" %in% input$additional_params
    fixed_log       <- "fixed" %in% input$additional_params
    
    safe_get_match_list(test_str(), pattern(), "base", 
                        ignore_case_log, global_log, perl_log, fixed_log)
  })
  
  output$highlight_str <- renderUI({
    ignore_case_log <- "ignore_case" %in% input$additional_params
    global_log      <- "global" %in% input$additional_params
    perl_log        <- "perl" %in% input$additional_params
    fixed_log       <- "fixed" %in% input$additional_params
    
    out <- safe_highlight_test_str(test_str(), pattern(), "base", 
                   ignore_case_log, global_log, perl_log, fixed_log, color_palette=highlight_color_pallete)
    if (is.null(out)) {
      HTML("")
    } else {
      HTML(paste0("<div style='overflow: auto'><h3>", out, "</h3><div>"))
    }
  })
  
  output$match_list_html <- renderUI({
    if(!bad_slash()) {
      out <- safe_html_format_match_list(match_list(), color_palette=highlight_color_pallete)
    } else if(bad_slash()) {
      out <- paste0("<h4 style='color:#990000'> Error with backslashes.</h4>",
                    "<font style='color:#990000'>Remember to manually escape backslashes when ",
                    "escape backslashes option isn't selected.</font>")
    }
    if(is.null(out)) {
      out <- HTML("No matches")
    } else {
      out <- HTML(out)
    }
      
    wellPanel(out)
  })
  
})#shinyServer
