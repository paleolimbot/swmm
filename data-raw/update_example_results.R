
library(swmm)

unlink(list.files("inst/swmm_examples", pattern = "\\.(rpt|out)$", full.names = TRUE))

withr::with_dir("inst/swmm_examples", {
  for(file in setdiff(swmm_example_files(), "Example9.inp")) {
    swmm_run(
      inp = file,
      rpt = gsub("inp$", "rpt", file),
      out = gsub("inp$", "out", file)
    )
  }
})
