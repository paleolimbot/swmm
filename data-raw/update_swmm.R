
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

# Source code modifications -------------------------------------

# we don't need the main.c file (this also causes warnings since main.c writes to stdout)
unlink("src/swmm/main.c")

# need to replace the two references to stdout, which cause
# warnings and also are bad practice, since we want to write the
# messages that get printed to stdout in a way that they can be
# captured by the R session (i.e., sink()). The C way of doing this
# is Rprintf().
# this isn't a perfect regex, but should work for this and future versions
readr::read_file("src/swmm/swmm5.c") %>%
  stringr::str_replace(
    "(void\\s+writecon\\(char\\s+\\*\\s*s\\)[^{]*\\{\\s*)([^}])*(\\})",
    "\\1Rprintf(s);\n\\3"
  ) %>%
  stringr::str_replace(
    "#include <stdlib.h>",
    "#include <stdlib.h>\n#include <R.h>"
  ) %>%
  readr::write_file("src/swmm/swmm5.c")

# Cleanup ------------------------------
unlink("data-raw/swmm", recursive = TRUE)
unlink("data-raw/swmm.zip")
