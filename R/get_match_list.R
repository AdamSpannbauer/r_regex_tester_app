get_match_list = function(str, pattern, ignore_case=TRUE,
                          global=TRUE, perl=TRUE, fixed=FALSE) {
  #' Return list of pattern matches and captured text
  #'
  #' @param str string to apply regex to
  #' @param pattern regex to search for in str
  #' @param ignore_case see ?gsub
  #' @param global see ?gsub
  #' @param perl see ?gsub
  #' @param fixed see ?gsub
  #'
  #' @return a list with names as matched text and elements as
  #'         character vectors of matched text
  #' @keywords internal
  #' @importFrom data.table :=
  #'
  #' @examples
  #' # get_match_list('abc aaa abc acdc', 'a(.)(.)')
  #'
  #' # list(abc = c("b", "c"),
  #' #      aaa = c("a", "a"),
  #' #      abc = c("b", "c"),
  #' #      acd = c("c", "d"))

  # Satisfy global variable check issues w/o globalVariables
  # These are col names used in NSE data.table expressions
  match_ind = NULL
  starts = NULL
  ends = NULL
  capture_text = NULL

  if (global) {
    matches_raw = gregexpr(pattern,
                           str,
                           fixed = fixed,
                           perl = perl,
                           ignore.case = ignore_case)[[1]]

    suppressWarnings(if (matches_raw == -1) return(NULL))

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
    capture_length = attr(matches_raw, "capture.length") - 1
    capture_end    = capture_start + capture_length

    match_df = data.table::data.table(match_ind = c(seq_len(length(matches))),
                                      match     = matches,
                                      starts    = as.numeric(capture_start),
                                      ends      = as.numeric(capture_end))
    match_df = match_df[order(match_ind, starts), ]
    match_df[, capture_text := stringr::str_sub(str, starts, ends)]

    match_list = split(
      match_df$capture_text,
      paste0(match_df$match_ind, "_", match_df$match)
    )

    names(match_list) = gsub("^\\d+_", "", names(match_list))
  } else {
    match_list = lapply(seq_len(length(matches)), function(x) character(0))
    names(match_list) = matches
  }

  return(match_list)
}
