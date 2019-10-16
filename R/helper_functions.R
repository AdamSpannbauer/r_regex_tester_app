#' Half slashes for regular expression matching
#' 
#' @param str regular expression string
#' @export 
half_slashes = function(str) {
  deparsed = deparse(str)
  
  half_df = data.table::as.data.table(stringr::str_match_all(deparsed, "(\\\\+)(.)")[[1]])
  data.table::setnames(half_df, c("match","slash_cap","char_cap"))
  half_df[, half_slash := stringr::str_sub(half_df$slash_cap, 
                                           end=(nchar(half_df$slash_cap)/2))]
  half_df[, out := paste0(half_df$half_slash, half_df$char_cap)]
  half_df = unique(half_df[order(nchar(half_df$out)), ])
  
  halfed_deparse = mgsub(half_df$match, 
                         half_df$out, 
                         deparsed, 
                         order.pattern = FALSE)
  
  eval(parse(text=halfed_deparse))
}
NULL

#' Function to match text using 
#' 
#' @param str Regular expression string
#' @param pattern Pattern to be matched
#' @param ignore_case Whether or not to ignore cases
#' @param global Whether the matches are global expression
#' @param perl Whether to use Perl or POSIX standard
#' @param fixed ...
#' 
#' @export
get_match_list = function(str, pattern, ignore_case=TRUE, global=TRUE, perl=TRUE, fixed=FALSE) {
    if(global) {
      matches_raw = gregexpr(pattern, 
                              str,
                              fixed = fixed,
                              perl = perl,
                              ignore.case = ignore_case)[[1]]
      
      suppressWarnings(if(matches_raw==-1) return(NULL))
      
      matches = regmatches(rep(str, length(matches_raw)),
                            matches_raw)
    } else {
      matches_raw = regexpr(pattern, 
                             str,
                             fixed = fixed,
                             perl = perl,
                             ignore.case = ignore_case)
      
      matches = regmatches(str, matches_raw)[[1]]
    }
    
    if (perl & !is.null(attr(matches_raw, "capture.start"))) {
      capture_start  = attr(matches_raw, "capture.start")
      capture_length = attr(matches_raw, "capture.length")-1
      capture_end    = capture_start + capture_length
      
      match_df = data.table::data.table(match_ind = c(1:length(matches)),
                                        match     = matches,
                                        starts    = as.numeric(capture_start),
                                        ends      = as.numeric(capture_end))
      match_df = match_df[order(match_df$match_ind, match_df$starts),]
      match_df[, capture_text := stringr::str_sub(str, match_df$starts, match_df$ends)]
      
      match_list = split(match_df$capture_text, paste0(match_df$match_ind, "_", match_df$match))
      names(match_list) = gsub("^\\d+_", "", names(match_list))
    } else {
      match_list = lapply(1:length(matches), function(x) character(0))
      names(match_list) = matches
    }
  
  return(match_list)
}
NULL

#' Function to format matched list
#' 
#' @param match_list Matched list
#' @param color_palette Color pallete to be used for displaying matches
#' 
#' @export
html_format_match_list = function(match_list, color_palette="Set2") {
  suppressWarnings({colors = RColorBrewer::brewer.pal(100, color_palette)})
  
  match_text = paste0("<span style='background-color:", colors[1],"'>",
                      stringr::str_replace_all(names(match_list), "\\s", "&nbsp;"),
                      "</span>%s")
  
  capture_text = vapply(match_list, function(x){
    if (length(x) > 0) {
      x_colors = colors[2:(length(x)+1)]
      list_elemes = paste0("<li><span style='background-color:", x_colors,"'>",
                           stringr::str_replace_all(x, "\\s", "&nbsp;"),
                           "</span></li>")
      collapsed_list_elems = paste(list_elemes, collapse="<br>")
      paste("<ul>", collapsed_list_elems, "</ul>")
    } else {
      ""
    }
  }, character(1))
  
  html_match_lists = purrr::map2_chr(match_text, capture_text, ~sprintf(.x, .y))
  collapsed_html_match_lists = paste0(html_match_lists, collapse="</li><br><li>")
  
  paste0("<h4>Matched & Captured Text</h4><ol><li>", 
         collapsed_html_match_lists,
         "</li></ol>")
}
NULL


