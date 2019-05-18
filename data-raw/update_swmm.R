
curl::curl_download(
  "https://www.epa.gov/sites/production/files/2018-08/swmm51013_engine_0.zip",
  "data-raw/swmm.zip"
)

if(dir.exists("data-raw/swmm")) unlink("data-raw/swmm", recursive = TRUE)
dir.create("data-raw/swmm")

utils::unzip("data-raw/swmm.zip", exdir = "data-raw/swmm")

if(dir.exists("src/swmm")) unlink("src/swmm", recursive = TRUE)
dir.create("src/swmm")

utils::unzip("data-raw/swmm/source5_1_013.zip", exdir = "src/swmm")

# we don't need the main.c file (this also causes warnings since main.c writes to stdout)
unlink("src/swmm/main.c")

# cleanup
unlink("data-raw/swmm", recursive = TRUE)
unlink("data-raw/swmm.zip")
