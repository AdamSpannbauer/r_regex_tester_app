
# input <- list(
#   test_str    = "test string test",
#   environ     = "base",
#   pattern     = "t(es)(t)",
#   ignore_case = FALSE,
#   global      = TRUE,
#   perl        = TRUE
# )
# 
# get_match_list(input$test_str, input$pattern, input$environ, 
#                input$ignore_case, input$global, input$perl) %>% 
#   html_format_match_list()

#function to match text using 
get_match_list <- function(str, pattern, environ="base", ignore_case=TRUE, global=TRUE, perl=TRUE, fixed=FALSE) {
  if (environ == "stringr") {
    if(fixed) {
      reg <- stringr::fixed(pattern, ignore_case = ignore_case)
    } else {
      reg <- stringr::regex(pattern, ignore_case = ignore_case)
    }
    
    if(global) {
      match_mat  <- stringr::str_match_all(str, reg)[[1]]
    } else {
      match_mat  <- stringr::str_match(str, reg)
    }
    
    if(nrow(match_mat) == 0) return(NULL)
    
    match_list <- purrr::map(1:nrow(match_mat), ~match_mat[.x,-1]) %>% 
      purrr::set_names(match_mat[,1])
  } else if (environ == "base") {
    if(global) {
      matches_raw <- gregexpr(pattern, 
                              str,
                              perl = perl,
                              ignore.case = ignore_case)[[1]]
      
      if(matches_raw==-1) return(NULL)
      
      matches <- regmatches(rep(str, length(matches_raw)),
                            matches_raw)
    } else {
      matches_raw <- regexpr(pattern, 
                             str,
                             perl = perl,
                             ignore.case = ignore_case)
      
      matches <- regmatches(str, matches_raw)[[1]]
    }
    
    if (perl & !is.null(attr(matches_raw, "capture.start"))) {
      capture_start  <- attr(matches_raw, "capture.start")
      capture_length <- attr(matches_raw, "capture.length")-1
      capture_end    <- capture_start + capture_length
      
      match_df <- data.frame(match_ind = c(1:length(matches)),
                             match     = matches,
                             starts    = as.numeric(capture_start),
                             ends      = as.numeric(capture_end),
                             stringsAsFactors = FALSE) %>% 
        dplyr::as_data_frame() %>% 
        dplyr::arrange(match_ind, starts) %>% 
        dplyr::mutate(capture_text = stringr::str_sub(str, starts, ends)) %>% 
        dplyr::group_by(match_ind, match) %>% 
        dplyr::summarise(capture=list(capture_text)) %>% 
        dplyr::ungroup()
      
      match_list <- match_df$capture %>% 
        purrr::set_names(match_df$match)
    } else {
      match_list <- purrr::map(1:length(matches), ~character(0)) %>% 
        purrr::set_names(matches)
    }
  }
  
  match_list
}

html_format_match_list <- function(match_list, color_palette="Set2") {
  suppressWarnings(colors <- RColorBrewer::brewer.pal(100, color_palette))
  
  match_text <- paste0("<font style='color:", colors[1],"'>",
                       names(match_list),
                       "</font>%s")
  capture_text <- purrr::map_chr(match_list, function(.x){
    if (length(.x) > 0) {
      x_colors <- colors[2:(length(.x)+1)]
      paste0("<li><font style='color:", x_colors,"'>",
             .x,
             "</font></li>") %>% 
        paste(collapse="<br>") %>% 
        paste("<ul>", .,"</ul>")
    } else {
      ""
    }
  })
  
  purrr::map2_chr(match_text, capture_text, ~sprintf(.x, .y)) %>% 
    paste0(collapse="</li><br><li>") %>% 
    paste0("<h4>Matched & Captured Text</h4><ol><li>",.,"</li></ol>")
}
