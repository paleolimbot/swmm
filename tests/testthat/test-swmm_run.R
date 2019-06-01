
test_that("all examples run", {
  # Example 9 includes references to other files in the input file. The SWMM
  # tries to find these files in the working directory (it does respect R's working)
  # directory, so `withr::with_dir(swmm_example_dir(), swmm_run("Example9.inp"))` works
  for(file in setdiff(swmm_example_files(), "Example9.inp")) {
    if(interactive()) message("swmm_run(\"", swmm_example_file(file), "\")")
    result <- swmm_run(swmm_example_file(file))
    expect_is(result, "list")
    expect_true(file.exists(result$rpt))
    expect_true(file.exists(result$out))
    expect_equal(result$last_error, 0)
  }
})

test_that("the quiet flag works", {
  expect_silent(swmm_run(swmm_example_file("Example1-Pre.inp"), quiet = TRUE))
  expect_output(swmm_run(swmm_example_file("Example1-Pre.inp"), quiet = FALSE))
})

test_that("the inp argument must be a valid existing file", {
  expect_error(swmm_run(NULL))
  expect_error(swmm_run(character(0)))
  expect_error(swmm_run(tempfile()))
})

test_that("output arguments can be a specific (non-existing) file", {
  inp_file <- swmm_example_file("Example1-Pre.inp")
  expect_path_equal <- function(p1, p2) {
    expect_identical(
      normalizePath(p1, mustWork = FALSE),
      normalizePath(p1, mustWork = FALSE)
    )
  }

  known_rpt <- tempfile(fileext = ".rpt")
  expect_path_equal(swmm_run(inp_file, rpt = known_rpt)$rpt, known_rpt)

  known_out <- tempfile(fileext = ".out")
  expect_path_equal(swmm_run(inp_file, out = known_out)$out, known_out)
})

test_that("output arguments can be files that will be overwritten", {
  inp_file <- swmm_example_file("Example1-Pre.inp")

  known_rpt <- tempfile(fileext = ".rpt")
  expect_silent(swmm_run(inp_file, rpt = known_rpt))
  expect_error(swmm_run(inp_file, rpt = known_rpt), "overwrite = TRUE")
  expect_silent(swmm_run(inp_file, rpt = known_rpt, overwrite = TRUE))

  known_out <- tempfile(fileext = ".out")
  expect_silent(swmm_run(inp_file, out = known_out))
  expect_error(swmm_run(inp_file, out = known_out), "overwrite = TRUE")
  expect_silent(swmm_run(inp_file, out = known_out, overwrite = TRUE))
})

test_that("swmm errors result in an R error", {
  expect_error(
    swmm_run(swmm_example_file("Example9.inp")),
    "cannot open rainfall data"
  )
})
