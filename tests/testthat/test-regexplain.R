context("regexlpain")


test_that("split_vec", {
  test_result = regexTestR:::split_vec(1:10, c(2, 5, 8))
  expected = list(
    `0` = 1L,
    `1` = 2:4,
    `2` = 5:7,
    `3` = 8:10
  )

  expect_equal(test_result, expected)
})


test_that("regexlpain basic", {
  test_result = regexTestR:::regexplain("[[:blank:]][^[:blank:]]\\s+")

  expected = data.table::data.table(
    regex = c(
      "[[:blank:]]",
      "[^[:blank:]]",
      "\\s+"
    ),
    explanation = c(
      "any character of: blank characters (space and tab, and possibly other locale-dependent characters such as non-breaking space)",
      "any character except: blank characters (space and tab, and possibly other locale-dependent characters such as non-breaking space)",
      "whitespace (\\n, \\r, \\t, \\f, and \" \") (1 or more times (matching the most amount possible))"
    )
  )

  expect_equal(test_result, expected)
})
