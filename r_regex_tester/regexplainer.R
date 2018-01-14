#explainnnnnnn
split_vec = function(vec, splits) split(vec, cumsum(seq_along(vec) %in% (splits)))

regexplain = function(regx) {
  # regx = '\\s+\\s+'
  base_url = "http://rick.measham.id.au/paste/explain?regex="
  
  regx_url = stringr::str_replace_all(URLencode(regx), stringr::fixed("+"), "%2B")
  regx_url = stringr::str_replace_all(regx_url, fixed('[[:blank:]]'), '[:blank:]')
  regx_url = stringr::str_replace_all(regx_url, fixed('[%5E[:blank:]]'), '[%5E:blank:]')
  
  full_url = paste0(base_url, regx_url)
  
  page_html = xml2::read_html(full_url)
  regexplain_tbl_txt = rvest::html_text(rvest::html_node(page_html, "pre"))
  regexplain_tbl_txt = stringr::str_split(trimws(regexplain_tbl_txt), "\n")[[1]]
  
  row_breaker = "--------------------------------------------------------------------------------"
  
  regexplain_tbl_txt = trimws(regexplain_tbl_txt[regexplain_tbl_txt != row_breaker])
  
  split_rows = stringr::str_split(regexplain_tbl_txt, stringr::regex("\\s{2,}"))
  
  headers = split_rows[[1]]
  rows = split_rows[-1]
  
  good_inds = which(vapply(rows, length, numeric(1)) != 1)
  
  clean_row_list = lapply(split_vec(rows, good_inds), unlist)
  clean_row_list = lapply(clean_row_list, function(x) trimws(c(x[1], paste(x[-1], collapse=" "))))
  names(clean_row_list) = paste0("node_", seq_along(clean_row_list))

  explain_df = data.table::as.data.table(do.call('rbind', clean_row_list))
  data.table::setnames(explain_df, c("regex","explanation"))
  
  if(stringr::str_detect(regx, fixed('[[:blank:]]')) & 
     any(stringr::str_detect(explain_df$regex,fixed('[:blank:]')))) {
    blank_inds = which(explain_df$regex == '[:blank:]')
    explain_df$regex[blank_inds] = '[[:blank:]]'
    explain_df$explanation[blank_inds] = 'any character of: blank characters (space and tab, and possibly other locale-dependent characters such as non-breaking space)'
  }
  if(stringr::str_detect(regx, fixed('[^[:blank:]]')) & 
     any(stringr::str_detect(explain_df$regex,fixed('[^:blank:]')))) {
    blank_inds = which(explain_df$regex == '[^:blank:]')
    explain_df$regex[blank_inds] = '[^[:blank:]]'
    explain_df$explanation[blank_inds] = 'any character except: blank characters (space and tab, and possibly other locale-dependent characters such as non-breaking space)'
  }
  
  explain_df
}

# View(regexplain("test\\s+.[^[:blank:]][[:alpha:]]"))
