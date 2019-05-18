
#' Initiate a simulation run
#'
#' This is intended to be a drop-in replacement for [swmmr::run_swmm()].
#'
#' @param inp Path to an input file.
#' @param rpt Path to a report file (that does not yet exist or will be overwritten).
#' @param out Path to an output file (that does not yet exist or will be overwritten).
#' @param overwrite Use `overwrite = TRUE` overwrite `rpt` and `out`.
#'
#' @export
#'
#' @examples
#' swmm_run(swmm_example_file("Example1-Pre.inp"))
#'
swmm_run <- function(inp, rpt = NULL, out = NULL, overwrite = FALSE) {
  overwrite <- isTRUE(overwrite)
  stopifnot(
    is_valid_input_file(inp),
    is_valid_output_file(rpt),
    is_valid_output_file(out)
  )

  if(is.null(rpt)) {
    rpt <- tempfile(fileext = ".rpt")
  }

  if(is.null(out)) {
    out <- tempfile(fileext = ".out")
  }

  output <- swmmRun(
    fs::path_real(inp),
    fs::path_real(rpt),
    fs::path_real(out)
  )

  output
}

is_valid_input_file <- function(path) {
  is_valid_file(path) && file.exists(path)
}

is_valid_output_file <- function(path, overwrite = FALSE) {
  is.null(path) || (overwrite && is_valid_input_file(path)) || is_valid_file(path)
}

is_valid_file <- function(path) {
  is.character(path) && (length(path) == 1) && !is.na(path)
}
