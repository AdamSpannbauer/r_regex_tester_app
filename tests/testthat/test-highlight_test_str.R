context("highlight_test_str")


test_that("highlight_test_str basic", {
  test_result <- regexTestR:::highlight_test_str("abc aaa", "a(..)")
  expected <- paste0(
    "<span style='background-color:#8DD3C7'>a",
    "<span style='background-color:#FFFFB3'>bc</span></span>",
    " <span style='background-color:#8DD3C7'>a",
    "<span style='background-color:#FFFFB3'>aa</span></span>"
  )

  expect_equal(test_result, expected)
})


test_that("welcome screen example", {
  test_result <- regexTestR:::highlight_test_str("This is a test string for testing regex.", "t(es)(t)")
  expected <- paste0(
    "This is a <span style='background-color:#8DD3C7'>t",
    "<span style='background-color:#FFFFB3'>es</span>",
    "<span style='background-color:#BEBADA'>t</span></span>",
    " string for <span style='background-color:#8DD3C7'>t",
    "<span style='background-color:#FFFFB3'>es</span>",
    "<span style='background-color:#BEBADA'>t</span></span>ing regex."
  )

  expect_equal(test_result, expected)
})


test_that("highlight_test_str perl = FALSE", {
  test_result <- regexTestR:::highlight_test_str("abc aaa", "a(..)", perl = FALSE)
  expected <- paste0(
    "<span style='background-color:#8DD3C7'>abc</span> ",
    "<span style='background-color:#8DD3C7'>aaa</span>"
  )

  expect_equal(test_result, expected)
})


test_that("highlight_test_str global = FALSE", {
  test_result <- regexTestR:::highlight_test_str("abc aaa", "a(..)", global = FALSE)
  expected <- paste0(
    "<span style='background-color:#8DD3C7'>a",
    "<span style='background-color:#FFFFB3'>bc</span></span>",
    " aaa"
  )

  expect_equal(test_result, expected)
})


test_that("highlight_test_str no matches", {
  test_result <- regexTestR:::highlight_test_str("aaa", "abc")
  expect_null(test_result)
})
