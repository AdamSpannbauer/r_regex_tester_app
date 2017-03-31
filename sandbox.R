
input <- list(
  test_str    = "test string test",
  environ     = "base",
  pattern     = "t(es)(t)",
  ignore_case = FALSE,
  global      = TRUE,
  perl        = TRUE
)

if (input$environ == "stringr") {
  reg <- regex(input$pattern, ignore_case = input$ignore_case)
  
  if(input$global) {
    match_mat  <- str_match_all(input$test_str, reg)[[1]]
  } else {
    match_mat  <- str_match(input$test_str, reg)
  }
  match_list <- purrr::map(1:nrow(match_mat), ~match_mat[.x,-1]) %>% 
    purrr::set_names(match_mat[,1])
} else if (input$environ == "base") {
  if(input$global) {
    matches_raw <- gregexpr(input$pattern, 
                            input$test_str,
                            perl = input$perl,
                            ignore.case = input$ignore_case)[[1]]
    
    matches <- regmatches(rep(input$test_str, length(matches_raw)),
                          matches_raw)
  } else {
    matches_raw <- regexpr(input$pattern, 
                           input$test_str,
                           perl = input$perl,
                           ignore.case = input$ignore_case)
    
    matches <- regmatches(input$test_str, matches_raw)[[1]]
  }
  
  if (input$perl & !is.null(attr(matches_raw, "capture.start"))) {
    capture_start  <- attr(matches_raw, "capture.start")
    capture_length <- attr(matches_raw, "capture.length")-1
    capture_end    <- capture_start + capture_length
    
    match_df <- data.frame(match_ind = c(1:length(matches)),
                           match     = matches,
                           starts    = as.numeric(capture_start),
                           ends      = as.numeric(capture_end),
                           stringsAsFactors = FALSE) %>% 
      as_data_frame() %>% 
      arrange(match_ind, starts) %>% 
      mutate(capture_text = str_sub(input$test_str, starts, ends)) %>% 
      group_by(match_ind, match) %>% 
      summarise(capture=list(capture_text)) %>% 
      ungroup()
    
    match_list <- match_df$capture %>% 
      purrr::set_names(match_df$match)
  } else {
    match_list <- purrr::map(1:length(matches), ~character(0)) %>% 
      purrr::set_names(matches)
  }
}

match_text <- paste0("<font style='color:", colors[1],"'>",
      names(match_list),
      "</font>%s")
capture_text <- map_chr(match_list, function(.x){
  if (length(.x) > 0) {
    x_colors <- colors[2:(length(.x)+1)]
    paste0("<font style='color:", x_colors,"'>",
           .x,
           "</font>") %>% 
      paste(collapse="<br>   ") %>% 
      paste("<br> Capture(s)<br>  ", .)
  } else {
    ""
  }
})

map2_chr(match_text, capture_text, ~sprintf(.x, .y)) %>% 
  paste0(collapse="<br>") %>% 
  paste0("<h3>Matches</h3><br>") %>% 
  cat()



str <- "test test"
match_text <- regexpr("t(es)(t)", str, perl=TRUE)
[[1]] %>% 
  as.character() %>% 
  unique()

replacements <- paste0("<font style='color:",
                       colors[1:length(match_text)],"'>",
                       match_text,
                       "</font>")

out_str <- str
for(i in 1:length(match_text)) {
  out_str <- str_replace_all(str, match_text[i], replacements[i])
}
out_str

map2_chr(match_text, replacements, ~str_replace_all(str, .x, .y))
