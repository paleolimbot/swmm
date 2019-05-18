
#' Get the path to an example input file
#'
#' @param file A file such as one listed by `swmm_example_files()`.
#'
#' @export
#'
#' @examples
#' swmm_example_dir()
#' swmm_example_files()
#' swmm_example_file("Example1-Pre.inp")
#'
swmm_example_file <- function(file) {
  file.path(swmm_example_dir(), file)
}

#' @rdname swmm_example_file
#' @export
swmm_example_files <- function() {
  list.files(swmm_example_dir(), pattern = "\\.inp$", full.names = FALSE)
}

#' @rdname swmm_example_file
#' @export
swmm_example_dir <- function() {
  system.file("swmm_examples", package = "swmmbin")
}
