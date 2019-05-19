
<!-- README.md is generated from README.Rmd. Please edit that file -->

# swmm

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/paleolimbot/swmm.svg?branch=master)](https://travis-ci.org/paleolimbot/swmm)
[![Codecov test
coverage](https://codecov.io/gh/paleolimbot/swmm/branch/master/graph/badge.svg)](https://codecov.io/gh/paleolimbot/swmm?branch=master)
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
swmm_run(swmm_example_file("Example1-Pre.inp"))
#> $input_file
#> [1] "/Library/Frameworks/R.framework/Versions/3.6/Resources/library/swmm/swmm_examples/Example1-Pre.inp"
#> 
#> $report_file
#> [1] "/private/var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T/RtmpLGojRB/fileed6577a0e819.rpt"
#> 
#> $binary_file
#> [1] "/private/var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T/RtmpLGojRB/fileed6564e5feaa.out"
#> 
#> $error
#> [1] 0
#> 
#> $warning
#> [1] 0
```

You can find out which version of SWMM is included in the package with
`swmm_version()`:

``` r
swmm_version()
#> [1] "5.1.13"
```
