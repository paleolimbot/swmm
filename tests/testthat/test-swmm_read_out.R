
test_that("swmm out files can be read and produce the correct data", {

  skip("SWMM output reading doesn't always work!")

  inp_file <- swmm_example_file("Example8.inp")
  run <- swmm_run(inp_file)

  swmmr_out <- swmmr::read_out(run$out, iType = 0, object_name = "S1", vIndex = 0)
  swmmr_rainfall <- as.numeric(swmmr_out$S1$rainfall_rate)

  rainfall_df <- swmm_read_out(
    run$out,
    element_type = "subcatchments",
    variable = "rainfall_rate",
    object_name = "S1"
  )

  expect_identical(swmmr_rainfall, rainfall_df$value)

  unlink(run$rpt)
  unlink(run$out)
})
