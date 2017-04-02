shinyServer(function(input, output, session){
  
  observe(test <<- input$auto_escape_check_group)
  
  bad_slash <- reactive({
    (!("pattern" %in% input$auto_escape_check_group) & is.null(safe_slashes(input$pattern))) |
      (!("test_str" %in% input$auto_escape_check_group) & is.null(safe_slashes(input$test_str)))
  })
  
  pattern <- reactive({
    req(input$pattern)
    
    ifelse("pattern" %in% input$auto_escape_check_group, 
           input$pattern, 
           safe_slashes(input$pattern))
  })
  
  test_str <- reactive({
    req(input$test_str)
    
    ifelse("test_str" %in% input$auto_escape_check_group, 
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
      HTML(paste0("<div style = 'overflow-y:scroll; max-height: 300px'><h3>", out, "</h3><div><br>"))
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
      out <- HTML("<h4>No matches found in Test String</h4>")
    } else {
      out <- HTML(out)
    }
      
    wellPanel(out, style = 'background-color: #ffffff; overflow-y:scroll; max-height: 500px')
  })
  
})#shinyServer
