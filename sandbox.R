
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

test <- "\\w"

half_slash <- str_replace(deparse(test), regex("\\\\"), regex("\\"))
eval(parse(text=half_slash))

tmp <- tempfile()
writeLines(test, tmp)
scan(tmp, allowEscapes = F, what = "character")


half_slash <- function(){}

pattern <- "\\\\w"
pattern <- "\\w test\\\\w"

deparsed <- deparse(pattern)

half_df <- str_match_all(deparsed, "(\\\\+)(.)")[[1]] %>% 
  as_data_frame() %>% 
  set_names(c("match","slash_cap","char_cap")) %>% 
  mutate(half_slash = str_sub(slash_cap, end=(nchar(slash_cap)/2))) %>%
  mutate(out = paste0(half_slash, char_cap)) %>% 
  distinct() %>% 
  arrange(nchar(out))

halfed_deparse <- qdap::mgsub(half_df$match, 
                              half_df$out, 
                              deparsed, 
                              order.pattern = FALSE)

eval(parse(text=halfed_deparse))




str <- "test testing"
pattern <- "t(es)(t)"
color_palette <- "Set2"
suppressWarnings(colors <- RColorBrewer::brewer.pal(nchar(str), color_palette))
match_list <- get_match_list(str,pattern)
if(!is.null(match_list)) {
  match_mat <- do.call(rbind, match_list)
  
  match_df <- bind_cols(data_frame(pattern=pattern,
                                   match = rownames(match_mat)),
            as_data_frame(match_mat)) %>% 
    distinct()
  
  replacements <- apply(match_df, 1, function(.x){
    captures <- length(.x) - 2
    
    paste0("<font style='color:",
           colors[2:(captures+1)],
           ">\\",1:captures,"</font>") %>% 
      paste(collapse="")
    
    paste0("<font style='color:",
           colors[1:length(.x)],
           "'>", .x,"</font>")
    }) %>% 
    as.character()
  
  ncol(match_df)-1
  
  mgsub(as.character(match_df[1,]), replacements, match_df$match)
}

highlight_patterns <- c(names(match_list), unlist(match_list)) %>% 
  unique()
highlight_replacements <- paste0("<font style='color:",
                                 colors[1:length(highlight_patterns)],
                                 "'>", highlight_patterns,"</font>")
mgsub(highlight_patterns, highlight_replacements, str)


if(matches_raw==-1) return(NULL)
matches_raw <- gregexpr(pattern,str,perl=T)[[1]]

matches <- regmatches(rep(str, length(matches_raw)),
                      matches_raw)

match_end      <- matches_raw + attr(matches_raw, "match.length")
capture_start  <- attr(matches_raw, "capture.start")
capture_length <- attr(matches_raw, "capture.length")-1
capture_end    <- capture_start + capture_length

match_df <- data.frame(match_ind     = rep(c(1:length(matches)), ncol(capture_end)),
                       match         = rep(matches, ncol(capture_end)),
                       match_start   = rep(matches_raw, ncol(capture_end)),
                       match_end     = rep(match_end, ncol(capture_end)),
                       capture_ind   = rep(1:ncol(capture_end), each=ncol(capture_end)),
                       capture_start = as.numeric(capture_start),
                       capture_end   = as.numeric(capture_end),
                       stringsAsFactors = FALSE) %>% 
  dplyr::as_data_frame() %>% 
  dplyr::arrange(match_ind, capture_start) %>% 
  dplyr::mutate(capture_text = stringr::str_sub(str, capture_start, capture_end)) %>% 
  dplyr::mutate(in_match_cap_start = capture_start-(match_start-1)) %>% 
  dplyr::mutate(in_match_cap_end   = capture_end-(match_start-1)) %>% 
  dplyr::select(match, capture_text, in_match_cap_start, in_match_cap_end) %>% 
  dplyr::distinct() %>% 
  dplyr::group_by(match) %>% 
  dplyr::summarise_all(list)

map(1:nrow(match_df), function(.x){
  txt <- match_df$match
  buffer <- 0
  for (i in 1:length(match_df$in_match_cap_start[[.x]])) {
    str_sub(txt, 
            match_df$in_match_cap_start[[.x]][i]+buffer,
            match_df$in_match_cap_end[[.x]][i]+buffer) <- "%s"
    replacement <- paste0("<font style='color:",colors[1+i],"'>",match_df$capture_text[[1]][i],"</font>")
    txt <- sprintf(txt, replacement)
    buffer <- nchar(replacement) - nchar(match_df$capture_text[[.x]][i])
  }
  paste0("<font style='color:",colors[1],"'>",txt,"</font>")
})

testmatch_df$in_match_cap_start
