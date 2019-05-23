
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

  # create paths here that both R and C can understand
  inp <- sanitize_c_path(inp)
  rpt <- sanitize_c_path(rpt)
  out <- sanitize_c_path(out)

  # on Windows, files must exist before SWMM is called
  # on not Windows, this doesn't cause a failure
  if(!file.exists(rpt)) {
    if(!file.create(rpt)) stop("Could not create report file '", rpt, "'")
  }

  if(!file.exists(out)) {
    if(!file.create(out)) stop("Could not create output file '", out, "'")
  }

  if(quiet) {
    output_file <- tempfile()
    sink(output_file)
    on.exit({sink(); unlink(output_file)})
  }

  # runn SWMM
  output <- swmmRun(inp, rpt, out)

  # convert paths back to R-friendly paths
  file_items <- c("input_file", "report_file", "binary_file")
  output[file_items] <- lapply(output[file_items], sanitize_path)

  # make sure there's a newline before returning to R
  if(!quiet) cat("\n")

  output
}

# on Windows, the C functions need path to have
# backslashes instead of forward slashses
sanitize_c_path <- function(path) {
  normalizePath(path, mustWork = FALSE)
}

sanitize_path <- function(path) {
  gsub("\\\\", "/", normalizePath(path, mustWork = FALSE))
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
