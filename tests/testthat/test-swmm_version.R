
test_that("swmm_version() works", {
  expect_is(swmm_version(), "character")
  expect_length(swmm_version(), 1)
})