#' Function to highlight test string
#' 
#' @param str Regular expression string
#' @param pattern Pattern to be matched 
#' @param ignore_case Whether or not to ignore cases
#' @param global Whether the matches are global expression
#' @param perl Whether to use Perl or POSIX standard
#' @param fixed ...
#' @param color_palette Color pallete to be used for highlighing test string
#' 
#' @export
highlight_test_str = function(str, pattern, ignore_case=TRUE, global=TRUE, perl=TRUE, fixed=FALSE, color_palette="Set2"){
  suppressWarnings({colors = RColorBrewer::brewer.pal(100, color_palette)})
  if(global) {
    matches_raw = gregexpr(pattern, 
                            str,
                            fixed = fixed,
                            perl = perl,
                            ignore.case = ignore_case)[[1]]
    
    suppressWarnings(if(matches_raw==-1) return(NULL))
    
    matches = regmatches(rep(str, length(matches_raw)),
                          matches_raw)
  } else {
    matches_raw = regexpr(pattern, 
                           str,
                           fixed = fixed,
                           perl = perl,
                           ignore.case = ignore_case)
    
    suppressWarnings(if(matches_raw==-1) return(NULL))
    
    matches = regmatches(str, matches_raw)[[1]]
  }
  
  if (perl & !is.null(attr(matches_raw, "capture.start"))) {
    match_end      = matches_raw + attr(matches_raw, "match.length") - 1
    capture_start  = attr(matches_raw, "capture.start")
    capture_length = attr(matches_raw, "capture.length")-1
    capture_end    = capture_start + capture_length
    
    match_df = data.table::data.table(match_ind     = c(1:length(matches)),
                                      match         = matches,
                                      match_start   = rep(matches_raw, ncol(capture_end)),
                                      match_end     = rep(match_end, ncol(capture_end)),
                                      capture_ind   = rep(1:ncol(capture_end), each=nrow(capture_end)),
                                      capture_start = as.numeric(capture_start),
                                      capture_end   = as.numeric(capture_end))
    match_df = match_df[order(match_df$match_ind, capture_start),]
    match_df[, capture_text := stringr::str_sub(str, capture_start, capture_end)]
    match_df[, in_match_cap_start := capture_start-(match_start-1)]
    match_df[, in_match_cap_end   := capture_end-(match_start-1)]
    match_df = unique(match_df[, .(match, match_df$match_ind, match_start, match_end, capture_text, capture_ind, in_match_cap_start, in_match_cap_end)])
    match_df[, capture_text := paste0(capture_text,"_",capture_ind)]
    match_df = match_df[, lapply(.SD, function(...) list(unique(...))), by=match]
    
    match_df$replacements = vapply(1:nrow(match_df), function(.x){
      txt = match_df$match
      buffer = 0
      for (i in 1:length(match_df$in_match_cap_start[[.x]])) {
        cap_txt = stringr::str_match(match_df$capture_text[[.x]][i], "(.+)_\\d+")[,2]
        if (match_df$in_match_cap_start[[.x]][i]+buffer <= nchar(txt) &
            match_df$in_match_cap_end[[.x]][i]+buffer <= nchar(txt)) {
          stringr::str_sub(txt, 
                           match_df$in_match_cap_start[[.x]][i]+buffer,
                           match_df$in_match_cap_end[[.x]][i]+buffer) = "%s"
          replacement = paste0("<span style='background-color:",colors[1+i],"'>",cap_txt,"</span>")
          txt = sprintf(txt, replacement)
          buffer = buffer + nchar(replacement)-nchar(cap_txt)
        }
      }
      paste0("<span style='background-color:",colors[1],"'>",txt,"</span>")
    }, character(1))
    
    match_df = tidyr::unnest(match_df[,.(match_df$match_ind, match, replacements, 
                                         match_start, match_end)])
    match_df = unique(match_df)
  } else {
    match_end = matches_raw + attr(matches_raw, "match.length") - 1
    
    match_df = data.table::data.table(match_ind        = c(1:length(matches)),
                                      match            = matches,
                                      match_start      = matches_raw,
                                      match_end        = match_end) 
    match_df[, replacements := paste0("<span style='background-color:",colors[1],"'>", match,"</span>")]
  }
  
  txt = str
  buffer = 0
  for (i in 1:nrow(match_df)) {
    str_sub(txt, 
            match_df$match_start[i]+buffer,
            match_df$match_end[i]+buffer) = "%s"
    txt = sprintf(txt, match_df$replacements[i])
    buffer = buffer + nchar(match_df$replacements[i]) - nchar(match_df$match[i])
  }
  
  txt
}
NULL



#' Function to substitute test string
#' 
#' @param pattern Pattern to be matched 
#' @param replacement Replacement 
#' @param text.var ...
#' @param leadspace ...
#' @param trailspace ...
#' @param fixed ...
#' @param trim ...
#' @param order.pattern ...
#' @param ... ...
#' 
#' @export
mgsub = function (pattern, replacement, text.var, leadspace = FALSE, trailspace = FALSE, 
                  fixed = TRUE, trim = TRUE, order.pattern = fixed, ...) {
  if (leadspace | trailspace)
    replacement <- spaste(replacement, trailing = trailspace, leading = leadspace)
  
  if (fixed && order.pattern) {
    ord <- rev(order(nchar(pattern)))
    pattern <- pattern[ord]
    if (length(replacement) != 1)
      replacement <- replacement[ord]
  }
  if (length(replacement) == 1)
    replacement <- rep(replacement, length(pattern))
  
  for (i in seq_along(pattern)) {
    text.var <- gsub(pattern[i], replacement[i], text.var, fixed = fixed, ...)
  }
  
  if (trim)
    text.var <-
      gsub("\\s+", " ", gsub("^\\s+|\\s+$", "", text.var, perl = TRUE), perl = TRUE)
  text.var
}
NULL