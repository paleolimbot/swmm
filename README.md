
<!-- README.md is generated from README.Rmd. Please edit that file -->

# swmm

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/paleolimbot/swmm.svg?branch=master)](https://travis-ci.org/paleolimbot/swmm)
[![Codecov test
coverage](https://codecov.io/gh/paleolimbot/swmm/branch/master/graph/badge.svg)](https://codecov.io/gh/paleolimbot/swmm?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of swmm is to provide a cross-platform interface to the [United
States Environmental Protection Agency](https://www.epa.gov/)’s
[Stormwater Management Model
(SWMM)](https://www.epa.gov/water-research/storm-water-management-model-swmm)
(the [source for SWMM is also available on
GitHub](https://github.com/USEPA/Stormwater-Management-Model).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("paleolimbot/swmm")
```

If you can load the package, you’re all set\! There is no need to
install SWMM (the package contains a copy).

``` r
library(swmm)
```

## Running SWMM

Run SWMM using the `swmm_run()` function and an “.inp” input file.

``` r
result <- swmm_run(swmm_example_file("Example8.inp"))
result
#> $inp
#> [1] "/Library/Frameworks/R.framework/Versions/3.6/Resources/library/swmm/swmm_examples/Example8.inp"
#> 
#> $rpt
#> [1] "/private/var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T/RtmpfJuNSQ/file106f025fadd28.rpt"
#> 
#> $out
#> [1] "/private/var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T/RtmpfJuNSQ/file106f078cd8092.out"
#> 
#> $last_error
#> [1] 0
#> 
#> $last_warning
#> [1] 0
```

You can find out which version of SWMM is included in the package with
`swmm_version()`:

``` r
swmm_version()
#> [1] "5.1.13"
```

## Reading swmm output

Use the `swmm_read_*()` functions (highly experimental):

``` r
out_file <- result$out

swmm_read_subcatchments(out_file)
#> # A tibble: 5,040 x 10
#>    object_name  step evaporation_loss groundwater_ele… groundwater_flow
#>    <chr>       <int>            <dbl>            <dbl>            <dbl>
#>  1 S1              1                0                0                0
#>  2 S1              2                0                0                0
#>  3 S1              3                0                0                0
#>  4 S1              4                0                0                0
#>  5 S1              5                0                0                0
#>  6 S1              6                0                0                0
#>  7 S1              7                0                0                0
#>  8 S1              8                0                0                0
#>  9 S1              9                0                0                0
#> 10 S1             10                0                0                0
#> # … with 5,030 more rows, and 5 more variables: infiltration_loss <dbl>,
#> #   rainfall_rate <dbl>, runoff_flow <dbl>, snow_depth <dbl>,
#> #   soil_moisture <dbl>
swmm_read_links(out_file)
#> # A tibble: 25,200 x 7
#>    object_name  step average_water capacity flow_rate flow_velocity
#>    <chr>       <int>         <dbl>    <dbl>     <dbl>         <dbl>
#>  1 C_Aux3          1      0.000100  8.33e-6         0             0
#>  2 C_Aux3          2      0.000100  8.33e-6         0             0
#>  3 C_Aux3          3      0.000100  8.33e-6         0             0
#>  4 C_Aux3          4      0.000100  8.33e-6         0             0
#>  5 C_Aux3          5      0.000100  8.33e-6         0             0
#>  6 C_Aux3          6      0.000100  8.33e-6         0             0
#>  7 C_Aux3          7      0.000100  8.33e-6         0             0
#>  8 C_Aux3          8      0.000100  8.33e-6         0             0
#>  9 C_Aux3          9      0.000100  8.33e-6         0             0
#> 10 C_Aux3         10      0.000100  8.33e-6         0             0
#> # … with 25,190 more rows, and 1 more variable: volume_of <dbl>
swmm_read_nodes(out_file)
#> # A tibble: 22,320 x 8
#>    object_name  step hydraulic_head  inflow lateral_inflow stored_water
#>    <chr>       <int>          <dbl>   <dbl>          <dbl>        <dbl>
#>  1 Aux3            1          4969. 0.00512        0.00512            0
#>  2 Aux3            2          4969. 0.00752        0.00752            0
#>  3 Aux3            3          4969. 0.0105         0.0105             0
#>  4 Aux3            4          4969. 0.0134         0.0134             0
#>  5 Aux3            5          4969. 0.0162         0.0162             0
#>  6 Aux3            6          4969. 0.0195         0.0195             0
#>  7 Aux3            7          4969. 0.0223         0.0223             0
#>  8 Aux3            8          4969. 0.0247         0.0247             0
#>  9 Aux3            9          4969. 0.0266         0.0266             0
#> 10 Aux3           10          4969. 0.0281         0.0281             0
#> # … with 22,310 more rows, and 2 more variables: surface_flooding <dbl>,
#> #   water_depth <dbl>
swmm_read_system(out_file)
#> # A tibble: 720 x 17
#>    object_name  step actual_evaporat… air_temperature average_losses
#>    <chr>       <int>            <dbl>           <dbl>          <dbl>
#>  1 system          1                0              70         0.0292
#>  2 system          2                0              70         0.0292
#>  3 system          3                0              70         0.0292
#>  4 system          4                0              70         0.0292
#>  5 system          5                0              70         0.0334
#>  6 system          6                0              70         0.0334
#>  7 system          7                0              70         0.0334
#>  8 system          8                0              70         0.0334
#>  9 system          9                0              70         0.0334
#> 10 system         10                0              70         0.0382
#> # … with 710 more rows, and 12 more variables: direct_inflow <dbl>,
#> #   dry_weather <dbl>, external_flooding <dbl>, external_inflow <dbl>,
#> #   groundwater_inflow <dbl>, nodal_storage <dbl>, outflow_from <dbl>,
#> #   potential_evaporation <dbl>, rainfall <dbl>, RDII_inflow <dbl>,
#> #   runoff <dbl>, snow_depth <dbl>
```

To find out which variables there are to choose from (for the purposes
of only reading part of the output, which you probably want to do), use
`swmm_read_variables()`:

``` r
swmm_read_variables(out_file)
#> # A tibble: 432 x 8
#>    element_type type_index variable_index variable variable_name unit 
#>    <chr>             <dbl>          <dbl> <chr>    <chr>         <chr>
#>  1 links                 2              0 flow_ra… flow rate     flow…
#>  2 links                 2              0 flow_ra… flow rate     flow…
#>  3 links                 2              0 flow_ra… flow rate     flow…
#>  4 links                 2              0 flow_ra… flow rate     flow…
#>  5 links                 2              0 flow_ra… flow rate     flow…
#>  6 links                 2              0 flow_ra… flow rate     flow…
#>  7 links                 2              0 flow_ra… flow rate     flow…
#>  8 links                 2              0 flow_ra… flow rate     flow…
#>  9 links                 2              0 flow_ra… flow rate     flow…
#> 10 links                 2              0 flow_ra… flow rate     flow…
#> # … with 422 more rows, and 2 more variables: object_name <chr>,
#> #   object_index <dbl>
```
