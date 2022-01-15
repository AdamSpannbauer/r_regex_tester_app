context("half_slashes")


test_that("half_slashes basic", {
  n_reps <- sample(1:10, size = 1)

  test_str <- paste(rep("\\", 2 * n_reps), collapse = "")
  expected <- paste(rep("\\", n_reps), collapse = "")

  test_result <- regexTestR:::half_slashes(test_str)

  expect_equal(test_result, expected)
})


test_that("half_slashes exclude", {
  test_str <- "\\\n\\\t"
  expected <- "\\n\\t"

  test_result <- regexTestR:::half_slashes(test_str, exclude = c("\\n", "\\t"))

  expect_equal(test_result, expected)
})
