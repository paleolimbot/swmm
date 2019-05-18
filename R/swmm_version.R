
#' Get the current SWMM version
#'
#' @export
#'
#' @examples
#' swmm_version()
#'
swmm_version <- function() {
  version_int <- swmmVersion()
  paste0(version_int, collapse = ".")
}
