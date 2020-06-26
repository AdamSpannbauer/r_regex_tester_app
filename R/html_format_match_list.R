html_format_match_list = function(match_list, color_palette = "Set3") {
  #' Create HTML component to show list of items matched by pattern in test str
  #'
  #' @param match_list output of get_match_list()
  #' @param color_palette RColorBrewer palette name for highlighting colors
  #'
  #' @return HTML string to be rendered with shiny::HTML()
  #' @keywords internal
  #' @noRd

  suppressWarnings({
    colors = RColorBrewer::brewer.pal(100, color_palette)
  })

  match_text = paste0(
    "<span style='background-color:", colors[1], "'>",
    stringr::str_replace_all(names(match_list), "\\s", "&nbsp;"),
    "</span>%s"
  )

  capture_text = vapply(match_list, function(x) {
    if (length(x) > 0) {
      x_colors = colors[2:(length(x) + 1)]
      list_elemes = paste0(
        "<li><span style='background-color:", x_colors, "'>",
        stringr::str_replace_all(x, "\\s", "&nbsp;"),
        "</span></li>"
      )
      collapsed_list_elems = paste(list_elemes, collapse = "<br>")
      paste("<ul>", collapsed_list_elems, "</ul>")
    } else {
      ""
    }
  }, character(1))

  html_match_lists = purrr::map2_chr(
    match_text, capture_text, ~sprintf(.x, .y)
  )
  collapsed_html_match_lists = paste0(
    html_match_lists, collapse = "</li><br><li>"
  )

  paste0("<h4>Matched & Captured Text</h4><ol><li>",
         collapsed_html_match_lists,
         "</li></ol>")
}
