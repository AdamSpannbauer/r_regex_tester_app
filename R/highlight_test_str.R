highlight_test_str <- function(str, pattern, ignore_case = TRUE,
                               global = TRUE, perl = TRUE, fixed = FALSE,
                               color_palette = "Set3") {
  #' Highlight regex matches in output display with HTML
  #'
  #' @param str string to find matches in
  #' @param pattern pattern to match in str
  #' @param ignore_case see ?gsub
  #' @param global see ?gsub
  #' @param perl see ?gsub
  #' @param fixed see ?gsub
  #' @param color_palette RColorBrewer palette name for highlighting colors
  #'
  #' @return HTML string to be rendered with shiny::HTML()
  #' @keywords internal
  #' @noRd
  #' @importFrom data.table := .SD

  # Satisfy global variable check issues w/o globalVariables
  # These are col names used in NSE data.table expressions
  match_start <- NULL
  match_ind <- NULL
  capture_text <- NULL
  capture_ind <- NULL
  in_match_cap_start <- NULL
  in_match_cap_end <- NULL
  replacements <- NULL

  suppressWarnings({
    colors <- RColorBrewer::brewer.pal(100, color_palette)
  })

  if (global) {
    matches_raw <- gregexpr(pattern,
      str,
      fixed = fixed,
      perl = perl & !fixed,
      ignore.case = ignore_case & !fixed
    )[[1]]

    if (all(matches_raw == -1)) {
      return(NULL)
    }

    matches <- regmatches(
      rep(str, length(matches_raw)),
      matches_raw
    )
  } else {
    matches_raw <- regexpr(pattern,
      str,
      fixed = fixed,
      perl = perl & !fixed,
      ignore.case = ignore_case & !fixed
    )

    if (all(matches_raw == -1)) {
      return(NULL)
    }

    matches <- regmatches(str, matches_raw)[[1]]
  }

  if (perl & !is.null(attr(matches_raw, "capture.start"))) {
    match_end <- matches_raw + attr(matches_raw, "match.length") - 1
    capture_start <- attr(matches_raw, "capture.start")
    capture_length <- attr(matches_raw, "capture.length") - 1
    capture_end <- capture_start + capture_length

    match_df <- data.table::data.table(
      match_ind     = c(seq_len(length(matches))),
      match         = matches,
      match_start   = rep(matches_raw, ncol(capture_end)),
      match_end     = rep(match_end, ncol(capture_end)),
      capture_ind   = rep(seq_len(ncol(capture_end)), each = nrow(capture_end)),
      capture_start = as.numeric(capture_start),
      capture_end   = as.numeric(capture_end)
    )

    match_df <- match_df[order(match_ind, capture_start), ]
    match_df[, capture_text := stringr::str_sub(
      str, capture_start, capture_end
    )]
    match_df[, in_match_cap_start := capture_start - (match_start - 1)]
    match_df[, in_match_cap_end := capture_end - (match_start - 1)]
    match_df <- unique(
      match_df[
        ,
        list(
          match, match_ind, match_start, match_end,
          capture_text, capture_ind, in_match_cap_start,
          in_match_cap_end
        )
      ]
    )
    match_df[, capture_text := paste0(capture_text, "_", capture_ind)]
    match_df <- match_df[, lapply(
      .SD, function(...) list(unique(...))
    ), by = match]

    match_df$replacements <- vapply(seq_len(nrow(match_df)), function(.x) {
      txt <- match_df$match[.x]
      buffer <- 0
      for (i in seq_len(length(match_df$in_match_cap_start[[.x]]))) {
        cap_txt <- stringr::str_match(
          match_df$capture_text[[.x]][i],
          "(.+)_\\d+"
        )[, 2]

        if (match_df$in_match_cap_start[[.x]][i] + buffer <= nchar(txt) &
          match_df$in_match_cap_end[[.x]][i] + buffer <= nchar(txt)) {
          stringr::str_sub(
            txt,
            match_df$in_match_cap_start[[.x]][i] + buffer,
            match_df$in_match_cap_end[[.x]][i] + buffer
          ) <- "%s"
          replacement <- paste0(
            "<span style='background-color:", colors[1 + i], "'>",
            cap_txt,
            "</span>"
          )
          txt <- sprintf(txt, replacement)
          buffer <- buffer + nchar(replacement) - nchar(cap_txt)
        }
      }
      paste0(
        "<span style='background-color:", colors[1], "'>",
        txt,
        "</span>"
      )
    }, character(1))

    match_df <- tidyr::unnest(match_df[, list(
      match_ind, match, replacements,
      match_start, match_end
    )],
    cols = c(match_ind, match_start, match_end)
    )
    match_df <- unique(match_df)

    # modifying string in place using indices
    # work back to front to avoid disrupting indices
    match_df <- data.table::data.table(match_df)
    match_df <- match_df[order(match_ind, decreasing = TRUE), ]
  } else {
    match_end <- matches_raw + attr(matches_raw, "match.length") - 1

    match_df <- data.table::data.table(
      match_ind = seq_len(length(matches)),
      match = matches,
      match_start = matches_raw,
      match_end = match_end
    )
    match_df[, replacements := paste0(
      "<span style='background-color:", colors[1], "'>",
      match,
      "</span>"
    )]

    # modifying string in place using indices
    # work back to front to avoid disrupting indices
    match_df = match_df[order(match_ind, decreasing = TRUE), ]
  }

  txt <- str
  for (i in seq_len(nrow(match_df))) {
    stringr::str_sub(
      txt,
      match_df$match_start[i],
      match_df$match_end[i]
    ) <- "%s"
    txt <- sprintf(txt, match_df$replacements[i])
  }

  txt
}
