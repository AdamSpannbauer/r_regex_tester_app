context("try_default")


test_that("try_default basic", {
  add = function(a, b) a + b
  safe_add = regexTestR:::try_default(add, default = NULL, silent = TRUE)

  x = runif(1)
  y = runif(1)

  expect_equal(add(x, y), safe_add(x, y))
  expect_null(safe_add(1, "1"))
})


test_that("try_default change default", {
  add = function(a, b) a + b
  safe_add = regexTestR:::try_default(add, default = FALSE, silent = TRUE)

  expect_false(safe_add(1, "1"))
})
