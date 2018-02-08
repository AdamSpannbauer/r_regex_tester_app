library(data.table)

half_slashes = function(str) {
  deparsed = deparse(str)
  
  half_df = data.table::as.data.table(stringr::str_match_all(deparsed, "(\\\\+)(.)")[[1]])
  data.table::setnames(half_df, c("match","slash_cap","char_cap"))
  half_df[, half_slash := stringr::str_sub(slash_cap, 
                                           end=(nchar(slash_cap)/2))]
  half_df[, out := paste0(half_slash, char_cap)]
  half_df = unique(half_df[order(nchar(out)), ])
  
  halfed_deparse = qdap::mgsub(half_df$match, 
                                half_df$out, 
                                deparsed, 
                                order.pattern = FALSE)
  
  eval(parse(text=halfed_deparse))
}

#function to match text using 
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
      match_df = match_df[order(match_ind, starts),]
      match_df[, capture_text := stringr::str_sub(str, starts, ends)]
      
      match_list = split(match_df$capture_text, paste0(match_df$match_ind, "_", match_df$match))
      names(match_list) = gsub("^\\d+_", "", names(match_list))
    } else {
      match_list = lapply(1:length(matches), function(x) character(0))
      names(match_list) = matches
    }
  
  return(match_list)
}

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
    match_df = match_df[order(match_ind, capture_start),]
    match_df[, capture_text := stringr::str_sub(str, capture_start, capture_end)]
    match_df[, in_match_cap_start := capture_start]
    match_df[, in_match_cap_end   := capture_end]
    match_df = unique(match_df[, .(match, match_ind, match_start, match_end, capture_text, capture_ind, in_match_cap_start, in_match_cap_end)])
    
    for(n in 1:nrow(match_df)){
      match_df$height[n] = sum(match_df[-n]$in_match_cap_start >= match_df[n]$in_match_cap_start & match_df[-n]$in_match_cap_end <= match_df[n]$in_match_cap_end)*0.1
    }
    
    match_df = match_df[order(height),]
    match_df$match[1] = str

    for(.x in 1:nrow(match_df)){
      tstart = match_df$in_match_cap_start[.x]
      tend = match_df$in_match_cap_end[.x]
      txt = match_df$match[1]
      span_start = sprintf("<span style='border:3px; border-style:solid; border-color:%s; padding: %fem;'>",colors[.x],match_df$height[.x])
      txt = paste0(substr(txt,0,tstart-1),
             span_start,
             substr(txt,tstart,tend),
             "</span>",
             substr(txt,tend+1,nchar(txt)))
      for(j in 1:nrow(match_df)){
        if(j == .x) next
        jstart = match_df$in_match_cap_start[j]
        jend = match_df$in_match_cap_end[j]
        ep = 0
        sp = 0
        nss = nchar(span_start)
        if(jstart > tend){
          ep = nss + 7
          sp = nss + 7
        } else if(jstart > tstart & jend > tend){
          sp = nss
          ep = nss + 7
        } else if(jstart <= tstart & jend > tend){
          sp = 0
          ep = nss+7
        } else if(jstart <= tstart & jend <= tend & jend >= tstart){
          sp = 0
          ep = nss
        }
        match_df$in_match_cap_start[j] = match_df$in_match_cap_start[j] + sp
        match_df$in_match_cap_end[j] = match_df$in_match_cap_end[j] + ep
      }
      match_df$match[1] = txt
    }
    txt = match_df$match[1]
  } else {
    match_end = matches_raw + attr(matches_raw, "match.length") - 1
    
    match_df = data.table::data.table(match_ind        = c(1:length(matches)),
                                      match            = matches,
                                      match_start      = matches_raw,
                                      match_end        = match_end) 
    match_df[, replacements := paste0("<span style='background-color:",colors[1],"'>", match,"</span>")]
    
    txt = str
    buffer = 0
    for (i in 1:nrow(match_df)) {
      str_sub(txt, 
              match_df$match_start[i]+buffer,
              match_df$match_end[i]+buffer) = "%s"
      txt = sprintf(txt, match_df$replacements[i])
      buffer = buffer + nchar(match_df$replacements[i]) - nchar(match_df$match[i])
    }
  }
  return(txt)
}

