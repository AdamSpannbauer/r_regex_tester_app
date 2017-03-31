shinyServer(function(input, output, session){
  
  match_list <- reactive({
    req(input$pattern, input$test_str)
    
    ignore_case_log <- "ignore_case" %in% input$additional_params
    global_log      <- "global" %in% input$additional_params
    perl_log        <- "perl" %in% input$additional_params
    
    get_match_list(input$test_str, input$pattern, input$environ, 
                   ignore_case_log, global_log, perl_log)
  })
  
  output$match_list_html <- renderUI({
    req(input$pattern, input$test_str)
    
    if(!is.null(match_list())) {
      out <- html_format_match_list(match_list()) %>% 
        HTML()
    } else {
      out <- HTML("no matches found")
    }
    
    out
  })
  
})#shinyServer