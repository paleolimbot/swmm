
curl::curl_download(
  "https://www.epa.gov/sites/production/files/2014-05/epaswmm5_apps_manual.zip",
  "data-raw/swmm_ex.zip"
)

if(dir.exists("data-raw/swmm_ex")) unlink("data-raw/swmm_ex", recursive = TRUE)
dir.create("data-raw/swmm_ex")

utils::unzip("data-raw/swmm_ex.zip", exdir = "data-raw/swmm_ex")

if(dir.exists("inst/swmm_examples")) unlink("inst/swmm_examples", recursive = TRUE)
utils::unzip("data-raw/swmm_ex/epaswmm5_apps_manual/files.zip", exdir = "inst/swmm_examples")

# cleanup
unlink("data-raw/swmm_ex", recursive = TRUE)
unlink("data-raw/swmm_ex.zip")
