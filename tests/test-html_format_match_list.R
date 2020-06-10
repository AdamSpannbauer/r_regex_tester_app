context("html_format_match_list")


test_that("html_format_match_list basic", {
  match_list = regexTestR:::get_match_list("abc aaa", "a(..)")
  test_result = regexTestR:::html_format_match_list(match_list)
  expected = paste0(
    "<h4>Matched & Captured Text</h4>",
    "<ol>",
      "<li>",
        "<span style='background-color:#8DD3C7'>abc</span>",
        "<ul>",
          " <li><span style='background-color:#FFFFB3'>bc</span></li> ",
        "</ul>",
      "</li>",
      "<br>",
      "<li>",
        "<span style='background-color:#8DD3C7'>aaa</span>",
        "<ul>",
          " <li><span style='background-color:#FFFFB3'>aa</span></li> ",
        "</ul>",
      "</li>",
    "</ol>"
  )

  expect_equal(test_result, expected)
})
