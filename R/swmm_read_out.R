
swmm_read_out_raw <- function(out) {
  on.exit(CloseSwmmOutFile())
  OpenSwmmOutFile(out)
}

#' Get out file variable information
#'
#' @param pollutant_names Optional names of pollutants in the system
#'
#' @return A tibble
#' @export
#'
#' @examples
#' swmm_out_variables()
#'
swmm_out_variables <- function(pollutant_names = character(0)) {
  rbind(
    out_variables[!grepl("pollutant", out_variables$variable), ],
    pollutant_variables(pollutant_names)
  )
}

pollutant_variables <- function(pollutant_names = character(0)) {
  if(length(pollutant_names == 0)) return(out_variables[integer(0), ])
  pollutant_vars_base <- out_variables[grepl("pollutant", out_variables$variable), ]

  pollutant_vars_list <- lapply(seq_along(pollutant_names), function(i) {
    pollutant_vars <- pollutant_vars_base
    pollutant_vars$variable <- sprintf(pollutant_vars$variable, pollutant_names[i])
    pollutant_vars$variable_name <- sprintf(pollutant_vars$variable_name, pollutant_names[i])
    pollutant_vars$variable_index <- pollutant_vars$variable_index + i - 1
    pollutant_vars
  })

  do.call(rbind, pollutant_vars_list)
}
