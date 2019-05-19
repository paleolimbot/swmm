
#' Initiate a simulation run
#'
#' This is intended to be a drop-in replacement for [swmmr::run_swmm()].
#'
#' @param inp Path to an input file.
#' @param rpt Path to a report file (that does not yet exist or will be overwritten).
#' @param out Path to an output file (that does not yet exist or will be overwritten).
#' @param overwrite Use `overwrite = TRUE` overwrite `rpt` and `out`.
#' @param quiet Silence default SWWM output.
#'
#' @export
#'
#' @examples
#' swmm_run(swmm_example_file("Example1-Pre.inp"))
#'
#' @importFrom assertthat is.scalar is.string assert_that
#'
swmm_run <- function(inp, rpt = NULL, out = NULL, overwrite = FALSE, quiet = TRUE) {
  overwrite <- isTRUE(overwrite)

  assert_that(is.character(inp), is.scalar(inp), file.exists(inp))
  assert_that(is.null(rpt) || (is.character(rpt) && is.scalar(rpt)))
  assert_that(is.null(out) || (is.character(out) && is.scalar(out)))

  if(is.null(rpt)) {
    rpt <- tempfile(fileext = ".rpt")
  }

  if(is.null(out)) {
    out <- tempfile(fileext = ".out")
  }

  if(!overwrite && file.exists(rpt)) {
    stop("File \"", rpt, "\" already exists. Use overwrite = TRUE to overwrite.")
  }

  if(!overwrite && file.exists(out)) {
    stop("File \"", out, "\" already exists. Use overwrite = TRUE to overwrite.")
  }

  if(quiet) {
    output_file <- tempfile()
    sink(output_file)
    on.exit({sink(); unlink(output_file)})
  }

  output <- swmmRun(
    as_absolute_path(inp),
    as_absolute_path(rpt),
    as_absolute_path(out)
  )

  # make sure there's a newline before returning to R
  if(!quiet) cat("\n")

  output
}
