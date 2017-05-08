#explainnnnnnn
library(magrittr)
split_vec <- function(vec, splits) split(vec, cumsum(seq_along(vec) %in% (splits)))

regexplain <- function(regx) {
  # regx <- '\\s+\\s+'
  base_url <- "http://rick.measham.id.au/paste/explain?regex="
  regx_url <- URLencode(regx) %>% 
    stringr::str_replace_all(stringr::fixed("+"), "%2B") %>% 
    stringr::str_replace_all(fixed('[[:blank:]]'), '[:blank:]')
  
  full_url <- paste0(base_url, regx_url)
  
  regexplain_tbl_txt <- xml2::read_html(full_url) %>% 
    rvest::html_node("pre") %>% 
    rvest::html_text() %>% 
    trimws() %>% 
    stringr::str_split("\n") %>% 
    .[[1]]
  
  row_breaker <- "--------------------------------------------------------------------------------"
  
  regexplain_tbl_txt <- 
    regexplain_tbl_txt[regexplain_tbl_txt != row_breaker] %>% 
    trimws()
  
  split_rows <- stringr::str_split(regexplain_tbl_txt, 
                                   stringr::regex("\\s{2,}"))
  
  headers <- split_rows[[1]]
  
  rows <- split_rows[-1]
  
  good_inds      <- which(purrr::map_int(rows, length) != 1)
  
  clean_row_list <- split_vec(rows, good_inds) %>% 
    purrr::map(unlist) %>% 
    purrr::map(~c(.x[1], paste(.x[-1], collapse=" ")) %>% 
                 trimws()) %>% 
    magrittr::set_names(paste0("node_", seq_along(.)))
  # clean_row_list
  explain_df <- do.call('rbind', clean_row_list) %>%
    dplyr::as_data_frame() %>%
    magrittr::set_names(c("regex","explanation"))
  
  if(stringr::str_detect(regx, fixed('[[:blank:]]')) & 
     any(stringr::str_detect(explain_df$regex,fixed('[:blank:]')))) {
    blank_inds <- which(explain_df$regex == '[:blank:]')
    explain_df$regex[blank_inds] <- '[[:blank:]]'
    explain_df$explanation[blank_inds] <- 'any character of: blank characters (space and tab, and possibly other locale-dependent characters such as non-breaking space)'
  }
  
  explain_df
}

View(regexplain("\\s+.[[:blank:]][[:alpha:]]"))
