
test_that("all examples run", {
  for(file in swmm_example_files()) {
    expect_is(swmm_run(swmm_example_file(file)), "list")
  }
})
