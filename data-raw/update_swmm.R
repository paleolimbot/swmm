
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

# there is a self-assign warning in input.c / match(), which is related to a confusing
# but seemingly harmless practice of using the value of i
# of a previous for-loop counter
current_body_loc <- 771:787
new_match_body <- "
    int i,j,leadingWhitespace;

    // --- fail if substring is empty
    if (!substr[0]) return(0);

    // --- skip leading blanks of str
    leadingWhitespace = 0;
    for (i = 0; str[i]; i++)
    {
        if (str[i] != ' ') {
          leadingWhitespace = i;
          break;
        }
    }

    // --- check if substr matches remainder of str
    for (i = leadingWhitespace,j = 0; substr[j]; i++,j++)
    {
        if (!str[i] || UCHAR(str[i]) != UCHAR(substr[j])) return(0);
    }
    return(1);
"

input_lines <- readr::read_lines("src/swmm/input.c")
c(input_lines[
  1:(min(current_body_loc) - 1)],
  new_match_body,
  input_lines[(max(current_body_loc + 1):length(input_lines))]
) %>%
  # using sep as \r\n makes for a better diff, since it has
  # windows line returns in the original
  readr::write_lines("src/swmm/input.c", sep = "\r\n")

# we don't need the main.c file (this also causes warnings since main.c writes to stdout)
unlink("src/swmm/main.c")

# non-source files result in a package warning
unlink(c("src/swmm/Roadmap.txt", "src/swmm/swmm5.def"))

# ----- Clean previously installed SWMM files ----

if(file.exists("data-raw/swmm_files.txt")) {
  old_swmm_files <- readr::read_lines("data-raw/swmm_files.txt")
  unlink(file.path("src", old_swmm_files))
  unlink("data-raw/swmm_files.txt")
}

# ------ Make a list of files that were included from SWMM and move them to src/

swmm_files <- list.files("src/swmm")
file.rename(file.path("src/swmm", swmm_files), file.path("src", swmm_files))
readr::write_lines(swmm_files, "data-raw/swmm_files.txt")

# Cleanup ------------------------------

unlink("src/swmm", recursive = TRUE)
unlink("data-raw/swmm", recursive = TRUE)
unlink("data-raw/swmm.zip")
