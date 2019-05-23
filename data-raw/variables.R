
library(tidyverse)

# this is from the swmmr package
# https://github.com/dleutnant/swmmr/blob/master/R/read_out_helper.R#L66-L113
type_choices <- list(

  subcatchments = c(
    "rainfall rate (in/hr or mm/hr)",
    "snow depth (inches or millimeters)",
    "evaporation loss (in/day or mm/day)",
    "infiltration loss (in/hr or mm/hr)",
    "runoff flow (flow units)",
    "groundwater flow into the drainage network (flow units)",
    "groundwater elevation (ft or m)",
    "soil moisture in the unsaturated groundwater zone (volume fraction)",
    "pollutant %s concentration (washoff, mass/liter)"
  ),

  nodes = c(
    "water depth (ft or m above the node invert elevation)",
    "hydraulic head (ft or m, absolute elevation per vertical datum)",
    "stored water volume (including ponded water, ft3 or m3)",
    "lateral inflow (runoff + all other external inflows, in flow units)",
    "total inflow (lateral inflow + upstream inflows, in flow units)",
    "surface flooding (excess overflow when the node is at full depth, in flow units)",
    "pollutant %s concentration after any treatment (mass/liter)"
  ),

  links = c(
    "flow rate (flow units)",
    "average water depth (ft or m)",
    "flow velocity (ft/s or m/s)",
    "volume of water (ft3 or m3)",
    "capacity (fraction of full area filled by flow for conduits; control setting for pumps and regulators)",
    "pollutant %s concentration (mass/liter)"
  ),

  system = c(
    "air temperature (deg. F or deg. C)",
    "total rainfall (in/hr or mm/hr)",
    "total snow depth (inches or millimeters)",
    "average losses (in/hr or mm/hr)",
    "total runoff (flow units)",
    "total dry weather inflow (flow units)",
    "total groundwater inflow (flow units)",
    "total RDII inflow (flow units)",
    "total external inflow (flow units)",
    "total direct inflow (flow units)",
    "total external flooding (flow units)",
    "total outflow from outfalls (flow units)",
    "total nodal storage volume (ft3 or m3)",
    "potential evaporation (in/day or mm/day)",
    "actual evaporation (in/day or mm/day)"
  )
)

type_pollutants <- list(
  subcatchments = "washoff concentration of pollutant %s (mass/liter)",
  nodes = "concentration of pollutant %s after any treatment (mass/liter)",
  links = "concentration of pollutant %s (mass/liter)"
)

out_variables <- map_dfr(type_choices, ~tibble(description = .), .id = "element_type") %>%
  mutate(type_index = match(element_type, names(type_choices)) - 1) %>%
  extract(description, "unit", "\\((.*?)\\)", remove = FALSE) %>%
  extract(description, "variable_name", "^([^\\(]+)") %>%
  mutate(unit = unit %>% str_replace_all("deg. (C|F)", "deg.\\1")) %>%
  extract(unit, c("imperial_unit", "metric_unit"), "([^ ]+) or ([^ ,]+)", remove = FALSE) %>%
  mutate(
    variable_name = str_trim(variable_name),
    variable = variable_name %>%
      str_remove("^total") %>%
      str_trim() %>%
      str_split("\\s+") %>%
      map_chr(~paste(na.omit(.x[1:2]), collapse = "_"))
  ) %>%
  group_by(element_type) %>%
  mutate(variable_index = seq_len(n()) - 1) %>%
  ungroup() %>%
  select(type_index, element_type, variable_index, variable, everything())

usethis::use_data(out_variables, internal = TRUE, overwrite = TRUE)
