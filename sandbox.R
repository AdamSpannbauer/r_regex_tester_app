library(stringr)

input <- list(
  test_str    = "test string test",
  environ     = "base",
  pattern     = "t(es)(t)",
  ignore_case = TRUE,
  global      = TRUE,
  perl        = TRUE
)

if (input$environ == "stringr") {
  reg <- regex(input$pattern, ignore_case = input$ignore_case)
  
  if(input$global) {
    str_match_all(input$test_str, reg)
  } else {
    str_match(input$test_str, reg)
  }
} else if (input$environ == "base") {
  if(input$global) {
    matches_raw <- gregexpr(input$pattern, 
                            input$test_str,
                            perl = input$perl)
    
    matches <- regmatches(input$test_str, matches_raw)
    
    if (perl) {
      capture_start  <- attr(matches_raw[[1]], "capture.start")
      capture_length <- attr(matches_raw[[1]], "capture.length")
      capture_end    <- capture_start + capture_length
      
      purrr::map(1:length(matches), function(.x){
        dplyr::tibble(starts = capture_starts[.x, ])
      })
    }
    
    capture_match
    } else {
    regexpr(input$pattern, 
            input$test_str,
            perl = input$perl)
  }
}


