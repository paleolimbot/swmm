
test_that("all examples run", {
  for(file in swmm_example_files()) {
    expect_is(swmm_run(swmm_example_file(file)), "list")
  }
})

test_that("the quiet flag works", {
  expect_silent(swmm_run(swmm_example_file("Example1-Pre.inp"), quiet = TRUE))
  expect_output(swmm_run(swmm_example_file("Example1-Pre.inp"), quiet = FALSE), "Simulation complete")
})
