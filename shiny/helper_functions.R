
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

half_slashes <- function(str) {
  deparsed <- deparse(str)
  
  half_df <- stringr::str_match_all(deparsed, "(\\\\+)(.)")[[1]] %>% 
    dplyr::as_data_frame() %>% 
    purrr::set_names(c("match","slash_cap","char_cap")) %>% 
    dplyr::mutate(half_slash = stringr::str_sub(slash_cap, 
                                                end=(nchar(slash_cap)/2))) %>%
    dplyr::mutate(out = paste0(half_slash, char_cap)) %>% 
    dplyr::distinct() %>% 
    dplyr::arrange(nchar(out))
  
  halfed_deparse <- qdap::mgsub(half_df$match, 
                                half_df$out, 
                                deparsed, 
                                order.pattern = FALSE)
  
  eval(parse(text=halfed_deparse))
}

#function to match text using 
get_match_list <- function(str, pattern, environ="base", ignore_case=TRUE, global=TRUE, perl=TRUE, fixed=FALSE) {
  # if (environ == "stringr") {
  #   if(fixed) {
  #     reg <- stringr::fixed(pattern, ignore_case = ignore_case)
  #     if(global){
  #       matches <- str_extract_all(str,reg)[[1]]
  #     }else{
  #       matches <- str_extract(str,reg)
  #     }
  #     if(length(matches)==0) return(NULL)
  #     match_list <- vector("list",length(matches)) %>% 
  #       purrr::set_names(matches)
  #   } else {
  #     reg <- stringr::regex(pattern, ignore_case = ignore_case)
  #     if(global) {
  #       match_mat  <- stringr::str_match_all(str, reg)[[1]]
  #     } else {
  #       match_mat  <- stringr::str_match(str, reg)
  #     }
  #     
  #     if(nrow(match_mat) == 0) return(NULL)
  #     
  #     match_list <- purrr::map(1:nrow(match_mat), ~match_mat[.x,-1]) %>% 
  #       purrr::set_names(match_mat[,1])
  #   }
  # } else if (environ == "base") {
    if(global) {
      matches_raw <- gregexpr(pattern, 
                              str,
                              fixed = fixed,
                              perl = perl,
                              ignore.case = ignore_case)[[1]]
      
      if(matches_raw==-1) return(NULL)
      
      matches <- regmatches(rep(str, length(matches_raw)),
                            matches_raw)
    } else {
      matches_raw <- regexpr(pattern, 
                             str,
                             fixed = fixed,
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
  # }
  
  match_list
}

html_format_match_list <- function(match_list, color_palette="Set2") {
  suppressWarnings(colors <- RColorBrewer::brewer.pal(100, color_palette))
  
  match_text <- paste0("<span style='background-color:", colors[1],"'>",
                       names(match_list),
                       "</span>%s")
  capture_text <- purrr::map_chr(match_list, function(.x){
    if (length(.x) > 0) {
      x_colors <- colors[2:(length(.x)+1)]
      paste0("<li><span style='background-color:", x_colors,"'>",
             .x,
             "</span></li>") %>% 
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


highlight_test_str <- function(str, pattern, environ="base", ignore_case=TRUE, global=TRUE, perl=TRUE, fixed=FALSE, color_palette="Set2"){
  suppressWarnings(colors <- RColorBrewer::brewer.pal(100, color_palette))
  if(global) {
    matches_raw <- gregexpr(pattern, 
                            str,
                            fixed = fixed,
                            perl = perl,
                            ignore.case = ignore_case)[[1]]
    
    if(matches_raw==-1) return(NULL)
    
    matches <- regmatches(rep(str, length(matches_raw)),
                          matches_raw)
  } else {
    matches_raw <- regexpr(pattern, 
                           str,
                           fixed = fixed,
                           perl = perl,
                           ignore.case = ignore_case)
    
    if(matches_raw==-1) return(NULL)
    
    matches <- regmatches(str, matches_raw)[[1]]
  }
  
  if (perl & !is.null(attr(matches_raw, "capture.start"))) {
    match_end      <- matches_raw + attr(matches_raw, "match.length") - 1
    capture_start  <- attr(matches_raw, "capture.start")
    capture_length <- attr(matches_raw, "capture.length")-1
    capture_end    <- capture_start + capture_length
    
    match_df <- data.frame(match_ind     = c(1:length(matches)),
                           match         = matches,
                           match_start   = rep(matches_raw, ncol(capture_end)),
                           match_end     = rep(match_end, ncol(capture_end)),
                           capture_ind   = rep(1:ncol(capture_end), each=nrow(capture_end)),
                           capture_start = as.numeric(capture_start),
                           capture_end   = as.numeric(capture_end),
                           stringsAsFactors = FALSE) %>% 
      dplyr::as_data_frame() %>% 
      dplyr::arrange(match_ind, capture_start) %>% 
      dplyr::mutate(capture_text = stringr::str_sub(str, capture_start, capture_end)) %>% 
      dplyr::mutate(in_match_cap_start = capture_start-(match_start-1)) %>% 
      dplyr::mutate(in_match_cap_end   = capture_end-(match_start-1)) %>% 
      dplyr::select(match, match_ind, match_start, match_end, capture_text, capture_ind, in_match_cap_start, in_match_cap_end) %>% 
      dplyr::distinct() %>% 
      dplyr::mutate(capture_text = paste0(capture_text,"_",capture_ind)) %>% 
      dplyr::group_by(match) %>% 
      dplyr::summarise_all(function(...) list(unique(...))) %>% 
      dplyr::ungroup()
    
    match_df$replacements <- map_chr(1:nrow(match_df), function(.x){
      txt <- match_df$match
      buffer <- 0
      for (i in 1:length(match_df$in_match_cap_start[[.x]])) {
        cap_txt <- str_match(match_df$capture_text[[.x]][i], "(.+)_\\d+")[,2]
        str_sub(txt, 
                match_df$in_match_cap_start[[.x]][i]+buffer,
                match_df$in_match_cap_end[[.x]][i]+buffer) <- "%s"
        replacement <- paste0("<span style='background-color:",colors[1+i],"'>",cap_txt,"</span>")
        txt <- sprintf(txt, replacement)
        buffer <- buffer + nchar(replacement)-nchar(cap_txt)
      }
      paste0("<span style='background-color:",colors[1],"'>",txt,"</span>")
    })
    
    match_df <- match_df %>% 
      dplyr::select(match_ind, match, replacements, match_start, match_end) %>% 
      unnest() %>% 
      distinct()
  } else {
    match_end      <- matches_raw + attr(matches_raw, "match.length") - 1
    
    match_df <- data.frame(match_ind        = c(1:length(matches)),
                           match            = matches,
                           match_start      = matches_raw,
                           match_end        = match_end,
                           stringsAsFactors = FALSE) %>% 
      mutate(replacements = paste0("<span style='background-color:",colors[1],"'>", match,"</span>"))
  }
  
  txt <- str
  buffer <- 0
  for (i in 1:nrow(match_df)) {
    str_sub(txt, 
            match_df$match_start[i]+buffer,
            match_df$match_end[i]+buffer) <- "%s"
    txt <- sprintf(txt, match_df$replacements[i])
    buffer <- buffer + nchar(match_df$replacements[i]) - nchar(match_df$match[i])
  }
  
  txt
}

