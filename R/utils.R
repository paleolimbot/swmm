
as_absolute_path <- function(path) {
  path <- fs::path_real(path)
  if(is_windows()) {
    gsub("/", "\\", path)
  } else {
    path
  }
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

is_windows <- function() {
  tolower(Sys.info()[["sysname"]]) == "windows"
}
