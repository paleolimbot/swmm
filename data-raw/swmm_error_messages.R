
library(tidyverse)

swmm_error_messages <- tibble(lines = read_lines("src/error.c")) %>%
  extract(lines, c("code", "message"), 'ERR([0-9]+)\\s+"(.*?)"') %>%
  filter(!is.na(code)) %>%
  mutate(
    code = as.integer(code),
    message = message %>%
      str_remove("^[^:]*:")
  )

usethis::use_data(swmm_error_messages, overwrite = TRUE)
