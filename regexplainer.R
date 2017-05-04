#explainnnnnnn

regexplain <- function(regx) {
  base_url <- "http://rick.measham.id.au/paste/explain?regex="
  regx_url <- URLencode(regx) %>% 
    stringr::str_replace_all(stringr::fixed("+"), "%2B")
  
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
  
  purrr::map_int(rows, length)
}

