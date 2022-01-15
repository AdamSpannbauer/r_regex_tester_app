half_slashes <- function(str, exclude = character(0)) {
  #' Given a string, remove half of the escaping backslashes
  #'
  #' @param str A string to remove backslashes from
  #' @param exclude A character vector of items to exclude from processing
  #'
  #' @return A version of the input string with half of the escaping chars
  #' @keywords internal
  #' @noRd
  #' @importFrom data.table :=
  #'
  #' @details An exception will be thrown if removing slashes leads to a parsing
  #'         error.  For example, "\\" will be converted to "\" which is not
  #'         a valid string.
  #'

  # Satisfy global variable check issues w/o globalVariables
  # These are col names used in NSE data.table expressions
  half_slash <- NULL
  slash_cap <- NULL
  out <- NULL
  char_cap <- NULL

  deparsed <- deparse(str)

  half_df <- data.table::as.data.table(
    stringr::str_match_all(deparsed, "(\\\\)(.)")[[1]]
  )

  data.table::setnames(half_df, c("match", "slash_cap", "char_cap"))
  half_df[, half_slash := stringr::str_sub(slash_cap,
    end = (nchar(slash_cap) / 2)
  )]
  half_df[, out := paste0(half_slash, char_cap)]
  half_df <- unique(half_df[order(nchar(out)), ])

  # Removing slashes before double quotes breaks eval
  half_df <- half_df[char_cap != '"']

  # Dirty fix for new lines...
  for (x in exclude) {
    half_df[match == x, out := x]
  }

  halfed_deparse <- mgsub(
    half_df$match,
    half_df$out,
    deparsed
  )

  eval(parse(text = halfed_deparse))
}
