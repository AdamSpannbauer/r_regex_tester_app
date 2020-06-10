context("get_match_list")


test_that("get_match_list basic", {
  test_result = regexTestR:::get_match_list("abc aaa", "a(..)")
  expected = list("abc" = "bc", "aaa" = "aa")

  expect_equal(test_result, expected)
})


test_that("get_match_list perl = FALSE", {
  test_result = regexTestR:::get_match_list("abc aaa", "a(..)", perl = FALSE)
  expected = list("abc" = character(0), "aaa" = character(0))

  expect_equal(test_result, expected)
})


test_that("get_match_list global = FALSE", {
  test_result = regexTestR:::get_match_list("abc aaa", "a(..)", global = FALSE)
  expected = list("abc" = "bc")

  expect_equal(test_result, expected)
})


test_that("get_match_list no matches", {
  test_result = regexTestR:::get_match_list("aaa", "abc")
  expect_null(test_result)
})
