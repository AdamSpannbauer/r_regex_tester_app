shinyServer(function(input, output, session){
  
  bad_slash <- reactive({
    !input$escape_slashes_pattern & is.null(safe_slashes(input$pattern)) |
      !input$escape_slashes_test_str & is.null(safe_slashes(input$test_str))
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
    req(pattern(), test_str())
    
    ignore_case_log <- "ignore_case" %in% input$additional_params
    global_log      <- "global" %in% input$additional_params
    perl_log        <- "perl" %in% input$additional_params
    fixed_log        <- "fixed" %in% input$additional_params
    
    get_match_list(test_str(), pattern(), input$environ, 
                   ignore_case_log, global_log, perl_log, fixed_log)
  })
  
  output$highlight_str <- renderUI({
    req(pattern(), test_str())
    
    ignore_case_log <- "ignore_case" %in% input$additional_params
    global_log      <- "global" %in% input$additional_params
    perl_log        <- "perl" %in% input$additional_params
    fixed_log        <- "fixed" %in% input$additional_params
    
    highlight_test_str(test_str(), pattern(), input$environ, 
                   ignore_case_log, global_log, perl_log, fixed_log) %>% 
      HTML()
  })
  
  output$match_list_html <- renderUI({
    req(input$pattern, input$test_str)
    
    if(!is.null(match_list())) {
      out <- html_format_match_list(match_list()) %>% 
        HTML()
    } else {
      out <- HTML("no matches found")
    }
    
    wellPanel(out)
  })
  
})#shinyServer
